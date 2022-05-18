from ._value cimport AbstractBaseMutableTag


cdef class CyCompoundTag(AbstractBaseMutableTag):
    cdef dict value_
