from ._cpp cimport CStringEncode, CStringDecode


cdef class StringEncoding:
    cdef CStringEncode encode_cpp
    cdef CStringDecode decode_cpp
