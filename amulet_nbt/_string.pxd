from ._value cimport BaseImmutableTag

cdef class StringTag(BaseImmutableTag):
    cdef unicode value_