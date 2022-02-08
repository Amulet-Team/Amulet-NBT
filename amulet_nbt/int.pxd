from .numeric cimport BaseNumericTag
from .util cimport BufferContext

cdef class BaseIntTag(BaseNumericTag):
    pass

cdef class ByteTag(BaseIntTag):
    cdef char value_
    cdef char _sanitise_value(self, value)

cdef class ShortTag(BaseIntTag):
    cdef short value_
    cdef short _sanitise_value(self, value)

cdef class IntTag(BaseIntTag):
    cdef int value_
    cdef int _sanitise_value(self, value)

cdef class LongTag(BaseIntTag):
    cdef long long value_
    cdef long long _sanitise_value(self, value)

cdef class NamedByteTag(ByteTag):
    cdef public str name

    @staticmethod
    cdef NamedByteTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedShortTag(ShortTag):
    cdef public str name

    @staticmethod
    cdef NamedShortTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedIntTag(IntTag):
    cdef public str name

    @staticmethod
    cdef NamedIntTag read_named_payload(BufferContext buffer, bint little_endian)

cdef class NamedLongTag(LongTag):
    cdef public str name

    @staticmethod
    cdef NamedLongTag read_named_payload(BufferContext buffer, bint little_endian)
