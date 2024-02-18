## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8

from typing import Any
from collections.abc import Iterator

from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_string_snbt
from amulet_nbt._tag._cpp cimport TagNode, CStringTag
from .abc cimport AbstractBaseImmutableTag


cdef inline escape(str s):
    return s.replace('\\', '\\\\').replace('"', '\\"')


cdef class StringTag(AbstractBaseImmutableTag):
    """A class that behaves like a string."""
    tag_id: int = 8

    def __init__(self, object value: str | bytes = b"") -> None:
        if isinstance(value, (str, bytes)):
            self.cpp = value
        else:
            self.cpp = str(value)

    @staticmethod
    cdef StringTag wrap(CStringTag cpp):
        cdef StringTag tag = StringTag.__new__(StringTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CStringTag](self.cpp)
        return node

    @property
    def py_str(self) -> str:
        """The data stored in the class as a python string.

        In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError.
        """
        return <str> self.cpp

    @property
    def py_bytes(self) -> bytes:
        """The bytes stored in the class."""
        return <bytes> self.cpp

    @property
    def py_data(self) -> Any:
        return <bytes> self.py_str

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CStringTag](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_string_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, StringTag):
            return NotImplemented
        cdef StringTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self) -> str:
        return f"StringTag(\"{escape(self.py_str)}\")"

    def __str__(self) -> str:
        return <str> self.cpp

    def __reduce__(self):
        return StringTag, (self.cpp,)

    def __copy__(self) -> StringTag:
        return StringTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None) -> StringTag:
        return StringTag.wrap(self.cpp)

    def __hash__(self) -> int:
        return hash((8, self.cpp))

    # cdef str _to_snbt(self):
    #     return f"\"{escape(self.py_str)}\""

    def __ge__(self, other: Any) -> bool:
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) >= str(other_.cpp)
        return NotImplemented

    def __gt__(self, other: Any) -> bool:
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) > str(other_.cpp)
        return NotImplemented

    def __le__(self, other: Any) -> bool:
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) <= str(other_.cpp)
        return NotImplemented

    def __lt__(self, other: Any) -> bool:
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) < str(other_.cpp)
        return NotImplemented
