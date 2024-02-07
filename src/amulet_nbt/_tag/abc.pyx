from copy import copy
from typing import Any
import gzip

from libcpp cimport bool
from libcpp.string cimport string

from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding cimport StringEncoding
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._string_encoding import mutf8_encoding


cdef class AbstractBase:
    """Abstract Base class for all Tags and the NamedTag"""


cdef class AbstractBaseTag(AbstractBase):
    """Abstract Base Class for all Tag classes"""
    tag_id: int = -1

    cdef TagNode to_node(self):
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        raise NotImplementedError

    def to_nbt(
        self,
        *,
        bool compressed=True,
        bool little_endian=False,
        string_encoding: StringEncoding = mutf8_encoding,
        string name = b"",
    ):
        """
        Get the data in binary NBT format.

        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoding: A function to encode strings to bytes.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        cdef endian endianness = endian.little if little_endian else endian.big

        cdef bytes data = self.write_tag(
            name,
            endianness,
            string_encoding.encode_cpp
        )

        if compressed:
            return gzip.compress(data)
        return data

    cdef string write_tag(self, string name, endian endianness, CStringEncode string_encode):
        raise NotImplementedError

    def __eq__(self, other):
        """
        Check if the instance is equal to another instance.
        This will only return True if the tag type is the same and the data contained is the same.

        >>> from amulet_nbt import ByteTag, ShortTag
        >>> tag1 = ByteTag(1)
        >>> tag2 = ByteTag(2)
        >>> tag3 = ShortTag(1)
        >>> tag1 == tag1  # True
        >>> tag1 == tag2  # False
        >>> tag1 == tag3  # False
        """
        raise NotImplementedError

    def __repr__(self):
        """
        A string representation of the object to show how it can be constructed.
        >>> from amulet_nbt import ByteTag
        >>> tag = ByteTag(1)
        >>> repr(tag)  # "ByteTag(1)"
        """
        raise NotImplementedError

    def __str__(self):
        """A string representation of the object."""
        raise NotImplementedError

    def __reduce__(self):
        raise NotImplementedError

    def copy(self):
        """Return a shallow copy of the class"""
        return copy(self)

    def __copy__(self):
        """
        A shallow copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.copy(tag)
        """
        raise NotImplementedError

    def __deepcopy__(self, memo=None):
        """
        A deep copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.deepcopy(tag)
        """
        raise NotImplementedError


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self):
        raise NotImplementedError


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None
