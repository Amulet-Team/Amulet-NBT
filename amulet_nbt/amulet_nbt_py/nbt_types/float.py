from __future__ import annotations

from struct import Struct
from typing import ClassVar, Union
import numpy as np

from ..const import SNBTType
from .numeric import NumericTAG


class BaseFloatTAG(NumericTAG):
    _value: np.floating
    _data_type: ClassVar = np.floating

    def __init__(self, value: Union[int, float, np.number, NumericTAG, None] = None):
        if self.__class__ is BaseFloatTAG:
            raise TypeError(
                "BaseFloatTAG cannot be directly instanced. Use one of its subclasses."
            )
        super().__init__(value)

    @property
    def value(self) -> float:
        return float(self._value)

    def _to_snbt(self) -> SNBTType:
        return self.fstring.format(f"{self._value:.20f}".rstrip("0"))


class TAG_Float(BaseFloatTAG):
    tag_id: ClassVar[int] = 5
    _value: np.float32
    _data_type: ClassVar = np.float32
    tag_format_be = Struct(">f")
    tag_format_le = Struct("<f")
    fstring = "{}f"


class TAG_Double(BaseFloatTAG):
    tag_id: ClassVar[int] = 6
    _value: np.float64
    _data_type: ClassVar = np.float64
    tag_format_be = Struct(">d")
    tag_format_le = Struct("<d")
    fstring = "{}d"
