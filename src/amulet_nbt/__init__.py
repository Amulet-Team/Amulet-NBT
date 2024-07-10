import re
from typing import TypeAlias
from . import _version

__version__ = _version.get_versions()["version"]
__major__ = int(re.match(r"\d+", __version__)[0])  # type: ignore

del re
del _version


def get_include() -> str:
    import os
    return os.path.join(__path__[0], "include")


from ._nbt import (
    # Abstract classes
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    AbstractBaseMutableTag,
    AbstractBaseNumericTag,
    AbstractBaseIntTag,
    AbstractBaseFloatTag,
    AbstractBaseArrayTag,

    # Tag classes
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
    LongArrayTag,

    # Tag class aliases
    ByteTag as TAG_Byte,
    ShortTag as TAG_Short,
    IntTag as TAG_Int,
    LongTag as TAG_Long,
    FloatTag as TAG_Float,
    DoubleTag as TAG_Double,
    ByteArrayTag as TAG_Byte_Array,
    StringTag as TAG_String,
    ListTag as TAG_List,
    CompoundTag as TAG_Compound,
    IntArrayTag as TAG_Int_Array,
    LongArrayTag as TAG_Long_Array,

    NamedTag,

    read_nbt,
    read_nbt_array,
    ReadOffset,
    read_snbt,
    StringEncoding,
    mutf8_encoding,
    utf8_encoding,
    utf8_escape_encoding,
    EncodingPreset,
    java_encoding,
    bedrock_encoding,
)

SNBTType: TypeAlias = str
IntType: TypeAlias = ByteTag | ShortTag | IntTag | LongTag
FloatType: TypeAlias = FloatTag | DoubleTag
NumberType: TypeAlias = ByteTag | ShortTag | IntTag | LongTag | FloatTag | DoubleTag
ArrayType: TypeAlias = ByteArrayTag | IntArrayTag | LongArrayTag
AnyNBT: TypeAlias = ByteTag | ShortTag | IntTag | LongTag | FloatTag | DoubleTag | ByteArrayTag | StringTag | ListTag | CompoundTag | IntArrayTag | LongArrayTag


__all__ = [
    "__version__",
    "__major__",
    "get_include",
    "AbstractBaseTag",
    "AbstractBaseImmutableTag",
    "AbstractBaseMutableTag",
    "AbstractBaseNumericTag",
    "AbstractBaseIntTag",
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
    "TAG_Float",
    "DoubleTag",
    "TAG_Double",
    "AbstractBaseArrayTag",
    "ByteArrayTag",
    "TAG_Byte_Array",
    "IntArrayTag",
    "TAG_Int_Array",
    "LongArrayTag",
    "TAG_Long_Array",
    "StringTag",
    "TAG_String",
    "ListTag",
    "TAG_List",
    "CompoundTag",
    "TAG_Compound",
    "NamedTag",
    "read_nbt",
    "read_nbt_array",
    "ReadOffset",
    "read_snbt",
    "SNBTType",
    "IntType",
    "FloatType",
    "NumberType",
    "ArrayType",
    "AnyNBT",
    "StringEncoding",
    "mutf8_encoding",
    "utf8_encoding",
    "utf8_escape_encoding",
    "EncodingPreset",
    "java_encoding",
    "bedrock_encoding",
]
