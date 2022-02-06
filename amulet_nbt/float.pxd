from .numeric cimport BaseNumericTag

cdef class BaseFloatTag(BaseNumericTag):
    pass

cdef class TAG_Float(BaseFloatTag):
    cdef float value_

cdef class TAG_Double(BaseFloatTag):
    cdef double value_

cdef class Named_TAG_Float(TAG_Float):
    cdef public str name

cdef class Named_TAG_Double(TAG_Double):
    cdef public str name