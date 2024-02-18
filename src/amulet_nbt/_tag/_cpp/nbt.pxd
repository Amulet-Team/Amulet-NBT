# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS

from libc.stdint cimport (
    int8_t,
    int16_t,
    int32_t,
    int64_t
)
from libcpp.string cimport string
from libcpp.memory cimport shared_ptr
from libcpp.unordered_map cimport unordered_map
from libcpp.vector cimport vector
from amulet_nbt._libcpp.variant cimport variant
from .array cimport Array


cdef extern from "nbt.hpp" nogil:
    # Node variant
    ctypedef variant TagNode "TagNode"

    # Base types
    ctypedef int8_t CByteTag
    ctypedef int16_t CShortTag
    ctypedef int32_t CIntTag
    ctypedef int64_t CLongTag
    ctypedef float CFloatTag;
    ctypedef double CDoubleTag
    ctypedef Array[CByteTag] CByteArrayTag
    ctypedef string CStringTag
    cdef cppclass CListTag(variant):
        pass
    cdef cppclass CCompoundTag(unordered_map[string, TagNode]):
        CCompoundTag() except +
        CCompoundTag(CCompoundTag &) except +
        size_t erase(string &)
    ctypedef Array[CIntTag] CIntArrayTag
    ctypedef Array[CLongTag] CLongArrayTag

    # Pointer types
    ctypedef shared_ptr[CListTag] CListTagPtr
    ctypedef shared_ptr[CCompoundTag] CCompoundTagPtr
    ctypedef shared_ptr[CByteArrayTag] CByteArrayTagPtr
    ctypedef shared_ptr[CIntArrayTag] CIntArrayTagPtr
    ctypedef shared_ptr[CLongArrayTag] CLongArrayTagPtr

    # List types
    ctypedef vector[CByteTag] CByteList
    ctypedef vector[CShortTag] CShortList
    ctypedef vector[CIntTag] CIntList
    ctypedef vector[CLongTag] CLongList
    ctypedef vector[CFloatTag] CFloatList
    ctypedef vector[CDoubleTag] CDoubleList
    ctypedef vector[CByteArrayTagPtr] CByteArrayList
    ctypedef vector[CStringTag] CStringList
    ctypedef vector[CListTagPtr] CListList
    ctypedef vector[CCompoundTagPtr] CCompoundList
    ctypedef vector[CIntArrayTagPtr] CIntArrayList
    ctypedef vector[CLongArrayTagPtr] CLongArrayList
