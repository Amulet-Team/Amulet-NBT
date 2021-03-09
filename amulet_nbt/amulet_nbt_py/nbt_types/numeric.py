from __future__ import annotations

from typing import (
    ClassVar,
    Optional,
    BinaryIO,
)
from struct import Struct
from math import floor, ceil, trunc

from amulet_nbt.amulet_nbt_py.const import SNBTType

from .value import TAG_Value


class NumericTAG(TAG_Value):
    tag_format_be: ClassVar[Struct] = None
    tag_format_le: ClassVar[Struct] = None
    fstring: str = None

    def __init__(self, value: Optional[int] = None):
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

    def __eq__(self, other):
        return self._value == self.get_primitive(other)

    def __add__(self, other):
        return self._value + self.get_primitive(other)

    def __radd__(self, other):
        return self.get_primitive(other) + self._value

    def __sub__(self, other):
        return self._value - self.get_primitive(other)

    def __rsub__(self, other):
        return self.get_primitive(other) - self._value

    def __mul__(self, other):
        return self._value * self.get_primitive(other)

    def __rmul__(self, other):
        return self.get_primitive(other) * self._value

    def __truediv__(self, other):
        return self._value / self.get_primitive(other)

    def __rtruediv__(self, other):
        return self.get_primitive(other) / self._value

    def __floordiv__(self, other):
        return self._value // self.get_primitive(other)

    def __rfloordiv__(self, other):
        return self.get_primitive(other) // self._value

    def __mod__(self, other):
        return self._value % self.get_primitive(other)

    def __rmod__(self, other):
        return self.get_primitive(other) % self._value

    def __divmod__(self, other):
        return divmod(self._value, self.get_primitive(other))

    def __rdivmod__(self, other):
        return divmod(self.get_primitive(other), self._value)

    def __pow__(self, power, modulo):
        return pow(self._value, power, modulo)

    def __rpow__(self, other, modulo):
        return pow(self.get_primitive(other), self._value, modulo)

    def __neg__(self):
        return -self._value

    def __pos__(self):
        return +self._value

    def __abs__(self):
        return abs(self._value)

    def __int__(self):
        return int(self._value)

    def __float__(self):
        return float(self._value)

    def __round__(self, n=None):
        return round(self._value, n)

    def __trunc__(self):
        return trunc(self._value)

    def __floor__(self):
        return floor(self._value)

    def __ceil__(self):
        return ceil(self._value)

    def __getattr__(self, item):
        return self._value.__getattribute__(item)

    def __dir__(self):
        return dir(self._value)

    def __bool__(self):
        return bool(self)

    def __ge__(self, other):
        return self._value >= self.get_primitive(other)

    def __gt__(self, other):
        return self._value > self.get_primitive(other)

    def __le__(self, other):
        return self._value <= self.get_primitive(other)

    def __lt__(self, other):
        return self._value < self.get_primitive(other)
