from __future__ import annotations

import gzip
import itertools
from collections.abc import MutableMapping, MutableSequence
from dataclasses import dataclass, field
from io import BytesIO
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
)
import re

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

NBT_WRAPPER = "python"

_string_len_fmt_be = Struct(">H")
_string_len_fmt_le = Struct("<H")

_NON_QUOTED_KEY = re.compile(r"^[a-zA-Z0-9-]+$")


class NBTFormatError(Exception):
    pass


class SNBTParseError(Exception):
    pass


class _BufferContext:
    __slots__ = ("buffer", "offset", "size")

    def __init__(self, offset: int, buffer, size: int):
        self.offset = offset
        self.buffer = buffer
        self.size = size


def load_string(context: _BufferContext, little_endian=False) -> str:
    data = context.buffer[context.offset:]
    if little_endian:
        (str_len,) = _string_len_fmt_le.unpack_from(data)
    else:
        (str_len,) = _string_len_fmt_be.unpack_from(data)

    value = data[2: str_len + 2].decode("utf-8")
    context.offset += str_len + 2
    return value


def write_string(buffer, _str, little_endian=False):
    encoded_str = _str.encode("utf-8")
    if little_endian:
        buffer.write(pack(f"<H{len(encoded_str)}s", len(encoded_str), encoded_str))
    else:
        buffer.write(pack(f">H{len(encoded_str)}s", len(encoded_str), encoded_str))


@dataclass(eq=False)
class _TAG_Value:
    value: Any
    tag_id: ClassVar[int]
    _data_type: ClassVar[Any]
    tag_format_be: Struct = field(init=False, repr=False, compare=False)
    tag_format_le: Struct = field(init=False, repr=False, compare=False)

    def __new__(cls, *args, **kwargs):
        cls._data_type = get_type_hints(cls)["value"]

        return super(_TAG_Value, cls).__new__(cls)

    def __init__(self, value):
        self.value = self.format(value)

    def __eq__(self, other):
        return self.value == other.value and self.tag_id == other.tag_id

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> _TAG_Value:
        data = context.buffer[context.offset:]
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

    def save(self, buffer, name=None, little_endian=False):
        self.write_tag_id(buffer)
        if name is not None:
            write_string(buffer, name, little_endian)

        self.write_value(buffer, little_endian)

    def write_value(self, buffer, little_endian=False):
        if little_endian:
            buffer.write(self.tag_format_le.pack(self.value))
        else:
            buffer.write(self.tag_format_be.pack(self.value))

    def to_snbt(self):
        raise NotImplemented


@dataclass(eq=False)
class TAG_Byte(_TAG_Value):
    value: int = 0
    tag_id = TAG_BYTE
    tag_format_be = Struct(">b")
    tag_format_le = Struct("<b")

    def to_snbt(self):
        return f"{self.value}b"


@dataclass(eq=False)
class TAG_Short(_TAG_Value):
    value: int = 0
    tag_id = TAG_SHORT
    tag_format_be = Struct(">h")
    tag_format_le = Struct("<h")

    def to_snbt(self):
        return f"{self.value}s"


@dataclass(eq=False)
class TAG_Int(_TAG_Value):
    value: int = 0
    tag_id = TAG_INT
    tag_format_be = Struct(">i")
    tag_format_le = Struct("<i")

    def to_snbt(self):
        return f"{self.value}"


@dataclass(eq=False)
class TAG_Long(_TAG_Value):
    value: int = 0
    tag_id = TAG_LONG
    tag_format_be = Struct(">q")
    tag_format_le = Struct("<q")

    def to_snbt(self):
        return f"{self.value}L"


@dataclass(eq=False)
class TAG_Float(_TAG_Value):
    value: float = 0
    tag_id = TAG_FLOAT
    tag_format_be = Struct(">f")
    tag_format_le = Struct("<f")

    def to_snbt(self):
        return f"{self.value}f"


@dataclass(eq=False)
class TAG_Double(_TAG_Value):
    value: float = 0
    tag_id = TAG_DOUBLE
    tag_format_be = Struct(">d")
    tag_format_le = Struct("<d")

    def to_snbt(self):
        return f"{self.value}d"


@dataclass(eq=False)
class _TAG_Array(_TAG_Value):
    big_endian_data_type: ClassVar[Any]
    little_endian_data_type: ClassVar[Any]
    value: np.ndarray = np.zeros(0)

    def __eq__(self, other: _TAG_Array):
        return (
            self.tag_id == other.tag_id and np.array_equal(self.value, other.value)
        )

    def __len__(self):
        return len(self.value)

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> _TAG_Value:
        data_type = cls.little_endian_data_type if little_endian else cls.big_endian_data_type
        data = context.buffer[context.offset:]
        if little_endian:
            (string_len,) = TAG_Int.tag_format_le.unpack_from(data)
        else:
            (string_len,) = TAG_Int.tag_format_be.unpack_from(data)
        value = np.frombuffer(
            data[4: string_len * data_type.itemsize + 4], dtype=data_type
        )
        context.offset += string_len * data_type.itemsize + 4

        return cls(value=value)

    def write_value(self, buffer, little_endian=False):
        data_type = self.little_endian_data_type if little_endian else self.big_endian_data_type
        if self.value.dtype != data_type:
            if self.value.dtype != self.big_endian_data_type if little_endian else self.little_endian_data_type:
                print(f'[Warning] Mismatch array dtype. Expected: {data_type.str}, got: {self.value.dtype.str}')
            self.value = self.value.astype(data_type)
        if little_endian:
            value = self.value.tostring()
            buffer.write(pack(f"<I{len(value)}s", self.value.size, value))
        else:
            value = self.value.tostring()
            buffer.write(pack(f">I{len(value)}s", self.value.size, value))


@dataclass(eq=False)
class TAG_Byte_Array(_TAG_Array):
    big_endian_data_type = little_endian_data_type = np.dtype("int8")
    tag_id = TAG_BYTE_ARRAY

    def __init__(self, value: np.array = None):
        super(TAG_Byte_Array, self).__init__(value)
        if self.value is None:
            self.value = np.zeros(0, self.big_endian_data_type)
        if self.value.dtype != self.big_endian_data_type:
            self.value = self.value.astype(self.big_endian_data_type)

    def to_snbt(self):
        return f"[B;{'B, '.join(str(val) for val in self.value)}B]"


@dataclass(eq=False)
class TAG_Int_Array(_TAG_Array):
    big_endian_data_type = np.dtype(">i4")
    little_endian_data_type = np.dtype("<i4")
    tag_id = TAG_INT_ARRAY

    def __init__(self, value: np.array = None):
        super(TAG_Int_Array, self).__init__(value)
        if self.value is None:
            self.value = np.zeros(0, self.big_endian_data_type)
        if self.value.dtype != self.big_endian_data_type:
            self.value = self.value.astype(self.big_endian_data_type)

    def to_snbt(self):
        return f"[I;{', '.join(str(val) for val in self.value)}]"


@dataclass(eq=False)
class TAG_Long_Array(_TAG_Array):
    big_endian_data_type = np.dtype(">i8")
    little_endian_data_type = np.dtype("<i8")
    tag_id = TAG_LONG_ARRAY

    def __init__(self, value: np.array = None):
        super(TAG_Long_Array, self).__init__(value)
        if self.value is None:
            self.value = np.zeros(0, self.big_endian_data_type)
        if self.value.dtype != self.big_endian_data_type:
            self.value = self.value.astype(self.big_endian_data_type)

    def to_snbt(self):
        return f"[L;{', '.join(str(val) for val in self.value)}]"


def escape(string: str):
    return string.replace("\\", "\\\\").replace('"', '\\"')


@dataclass
class TAG_String(_TAG_Value):
    tag_id = TAG_STRING
    value: str = ""

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> _TAG_Value:
        return cls(load_string(context, little_endian))

    def write_value(self, buffer, little_endian=False):
        write_string(buffer, self.value, little_endian)

    def to_snbt(self):
        return f'"{escape(self.value)}"'


@dataclass
class TAG_List(_TAG_Value, MutableSequence):
    tag_id = TAG_LIST
    value: List[_TAG_Value] = field(default_factory=list)
    list_data_type: int = TAG_END

    def __getitem__(self, index: int) -> _TAG_Value:
        return self.value.__getitem__(index)

    def __setitem__(self, index: int, value: _TAG_Value):
        self.value.__setitem__(index, value)

    def __delitem__(self, index: int):
        self.value.__delitem__(index)

    def __contains__(self, item: _TAG_Value) -> bool:
        return self.value.__contains__(item)

    def __len__(self) -> int:
        return self.value.__len__()

    def __iter__(self):
        return self.value.__iter__()

    def _modify_type(self, value_type):
        if value_type != self.list_data_type:
            if len(self.value) == 0:
                self.list_data_type = value_type
            else:
                raise NBTFormatError(
                    f"TAG_List contains type {self.list_data_type} but insert was given {value_type}"
                )

    def insert(self, index: int, value: _TAG_Value):
        self._modify_type(value.tag_id)
        self.value.insert(index, value)

    def append(self, value: _TAG_Value) -> None:
        self._modify_type(value.tag_id)
        self.value.append(value)

    def __eq__(self, other):
        return (
            self.tag_id == other.tag_id
            and self.list_data_type == other.list_data_type
            and all(map(lambda i1, i2: i1 == i2, self.value, other.value))
        )

    @classmethod
    def load_from(cls, context: _BufferContext, little_endian: bool) -> _TAG_Value:
        tag = cls()
        tag.list_data_type = list_data_type = context.buffer[context.offset]
        context.offset += 1

        if little_endian:
            (list_len,) = TAG_Int.tag_format_le.unpack_from(context.buffer, context.offset)
            context.offset += TAG_Int.tag_format_le.size
        else:
            (list_len,) = TAG_Int.tag_format_be.unpack_from(context.buffer, context.offset)
            context.offset += TAG_Int.tag_format_be.size

        for i in range(list_len):
            child_tag = TAG_CLASSES[list_data_type].load_from(context, little_endian)
            tag.append(child_tag)

        return tag

    def write_value(self, buffer, little_endian=False):
        buffer.write(bytes(chr(self.list_data_type), "utf-8"))
        if little_endian:
            buffer.write(TAG_Int.tag_format_le.pack(len(self.value)))
        else:
            buffer.write(TAG_Int.tag_format_be.pack(len(self.value)))

        for item in self.value:
            item.write_value(buffer, little_endian)

    def to_snbt(self):
        return f"[{', '.join(elem.to_snbt() for elem in self.value)}]"


@dataclass
class TAG_Compound(_TAG_Value, MutableMapping):
    tag_id = TAG_COMPOUND
    value: Dict[str, _TAG_Value] = field(default_factory=dict)

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
        for key, value in self.value.items():
            value.save(buffer, key, little_endian)

        buffer.write(bytes(chr(TAG_END), "utf-8"))

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value.__getitem__(key)

    def __setitem__(self, key: str, value: _TAG_Value):
        self.value.__setitem__(key, value)

    def __delitem__(self, key: str):
        self.value.__delitem__(key)

    def __contains__(self, item: str) -> bool:
        return self.value.__contains__(item)

    def __len__(self) -> int:
        return self.value.__len__()

    def __iter__(self):
        return self.value.__iter__()

    def __eq__(self, other):
        return self.tag_id == other.tag_id and self.value == other.value

    def to_snbt(self):
        # TODO: make this faster
        data = (
            (
                f'"{name}"' if _NON_QUOTED_KEY.match(name) is None else name,
                elem.to_snbt(),
            )
            for name, elem in self.value.items()
        )
        return f"{{{', '.join(f'{name}: {elem}' for name, elem in data)}}}"


@dataclass
class NBTFile:
    value: TAG_Compound
    name: str = ""

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value[key]

    def __setitem__(self, key: str, tag: _TAG_Value):
        self.value[key] = tag

    def __delitem__(self, key: str):
        del self.value[key]

    def keys(self):
        return self.value.keys()

    def values(self):
        self.value.values()

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __len__(self) -> int:
        return self.value.__len__()

    def save_to(
        self, filename_or_buffer=None, compressed=True, little_endian=False
    ) -> Optional[Union[BytesIO, bytes]]:
        buffer = BytesIO()
        self.value.save(buffer, self.name, little_endian)

        data = buffer.getvalue()

        if compressed:
            gzip_buffer = BytesIO()
            gz = gzip.GzipFile(fileobj=gzip_buffer, mode="wb")
            gz.write(data)
            gz.close()
            data = gzip_buffer.getvalue()

        if not filename_or_buffer:
            return data

        if isinstance(filename_or_buffer, str):
            fp = open(filename_or_buffer, "wb")
            fp.write(data)
            fp.close()
        else:
            filename_or_buffer.write(data)

    def to_snbt(self):
        return self.value.to_snbt()


def safe_gunzip(data):
    try:
        data = gzip.GzipFile(fileobj=BytesIO(data)).read()
    except IOError as e:
        pass
    return data


def load(
    filename="", buffer=None, compressed=True, count: int = None, offset: bool = False, little_endian: bool = False
) -> Union[NBTFile, Tuple[Union[NBTFile, List[NBTFile]], int]]:
    if filename:
        buffer = open(filename, "rb")
    data_in = buffer

    if hasattr(buffer, "read"):
        data_in = buffer.read()

    if hasattr(buffer, "close"):
        buffer.close()
    elif hasattr(buffer, "open"):
        print(
            "[Warning]: Input buffer didn't have close() function. Memory leak may occur!"
        )

    if compressed:
        data_in = safe_gunzip(data_in)

    context: _BufferContext = _BufferContext(
        offset=0, buffer=data_in, size=len(data_in)
    )
    results = []

    for i in range(count or 1):
        tag_type = context.buffer[context.offset]
        if tag_type != TAG_COMPOUND:
            raise NBTFormatError(f"Expecting tag type {TAG_COMPOUND}, got {tag_type} instead")
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


def from_snbt(snbt: str) -> _TAG_Value:
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

            val = snbt[index:end_index]
            index = end_index + 1
        else:
            strict_str = False
            match = alnumplus.match(snbt, index)
            val = match.group()
            index = match.end()

        return val, strict_str, index

    def parse_snbt_recursive(index=0) -> Tuple[_TAG_Value, int]:
        index = strip_whitespace(index)
        if snbt[index] == "{":
            data_: Dict[str, _TAG_Value] = {}
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
                data = array_type(np.asarray(array, dtype=array_type.data_type))
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
                    data = TAG_List(array, first_data_type.tag_id)

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
    t().tag_id: t
    for t in itertools.chain(_TAG_Value.__subclasses__(), _TAG_Array.__subclasses__())
    if t is not _TAG_Array
}
