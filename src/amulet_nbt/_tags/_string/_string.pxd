from ._value cimport AbstractBaseImmutableTag
from libcpp.string cimport string

cdef class StringTag(AbstractBaseImmutableTag):
    cdef string value_
