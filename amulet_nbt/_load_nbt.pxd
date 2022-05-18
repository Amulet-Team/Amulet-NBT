from ._util cimport BufferContext
from ._value cimport AbstractBaseTag
from ._named_tag cimport BaseNamedTag

cdef AbstractBaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian)
cpdef tuple load_tag(BufferContext buffer, bint little_endian)
cpdef BaseNamedTag tag_to_named_tag(AbstractBaseTag tag, str name = *)

cdef class ReadContext:
    cdef readonly int offset
