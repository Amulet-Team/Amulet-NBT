from .value cimport BaseTag, BaseMutableTag

cdef class TAG_List(BaseMutableTag):
    cdef list _value
    cdef readonly char list_data_type

    cdef void _check_tag(self, BaseTag value, bint fix_if_empty=*) except *
    cdef void _check_tag_iterable(self, list value) except *
