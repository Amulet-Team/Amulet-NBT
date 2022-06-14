from ._value cimport AbstractBaseMutableTag
from ._util cimport BufferContext
from ._dtype import DecoderType


cdef CyCompoundTag read_compound_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType)

cdef class CyCompoundTag(AbstractBaseMutableTag):
    cdef dict value_
