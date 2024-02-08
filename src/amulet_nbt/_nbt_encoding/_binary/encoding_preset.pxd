from libcpp cimport bool
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding cimport StringEncoding


cdef class EncodingPreset:
    cdef bool compressed
    cdef endian endianness
    cdef StringEncoding string_encoding
