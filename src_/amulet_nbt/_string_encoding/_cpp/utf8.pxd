# distutils: language = c++

from libcpp.string cimport string

cdef extern from "utf8.hpp" nogil:
    string utf8_to_utf8(const string&)
    string utf8_escape_to_utf8(const string&)
    string utf8_to_utf8_escape(const string&)
