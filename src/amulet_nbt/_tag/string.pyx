## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

from io import BytesIO
from copy import deepcopy
import warnings

from libcpp.string cimport string

from amulet_nbt._tag.abc cimport AbstractBaseImmutableTag
from amulet_nbt._nbt cimport CStringTag
# from amulet_nbt._const cimport ID_STRING
# from amulet_nbt._dtype import EncoderType


# cdef inline escape(str string):
#     return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class StringTag(AbstractBaseImmutableTag):
    """A class that behaves like a string."""
    # tag_id = ID_STRING

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

    def __eq__(StringTag self, other):
        cdef StringTag other_
        if not isinstance(other, StringTag):
            return NotImplemented
        other_ = other
        return self.cpp == other_.cpp

    def __repr__(self):
        return f"StringTag({self})"

    def __str__(self):
        return self.cpp

    # @property
    # def py_str(StringTag self) -> str:
    #     """
    #     A python string representation of the class.
    #     """
    #     return self.value_
    #
    # @property
    # def py_data(self):
    #     """
    #     A python representation of the class. Note that the return type is undefined and may change in the future.
    #     You would be better off using the py_{type} or np_array properties if you require a fixed type.
    #     This is here for convenience to get a python representation under the same property name.
    #     """
    #     return self.py_str
    #
    # def __repr__(StringTag self):
    #     return f"{self.__class__.__name__}(\"{escape(self.py_str)}\")"
    #
    # cdef str _to_snbt(StringTag self):
    #     return f"\"{escape(self.py_str)}\""
    #
    # def __len__(self) -> int:
    #     return len(self.value_)
