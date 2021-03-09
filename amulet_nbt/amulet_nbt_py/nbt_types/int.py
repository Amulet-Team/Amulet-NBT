from __future__ import annotations

from struct import Struct
from typing import ClassVar, Optional

from .numeric import NumericTAG


class BaseIntegerTAG(NumericTAG):
    _value: int
    _data_type: ClassVar = int

    def __init__(self, value: Optional[int] = None):
        if self.__class__ is BaseIntegerTAG:
            raise TypeError(
                "BaseIntegerTAG cannot be directly instanced. Use one of its subclasses."
            )
        super().__init__(value)

    @property
    def value(self) -> int:
        return self._value

    def __lshift__(self, other):
        return self._value << self.get_primitive(other)

    def __rlshift__(self, other):
        return self.get_primitive(other) << self._value

    def __rshift__(self, other):
        return self._value >> self.get_primitive(other)

    def __rrshift__(self, other):
        return self.get_primitive(other) >> self._value

    def __and__(self, other):
        return self._value & self.get_primitive(other)

    def __rand__(self, other):
        return self.get_primitive(other) & self._value

    def __xor__(self, other):
        return self._value ^ self.get_primitive(other)

    def __rxor__(self, other):
        return self.get_primitive(other) ^ self._value

    def __or__(self, other):
        return self._value | self.get_primitive(other)

    def __ror__(self, other):
        return self.get_primitive(other) | self._value

    def __invert__(self):
        return ~self._value


class TAG_Byte(BaseIntegerTAG):
    tag_id = 1
    tag_format_be = Struct(">b")
    tag_format_le = Struct("<b")
    fstring = "{}b"


class TAG_Short(BaseIntegerTAG):
    tag_id = 2
    tag_format_be = Struct(">h")
    tag_format_le = Struct("<h")
    fstring = "{}s"


class TAG_Int(BaseIntegerTAG):
    tag_id = 3
    tag_format_be = Struct(">i")
    tag_format_le = Struct("<i")
    fstring = "{}"


class TAG_Long(BaseIntegerTAG):
    tag_id = 4
    tag_format_be = Struct(">q")
    tag_format_le = Struct("<q")
    fstring = "{}L"
