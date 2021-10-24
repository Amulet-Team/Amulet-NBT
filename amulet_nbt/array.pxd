cimport numpy
from .value cimport BaseMutableTag

cdef class BaseArrayTag(BaseMutableTag):
    cdef public numpy.ndarray value
    cdef void _fix_dtype(self)
    cdef numpy.ndarray _as_endianness(self, bint little_endian = *)

cdef class TAG_Byte_Array(BaseArrayTag):
    pass

cdef class TAG_Int_Array(BaseArrayTag):
    pass

cdef class TAG_Long_Array(BaseArrayTag):
    pass
