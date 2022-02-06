from .numeric cimport BaseNumericTag

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

cdef class NamedShortTag(ShortTag):
    cdef public str name

cdef class NamedIntTag(IntTag):
    cdef public str name

cdef class NamedLongTag(LongTag):
    cdef public str name
