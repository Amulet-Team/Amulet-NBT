from .numeric cimport BaseNumericTag
from .util cimport BufferContext

cdef class BaseFloatTag(BaseNumericTag):
    pass

cdef class FloatTag(BaseFloatTag):
    cdef float value_

cdef class DoubleTag(BaseFloatTag):
    cdef double value_

cdef class NamedFloatTag(FloatTag):
    cdef public str name

    @staticmethod
    cdef NamedFloatTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedDoubleTag(DoubleTag):
    cdef public str name

    @staticmethod
    cdef NamedDoubleTag read_named_payload(BufferContext buffer, bint little_endian)
