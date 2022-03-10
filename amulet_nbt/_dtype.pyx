from typing import Union

from ._int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from ._float cimport (
    FloatTag,
    DoubleTag,
)
from ._array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from ._string cimport StringTag
from ._list cimport ListTag
from ._compound cimport CompoundTag

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
