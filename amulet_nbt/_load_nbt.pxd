from ._util cimport BufferContext
from ._value cimport BaseTag
from ._named_tag cimport BaseNamedTag

cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian)
cpdef tuple load_tag(BufferContext buffer, bint little_endian)
cpdef BaseNamedTag tag_to_named_tag(BaseTag tag, str name = *)

cdef class ReadContext:
    cdef readonly int offset
