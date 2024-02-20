## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8

from typing import Any, SupportsInt

from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_byte_snbt, write_short_snbt, write_int_snbt, write_long_snbt
from amulet_nbt._tag._cpp cimport TagNode, CByteTag, CShortTag, CIntTag, CLongTag
from .numeric cimport AbstractBaseNumericTag


cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    """Abstract Base Class for all int Tag classes"""

    @property
    def py_int(self) -> int:
        """A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        return self.py_int


cdef class ByteTag(AbstractBaseIntTag):
    """A 1 byte integer class.

    Can Store numbers between -(2^7) and (2^7 - 1)
    """
    tag_id: int = 1

    def __init__(self, value: SupportsInt = 0) -> None:
        value = int(value)
        self.cpp = (value & 0x7F) - (value & 0x80)

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
    def py_int(self) -> int:
        """A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CByteTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_byte_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"ByteTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return ByteTag, (self.cpp,)

    def __copy__(self) -> ByteTag:
        return ByteTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> ByteTag:
        return ByteTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((1, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, ByteTag):
            return NotImplemented
        cdef ByteTag other_ = other
        return self.cpp < other_.cpp


cdef class ShortTag(AbstractBaseIntTag):
    """A 2 byte integer class.

    Can Store numbers between -(2^15) and (2^15 - 1)
    """
    tag_id: int = 2

    def __init__(self, value: SupportsInt = 0) -> None:
        value = int(value)
        self.cpp = (value & 0x7FFF) - (value & 0x8000)

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
    def py_int(self) -> int:
        """A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CShortTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_short_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"ShortTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return ShortTag, (self.cpp,)

    def __copy__(self) -> ShortTag:
        return ShortTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> ShortTag:
        return ShortTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((2, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, ShortTag):
            return NotImplemented
        cdef ShortTag other_ = other
        return self.cpp < other_.cpp


cdef class IntTag(AbstractBaseIntTag):
    """A 4 byte integer class.

    Can Store numbers between -(2^31) and (2^31 - 1)
    """
    tag_id: int = 3

    def __init__(self, value: SupportsInt = 0) -> None:
        value = int(value)
        self.cpp = (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

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
    def py_int(self) -> int:
        """A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CIntTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_int_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"IntTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return IntTag, (self.cpp,)

    def __copy__(self) -> IntTag:
        return IntTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> IntTag:
        return IntTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((3, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, IntTag):
            return NotImplemented
        cdef IntTag other_ = other
        return self.cpp < other_.cpp


cdef class LongTag(AbstractBaseIntTag):
    """An 8 byte integer class.

    Can Store numbers between -(2^63) and (2^63 - 1)
    """
    tag_id: int = 4

    def __init__(self, value: SupportsInt = 0) -> None:
        value = int(value)
        self.cpp = (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

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
    def py_int(self) -> int:
        """A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """
        return self.cpp

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CLongTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_long_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"LongTag({self.cpp})"

    def __str__(self) -> str:
        return str(self.cpp)

    def __reduce__(self):
        return LongTag, (self.cpp,)

    def __copy__(self) -> LongTag:
        return LongTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> LongTag:
        return LongTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((4, self.cpp))

    def __int__(self) -> int:
        return int(self.cpp)

    def __float__(self) -> float:
        return float(self.cpp)

    def __bool__(self) -> bool:
        return bool(self.cpp)

    def __ge__(self, other: Any) -> bool:
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp >= other_.cpp

    def __gt__(self, other: Any) -> bool:
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp > other_.cpp

    def __le__(self, other: Any) -> bool:
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp <= other_.cpp

    def __lt__(self, other: Any) -> bool:
        if not isinstance(other, LongTag):
            return NotImplemented
        cdef LongTag other_ = other
        return self.cpp < other_.cpp
