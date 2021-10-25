from .numeric cimport BaseNumericTag

cdef class BaseFloatTag(BaseNumericTag):
    pass

cdef class TAG_Float(BaseFloatTag):
    cdef readonly float value

cdef class TAG_Double(BaseFloatTag):
    cdef readonly double value