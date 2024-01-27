# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20

from libc.stdint cimport (
    int8_t,
    int16_t,
    int32_t,
    int64_t
)
from libcpp.string cimport string
from libcpp.memory cimport shared_ptr
from libcpp.unordered_map cimport unordered_map
from libcpp.pair cimport pair
from libcpp.vector cimport vector
from amulet_nbt._libcpp.variant cimport variant
from amulet_nbt._nbt.array cimport Array


from amulet_nbt._nbt.nbt cimport (
    TagNode,
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CStringTag,
    CListTag,
    CCompoundTag,
    CByteArrayTag,
    CIntArrayTag,
    CLongArrayTag,
    CListTagPtr,
    CCompoundTagPtr,
    CByteArrayTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr,
    CByteList,
    CShortList,
    CIntList,
    CLongList,
    CFloatList,
    CDoubleList,
    CByteArrayList,
    CStringList,
    CListList,
    CCompoundList,
    CIntArrayList,
    CLongArrayList,
)


cdef extern from "read.hpp" nogil:
    pair[string, TagNode] read_named_tag(istream, endian) except +
