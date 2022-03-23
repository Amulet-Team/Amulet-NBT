cimport numpy
from ._value cimport BaseMutableTag

cdef class BaseArrayTag(BaseMutableTag):
    pass

cdef class ByteArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_

cdef class IntArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_

cdef class LongArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_
