from ._value cimport AbstractBaseTag, AbstractBase


cdef class NamedTag(AbstractBase):
    cdef AbstractBaseTag _tag  # TODO: make readonly
    cdef str _name  # TODO: make readonly
