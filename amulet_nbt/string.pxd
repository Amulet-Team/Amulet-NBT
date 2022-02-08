from .value cimport BaseImmutableTag
from .util cimport BufferContext

cdef class StringTag(BaseImmutableTag):
    cdef unicode value_

cdef class NamedStringTag(StringTag):
    cdef public str name

    @staticmethod
    cdef NamedStringTag read_named_payload(BufferContext buffer, bint little_endian)
