from .util cimport BufferContext
from .value cimport BaseTag

cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian)
cpdef tuple load_tag(BufferContext buffer, bint little_endian)

cdef class ReadContext:
    cdef readonly int offset
