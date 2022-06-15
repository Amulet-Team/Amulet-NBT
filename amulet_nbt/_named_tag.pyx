from typing import Type, TypeVar
import warnings

from ._value cimport AbstractBaseTag, AbstractBase
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
from ._list import ListTag
from ._compound import CompoundTag
from ._dtype import EncoderType
from ._util import utf8_encoder


T = TypeVar("T")


cdef class NamedTag(AbstractBase):
    tag: AbstractBaseTag

    def __init__(self, AbstractBaseTag tag = None, str name not None = ""):
        if tag is None:
            self.tag = CompoundTag()
        else:
            self.tag = tag
        self.name = name

    @property
    def value(self):
        warnings.warn("value property is depreciated. Use tag attribute instead.")
        return self.tag

    @value.setter
    def value(self, AbstractBaseTag value):
        warnings.warn("value property is depreciated.")
        self.tag = value

    def _get_tag(self, t: Type[T]) -> T:
        if not isinstance(self.tag, t):
            raise TypeError(f"Expected tag to be of type {t} but got {type(self.tag)}")
        return self.tag

    def get_byte(self) -> ByteTag:
        return self._get_tag(ByteTag)

    def get_short(self) -> ShortTag:
        return self._get_tag(ShortTag)

    def get_int(self) -> IntTag:
        return self._get_tag(IntTag)

    def get_long(self) -> LongTag:
        return self._get_tag(LongTag)

    def get_float(self) -> FloatTag:
        return self._get_tag(FloatTag)

    def get_double(self) -> DoubleTag:
        return self._get_tag(DoubleTag)

    def get_string(self) -> StringTag:
        return self._get_tag(StringTag)

    def get_list(self) -> ListTag:
        return self._get_tag(ListTag)

    def get_compound(self) -> CompoundTag:
        return self._get_tag(CompoundTag)

    def get_byte_array(self) -> ByteArrayTag:
        return self._get_tag(ByteArrayTag)

    def get_int_array(self) -> IntArrayTag:
        return self._get_tag(IntArrayTag)

    def get_long_array(self) -> LongArrayTag:
        return self._get_tag(LongArrayTag)

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
        return self.tag.to_snbt(indent=indent, indent_chr=indent_chr)

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = utf8_encoder,
    ):
        return self.tag.to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            string_encoder=string_encoder,
            name = self.name,
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = utf8_encoder,
    ):
        return self.tag.save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            string_encoder=string_encoder,
            name=self.name,
        )

    def __eq__(self, other):
        if isinstance(other, NamedTag):
            return self.name == other.name and self.tag == other.tag
        return NotImplemented

    def __repr__(self):
        return f'NamedTag({repr(self.tag)}, "{self.name}")'

    def __iter__(self):
        yield self.name
        yield self.value

    def __getitem__(self, int item):
        return (self.name, self.value)[item]
