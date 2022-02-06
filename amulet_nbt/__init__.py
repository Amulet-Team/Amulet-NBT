# Base Types
from .value import (
    BaseTag,
    BaseNamedTag,
    BaseImmutableTag,
    BaseMutableTag,
    BaseValueType,
)
from .numeric import BaseNumericTag

# Types
from .int import (
    BaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    NamedByteTag,
    NamedShortTag,
    NamedIntTag,
    NamedLongTag,
    ByteTag as TAG_Byte,
    ShortTag as TAG_Short,
    IntTag as TAG_Int,
    LongTag as TAG_Long,
    NamedByteTag as Named_TAG_Byte,
    NamedShortTag as Named_TAG_Short,
    NamedIntTag as Named_TAG_Int,
    NamedLongTag as Named_TAG_Long,
)
from .float import (
    BaseFloatTag,
    FloatTag,
    DoubleTag,
    NamedFloatTag,
    NamedDoubleTag,
    FloatTag as TAG_Float,
    DoubleTag as TAG_Double,
    NamedFloatTag as Named_TAG_Float,
    NamedDoubleTag as Named_TAG_Double,
)
from .array import (
    BaseArrayTag,
    BaseArrayType,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    NamedByteArrayTag,
    NamedIntArrayTag,
    NamedLongArrayTag,
    ByteArrayTag as TAG_Byte_Array,
    IntArrayTag as TAG_Int_Array,
    LongArrayTag as TAG_Long_Array,
    NamedByteArrayTag as Named_TAG_Byte_Array,
    NamedIntArrayTag as Named_TAG_Int_Array,
    NamedLongArrayTag as Named_TAG_Long_Array,
)
from .string import (
    StringTag,
    NamedStringTag,
    StringTag as TAG_String,
    NamedStringTag as Named_TAG_String,
)
from .list import (
    ListTag,
    NamedListTag,
    ListTag as TAG_List,
    NamedListTag as Named_TAG_List,
)
from .compound import (
    CompoundTag,
    NamedCompoundTag,
    CompoundTag as TAG_Compound,
    NamedCompoundTag as Named_TAG_Compound,
)

# NBTFile
from .nbtfile import NBTFile

# Load functions
from .load_nbt import load, load_one, load_many
from .load_snbt import from_snbt

from .errors import NBTError, NBTLoadError, NBTFormatError, SNBTParseError

from .dtype import SNBTType, IntType, FloatType, NumberType, ArrayType, AnyNBT

from ._version import get_versions

__version__ = get_versions()["version"]
del get_versions
