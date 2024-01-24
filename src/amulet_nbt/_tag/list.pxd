from libcpp cimport bool
from amulet_nbt._tag.abc cimport AbstractBaseMutableTag, AbstractBaseTag
from amulet_nbt._nbt cimport CListTagPtr


cdef bool is_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil


cdef class ListTag(AbstractBaseMutableTag):
    cdef CListTagPtr cpp

    @staticmethod
    cdef ListTag wrap(CListTagPtr)
