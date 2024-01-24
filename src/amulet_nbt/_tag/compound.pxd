from libcpp cimport bool
from amulet_nbt._tag.abc cimport AbstractBaseMutableTag
from amulet_nbt._nbt cimport CCompoundTagPtr


cdef bool is_compound_eq(CCompoundTagPtr a, CCompoundTagPtr b) noexcept nogil


cdef class CompoundTag(AbstractBaseMutableTag):
    cdef CCompoundTagPtr cpp

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr)
