# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20

from libcpp.string cimport string
from libcpp.pair cimport pair
from .nbt cimport TagNode
from amulet_nbt._libcpp.endian cimport endian


cdef extern from "read.hpp" nogil:
    pair[string, TagNode] read_named_tag(string&, endian) except +
