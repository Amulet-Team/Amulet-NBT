from ._value cimport AbstractBaseTag, AbstractBase


cdef class NamedTag(AbstractBase):
    cdef readonly AbstractBaseTag tag
    cdef readonly str name
