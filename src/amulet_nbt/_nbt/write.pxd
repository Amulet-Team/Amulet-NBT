from libcpp.string cimport string
from .nbt cimport TagNode
from amulet_nbt._libcpp.endian cimport endian


cdef extern from "write.hpp" nogil:
    string write_named_tag(const string&, const TagNode&, endian) except +
