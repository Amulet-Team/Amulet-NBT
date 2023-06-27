# distutils: language = c++
# distutils: sources = src/amulet_nbt/_utf8/utf8.cpp

from libcpp.string cimport string

cdef extern from "utf8.hpp" nogil:
    string mutf8_to_utf8(string) except +
    string utf8_to_mutf8(string) except +
    string utf8_to_utf8(string) except +
