from .value cimport BaseImmutableTag

cdef class TAG_String(BaseImmutableTag):
    cdef unicode value_
