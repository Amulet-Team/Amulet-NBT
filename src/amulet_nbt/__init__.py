# Base Types
import warnings
import re

from . import _version

__version__ = _version.get_versions()["version"]
__major__ = int(re.match(r"\d+", __version__)[0])
__all__ = [
    "AbstractBaseTag",
    "AbstractBaseImmutableTag",
    "AbstractBaseMutableTag",
    "AbstractBaseNumericTag",
    "AbstractBaseIntTag",
    "ByteTag",
    "ShortTag",
    "IntTag",
    "LongTag",
    "ByteTag",
    "TAG_Byte",
    "ShortTag",
    "TAG_Short",
    "IntTag",
    "TAG_Int",
    "LongTag",
    "TAG_Long",
    "AbstractBaseFloatTag",
    "FloatTag",
    "DoubleTag",
    "FloatTag",
    "TAG_Float",
    "DoubleTag",
    "TAG_Double",
    "AbstractBaseArrayTag",
    "ByteArrayTag",
    "IntArrayTag",
    "LongArrayTag",
    "ByteArrayTag",
    "TAG_Byte_Array",
    "IntArrayTag",
    "TAG_Int_Array",
    "LongArrayTag",
    "TAG_Long_Array",
    "StringTag",
    "StringTag",
    "TAG_String",
    "NamedTag",
    "ListTag",
    "ListTag",
    "TAG_List",
    "CompoundTag",
    "CompoundTag",
    "TAG_Compound",
    # "load",
    # "load_array",
    # "ReadContext",
    # "from_snbt",
    # "NBTError",
    # "NBTLoadError",
    # "NBTFormatError",
    # "SNBTParseError",
    # "SNBTType",
    # "IntType",
    # "FloatType",
    # "NumberType",
    # "ArrayType",
    # "AnyNBT",
    # "utf8_decoder",
    # "utf8_encoder",
    # "utf8_escape_decoder",
    # "utf8_escape_encoder",
]

from ._tag.abc import (
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    AbstractBaseMutableTag,
)
from ._tag.numeric import AbstractBaseNumericTag

# Types
from ._tag.int import (
    AbstractBaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    ByteTag as TAG_Byte,
    ShortTag as TAG_Short,
    IntTag as TAG_Int,
    LongTag as TAG_Long,
)
from ._tag.float import (
    AbstractBaseFloatTag,
    FloatTag,
    DoubleTag,
    FloatTag as TAG_Float,
    DoubleTag as TAG_Double,
)
from ._tag.array import (
    AbstractBaseArrayTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    ByteArrayTag as TAG_Byte_Array,
    IntArrayTag as TAG_Int_Array,
    LongArrayTag as TAG_Long_Array,
)
from ._tag.string import (
    StringTag,
    StringTag as TAG_String,
)

from ._tag.named_tag import NamedTag

from ._tag.list import (
    ListTag,
    ListTag as TAG_List,
)
from ._tag.compound import (
    CompoundTag,
    CompoundTag as TAG_Compound,
)

# Load functions
# from ._load_nbt import load, load_many, load_array, ReadContext
# from ._load_snbt import from_snbt

# from ._errors import NBTError, NBTLoadError, NBTFormatError, SNBTParseError

# from ._dtype import SNBTType, IntType, FloatType, NumberType, ArrayType, AnyNBT

# from ._util import utf8_decoder, utf8_encoder, utf8_escape_decoder, utf8_escape_encoder

from ._utf8 import mutf8_to_utf8, utf8_to_mutf8, utf8_to_utf8
