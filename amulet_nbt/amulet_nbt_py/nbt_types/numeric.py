from __future__ import annotations

from typing import (
    ClassVar,
    BinaryIO,
    Union,
)
from struct import Struct
import numpy as np

from amulet_nbt.amulet_nbt_py.const import SNBTType

from .value import TAG_Value


class NumericTAG(TAG_Value):
    _value: np.number
    _data_type: ClassVar = np.number
    tag_format_be: ClassVar[Struct] = None
    tag_format_le: ClassVar[Struct] = None
    fstring: str = None

    def __init__(self, value: Union[int, float, np.number, NumericTAG, None] = None):
        if self.__class__ is NumericTAG:
            raise TypeError(
                "NumericTAG cannot be directly instanced. Use one of its subclasses."
            )
        assert isinstance(
            self.tag_format_be, Struct
        ), f"tag_format_be not set for {self.__class__}"
        assert isinstance(
            self.tag_format_le, Struct
        ), f"tag_format_le not set for {self.__class__}"
        assert isinstance(self.fstring, str), f"fstring not set for {self.__class__}"
        super().__init__(value)

    @classmethod
    def load_from(cls, context: BinaryIO, little_endian: bool):
        if little_endian:
            data = context.read(cls.tag_format_le.size)
            tag = cls(cls.tag_format_le.unpack_from(data)[0])
        else:
            data = context.read(cls.tag_format_be.size)
            tag = cls(cls.tag_format_be.unpack_from(data)[0])
        return tag

    def write_value(self, buffer: BinaryIO, little_endian=False):
        if little_endian:
            buffer.write(self.tag_format_le.pack(self._value))
        else:
            buffer.write(self.tag_format_be.pack(self._value))

    def _to_snbt(self) -> SNBTType:
        return self.fstring.format(self._value)

    def _to_python(self, value):
        """Convert numpy data types to their python equivalent."""
        if isinstance(value, np.floating):
            return float(value)
        elif isinstance(value, np.integer):
            return int(value)
        elif isinstance(value, np.generic):
            raise ValueError(f"Unexpected numpy type {type(value)}")
        else:
            return value

    def __add__(self, other):
        return self._to_python(self._value.__add__(self.get_primitive(other)))

    def __radd__(self, other):
        return self._to_python(self._value.__radd__(self.get_primitive(other)))

    def __iadd__(self, other):
        return self.__class__(self._value.__add__(self.get_primitive(other)))

    def __sub__(self, other):
        return self._to_python(self._value.__sub__(self.get_primitive(other)))

    def __rsub__(self, other):
        return self._to_python(self._value.__rsub__(self.get_primitive(other)))

    def __isub__(self, other):
        return self.__class__(self._value.__sub__(self.get_primitive(other)))

    def __mul__(self, other):
        return self._to_python(self._value.__mul__(self.get_primitive(other)))

    def __rmul__(self, other):
        return self._to_python(self._value.__rmul__(self.get_primitive(other)))

    def __imul__(self, other):
        return self.__class__(self._value.__mul__(self.get_primitive(other)))

    def __truediv__(self, other):
        return self._to_python(self._value.__truediv__(self.get_primitive(other)))

    def __rtruediv__(self, other):
        return self._to_python(self._value.__rtruediv__(self.get_primitive(other)))

    def __itruediv__(self, other):
        return self.__class__(self._value.__truediv__(self.get_primitive(other)))

    def __floordiv__(self, other):
        return self._to_python(self._value.__floordiv__(self.get_primitive(other)))

    def __rfloordiv__(self, other):
        return self._to_python(self._value.__rfloordiv__(self.get_primitive(other)))

    def __ifloordiv__(self, other):
        return self.__class__(self._value.__floordiv__(self.get_primitive(other)))

    def __mod__(self, other):
        return self._to_python(self._value.__mod__(self.get_primitive(other)))

    def __rmod__(self, other):
        return self._to_python(self._value.__rmod__(self.get_primitive(other)))

    def __imod__(self, other):
        return self.__class__(self._value.__mod__(self.get_primitive(other)))

    def __divmod__(self, other):
        return self._to_python(self._value.__divmod__(self.get_primitive(other)))

    def __rdivmod__(self, other):
        return self._to_python(self._value.__rdivmod__(self.get_primitive(other)))

    def __pow__(self, power, modulo):
        return self._to_python(
            self._value.__pow__(self.get_primitive(power), self.get_primitive(modulo))
        )

    def __rpow__(self, other, modulo):
        return self._to_python(
            self._value.__rpow__(self.get_primitive(other), self.get_primitive(modulo))
        )

    def __ipow__(self, other):
        return self.__class__(self._value.__pow__(self.get_primitive(other)))

    def __neg__(self):
        return self._to_python(self._value.__neg__())

    def __pos__(self):
        return self._to_python(self._value.__pos__())

    def __abs__(self):
        return self._to_python(self._value.__abs__())

    def __int__(self):
        return self._value.__int__()

    def __float__(self):
        return self._value.__float__()

    def __round__(self, n=None):
        return self._value.__round__(n)

    def __trunc__(self):
        return self._value.__trunc__()

    def __floor__(self):
        return self._value.__floor__()

    def __ceil__(self):
        return self._value.__ceil__()

    def __bool__(self):
        return self._value.__bool__()
