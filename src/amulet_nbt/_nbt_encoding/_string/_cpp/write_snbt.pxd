from libcpp.string cimport string


cdef extern from "write_snbt.hpp" nogil:
    void write_snbt[T](const string&, const T&) except +
    void write_snbt[T](const string&, const T&, const string&, size_t) except +
