from ._numeric cimport AbstractBaseNumericTag
from ._util cimport BufferContext

cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    pass

cdef ByteTag read_byte_tag(BufferContext buffer, bint little_endian)

cdef class ByteTag(AbstractBaseIntTag):
    cdef signed char value_
    cdef signed char _sanitise_value(self, value)

cdef ShortTag read_short_tag(BufferContext buffer, bint little_endian)

cdef class ShortTag(AbstractBaseIntTag):
    cdef short value_
    cdef short _sanitise_value(self, value)

cdef IntTag read_int_tag(BufferContext buffer, bint little_endian)

cdef class IntTag(AbstractBaseIntTag):
    cdef int value_
    cdef int _sanitise_value(self, value)

cdef LongTag read_long_tag(BufferContext buffer, bint little_endian)

cdef class LongTag(AbstractBaseIntTag):
    cdef long long value_
    cdef long long _sanitise_value(self, value)
