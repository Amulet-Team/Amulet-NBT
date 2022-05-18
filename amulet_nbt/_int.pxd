from ._numeric cimport AbstractBaseNumericTag

cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    pass

cdef class ByteTag(AbstractBaseIntTag):
    cdef char value_
    cdef char _sanitise_value(self, value)

cdef class ShortTag(AbstractBaseIntTag):
    cdef short value_
    cdef short _sanitise_value(self, value)

cdef class IntTag(AbstractBaseIntTag):
    cdef int value_
    cdef int _sanitise_value(self, value)

cdef class LongTag(AbstractBaseIntTag):
    cdef long long value_
    cdef long long _sanitise_value(self, value)
