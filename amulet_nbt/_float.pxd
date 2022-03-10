from ._numeric cimport BaseNumericTag

cdef class BaseFloatTag(BaseNumericTag):
    pass

cdef class FloatTag(BaseFloatTag):
    cdef float value_

cdef class DoubleTag(BaseFloatTag):
    cdef double value_
