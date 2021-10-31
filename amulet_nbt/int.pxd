from .numeric cimport BaseNumericTag

cdef class BaseIntTag(BaseNumericTag):
    pass

cdef class TAG_Byte(BaseIntTag):
    cdef readonly char value_
    cdef char _sanitise_value(self, value)

cdef class TAG_Short(BaseIntTag):
    cdef readonly short value_
    cdef short _sanitise_value(self, value)

cdef class TAG_Int(BaseIntTag):
    cdef readonly int value_
    cdef int _sanitise_value(self, value)

cdef class TAG_Long(BaseIntTag):
    cdef readonly long long value_
    cdef long long _sanitise_value(self, value)
