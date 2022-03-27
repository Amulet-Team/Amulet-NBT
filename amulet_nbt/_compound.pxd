from ._value cimport BaseMutableTag


cdef class CyCompoundTag(BaseMutableTag):
    cdef dict value_
