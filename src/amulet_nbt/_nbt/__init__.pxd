# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# distutils: include_dirs = /src/nbt

from libc.stdint cimport (
    int8_t,
    int16_t,
    int32_t,
    int64_t
)
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.memory cimport shared_ptr
from libcpp.unordered_map cimport unordered_map
from libcpp.pair cimport pair
from amulet_nbt._libcpp.variant cimport variant, get_if, get
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._libcpp.iostream cimport istream
from amulet_nbt._nbt.array cimport Array


cdef extern from "nbt.hpp" nogil:
    ctypedef int8_t ByteTag
    ctypedef int16_t ShortTag
    ctypedef int32_t IntTag
    ctypedef int64_t LongTag
    ctypedef float FloatTag;
    ctypedef double DoubleTag
    ctypedef string StringTag
    cdef cppclass ListTag
    cdef cppclass CompoundTag
    ctypedef Array[ByteTag] ByteArrayTag
    ctypedef Array[IntTag] IntArrayTag
    ctypedef Array[LongTag] LongArrayTag

    ctypedef shared_ptr[ListTag] ListTagPtr
    ctypedef shared_ptr[CompoundTag] CompoundTagPtr
    ctypedef shared_ptr[ByteArrayTag] ByteArrayTagPtr
    ctypedef shared_ptr[IntArrayTag] IntArrayTagPtr
    ctypedef shared_ptr[LongArrayTag] LongArrayTagPtr

    ctypedef variant TagNode "TagNode"

    cdef cppclass ListTag(variant):
        pass

    cdef cppclass CompoundTag(unordered_map[string, TagNode]):
        pass


cdef extern from "read.hpp" nogil:
    pair[string, TagNode] read_named_tag(istream, endian) except +
