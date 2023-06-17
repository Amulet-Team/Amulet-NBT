from ._value cimport AbstractBaseTag, AbstractBase


cdef class NamedTag(AbstractBase):
    cdef public AbstractBaseTag tag
    cdef public str name
