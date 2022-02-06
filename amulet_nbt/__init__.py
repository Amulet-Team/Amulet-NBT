# Base Types
from .value import BaseTag, BaseImmutableTag, BaseMutableTag, BaseValueType
from .numeric import BaseNumericTag

# Types
from .int import (
    BaseIntTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    Named_TAG_Byte,
    Named_TAG_Short,
    Named_TAG_Int,
    Named_TAG_Long,
    TAG_Byte as ByteTag,
    TAG_Short as ShortTag,
    TAG_Int as IntTag,
    TAG_Long as LongTag,
    Named_TAG_Byte as NamedByteTag,
    Named_TAG_Short as NamedShortTag,
    Named_TAG_Int as NamedIntTag,
    Named_TAG_Long as NamedLongTag,
)
from .float import (
    BaseFloatTag,
    TAG_Float,
    TAG_Double,
    Named_TAG_Float,
    Named_TAG_Double,
    TAG_Float as FloatTag,
    TAG_Double as DoubleTag,
    Named_TAG_Float as NamedFloatTag,
    Named_TAG_Double as NamedDoubleTag,
)
from .array import (
    BaseArrayTag,
    BaseArrayType,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
    Named_TAG_Byte_Array,
    Named_TAG_Int_Array,
    Named_TAG_Long_Array,
    TAG_Byte_Array as ByteArrayTag,
    TAG_Int_Array as IntArrayTag,
    TAG_Long_Array as LongArrayTag,
    Named_TAG_Byte_Array as NamedByteArrayTag,
    Named_TAG_Int_Array as NamedIntArrayTag,
    Named_TAG_Long_Array as NamedLongArrayTag,
)
from .string import (
    TAG_String,
    Named_TAG_String,
    TAG_String as StringTag,
    Named_TAG_String as NamedStringTag,
)
from .list import (
    TAG_List,
    Named_TAG_List,
    TAG_List as ListTag,
    Named_TAG_List as NamedListTag,
)
from .compound import (
    TAG_Compound,
    Named_TAG_Compound,
    TAG_Compound as CompoundTag,
    Named_TAG_Compound as NamedCompoundTag,
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
