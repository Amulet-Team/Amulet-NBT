from libcpp.string cimport string
from libcpp cimport bool
from amulet_nbt._libcpp.endian cimport endian

from amulet_nbt._tag._cpp cimport TagNode
from amulet_nbt._string_encoding._cpp cimport CStringEncode


cdef class AbstractBase:
    pass


cdef class AbstractBaseTag(AbstractBase):
    cdef TagNode to_node(self)
    cdef string write_nbt(self, string, endian, CStringEncode)


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    pass


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    pass
