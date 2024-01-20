from amulet_nbt._tag.abc cimport AbstractBaseMutableTag
from amulet_nbt._nbt cimport CCompoundTagPtr


cdef class CompoundTag(AbstractBaseMutableTag):
    cdef CCompoundTagPtr cpp

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr)
