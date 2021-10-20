from .value cimport BaseMutableTag

cdef class TAG_List(BaseMutableTag):
    cdef list _value
    cdef readonly char list_data_type
