## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

from typing import Any

from amulet_nbt._nbt cimport TagNode, CStringTag
from .abc cimport AbstractBaseImmutableTag
# from amulet_nbt._const cimport ID_STRING
# from amulet_nbt._dtype import EncoderType


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class StringTag(AbstractBaseImmutableTag):
    """A class that behaves like a string."""
    tag_id: int = 8

    def __init__(StringTag self, object value = b""):
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
    def py_str(StringTag self) -> str | bytes:
        """
        A python string representation of the class.
        """
        return str(self)

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        return self.py_str

    def __eq__(StringTag self, other):
        if not isinstance(other, StringTag):
            return NotImplemented
        cdef StringTag other_ = other
        return self.cpp == other_.cpp

    def __repr__(self):
        return f"StringTag(\"{escape(self.py_str)}\")"

    def __str__(self):
        try:
            return <str> self.cpp
        except UnicodeDecodeError:
            return <bytes> self.cpp

    def __reduce__(self):
        return StringTag, (self.cpp,)

    def __copy__(self):
        return StringTag.wrap(self.cpp)

    def __deepcopy__(self, memo=None):
        return StringTag.wrap(self.cpp)

    def __hash__(self):
        return hash((8, self.cpp))

    # cdef str _to_snbt(StringTag self):
    #     return f"\"{escape(self.py_str)}\""

    def __len__(self) -> int:
        return self.cpp.size()

    def __ge__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) >= str(other_.cpp)
        return NotImplemented

    def __gt__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) > str(other_.cpp)
        return NotImplemented

    def __le__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) <= str(other_.cpp)
        return NotImplemented

    def __lt__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return str(self.cpp) < str(other_.cpp)
        return NotImplemented
