from libcpp.string cimport string
from amulet_nbt._tag.abc cimport AbstractBase
from amulet_nbt._tag._cpp cimport TagNode


cdef class NamedTag(AbstractBase):
    cdef string tag_name
    cdef TagNode tag_node
