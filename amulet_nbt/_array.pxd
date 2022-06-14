cimport numpy
from ._value cimport AbstractBaseMutableTag

cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    pass

cdef class ByteArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_

cdef class IntArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_

cdef class LongArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_
