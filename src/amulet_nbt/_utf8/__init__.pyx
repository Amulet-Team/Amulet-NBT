# distutils: language = c++
# distutils: sources = src/amulet_nbt/_utf8/utf8.cpp

from libcpp.string cimport string
from .utf8 cimport mutf8_to_utf8 as mutf8_to_utf8_, utf8_to_mutf8 as utf8_to_mutf8_, utf8_to_utf8 as utf8_to_utf8_

cpdef bytes mutf8_to_utf8(bytes src):
    cdef string src_ = src
    return mutf8_to_utf8_(src_)

cpdef bytes utf8_to_mutf8(bytes src):
    cdef string src_ = src
    return utf8_to_mutf8_(src_)

cpdef bytes utf8_to_utf8(bytes src):
    cdef string src_ = src
    return utf8_to_utf8_(src_)
