cimport numpy
from .value cimport BaseMutableTag

cdef class BaseArrayTag(BaseMutableTag):
    cdef numpy.ndarray value_
    cdef void _fix_dtype(self)
    cdef numpy.ndarray _as_endianness(self, bint little_endian = *)

cdef class TAG_Byte_Array(BaseArrayTag):
    pass

cdef class TAG_Int_Array(BaseArrayTag):
    pass

cdef class TAG_Long_Array(BaseArrayTag):
    pass

cdef class Named_TAG_Byte_Array(TAG_Byte_Array):
    cdef public str name

cdef class Named_TAG_Int_Array(TAG_Int_Array):
    cdef public str name

cdef class Named_TAG_Long_Array(TAG_Long_Array):
    cdef public str name
