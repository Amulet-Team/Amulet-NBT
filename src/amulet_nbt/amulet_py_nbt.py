from __future__ import annotations

import traceback
from dataclasses import dataclass, field
from struct import Struct
from typing import Any, ClassVar, get_type_hints

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

class _BufferContext:
    __slots__ = ("offset", "buffer", "size")

@dataclass
class _TAG_Value:
    value: Any
    tag_id: ClassVar[int]
    _data_type: ClassVar[Any]
    _tag_format: Struct = field(init=False, repr=False)

    def __new__(cls, *args, **kwargs):
        cls._data_type = get_type_hints(cls)["value"]

        return super(_TAG_Value, cls).__new__(cls)

    def __init__(self, value):
        self.value = self.format(value)

    @classmethod
    def load_from(cls, context: _BufferContext) -> _TAG_Value:
        data = context.buffer[context.offset:]
        tag = cls(cls._tag_format.unpack_from(data))
        context.offset += cls._tag_format.size
        return tag

    def format(self, value):
        return self._data_type(value)

@dataclass
class TAG_Byte(_TAG_Value):
    value: int = 0
    tag_id = TAG_BYTE
    _tag_format = Struct(">b")

@dataclass
class TAG_Short(_TAG_Value):
    value: int = 0
    tag_id = TAG_SHORT
    _tag_format = Struct(">h")

@dataclass
class TAG_Int(_TAG_Value):
    value: int = 0
    tag_id = TAG_INT
    _tag_format = Struct(">i")

@dataclass
class TAG_Long(_TAG_Value):
    value: int = 0
    tag_id = TAG_LONG
    _tag_format = Struct(">q")

@dataclass
class TAG_Float(_TAG_Value):
    value: float = 0
    tag_id = TAG_FLOAT
    _tag_format = Struct(">f")



try:
    from .amulet_py_nbt import *
    print("Using Amulet NBT library")
except ImportError as e:
    traceback.print_exc()
    print("Using python NBT library")

print(NBT_WRAPPER)
