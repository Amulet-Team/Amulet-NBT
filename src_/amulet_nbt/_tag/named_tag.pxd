from libcpp.string cimport string
from amulet_nbt._tag.abc cimport AbstractBase
from amulet_nbt._tag._cpp cimport TagNode
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode


cdef class NamedTag(AbstractBase):
    cdef string tag_name
    cdef TagNode tag_node
    cdef string write_nbt(self, endian endianness, CStringEncode string_encode)
    @staticmethod
    cdef NamedTag wrap(string name, TagNode node)
