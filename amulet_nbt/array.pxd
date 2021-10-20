from .value cimport BaseMutableTag

cdef class BaseArrayTag(BaseMutableTag):
    cdef public object value
    cdef void _fix_dtype(self, bint little_endian)

cdef class TAG_Byte_Array(BaseArrayTag):
    pass

cdef class TAG_Int_Array(BaseArrayTag):
    pass

cdef class TAG_Long_Array(BaseArrayTag):
    pass
