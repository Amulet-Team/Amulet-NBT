cimport numpy
from ._value cimport AbstractBaseMutableTag

cdef class BaseArrayTag(AbstractBaseMutableTag):
    pass

cdef class ByteArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_

cdef class IntArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_

cdef class LongArrayTag(BaseArrayTag):
    cdef numpy.ndarray value_
