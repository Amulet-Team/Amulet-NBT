from __future__ import annotations

from struct import Struct
from typing import ClassVar, Union
import numpy as np

from .numeric import NumericTAG


class BaseIntegerTAG(NumericTAG):
    _value: np.signedinteger
    _data_type: ClassVar = np.signedinteger

    def __init__(self, value: Union[int, float, np.number, NumericTAG, None] = None):
        if self.__class__ is BaseIntegerTAG:
            raise TypeError(
                "BaseIntegerTAG cannot be directly instanced. Use one of its subclasses."
            )
        super().__init__(value)

    @property
    def value(self) -> int:
        return int(self._value)

    def __lshift__(self, other):
        return self._value.__lshift__(self.get_primitive(other))

    def __rlshift__(self, other):
        return self._value.__rlshift__(self.get_primitive(other))

    def __ilshift__(self, other):
        return self.__class__(self._value.__lshift__(self.get_primitive(other)))

    def __rshift__(self, other):
        return self._value.__rshift__(self.get_primitive(other))

    def __rrshift__(self, other):
        return self._value.__rrshift__(self.get_primitive(other))

    def __irshift__(self, other):
        return self.__class__(self._value.__rshift__(self.get_primitive(other)))

    def __and__(self, other):
        return self._value.__and__(self.get_primitive(other))

    def __rand__(self, other):
        return self._value.__rand__(self.get_primitive(other))

    def __iand__(self, other):
        return self.__class__(self._value.__and__(self.get_primitive(other)))

    def __xor__(self, other):
        return self._value.__xor__(self.get_primitive(other))

    def __rxor__(self, other):
        return self._value.__rxor__(self.get_primitive(other))

    def __ixor__(self, other):
        return self.__class__(self._value.__xor__(self.get_primitive(other)))

    def __or__(self, other):
        return self._value.__or__(self.get_primitive(other))

    def __ror__(self, other):
        return self._value.__ror__(self.get_primitive(other))

    def __ior__(self, other):
        return self.__class__(self._value.__or__(self.get_primitive(other)))

    def __invert__(self):
        return self._value.__invert__()


class TAG_Byte(BaseIntegerTAG):
    tag_id: ClassVar[int] = 1
    _value: np.int8
    _data_type: ClassVar = np.int8
    tag_format_be = Struct(">b")
    tag_format_le = Struct("<b")
    fstring = "{}b"


class TAG_Short(BaseIntegerTAG):
    tag_id: ClassVar[int] = 2
    _value: np.int16
    _data_type: ClassVar = np.int16
    tag_format_be = Struct(">h")
    tag_format_le = Struct("<h")
    fstring = "{}s"


class TAG_Int(BaseIntegerTAG):
    tag_id: ClassVar[int] = 3
    _value: np.int32
    _data_type: ClassVar = np.int32
    tag_format_be = Struct(">i")
    tag_format_le = Struct("<i")
    fstring = "{}"


class TAG_Long(BaseIntegerTAG):
    tag_id: ClassVar[int] = 4
    _value: np.int64
    _data_type: ClassVar = np.int64
    tag_format_be = Struct(">q")
    tag_format_le = Struct("<q")
    fstring = "{}L"
