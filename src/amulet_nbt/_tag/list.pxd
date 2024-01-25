from libcpp cimport bool
from amulet_nbt._tag.abc cimport AbstractBaseMutableTag, AbstractBaseTag
from amulet_nbt._nbt cimport CListTagPtr

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

    cpdef ByteTag get_byte(self, ptrdiff_t index)
    cpdef ShortTag get_short(self, ptrdiff_t index)
    cpdef IntTag get_int(self, ptrdiff_t index)
    cpdef LongTag get_long(self, ptrdiff_t index)
    cpdef FloatTag get_float(self, ptrdiff_t index)
    cpdef DoubleTag get_double(self, ptrdiff_t index)
    cpdef StringTag get_string(self, ptrdiff_t index)
    cpdef ListTag get_list(self, ptrdiff_t index)
    cpdef CompoundTag get_compound(self, ptrdiff_t index)
    cpdef ByteArrayTag get_byte_array(self, ptrdiff_t index)
    cpdef IntArrayTag get_int_array(self, ptrdiff_t index)
    cpdef LongArrayTag get_long_array(self, ptrdiff_t index)
