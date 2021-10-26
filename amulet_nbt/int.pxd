from .numeric cimport BaseNumericTag

cdef class BaseIntTag(BaseNumericTag):
    pass

cdef class TAG_Byte(BaseIntTag):
    cdef readonly char value
    cdef char _sanitise_value(self, value)

cdef class TAG_Short(BaseIntTag):
    cdef readonly short value
    cdef short _sanitise_value(self, value)

cdef class TAG_Int(BaseIntTag):
    cdef readonly int value
    cdef int _sanitise_value(self, value)

cdef class TAG_Long(BaseIntTag):
    cdef readonly long long value
    cdef long long _sanitise_value(self, value)
