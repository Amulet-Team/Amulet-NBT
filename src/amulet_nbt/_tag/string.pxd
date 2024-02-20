from libcpp.string cimport string
from amulet_nbt._tag.abc cimport AbstractBaseImmutableTag
from amulet_nbt._tag._cpp cimport CStringTag


cdef class StringTag(AbstractBaseImmutableTag):
    cdef CStringTag cpp

    @staticmethod
    cdef StringTag wrap(CStringTag)
