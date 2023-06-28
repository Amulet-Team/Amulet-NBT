from amulet_nbt._nbt cimport TagNode
from amulet_nbt._tags._value cimport AbstractBaseTag

cdef AbstractBaseTag wrap_tag_node(TagNode node)
