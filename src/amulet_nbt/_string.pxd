from ._value cimport AbstractBaseImmutableTag
from ._util cimport BufferContext
from ._dtype import DecoderType


cdef StringTag read_string_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType)

cdef class StringTag(AbstractBaseImmutableTag):
    cdef str value_
