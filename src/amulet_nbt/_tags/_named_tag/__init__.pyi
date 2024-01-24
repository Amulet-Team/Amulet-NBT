from amulet_nbt._tags._value import AbstractBaseTag
from amulet_nbt._tags._numeric._int import ByteTag, ShortTag, IntTag, LongTag
from amulet_nbt._tags._numeric._float import FloatTag, DoubleTag
from amulet_nbt._tags._string import StringTag
from amulet_nbt._tags._list import ListTag
from amulet_nbt._tags._compound import CompoundTag
from amulet_nbt._tags._array import ByteArrayTag, IntArrayTag, LongArrayTag
from ._util import EncoderType
from mutf8 import encode_modified_utf8

class NamedTag:
    name: str
    tag: AbstractBaseTag
    def __init__(self, tag: AbstractBaseTag = None, name: str = ""): ...
    def to_snbt(self, indent=None, indent_chr=None) -> str: ...
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoder: EncoderType = encode_modified_utf8,
    ) -> bytes: ...
    def save_to(
        self,
        filepath_or_buffer=None,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoder: EncoderType = encode_modified_utf8,
    ) -> bytes: ...
    @property
    def byte(self) -> ByteTag: ...
    @property
    def short(self) -> ShortTag: ...
    @property
    def int(self) -> IntTag: ...
    @property
    def long(self) -> LongTag: ...
    @property
    def float(self) -> FloatTag: ...
    @property
    def double(self) -> DoubleTag: ...
    @property
    def string(self) -> StringTag: ...
    @property
    def list(self) -> ListTag: ...
    @property
    def compound(self) -> CompoundTag: ...
    @property
    def byte_array(self) -> ByteArrayTag: ...
    @property
    def int_array(self) -> IntArrayTag: ...
    @property
    def long_array(self) -> LongArrayTag: ...