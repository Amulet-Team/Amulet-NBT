# distutils: language = c++

from libcpp.string cimport string

cdef extern from "utf8.hpp" nogil:
    string mutf8_to_utf8(string&)
    string utf8_to_mutf8(string&)
