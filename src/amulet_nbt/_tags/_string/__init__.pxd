from amulet_nbt._tags._value cimport AbstractBaseImmutableTag

cdef class StringTag(AbstractBaseImmutableTag):
    cdef str value_
