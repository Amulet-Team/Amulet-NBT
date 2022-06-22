from ._value cimport AbstractBaseTag, AbstractBase


cdef class NamedTag(AbstractBase):
    cdef AbstractBaseTag tag
    cdef str name
