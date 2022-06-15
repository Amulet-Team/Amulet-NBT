from typing import Union, Callable, TYPE_CHECKING

if TYPE_CHECKING:
    from ._int import (
        ByteTag,
        ShortTag,
        IntTag,
        LongTag,
    )
    from ._float import (
        FloatTag,
        DoubleTag,
    )
    from ._array import (
        ByteArrayTag,
        IntArrayTag,
        LongArrayTag,
    )
    from ._string import StringTag
    from ._list import ListTag
    from ._compound import CompoundTag

SNBTType = str

IntType = Union["ByteTag", "ShortTag", "IntTag", "LongTag"]

FloatType = Union["FloatTag", "DoubleTag"]

NumberType = Union["ByteTag", "ShortTag", "IntTag", "LongTag", "FloatTag", "DoubleTag"]

ArrayType = Union["ByteArrayTag", "IntArrayTag", "LongArrayTag"]

AnyNBT = Union[
    "ByteTag",
    "ShortTag",
    "IntTag",
    "LongTag",
    "FloatTag",
    "DoubleTag",
    "ByteArrayTag",
    "StringTag",
    "ListTag",
    "CompoundTag",
    "IntArrayTag",
    "LongArrayTag",
]

EncoderType = Callable[[str], bytes]
DecoderType = Callable[[bytes], str]
