# distutils: language = c++

from libcpp.string cimport string

cdef extern from "mutf8.hpp" nogil:
    string mutf8_to_utf8(const string&)
    string utf8_to_mutf8(const string&)
