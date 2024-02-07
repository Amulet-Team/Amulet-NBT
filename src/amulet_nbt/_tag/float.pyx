## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20

from typing import Any

from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._tag._cpp cimport TagNode, CFloatTag, CDoubleTag
from .numeric cimport AbstractBaseNumericTag


cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    """Abstract Base Class for all float Tag classes"""

    @property
    def py_float(self) -> float:
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        return self.py_float


cdef class FloatTag(AbstractBaseFloatTag):
    """A single precision float class."""
    tag_id: int = 5

    def __init__(self, value = 0):
        self.cpp = float(value)

    @staticmethod
    cdef FloatTag wrap(CFloatTag cpp):
        cdef FloatTag tag = FloatTag.__new__(FloatTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CFloatTag](self.cpp)
        return node

    @property
    def py_float(self) -> float:
        return self.cpp

    cdef string write_tag(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CFloatTag](name, self.cpp, endianness, string_encode)

    def __eq__(self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self):
        return f"FloatTag({self.cpp})"

    def __str__(self):
        return str(self.cpp)

    def __reduce__(self):
        return FloatTag, (self.cpp,)

    def __copy__(self):
        return FloatTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None):
        return FloatTag.wrap(self.cpp)

    def __hash__(self):
        return hash((5, self.cpp))

    def __int__(self):
        return int(self.cpp)

    def __float__(self):
        return float(self.cpp)

    def __bool__(self):
        return bool(self.cpp)

    def __ge__(self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp < other_.cpp


cdef class DoubleTag(AbstractBaseFloatTag):
    """A double precision float class."""
    tag_id: int = 6

    def __init__(self, value = 0):
        self.cpp = float(value)

    @staticmethod
    cdef DoubleTag wrap(CDoubleTag cpp):
        cdef DoubleTag tag = DoubleTag.__new__(DoubleTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CDoubleTag](self.cpp)
        return node

    @property
    def py_float(self) -> float:
        return self.cpp

    cdef string write_tag(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CDoubleTag](name, self.cpp, endianness, string_encode)

    def __eq__(self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self):
        return f"DoubleTag({self.cpp})"

    def __str__(self):
        return str(self.cpp)

    def __reduce__(self):
        return DoubleTag, (self.cpp,)

    def __copy__(self):
        return DoubleTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None):
        return DoubleTag.wrap(self.cpp)

    def __hash__(self):
        return hash((6, self.cpp))

    def __int__(self):
        return int(self.cpp)

    def __float__(self):
        return float(self.cpp)

    def __bool__(self):
        return bool(self.cpp)

    def __ge__(self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp < other_.cpp
