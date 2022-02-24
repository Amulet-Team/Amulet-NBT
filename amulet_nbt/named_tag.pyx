from typing import Type
import warnings

from .value cimport BaseTag
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
from .dtype import AnyNBT


cdef class BaseNamedTag:
    TagCls: Type[BaseTag] = None

    def __init__(self, BaseTag tag = None, str name = ""):
        if tag is None:
            self.tag = self.TagCls()
        elif tag.__class__ is self.TagCls:
            self.tag = tag
        else:
            raise TypeError(f"Expected type {self.TagCls} but got {tag.__class__}")
        self.name = name

    @property
    def value(self):
        warnings.warn("value property is depreciated. Use tag attribute instead.")
        return self.tag

    @value.setter
    def value(self, BaseTag value):
        warnings.warn("value property is depreciated.")
        self.tag = value

    def to_snbt(self, indent_chr=None) -> str:
        return self.tag.to_snbt(indent_chr)

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
    ):
        return self.tag.to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            name=self.name
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
    ):
        return self.tag.save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            name=self.name
        )

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.name == other.name and self.tag == other.tag
        return NotImplemented

    def __repr__(self):
        return f'{self.__class__.__name__}({repr(self.tag)}, "{self.name}")'


cdef class NamedByteTag(BaseNamedTag):
    tag: ByteTag
    TagCls = ByteTag


cdef class NamedShortTag(BaseNamedTag):
    tag: ShortTag
    TagCls = ShortTag


cdef class NamedIntTag(BaseNamedTag):
    tag: IntTag
    TagCls = IntTag


cdef class NamedLongTag(BaseNamedTag):
    tag: LongTag
    TagCls = LongTag


cdef class NamedFloatTag(BaseNamedTag):
    tag: FloatTag
    TagCls = FloatTag


cdef class NamedDoubleTag(BaseNamedTag):
    tag: DoubleTag
    TagCls = DoubleTag


cdef class NamedByteArrayTag(BaseNamedTag):
    tag: ByteArrayTag
    TagCls = ByteArrayTag


cdef class NamedStringTag(BaseNamedTag):
    tag: StringTag
    TagCls = StringTag


cdef class NamedListTag(BaseNamedTag):
    tag: ListTag
    TagCls = ListTag


cdef class NamedCompoundTag(BaseNamedTag):
    tag: CompoundTag
    TagCls = CompoundTag

    def __len__(self) -> int:
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag.__len__()

    def keys(self):
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag.keys()

    def values(self):
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        self.tag.values()

    def items(self):
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag.items()

    def __getitem__(self, key: str) -> AnyNBT:
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag[key]

    def __setitem__(self, key: str, tag: AnyNBT):
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        self.tag[key] = tag

    def __delitem__(self, key: str):
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        del self.tag[key]

    def __contains__(self, key: str) -> bool:
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return key in self.tag

    def pop(self, k, default=None) -> AnyNBT:
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag.pop(k, default)

    def get(self, k, default=None) -> AnyNBT:
        warnings.warn("tag methods in NBTFile/NamedCompoundTag are depreciated. Use tag attribute instead.")
        return self.tag.get(k, default)


cdef class NamedIntArrayTag(BaseNamedTag):
    tag: IntArrayTag
    TagCls = IntArrayTag


cdef class NamedLongArrayTag(BaseNamedTag):
    tag: LongArrayTag
    TagCls = LongArrayTag
