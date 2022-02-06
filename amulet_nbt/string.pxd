from .value cimport BaseImmutableTag

cdef class StringTag(BaseImmutableTag):
    cdef unicode value_

cdef class NamedStringTag(StringTag):
    cdef public str name
