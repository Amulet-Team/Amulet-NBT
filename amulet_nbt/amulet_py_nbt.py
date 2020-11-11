from __future__ import annotations

import gzip
import itertools
from collections.abc import MutableMapping
from dataclasses import dataclass, field
from io import BytesIO
from math import trunc, floor, ceil
from struct import Struct, pack
from typing import (
    Any,
    ClassVar,
    get_type_hints,
    Dict,
    List,
    Type,
    Tuple,
    Optional,
    Union,
    Iterator,
    overload,
    Iterable,
    BinaryIO,
)
import re
from copy import deepcopy
import os

import numpy as np

TAG_END = 0
TAG_BYTE = 1
TAG_SHORT = 2
TAG_INT = 3
TAG_LONG = 4
TAG_FLOAT = 5
TAG_DOUBLE = 6
TAG_BYTE_ARRAY = 7
TAG_STRING = 8
TAG_LIST = 9
TAG_COMPOUND = 10
TAG_INT_ARRAY = 11
TAG_LONG_ARRAY = 12

IMPLEMENTATION = "python"

_string_len_fmt_be = Struct(">H")
_string_len_fmt_le = Struct("<H")

_NON_QUOTED_KEY = re.compile(r"^[a-zA-Z0-9-]+$")

AnyNBT = Union[
    "TAG_Byte",
    "TAG_Short",
    "TAG_Int",
    "TAG_Long",
    "TAG_Float",
    "TAG_Double",
    "TAG_Byte_Array",
    "TAG_String",
    "TAG_List",
    "TAG_Compound",
    "TAG_Int_Array",
    "TAG_Long_Array",
]

SNBTType = str
CommaNewline = ",\n"
CommaSpace = ", "


class NBTError(Exception):
    """Some error in the NBT library."""


class NBTLoadError(NBTError):
    """The NBT data failed to load for some reason."""

    pass


class NBTFormatError(NBTLoadError):
    """Indicates the NBT format is invalid."""

    pass


class SNBTParseError(NBTError):
    """Indicates the SNBT format is invalid."""

    pass


class _BufferContext:
    __slots__ = ("buffer", "offset", "size")

    def __init__(self, offset: int, buffer, size: int):
        self.offset = offset
        self.buffer = buffer
        self.size = size


def load_string(context: _BufferContext, little_endian=False) -> str:
    data = context.buffer[context.offset :]
    if little_endian:
        (str_len,) = _string_len_fmt_le.unpack_from(data)
    else:
        (str_len,) = _string_len_fmt_be.unpack_from(data)

    value = data[2 : str_len + 2].decode("utf-8")
    context.offset += str_len + 2
    return value


def write_string(buffer, _str, little_endian=False):
    encoded_str = _str.encode("utf-8")
    if little_endian:
        buffer.write(pack(f"<H{len(encoded_str)}s", len(encoded_str), encoded_str))
    else:
        buffer.write(pack(f">H{len(encoded_str)}s", len(encoded_str), encoded_str))


def primitive_conversion(obj):
    return obj._value if isinstance(obj, _TAG_Value) else obj


def safe_gunzip(data):
    if data[:2] == b"\x1f\x8b":  # if the first two bytes are this it should be gzipped
        try:
            data = gzip.GzipFile(fileobj=BytesIO(data)).read()
        except IOError as e:
            pass
    return data


@dataclass(eq=False, repr=False)
class _TAG_Value:
    _value: Any
    tag_id: ClassVar[int]
    _data_type: ClassVar[Any]
    tag_format_be: Struct = field(init=False, repr=False, compare=False)
    tag_format_le: Struct = field(init=False, repr=False, compare=False)

    def __new__(cls, *args, **kwargs):
        cls._data_type = get_type_hints(cls)["_value"]
        return super(_TAG_Value, cls).__new__(cls)

    def __init__(self, value=None):
        if value is None:
            value = self._data_type()
        self._value = self.format(value)

    @property
    def value(self):
        return self._value

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> AnyNBT:
        data = context.buffer[context.offset :]
        if little_endian:
            tag = cls(cls.tag_format_le.unpack_from(data)[0])
            context.offset += cls.tag_format_le.size
        else:
            tag = cls(cls.tag_format_be.unpack_from(data)[0])
            context.offset += cls.tag_format_be.size
        return tag

    def format(self, value):
        return self._data_type(value)

    def write_tag_id(self, buffer):
        buffer.write(bytes(chr(self.tag_id), "utf-8"))

    def write_payload(self, buffer, name="", little_endian=False):
        self.write_tag_id(buffer)
        write_string(buffer, name, little_endian)
        self.write_value(buffer, little_endian)

    def write_value(self, buffer, little_endian=False):
        if little_endian:
            buffer.write(self.tag_format_le.pack(self._value))
        else:
            buffer.write(self.tag_format_be.pack(self._value))

    def to_snbt(self, indent_chr=None):
        if isinstance(indent_chr, int):
            return self._pretty_to_snbt(" " * indent_chr)
        elif isinstance(indent_chr, str):
            return self._pretty_to_snbt(indent_chr)
        return self._to_snbt()

    def _to_snbt(self) -> SNBTType:
        raise NotImplementedError

    def _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        return f"{indent_chr * indent_count * leading_indent}{self._to_snbt()}"

    def __repr__(self):
        return self._to_snbt()

    def __eq__(self, other):
        return self._value == other

    def strict_equals(self, other):
        return (
            isinstance(other, self.__class__)
            and self.tag_id == other.tag_id
            and self.__eq__(other)
        )


BaseValueType = _TAG_Value


def ensure_float(func):
    def wrap(*args, **kwargs):
        if any(map(lambda a: isinstance(a, (float, TAG_Float, TAG_Double)), args)):
            return float(func(*args, **kwargs))
        return func(*args, **kwargs)

    return wrap


class _Int:
    def __eq__(self, other):
        return self._value == primitive_conversion(other)

    @ensure_float
    def __add__(self, other):
        return self._value + primitive_conversion(other)

    @ensure_float
    def __sub__(self, other):
        return self._value - primitive_conversion(other)

    @ensure_float
    def __mul__(self, other):
        return self._value * primitive_conversion(other)

    @ensure_float
    def __truediv__(self, other):
        return self._value / primitive_conversion(other)

    def __floordiv__(self, other):
        return self._value // primitive_conversion(other)

    def __mod__(self, other):
        return self._value % primitive_conversion(other)

    def __divmod__(self, other):
        return divmod(self._value, primitive_conversion(other))

    def __pow__(self, power, modulo):
        return pow(self._value, power, modulo)

    def __lshift__(self, other):
        return self._value << primitive_conversion(other)

    def __rshift__(self, other):
        return self._value >> primitive_conversion(other)

    def __and__(self, other):
        return self._value & primitive_conversion(other)

    def __xor__(self, other):
        return self._value ^ primitive_conversion(other)

    def __or__(self, other):
        return self._value | primitive_conversion(other)

    @ensure_float
    def __radd__(self, other):
        return primitive_conversion(other) + self._value

    @ensure_float
    def __rsub__(self, other):
        return primitive_conversion(other) - self._value

    @ensure_float
    def __rmul__(self, other):
        return primitive_conversion(other) * self._value

    @ensure_float
    def __rtruediv__(self, other):
        return primitive_conversion(other) / self._value

    def __rfloordiv__(self, other):
        return primitive_conversion(other) // self._value

    def __rmod__(self, other):
        return primitive_conversion(other) % self._value

    def __rdivmod__(self, other):
        return divmod(primitive_conversion(other), self._value)

    def __rpow__(self, other, modulo):
        return pow(primitive_conversion(other), self._value, modulo)

    def __rlshift__(self, other):
        return primitive_conversion(other) << self._value

    def __rrshift__(self, other):
        return primitive_conversion(other) >> self._value

    def __rand__(self, other):
        return primitive_conversion(other) & self._value

    def __rxor__(self, other):
        return primitive_conversion(other) ^ self._value

    def __ror__(self, other):
        return primitive_conversion(other) | self._value

    def __neg__(self):
        return -self._value

    def __pos__(self):
        return +self._value

    def __abs__(self):
        return abs(self._value)

    def __invert__(self):
        return ~self._value

    def __int__(self):
        return self._value

    def __float__(self):
        return float(self._value)

    def __deepcopy__(self, memo=None):
        return self.__class__(deepcopy(self.value, memo=memo))

    def __getattr__(self, item):
        return self._value.__getattribute__(item)

    def __dir__(self):
        return dir(self._value)


class _Float:
    def __eq__(self, other):
        return self._value == primitive_conversion(other)

    def __add__(self, other):
        return float(self._value + primitive_conversion(other))

    def __sub__(self, other):
        return float(self._value - primitive_conversion(other))

    def __mul__(self, other):
        return float(self._value * primitive_conversion(other))

    def __truediv__(self, other):
        return float(self._value / primitive_conversion(other))

    def __floordiv__(self, other):
        return self._value // primitive_conversion(other)

    def __mod__(self, other):
        return self._value % primitive_conversion(other)

    def __divmod__(self, other):
        return divmod(self._value, primitive_conversion(other))

    def __pow__(self, power, modulo):
        return pow(self._value, power, modulo)

    def __lshift__(self, other):
        return self._value << primitive_conversion(other)

    def __rshift__(self, other):
        return self._value >> primitive_conversion(other)

    def __and__(self, other):
        return self._value & primitive_conversion(other)

    def __xor__(self, other):
        return self._value ^ primitive_conversion(other)

    def __or__(self, other):
        return self._value | primitive_conversion(other)

    def __radd__(self, other):
        return float(primitive_conversion(other) + self._value)

    def __rsub__(self, other):
        return float(primitive_conversion(other) - self._value)

    def __rmul__(self, other):
        return primitive_conversion(other) * self._value

    def __rtruediv__(self, other):
        return float(primitive_conversion(other) / self._value)

    def __rfloordiv__(self, other):
        return primitive_conversion(other) // self._value

    def __rmod__(self, other):
        return primitive_conversion(other) % self._value

    def __rdivmod__(self, other):
        return divmod(primitive_conversion(other), self._value)

    def __rpow__(self, other, modulo):
        return pow(primitive_conversion(other), self._value, modulo)

    def __rlshift__(self, other):
        return primitive_conversion(other) << self._value

    def __rrshift__(self, other):
        return primitive_conversion(other) >> self._value

    def __rand__(self, other):
        return primitive_conversion(other) & self._value

    def __rxor__(self, other):
        return primitive_conversion(other) ^ self._value

    def __ror__(self, other):
        return primitive_conversion(other) | self._value

    def __neg__(self):
        return -self._value

    def __pos__(self):
        return +self._value

    def __abs__(self):
        return abs(self._value)

    def __float__(self):
        return self._value

    def __round__(self, n=None):
        return round(self._value, n)

    def __trunc__(self):
        return trunc(self._value)

    def __floor__(self):
        return floor(self._value)

    def __ceil__(self):
        return ceil(self._value)

    def __deepcopy__(self, memo=None):
        return self.__class__(deepcopy(self.value, memo=memo))

    def __getattr__(self, item):
        return self._value.__getattribute__(item)

    def __dir__(self):
        return dir(self._value)


@dataclass(eq=False, init=False, repr=False)
class TAG_Byte(_TAG_Value, _Int):
    _value: int = 0
    tag_id = TAG_BYTE
    tag_format_be = Struct(">b")
    tag_format_le = Struct("<b")
    _data_type = int

    def _to_snbt(self) -> SNBTType:
        return f"{self._value}b"


@dataclass(eq=False, init=False, repr=False)
class TAG_Short(_TAG_Value, _Int):
    _value: int = 0
    tag_id = TAG_SHORT
    tag_format_be = Struct(">h")
    tag_format_le = Struct("<h")

    def _to_snbt(self) -> SNBTType:
        return f"{self._value}s"


@dataclass(eq=False, init=False, repr=False)
class TAG_Int(_TAG_Value, _Int):
    _value: int = 0
    tag_id = TAG_INT
    tag_format_be = Struct(">i")
    tag_format_le = Struct("<i")

    def _to_snbt(self) -> SNBTType:
        return f"{self._value}"


@dataclass(eq=False, init=False, repr=False)
class TAG_Long(_TAG_Value, _Int):
    _value: int = 0
    tag_id = TAG_LONG
    tag_format_be = Struct(">q")
    tag_format_le = Struct("<q")

    def _to_snbt(self) -> SNBTType:
        return f"{self._value}L"


@dataclass(eq=False, init=False, repr=False)
class TAG_Float(_TAG_Value, _Float):
    _value: float = 0
    tag_id = TAG_FLOAT
    tag_format_be = Struct(">f")
    tag_format_le = Struct("<f")

    def _to_snbt(self) -> SNBTType:
        return f"{self._value:.20f}".rstrip("0") + "f"


@dataclass(eq=False, init=False, repr=False)
class TAG_Double(_TAG_Value, _Float):
    _value: float = 0
    tag_id = TAG_DOUBLE
    tag_format_be = Struct(">d")
    tag_format_le = Struct("<d")

    def _to_snbt(self) -> SNBTType:
        return f"{self._value:.20f}".rstrip("0") + "d"


@dataclass(eq=False, init=False, repr=False)
class _TAG_Array(_TAG_Value):
    big_endian_data_type: ClassVar[Any]
    little_endian_data_type: ClassVar[Any]
    value: np.ndarray = np.zeros(0)

    def __init__(
        self,
        value: Union[
            np.ndarray,
            List[int],
            Tuple[int, ...],
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        ] = None,
    ):
        if value is None:
            value = np.zeros((0,), self.big_endian_data_type)
        elif isinstance(value, (list, tuple)):
            value = np.array(value, self.big_endian_data_type)
        elif isinstance(value, (TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array)):
            value = value._value
        if isinstance(value, np.ndarray):
            if value.dtype != self.big_endian_data_type:
                value = value.astype(self.big_endian_data_type)
        else:
            raise NBTError(
                f"Unexpected object {value} given to {self.__class__.__name__}"
            )

        self._value = value

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> _TAG_Array:
        data_type = (
            cls.little_endian_data_type if little_endian else cls.big_endian_data_type
        )
        data = context.buffer[context.offset :]
        if little_endian:
            (string_len,) = TAG_Int.tag_format_le.unpack_from(data)
        else:
            (string_len,) = TAG_Int.tag_format_be.unpack_from(data)
        value = np.frombuffer(
            data[4 : string_len * data_type.itemsize + 4], dtype=data_type
        )
        context.offset += string_len * data_type.itemsize + 4

        return cls(value)

    def write_value(self, buffer, little_endian=False):
        data_type = (
            self.little_endian_data_type if little_endian else self.big_endian_data_type
        )
        if self._value.dtype != data_type:
            if (
                self._value.dtype != self.big_endian_data_type
                if little_endian
                else self.little_endian_data_type
            ):
                print(
                    f"[Warning] Mismatch array dtype. Expected: {data_type.str}, got: {self._value.dtype.str}"
                )
            self._value = self._value.astype(data_type)
        if little_endian:
            value = self._value.tostring()
            buffer.write(pack(f"<I{len(value)}s", self._value.size, value))
        else:
            value = self._value.tostring()
            buffer.write(pack(f">I{len(value)}s", self._value.size, value))

    def __eq__(self, other):
        return np.array_equal(primitive_conversion(self), primitive_conversion(other))

    def __getitem__(self, item):
        return self._value.__getitem__(item)

    def __setitem__(self, key, value):
        self._value.__setitem__(key, value)

    def __getattr__(self, item):
        return self._value.__getattribute__(item)

    def __dir__(self):
        return dir(self._value)

    def __array__(self):
        return self._value

    def __len__(self):
        return len(self._value)

    def __add__(self, other):
        return (primitive_conversion(self) + primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __sub__(self, other):
        return (primitive_conversion(self) - primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __mul__(self, other):
        return (primitive_conversion(self) - primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __matmul__(self, other):
        return (primitive_conversion(self) @ primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __truediv__(self, other):
        return (primitive_conversion(self) / primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __floordiv__(self, other):
        return (primitive_conversion(self) // primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __mod__(self, other):
        return (primitive_conversion(self) % primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __divmod__(self, other):
        return divmod(primitive_conversion(self), primitive_conversion(other))

    def __pow__(self, power, modulo):
        return pow(primitive_conversion(self), power, modulo).astype(
            self.big_endian_data_type
        )

    def __lshift__(self, other):
        return (primitive_conversion(self) << primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __rshift__(self, other):
        return (primitive_conversion(self) >> primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __and__(self, other):
        return (primitive_conversion(self) & primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __xor__(self, other):
        return (primitive_conversion(self) ^ primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __or__(self, other):
        return (primitive_conversion(self) | primitive_conversion(other)).astype(
            self.big_endian_data_type
        )

    def __radd__(self, other):
        return (primitive_conversion(other) + primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rsub__(self, other):
        return (primitive_conversion(other) - primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rmul__(self, other):
        return (primitive_conversion(other) * primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rtruediv__(self, other):
        return (primitive_conversion(other) / primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rfloordiv__(self, other):
        return (primitive_conversion(other) // primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rmod__(self, other):
        return (primitive_conversion(other) % primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rdivmod__(self, other):
        return divmod(primitive_conversion(other), primitive_conversion(self))

    def __rpow__(self, other, modulo):
        return pow(
            primitive_conversion(other), primitive_conversion(self), modulo
        ).astype(self.big_endian_data_type)

    def __rlshift__(self, other):
        return (primitive_conversion(other) << primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rrshift__(self, other):
        return (primitive_conversion(other) >> primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rand__(self, other):
        return (primitive_conversion(other) & primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __rxor__(self, other):
        return (primitive_conversion(other) ^ primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __ror__(self, other):
        return (primitive_conversion(other) | primitive_conversion(self)).astype(
            self.big_endian_data_type
        )

    def __neg__(self):
        return (-self.value).astype(self.big_endian_data_type)

    def __pos__(self):
        return (+self.value).astype(self.big_endian_data_type)

    def __abs__(self):
        return abs(self.value).astype(self.big_endian_data_type)


BaseArrayType = _TAG_Array


@dataclass(eq=False, init=False, repr=False)
class TAG_Byte_Array(_TAG_Array):
    big_endian_data_type = little_endian_data_type = np.dtype("int8")
    tag_id = TAG_BYTE_ARRAY

    def __init__(
        self,
        value: Union[
            np.ndarray,
            List[int],
            Tuple[int, ...],
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        ] = None,
    ):
        super().__init__(value)

    def _to_snbt(self) -> SNBTType:
        return f"[B;{'B, '.join(str(val) for val in self._value)}B]"


@dataclass(eq=False, init=False, repr=False)
class TAG_Int_Array(_TAG_Array):
    big_endian_data_type = np.dtype(">i4")
    little_endian_data_type = np.dtype("<i4")
    tag_id = TAG_INT_ARRAY

    def __init__(
        self,
        value: Union[
            np.ndarray,
            List[int],
            Tuple[int, ...],
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        ] = None,
    ):
        super().__init__(value)

    def _to_snbt(self) -> SNBTType:
        return f"[I;{CommaSpace.join(str(val) for val in self._value)}]"


@dataclass(eq=False, init=False, repr=False)
class TAG_Long_Array(_TAG_Array):
    big_endian_data_type = np.dtype(">i8")
    little_endian_data_type = np.dtype("<i8")
    tag_id = TAG_LONG_ARRAY

    def __init__(
        self,
        value: Union[
            np.ndarray,
            List[int],
            Tuple[int, ...],
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        ] = None,
    ):
        super().__init__(value)

    def _to_snbt(self) -> SNBTType:
        return f"[L;{CommaSpace.join(str(val) for val in self._value)}]"


# TODO: these could probably do with being improved
def escape(string: str):
    return string.replace("\\", "\\\\").replace('"', '\\"')


def unescape(string: str):
    return string.replace('\\"', '"').replace("\\\\", "\\")


@dataclass(eq=False, init=False, repr=False)
class TAG_String(_TAG_Value):
    tag_id = TAG_STRING
    _value: str = ""

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> TAG_String:
        return cls(load_string(context, little_endian))

    def write_value(self, buffer, little_endian=False):
        write_string(buffer, self._value, little_endian)

    def _to_snbt(self) -> SNBTType:
        return f'"{escape(self._value)}"'

    def __len__(self) -> int:
        return len(self._value)

    def __getitem__(self, item):
        return self._value.__getitem__(item)

    def __add__(self, other):
        return self._value + primitive_conversion(other)

    def __radd__(self, other):
        return primitive_conversion(other) + self._value

    def __mul__(self, other):
        return self._value * primitive_conversion(other)

    def __rmul__(self, other):
        return primitive_conversion(other) * self._value


@dataclass(eq=False, init=False, repr=False)
class TAG_List(_TAG_Value):
    tag_id = TAG_LIST
    _value: List[AnyNBT] = field(default_factory=list)
    list_data_type: int = TAG_BYTE

    def __init__(self, value: List[AnyNBT] = None, list_data_type: int = TAG_BYTE):
        self.list_data_type = list_data_type
        self._value = []
        if value:
            self._check_tag(value[0])
            self._value = list(value)
            for tag in value[1:]:
                self._check_tag(tag)

    def _check_tag(self, value: _TAG_Value):
        if not isinstance(value, _TAG_Value):
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List. Must be an NBT object."
            )
        if not self._value:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List({TAG_CLASSES[self.list_data_type].__name__})"
            )

    def __getitem__(self, index: int) -> AnyNBT:
        return self._value[index]

    @overload
    def __setitem__(self, index: int, value: AnyNBT):
        ...

    @overload
    def __setitem__(self, index: slice, value: Iterable[AnyNBT]):
        ...

    def __setitem__(self, index, value):
        if isinstance(index, slice):
            map(self._check_tag, value)
        else:
            self._check_tag(value)
        self._value[index] = value

    def __delitem__(self, index: int):
        del self._value[index]

    def __iter__(self) -> Iterator[AnyNBT]:
        return iter(self._value)

    def __contains__(self, item: AnyNBT) -> bool:
        return item in self._value

    def __len__(self) -> int:
        return len(self._value)

    def insert(self, index: int, value: AnyNBT):
        self._check_tag(value)
        self._value.insert(index, value)

    def append(self, value: AnyNBT) -> None:
        self._check_tag(value)
        self._value.append(value)

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> TAG_List:
        tag = cls()
        tag.list_data_type = list_data_type = context.buffer[context.offset]
        context.offset += 1

        if little_endian:
            (list_len,) = TAG_Int.tag_format_le.unpack_from(
                context.buffer, context.offset
            )
            context.offset += TAG_Int.tag_format_le.size
        else:
            (list_len,) = TAG_Int.tag_format_be.unpack_from(
                context.buffer, context.offset
            )
            context.offset += TAG_Int.tag_format_be.size

        for i in range(list_len):
            child_tag = TAG_CLASSES[list_data_type].load_from(context, little_endian)
            tag.append(child_tag)

        return tag

    def write_value(self, buffer, little_endian=False):
        buffer.write(bytes(chr(self.list_data_type), "utf-8"))
        if little_endian:
            buffer.write(TAG_Int.tag_format_le.pack(len(self._value)))
        else:
            buffer.write(TAG_Int.tag_format_be.pack(len(self._value)))

        for item in self._value:
            item.write_value(buffer, little_endian)

    def _to_snbt(self) -> SNBTType:
        return f"[{CommaSpace.join(elem._to_snbt() for elem in self._value)}]"

    def _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        if self._value:
            return f"{indent_chr * indent_count * leading_indent}[\n{CommaNewline.join(elem._pretty_to_snbt(indent_chr, indent_count + 1) for elem in self._value)}\n{indent_chr * indent_count}]"
        else:
            return f"{indent_chr * indent_count * leading_indent}[]"


@dataclass(eq=False, init=False, repr=False)
class TAG_Compound(_TAG_Value, MutableMapping):
    tag_id = TAG_COMPOUND
    _value: Dict[str, AnyNBT] = field(default_factory=dict)

    def __init__(self, value: Dict[str, AnyNBT] = None):
        self._value = value or {}
        for key, value in self._value.items():
            self._check_entry(key, value)

    @staticmethod
    def _check_entry(key: str, value: AnyNBT):
        if not isinstance(key, str):
            raise TypeError(
                f"TAG_Compound key must be a string. Got {key.__class__.__name__}"
            )
        if not isinstance(value, _TAG_Value):
            raise TypeError(
                f'Invalid type {value.__class__.__name__} for key "{key}" in TAG_Compound. Must be an NBT object.'
            )

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> TAG_Compound:
        tag = cls()

        while context.offset < context.size:
            tag_id = context.buffer[context.offset]
            context.offset += 1

            if tag_id == TAG_END:
                break

            tag_name = load_string(context, little_endian)
            child_tag = TAG_CLASSES[tag_id].load_from(context, little_endian)

            tag[tag_name] = child_tag

        return tag

    def write_value(self, buffer, little_endian=False):
        for key, value in self._value.items():
            value.write_payload(buffer, key, little_endian)

        buffer.write(bytes(chr(TAG_END), "utf-8"))

    def __getitem__(self, key: str) -> AnyNBT:
        return self._value.__getitem__(key)

    def __setitem__(self, key: str, value: AnyNBT):
        self._check_entry(key, value)
        self._value.__setitem__(key, value)

    def __delitem__(self, key: str):
        self._value.__delitem__(key)

    def __iter__(self) -> Iterator[str]:
        return self._value.__iter__()

    def __contains__(self, item: str) -> bool:
        return self._value.__contains__(item)

    def __len__(self) -> int:
        return self._value.__len__()

    def _to_snbt(self) -> SNBTType:
        tags = []
        for name, elem in self._value.items():
            if _NON_QUOTED_KEY.match(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f"{name}: {elem.to_snbt()}")
        return f"{{{CommaSpace.join(tags)}}}"

    def _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        if self._value:
            tags = (
                f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}'
                for name, elem in self._value.items()
            )
            return f"{indent_chr * indent_count * leading_indent}{{\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{}}"


@dataclass
class NBTFile:
    _value: TAG_Compound = field(default_factory=TAG_Compound)
    name: str = ""

    def to_snbt(self, indent_chr=None) -> SNBTType:
        return self._value.to_snbt(indent_chr)

    def save_to(
        self, filepath_or_buffer=None, compressed=True, little_endian=False
    ) -> Optional[bytes]:
        buffer = BytesIO()
        self._value.write_payload(buffer, self.name, little_endian)

        data = buffer.getvalue()

        if compressed:
            gzip_buffer = BytesIO()
            with gzip.GzipFile(fileobj=gzip_buffer, mode="wb") as gz:
                gz.write(data)
            data = gzip_buffer.getvalue()

        if not filepath_or_buffer:
            return data

        if isinstance(filepath_or_buffer, str):
            with open(filepath_or_buffer, "wb") as fp:
                fp.write(data)
        else:
            filepath_or_buffer.write(data)

    def __eq__(self, other):
        return isinstance(other, NBTFile) and self._value.__eq__(other._value)

    def __len__(self) -> int:
        return self._value.__len__()

    def keys(self):
        return self._value.keys()

    def values(self):
        self._value.values()

    def __getitem__(self, key: str) -> AnyNBT:
        return self._value[key]

    def __setitem__(self, key: str, tag: AnyNBT):
        self._value[key] = tag

    def __delitem__(self, key: str):
        del self._value[key]

    def __contains__(self, key: str) -> bool:
        return key in self._value

    def pop(self, k, default=None) -> AnyNBT:
        return self._value.pop(k, default)

    def get(self, k, default=None) -> AnyNBT:
        return self._value.get(k, default)

    def __repr__(self):
        return f'NBTFile("{self.name}":{self.to_snbt()})'

    @property
    def value(self):
        return self._value


def load(
    filepath_or_buffer: Union[
        str, bytes, BinaryIO, None
    ] = None,  # TODO: This should become a required input
    compressed=True,
    count: int = None,
    offset: bool = False,
    little_endian: bool = False,
    buffer=None,  # TODO: this should get depreciated and removed.
) -> Union[NBTFile, Tuple[Union[NBTFile, List[NBTFile]], int]]:
    if isinstance(filepath_or_buffer, str):
        # if a string load from the file path
        if not os.path.isfile(filepath_or_buffer):
            raise NBTLoadError(f"There is no file at {filepath_or_buffer}")
        with open(filepath_or_buffer, "rb") as f:
            data_in = f.read()
    else:
        # TODO: when buffer is removed, remove this if block and make the next if block an elif part of the parent if block
        if filepath_or_buffer is None:  # For backwards compatability with buffer.
            if buffer is None:
                raise NBTLoadError("No object given to load.")
            filepath_or_buffer = buffer

        if isinstance(filepath_or_buffer, bytes):
            data_in = filepath_or_buffer
        elif hasattr(filepath_or_buffer, "read"):
            data_in = filepath_or_buffer.read()
            if not isinstance(data_in, bytes):
                raise NBTLoadError(
                    f"buffer.read() must return a bytes object. Got {type(data_in)} instead."
                )
            if hasattr(filepath_or_buffer, "close"):
                filepath_or_buffer.close()
            elif hasattr(filepath_or_buffer, "open"):
                print(
                    "[Warning]: Input buffer didn't have close() function. Memory leak may occur!"
                )
        else:
            raise NBTLoadError("buffer did not have a read method.")

    if compressed:
        data_in = safe_gunzip(data_in)

    context: _BufferContext = _BufferContext(
        offset=0, buffer=data_in, size=len(data_in)
    )
    results = []

    for i in range(count or 1):
        tag_type = context.buffer[context.offset]
        if tag_type != TAG_COMPOUND:
            raise NBTFormatError(
                f"Expecting tag type {TAG_COMPOUND}, got {tag_type} instead"
            )
        context.offset += 1

        tag_name = load_string(context, little_endian)
        tag: TAG_Compound = TAG_Compound.load_from(context, little_endian)

        results.append(NBTFile(tag, tag_name))

    if count is None:
        results = results[0]

    if offset:
        return results, context.offset

    return results


# this is going to be rather slow but should exist as a starting point for functionality

whitespace = re.compile("[ \t\r\n]*")
int_numeric = re.compile("-?[0-9]+[bBsSlL]?")
float_numeric = re.compile("-?[0-9]+\.?[0-9]*[fFdD]?")
alnumplus = re.compile("[-.a-zA-Z0-9_]*")
comma = re.compile("[ \t\r\n]*,[ \t\r\n]*")
colon = re.compile("[ \t\r\n]*:[ \t\r\n]*")
array_lookup = {"B": TAG_Byte_Array, "I": TAG_Int_Array, "L": TAG_Long_Array}


def from_snbt(snbt: SNBTType) -> AnyNBT:
    def strip_whitespace(index) -> int:
        match = whitespace.match(snbt, index)
        if match is None:
            return index
        else:
            return match.end()

    def strip_comma(index, end_chr) -> int:
        match = comma.match(snbt, index)
        if match is None:
            index = strip_whitespace(index)
            if snbt[index] != end_chr:
                raise SNBTParseError(
                    f"Expected a comma or {end_chr} at {index} but got ->{snbt[index:index + 10]} instead"
                )
        else:
            index = match.end()
        return index

    def strip_colon(index) -> int:
        match = colon.match(snbt, index)
        if match is None:
            raise SNBTParseError(
                f"Expected : at {index} but got ->{snbt[index:index + 10]} instead"
            )
        else:
            return match.end()

    def capture_string(index) -> Tuple[str, bool, int]:
        if snbt[index] in ('"', "'"):
            quote = snbt[index]
            strict_str = True
            index += 1
            end_index = index
            while not (  # keep running this until
                snbt[end_index]
                == quote  # the last character is a quote of the same type
                and not (  # and there is an even number of backslashes before it (including 0)
                    len(snbt[:end_index]) - len(snbt[:end_index].rstrip("\\"))
                )
            ):
                end_index += 1

            val = unescape(snbt[index:end_index])
            index = end_index + 1
        else:
            strict_str = False
            match = alnumplus.match(snbt, index)
            val = match.group()
            index = match.end()

        return val, strict_str, index

    def parse_snbt_recursive(index=0) -> Tuple[AnyNBT, int]:
        index = strip_whitespace(index)
        if snbt[index] == "{":
            data_: Dict[str, AnyNBT] = {}
            index += 1
            index = strip_whitespace(index)
            while snbt[index] != "}":
                # read the key
                key, _, index = capture_string(index)

                # get around the colon
                index = strip_colon(index)

                # load the data and save it to the dictionary
                nested_data, index = parse_snbt_recursive(index)
                data_[key] = nested_data

                index = strip_comma(index, "}")
            data = TAG_Compound(data_)
            # skip the }
            index += 1

        elif snbt[index] == "[":
            index += 1
            index = strip_whitespace(index)
            if snbt[index : index + 2] in {"B;", "I;", "L;"}:
                # array
                array = []
                array_type_chr = snbt[index]
                array_type = array_lookup[array_type_chr]
                index += 2
                index = strip_whitespace(index)

                while snbt[index] != "]":
                    match = int_numeric.match(snbt, index)
                    if match is None:
                        raise SNBTParseError(
                            f"Expected an integer value or ] at {index} but got ->{snbt[index:index + 10]} instead"
                        )
                    else:
                        val = match.group()
                        if val[-1].isalpha():
                            if val[-1] == array_type_chr:
                                val = val[:-1]
                            else:
                                raise SNBTParseError(
                                    f'Expected the datatype marker "{array_type_chr}" at {index} but got ->{snbt[index:index + 10]} instead'
                                )
                        array.append(int(val))
                        index = match.end()

                    index = strip_comma(index, "]")
                data = array_type(
                    np.asarray(array, dtype=array_type.big_endian_data_type)
                )
            else:
                # list
                array = []
                first_data_type = None
                while snbt[index] != "]":
                    nested_data, index_ = parse_snbt_recursive(index)
                    if first_data_type is None:
                        first_data_type = nested_data.__class__
                    if not isinstance(nested_data, first_data_type):
                        raise SNBTParseError(
                            f"Expected type {first_data_type.__name__} but got {nested_data.__class__.__name__} at {index}"
                        )
                    else:
                        index = index_
                    array.append(nested_data)
                    index = strip_comma(index, "]")

                if first_data_type is None:
                    data = TAG_List()
                else:
                    data = TAG_List(array, list_data_type=first_data_type.tag_id)

            # skip the ]
            index += 1

        else:
            val, strict_str, index = capture_string(index)
            if strict_str:
                data = TAG_String(val)
            else:
                int_match = int_numeric.match(val)
                if int_match is not None and int_match.end() == len(val):
                    # we have an int type
                    if val[-1] in {"b", "B"}:
                        data = TAG_Byte(int(val[:-1]))
                    elif val[-1] in {"s", "S"}:
                        data = TAG_Short(int(val[:-1]))
                    elif val[-1] in {"l", "L"}:
                        data = TAG_Long(int(val[:-1]))
                    else:
                        data = TAG_Int(int(val))
                else:
                    float_match = float_numeric.match(val)
                    if float_match is not None and float_match.end() == len(val):
                        # we have a float type
                        if val[-1] in {"f", "F"}:
                            data = TAG_Float(float(val[:-1]))
                        elif val[-1] in {"d", "D"}:
                            data = TAG_Double(float(val[:-1]))
                        else:
                            data = TAG_Double(float(val))
                    else:
                        # we just have a string type
                        data = TAG_String(val)

        return data, index

    try:
        return parse_snbt_recursive()[0]
    except SNBTParseError as e:
        raise SNBTParseError(e)
    except IndexError:
        raise SNBTParseError(
            "SNBT string is incomplete. Reached the end of the string."
        )


TAG_CLASSES: Dict[int, Type[_TAG_Value]] = {
    t(None).tag_id: t
    for t in itertools.chain(_TAG_Value.__subclasses__(), _TAG_Array.__subclasses__())
    if t is not _TAG_Array
}
