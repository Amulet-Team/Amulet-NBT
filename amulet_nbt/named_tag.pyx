from typing import Type
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


cdef class NamedIntArrayTag(BaseNamedTag):
    tag: IntArrayTag
    TagCls = IntArrayTag


cdef class NamedLongArrayTag(BaseNamedTag):
    tag: LongArrayTag
    TagCls = LongArrayTag
