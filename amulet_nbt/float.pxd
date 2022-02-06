from .numeric cimport BaseNumericTag

cdef class BaseFloatTag(BaseNumericTag):
    pass

cdef class FloatTag(BaseFloatTag):
    cdef float value_

cdef class DoubleTag(BaseFloatTag):
    cdef double value_

cdef class NamedFloatTag(FloatTag):
    cdef public str name

cdef class NamedDoubleTag(DoubleTag):
    cdef public str name