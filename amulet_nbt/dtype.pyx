from typing import Union

from .int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    NamedByteTag,
    NamedShortTag,
    NamedIntTag,
    NamedLongTag,
)
from .float cimport (
    FloatTag,
    DoubleTag,
    NamedFloatTag,
    NamedDoubleTag,
)
from .array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    NamedByteArrayTag,
    NamedIntArrayTag,
    NamedLongArrayTag,
)
from .string cimport (
    StringTag,
    NamedStringTag,
)
from .list cimport (
    ListTag,
    NamedListTag,
)
from .compound cimport (
    CompoundTag,
    NamedCompoundTag,
)

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

NamedTag = Union[
    NamedByteTag,
    NamedShortTag,
    NamedIntTag,
    NamedLongTag,
    NamedFloatTag,
    NamedDoubleTag,
    NamedByteArrayTag,
    NamedStringTag,
    NamedListTag,
    NamedCompoundTag,
    NamedIntArrayTag,
    NamedLongArrayTag,
]
