from .numeric cimport BaseNumericTag

cdef class BaseIntegerTag(BaseNumericTag):
    pass

cdef class TAG_Byte(BaseIntegerTag):
    cdef readonly char value
    cdef char _sanitise_value(self, value)

cdef class TAG_Short(BaseIntegerTag):
    cdef readonly short value
    cdef short _sanitise_value(self, value)

cdef class TAG_Int(BaseIntegerTag):
    cdef readonly int value
    cdef int _sanitise_value(self, value)

cdef class TAG_Long(BaseIntegerTag):
    cdef readonly long long value
    cdef long long _sanitise_value(self, value)
