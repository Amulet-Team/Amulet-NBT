from ._value cimport AbstractBaseImmutableTag

cdef class StringTag(AbstractBaseImmutableTag):
    cdef bytes value_
