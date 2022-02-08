from typing import Union

from .int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from .float cimport (
    FloatTag,
    DoubleTag,
)
from .array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from .string cimport StringTag
from .list cimport ListTag
from .compound cimport CompoundTag

SNBTType = str

IntType = Union[
    ByteTag,
    ShortTag,
    IntTag,
    LongTag
]

FloatType = Union[
    FloatTag,
    DoubleTag
]

NumberType = Union[
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag
]

ArrayType = Union[
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag
]

AnyNBT = Union[
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    IntArrayTag,
    LongArrayTag
]
