from ._value cimport AbstractBaseTag, AbstractBaseMutableTag

cdef class CyListTag(AbstractBaseMutableTag):
    cdef list value_
    cdef readonly char list_data_type

    cdef void _check_tag(self, AbstractBaseTag value, bint fix_if_empty=*) except *
    cdef void _check_tag_iterable(self, list value) except *
