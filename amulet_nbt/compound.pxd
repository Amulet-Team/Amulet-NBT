from .value cimport BaseMutableTag

cdef class TAG_Compound(BaseMutableTag):
    cdef dict _value
