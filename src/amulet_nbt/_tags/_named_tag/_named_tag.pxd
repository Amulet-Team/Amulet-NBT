from ._value cimport AbstractBaseTag, AbstractBase
from nbt cimport TagNode


cdef class NamedTag(AbstractBase):
    cdef TagNode tag_node
    cdef public str name
