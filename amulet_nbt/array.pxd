cimport numpy
from .value cimport BaseMutableTag
from .util cimport BufferContext

cdef class BaseArrayTag(BaseMutableTag):
    cdef numpy.ndarray value_
    cdef void _fix_dtype(self)
    cdef numpy.ndarray _as_endianness(self, bint little_endian = *)

cdef class ByteArrayTag(BaseArrayTag):
    pass

cdef class IntArrayTag(BaseArrayTag):
    pass

cdef class LongArrayTag(BaseArrayTag):
    pass

cdef class NamedByteArrayTag(ByteArrayTag):
    cdef public str name

    @staticmethod
    cdef NamedByteArrayTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedIntArrayTag(IntArrayTag):
    cdef public str name

    @staticmethod
    cdef NamedIntArrayTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedLongArrayTag(LongArrayTag):
    cdef public str name

    @staticmethod
    cdef NamedLongArrayTag read_named_payload(BufferContext buffer, bint little_endian)
