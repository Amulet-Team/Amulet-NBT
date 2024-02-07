from libcpp.string cimport string
from amulet_nbt._tag._cpp.nbt cimport TagNode
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode


cdef extern from "write.hpp" nogil:
    string write_named_tag[T](const string&, const T&, endian, CStringEncode) except +
