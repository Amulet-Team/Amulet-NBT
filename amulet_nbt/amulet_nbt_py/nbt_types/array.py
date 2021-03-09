from __future__ import annotations

from typing import BinaryIO, ClassVar, Union, Iterable
import numpy as np

from amulet_nbt.amulet_nbt_py.const import SNBTType
from .int import TAG_Int
from .value import TAG_Value
from ..errors import NBTError
from ..const import CommaSpace


class ArrayTag(TAG_Value):
    _value: np.ndarray
    big_endian_data_type: ClassVar[np.dtype] = None
    little_endian_data_type: ClassVar[np.dtype] = None

    def __init__(
        self,
        value: Union[
            np.ndarray,
            Iterable[int],
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
            None,
        ] = None,
    ):
        if value is None:
            value = np.zeros((0,), self.big_endian_data_type)
        elif isinstance(value, (TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array)):
            value = value.value
        elif not isinstance(value, np.ndarray):
            value = np.array(value, self.big_endian_data_type)

        if isinstance(value, np.ndarray):
            if value.dtype != self.big_endian_data_type:
                value = value.astype(self.big_endian_data_type)
        else:
            raise NBTError(
                f"Unexpected object {value} given to {self.__class__.__name__}"
            )

        super().__init__(value)

    @property
    def value(self) -> np.ndarray:
        return self._value

    @classmethod
    def load_from(cls, context: BinaryIO, little_endian: bool):
        data_type: np.dtype = (
            cls.little_endian_data_type if little_endian else cls.big_endian_data_type
        )
        if little_endian:
            (string_len,) = TAG_Int.tag_format_le.unpack(
                context.read(TAG_Int.tag_format_le.size)
            )
        else:
            (string_len,) = TAG_Int.tag_format_be.unpack(
                context.read(TAG_Int.tag_format_be.size)
            )
        value = np.frombuffer(
            context.read(string_len * data_type.itemsize), dtype=data_type
        )
        return cls(value)

    def write_value(self, buffer: BinaryIO, little_endian=False):
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
        value = self._value.tobytes()
        if little_endian:
            buffer.write(TAG_Int.tag_format_le.pack(self._value.size))
        else:
            buffer.write(TAG_Int.tag_format_be.pack(self._value.size))
        buffer.write(value)

    def __eq__(self, other):
        return self._value.__eq__(self.get_primitive(other))

    def __getitem__(self, item):
        return self._value.__getitem__(item)

    def __setitem__(self, key, value):
        self._value.__setitem__(key, value)

    def __getattr__(self, item):
        return self._value.__getattribute__(item)

    def __dir__(self):
        return self._value.__dir__()

    def __array__(self):
        return self._value

    def __len__(self):
        return self._value.__len__()

    def __add__(self, other):
        return self._value.__add__(self.get_primitive(other))

    def __sub__(self, other):
        return self._value.__sub__(self.get_primitive(other))

    def __mul__(self, other):
        return self._value.__mul__(self.get_primitive(other))

    def __matmul__(self, other):
        return self._value.__matmul__(self.get_primitive(other))

    def __truediv__(self, other):
        return self._value.__truediv__(self.get_primitive(other))

    def __floordiv__(self, other):
        return self._value.__floordiv__(self.get_primitive(other))

    def __mod__(self, other):
        return self._value.__mod__(self.get_primitive(other))

    def __divmod__(self, other):
        return self._value.__divmod__(self.get_primitive(other))

    def __pow__(self, power, modulo):
        return self._value.__pow__(power, modulo)

    def __lshift__(self, other):
        return self._value.__lshift__(self.get_primitive(other))

    def __rshift__(self, other):
        return self._value.__rshift__(self.get_primitive(other))

    def __and__(self, other):
        return self._value.__and__(self.get_primitive(other))

    def __xor__(self, other):
        return self._value.__xor__(self.get_primitive(other))

    def __or__(self, other):
        return self._value.__or__(self.get_primitive(other))

    def __radd__(self, other):
        return self._value.__radd__(self.get_primitive(other))

    def __rsub__(self, other):
        return self._value.__rsub__(self.get_primitive(other))

    def __rmul__(self, other):
        return self._value.__rmul__(self.get_primitive(other))

    def __rtruediv__(self, other):
        return self._value.__rtruediv__(self.get_primitive(other))

    def __rfloordiv__(self, other):
        return self._value.__rfloordiv__(self.get_primitive(other))

    def __rmod__(self, other):
        return self._value.__rmod__(self.get_primitive(other))

    def __rdivmod__(self, other):
        return self._value.__rdivmod__(self.get_primitive(other))

    def __rpow__(self, other, modulo):
        return self._value.__rpow__(self.get_primitive(other))

    def __rlshift__(self, other):
        return self._value.__rlshift__(self.get_primitive(other))

    def __rrshift__(self, other):
        return self._value.__rrshift__(self.get_primitive(other))

    def __rand__(self, other):
        return self._value.__rand__(self.get_primitive(other))

    def __rxor__(self, other):
        return self._value.__rxor__(self.get_primitive(other))

    def __ror__(self, other):
        return self._value.__ror__(self.get_primitive(other))

    def __neg__(self):
        return self._value.__neg__()

    def __pos__(self):
        return self._value.__pos__()

    def __abs__(self):
        return self._value.__abs__()


class TAG_Byte_Array(ArrayTag):
    big_endian_data_type = little_endian_data_type = np.dtype("int8")
    tag_id = 7

    def _to_snbt(self) -> SNBTType:
        return f"[B;{'B, '.join(str(val) for val in self._value)}B]"


class TAG_Int_Array(ArrayTag):
    big_endian_data_type = np.dtype(">i4")
    little_endian_data_type = np.dtype("<i4")
    tag_id = 11

    def _to_snbt(self) -> SNBTType:
        return f"[I;{CommaSpace.join(str(val) for val in self._value)}]"


class TAG_Long_Array(ArrayTag):
    big_endian_data_type = np.dtype(">i8")
    little_endian_data_type = np.dtype("<i8")
    tag_id = 12

    def _to_snbt(self) -> SNBTType:
        return f"[L;{CommaSpace.join(str(val) for val in self._value)}]"
