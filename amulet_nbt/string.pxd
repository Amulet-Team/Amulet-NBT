from .value cimport BaseImmutableTag

cdef class TAG_String(BaseImmutableTag):
    cdef readonly unicode value_
