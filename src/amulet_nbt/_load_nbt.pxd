from ._util cimport BufferContext
from ._value cimport AbstractBaseTag
from ._dtype import DecoderType

cdef AbstractBaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian, string_decoder: DecoderType)
cdef tuple load_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType)

cdef class ReadContext:
    cdef readonly int offset
