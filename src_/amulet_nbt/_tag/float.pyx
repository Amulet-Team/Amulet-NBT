## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8

from typing import Any, SupportsFloat

from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_float_snbt, write_double_snbt
from amulet_nbt._tag._cpp cimport TagNode, CFloatTag, CDoubleTag
from .numeric cimport AbstractBaseNumericTag


cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    """Abstract Base Class for all float Tag classes"""

    @property
    def py_float(self) -> float:
        """A python float representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        return self.py_float


cdef class FloatTag(AbstractBaseFloatTag):
    """A single precision float class."""
    tag_id: int = 5

    def __init__(self, value: SupportsFloat = 0) -> None:
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

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CFloatTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_float_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"FloatTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return FloatTag, (self.cpp,)

    def __copy__(self) -> FloatTag:
        return FloatTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> FloatTag:
        return FloatTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((5, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp < other_.cpp


cdef class DoubleTag(AbstractBaseFloatTag):
    """A double precision float class."""
    tag_id: int = 6

    def __init__(self, value: SupportsFloat = 0) -> None:
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

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CDoubleTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_double_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"DoubleTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return DoubleTag, (self.cpp,)

    def __copy__(self) -> DoubleTag:
        return DoubleTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> DoubleTag:
        return DoubleTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((6, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp < other_.cpp
