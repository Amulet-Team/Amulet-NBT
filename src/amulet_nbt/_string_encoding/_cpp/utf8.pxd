# distutils: language = c++

from libcpp.string cimport string

cdef extern from "utf8.hpp" nogil:
    string utf8_to_utf8(string&)
