from amulet_nbt._tag.abc cimport AbstractBaseMutableTag, AbstractBaseTag
from amulet_nbt._nbt cimport CListTagPtr


cdef class ListTag(AbstractBaseMutableTag):
    cdef CListTagPtr cpp

    @staticmethod
    cdef ListTag wrap(CListTagPtr)
