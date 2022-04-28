from ._value cimport BaseImmutableTag

cdef class StringTag(BaseImmutableTag):
    cdef bytes value_
