from __future__ import annotations

from struct import Struct
from typing import ClassVar, Any, Optional

from ..data_types import SNBTType
from .numeric import NumericTAG


class BaseFloatTAG(NumericTAG):
    _value: float
    _data_type: ClassVar[Any] = float

    def __init__(self, value: Optional[float] = None):
        if self.__class__ is BaseFloatTAG:
            raise TypeError(
                "BaseFloatTAG cannot be directly instanced. Use one of its subclasses."
            )
        super().__init__(value)

    @property
    def value(self) -> float:
        return self._value

    def _to_snbt(self) -> SNBTType:
        return self.fstring.format(f"{self._value:.20f}".rstrip("0"))

    def is_integer(self):
        return self._value.is_integer()


class TAG_Float(BaseFloatTAG):
    tag_id = 5
    tag_format_be = Struct(">f")
    tag_format_le = Struct("<f")
    fstring = "{}f"


class TAG_Double(BaseFloatTAG):
    tag_id = 6
    tag_format_be = Struct(">d")
    tag_format_le = Struct("<d")
    fstring = "{}d"
