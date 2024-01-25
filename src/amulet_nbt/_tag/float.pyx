## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
## This file is generated by tempita. Do not modify this file directly or your changes will get overwritten.
## To edit this file edit the template in template/src

from io import BytesIO
from copy import deepcopy
import warnings
from math import trunc, floor, ceil
from typing import Any

from amulet_nbt._nbt cimport TagNode, CFloatTag, CDoubleTag
from amulet_nbt._tag.numeric cimport AbstractBaseNumericTag
# from amulet_nbt._const cimport ID_FLOAT, ID_DOUBLE
# from amulet_nbt._dtype import EncoderType


cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    """Abstract Base Class for all float Tag classes"""

    @property
    def py_float(AbstractBaseNumericTag self) -> float:
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        return self.py_float


cdef class FloatTag(AbstractBaseFloatTag):
    """A single precision float class."""
    # tag_id = ID_FLOAT

    def __init__(FloatTag self, value = 0):
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

    def __eq__(FloatTag self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(FloatTag self):
        return f"{self.__class__.__name__}({self.cpp})"

    def __int__(FloatTag self):
        return int(self.cpp)

    def __float__(FloatTag self):
        return float(self.cpp)

    def __bool__(FloatTag self):
        return bool(self.cpp)

    def __ge__(FloatTag self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(FloatTag self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp > other_.cpp

    def __le__(FloatTag self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(FloatTag self, other):
        if not isinstance(other, FloatTag):
            return NotImplemented
        cdef FloatTag other_ = other
        return self.cpp < other_.cpp


cdef class DoubleTag(AbstractBaseFloatTag):
    """A double precision float class."""
    # tag_id = ID_DOUBLE

    def __init__(DoubleTag self, value = 0):
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

    def __eq__(DoubleTag self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(DoubleTag self):
        return f"{self.__class__.__name__}({self.cpp})"

    def __int__(DoubleTag self):
        return int(self.cpp)

    def __float__(DoubleTag self):
        return float(self.cpp)

    def __bool__(DoubleTag self):
        return bool(self.cpp)

    def __ge__(DoubleTag self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(DoubleTag self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp > other_.cpp

    def __le__(DoubleTag self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(DoubleTag self, other):
        if not isinstance(other, DoubleTag):
            return NotImplemented
        cdef DoubleTag other_ = other
        return self.cpp < other_.cpp
