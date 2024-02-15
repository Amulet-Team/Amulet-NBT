from libcpp cimport bool
from amulet_nbt._tag.abc cimport AbstractBaseMutableTag, AbstractBaseTag
from amulet_nbt._tag._cpp cimport CListTagPtr

from amulet_nbt._tag.int cimport ByteTag, ShortTag, IntTag, LongTag
from amulet_nbt._tag.float cimport FloatTag, DoubleTag
from amulet_nbt._tag.string cimport StringTag
from amulet_nbt._tag.compound cimport CompoundTag
from amulet_nbt._tag.array cimport ByteArrayTag, IntArrayTag, LongArrayTag


cdef bool is_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil


cdef class ListTag(AbstractBaseMutableTag):
    cdef CListTagPtr cpp

    @staticmethod
    cdef ListTag wrap(CListTagPtr)
