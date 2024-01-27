## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
## This file is generated by tempita. Do not modify this file directly or your changes will get overwritten.
## To edit this file edit the template in template/src

from io import BytesIO
from copy import deepcopy
import warnings
from typing import Any

from amulet_nbt._nbt cimport TagNode, CByteTag, CShortTag, CIntTag, CLongTag
from .numeric cimport AbstractBaseNumericTag
# from amulet_nbt._const cimport ID_BYTE, ID_SHORT, ID_INT, ID_LONG
# from amulet_nbt._dtype import EncoderType


cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    """Abstract Base Class for all int Tag classes"""

    @property
    def py_int(AbstractBaseNumericTag self) -> int:
        """
        A python int representation of the class.
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
        return self.py_int


cdef class ByteTag(AbstractBaseIntTag):
    """
    A 1 byte integer class.
    Can Store numbers between -(2^7) and (2^7 - 1)
    """
    tag_id: int = 1

    def __init__(ByteTag self, value = 0):
        self.cpp = self._sanitise_value(int(value))

    def __eq__(ByteTag self, other):
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(ByteTag self):
        return f"ByteTag({self.cpp})"

    def __str__(ByteTag self):
        return str(self.cpp)

    def __reduce__(ByteTag self):
        raise NotImplementedError

    def __copy__(ByteTag self):
        raise NotImplementedError

    def __deepcopy__(ByteTag self, memo=None):
        raise NotImplementedError

    def __hash__(ByteTag self):
        return hash((1, self.cpp))

    def __int__(ByteTag self):
        return int(self.cpp)

    def __float__(ByteTag self):
        return float(self.cpp)

    def __bool__(ByteTag self):
        return bool(self.cpp)

    def __ge__(ByteTag self, other):
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(ByteTag self, other):
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp > other_.cpp

    def __le__(ByteTag self, other):
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(ByteTag self, other):
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp < other_.cpp
    @staticmethod
    cdef ByteTag wrap(CByteTag cpp):
        cdef ByteTag tag = ByteTag.__new__(ByteTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CByteTag](self.cpp)
        return node

    @property
    def py_int(ByteTag self) -> int:
        """
        A python int representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef CByteTag _sanitise_value(ByteTag self, value):
        return (value & 0x7F) - (value & 0x80)


cdef class ShortTag(AbstractBaseIntTag):
    """
    A 2 byte integer class.
    Can Store numbers between -(2^15) and (2^15 - 1)
    """
    tag_id: int = 2

    def __init__(ShortTag self, value = 0):
        self.cpp = self._sanitise_value(int(value))

    def __eq__(ShortTag self, other):
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(ShortTag self):
        return f"ShortTag({self.cpp})"

    def __str__(ShortTag self):
        return str(self.cpp)

    def __reduce__(ShortTag self):
        raise NotImplementedError

    def __copy__(ShortTag self):
        raise NotImplementedError

    def __deepcopy__(ShortTag self, memo=None):
        raise NotImplementedError

    def __hash__(ShortTag self):
        return hash((2, self.cpp))

    def __int__(ShortTag self):
        return int(self.cpp)

    def __float__(ShortTag self):
        return float(self.cpp)

    def __bool__(ShortTag self):
        return bool(self.cpp)

    def __ge__(ShortTag self, other):
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(ShortTag self, other):
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp > other_.cpp

    def __le__(ShortTag self, other):
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(ShortTag self, other):
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp < other_.cpp
    @staticmethod
    cdef ShortTag wrap(CShortTag cpp):
        cdef ShortTag tag = ShortTag.__new__(ShortTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CShortTag](self.cpp)
        return node

    @property
    def py_int(ShortTag self) -> int:
        """
        A python int representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef CShortTag _sanitise_value(ShortTag self, value):
        return (value & 0x7FFF) - (value & 0x8000)


cdef class IntTag(AbstractBaseIntTag):
    """
    A 4 byte integer class.
    Can Store numbers between -(2^31) and (2^31 - 1)
    """
    tag_id: int = 3

    def __init__(IntTag self, value = 0):
        self.cpp = self._sanitise_value(int(value))

    def __eq__(IntTag self, other):
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(IntTag self):
        return f"IntTag({self.cpp})"

    def __str__(IntTag self):
        return str(self.cpp)

    def __reduce__(IntTag self):
        raise NotImplementedError

    def __copy__(IntTag self):
        raise NotImplementedError

    def __deepcopy__(IntTag self, memo=None):
        raise NotImplementedError

    def __hash__(IntTag self):
        return hash((3, self.cpp))

    def __int__(IntTag self):
        return int(self.cpp)

    def __float__(IntTag self):
        return float(self.cpp)

    def __bool__(IntTag self):
        return bool(self.cpp)

    def __ge__(IntTag self, other):
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(IntTag self, other):
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp > other_.cpp

    def __le__(IntTag self, other):
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(IntTag self, other):
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp < other_.cpp
    @staticmethod
    cdef IntTag wrap(CIntTag cpp):
        cdef IntTag tag = IntTag.__new__(IntTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CIntTag](self.cpp)
        return node

    @property
    def py_int(IntTag self) -> int:
        """
        A python int representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef CIntTag _sanitise_value(IntTag self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)


cdef class LongTag(AbstractBaseIntTag):
    """
    An 8 byte integer class.
    Can Store numbers between -(2^63) and (2^63 - 1)
    """
    tag_id: int = 4

    def __init__(LongTag self, value = 0):
        self.cpp = self._sanitise_value(int(value))

    def __eq__(LongTag self, other):
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(LongTag self):
        return f"LongTag({self.cpp})"

    def __str__(LongTag self):
        return str(self.cpp)

    def __reduce__(LongTag self):
        raise NotImplementedError

    def __copy__(LongTag self):
        raise NotImplementedError

    def __deepcopy__(LongTag self, memo=None):
        raise NotImplementedError

    def __hash__(LongTag self):
        return hash((4, self.cpp))

    def __int__(LongTag self):
        return int(self.cpp)

    def __float__(LongTag self):
        return float(self.cpp)

    def __bool__(LongTag self):
        return bool(self.cpp)

    def __ge__(LongTag self, other):
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(LongTag self, other):
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp > other_.cpp

    def __le__(LongTag self, other):
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(LongTag self, other):
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp < other_.cpp
    @staticmethod
    cdef LongTag wrap(CLongTag cpp):
        cdef LongTag tag = LongTag.__new__(LongTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CLongTag](self.cpp)
        return node

    @property
    def py_int(LongTag self) -> int:
        """
        A python int representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef CLongTag _sanitise_value(LongTag self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)
