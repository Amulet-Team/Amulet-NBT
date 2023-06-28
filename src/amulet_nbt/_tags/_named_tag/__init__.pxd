from amulet_nbt._tags._value cimport AbstractBaseTag, AbstractBase
from amulet_nbt._nbt cimport TagNode


cdef class NamedTag(AbstractBase):
    cdef TagNode tag_node
    cdef public str name
