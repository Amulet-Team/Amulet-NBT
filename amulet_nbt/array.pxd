cimport numpy
from .value cimport BaseMutableTag

cdef class BaseArrayTag(BaseMutableTag):
    cdef numpy.ndarray value_
    cdef void _fix_dtype(self)
    cdef numpy.ndarray _as_endianness(self, bint little_endian = *)

cdef class ByteArrayTag(BaseArrayTag):
    pass

cdef class IntArrayTag(BaseArrayTag):
    pass

cdef class LongArrayTag(BaseArrayTag):
    pass
