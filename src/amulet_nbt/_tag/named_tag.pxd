from libcpp.string cimport string
from amulet_nbt._tag.abc cimport AbstractBase
from amulet_nbt._nbt cimport TagNode


cdef class NamedTag(AbstractBase):
    cdef TagNode tag_node
    cdef public string name
