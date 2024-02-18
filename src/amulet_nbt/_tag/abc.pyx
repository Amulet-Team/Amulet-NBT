# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8

from copy import copy
from typing import Any, Self, BinaryIO
import gzip

from libcpp cimport bool
from libcpp.string cimport string

from amulet_nbt._libcpp.endian cimport endian

import amulet_nbt
from amulet_nbt._string_encoding cimport StringEncoding
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._string_encoding import mutf8_encoding
from amulet_nbt._nbt_encoding._binary.encoding_preset cimport EncodingPreset


cdef class AbstractBase:
    """Abstract Base class for all Tags and the NamedTag"""


cdef class AbstractBaseTag(AbstractBase):
    """Abstract Base Class for all Tag classes"""
    tag_id: int = -1

    cdef TagNode to_node(self):
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        """A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        raise NotImplementedError

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        raise NotImplementedError

    def to_nbt(
        self,
        *,
        EncodingPreset preset: amulet_nbt.EncodingPreset = None,
        bool compressed: bool = True,
        bool little_endian: bool = False,
        StringEncoding string_encoding: amulet_nbt.StringTag = mutf8_encoding,
        string name: str | bytes = b"",
    ) -> bytes:
        """Get the data in binary NBT format.

        :param preset: A class containing endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        cdef endian endianness

        if preset is not None:
            endianness = preset.endianness
            compressed = preset.compressed
            string_encoding = preset.string_encoding
        else:
            endianness = endian.little if little_endian else endian.big

        cdef bytes data = self.write_nbt(
            name,
            endianness,
            string_encoding.encode_cpp
        )

        if compressed:
            return gzip.compress(data)
        return data

    def save_to(
        self,
        object filepath_or_buffer: bytes | str | BinaryIO | memoryview | None = None,
        *,
        EncodingPreset preset: amulet_nbt.EncodingPreset = None,
        bool compressed: bool = True,
        bool little_endian: bool = False,
        StringEncoding string_encoding: amulet_nbt.StringEncoding = mutf8_encoding,
        string name: str | bytes = b"",
    ) -> bytes:
        """Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param preset: A class containing endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        data = self.to_nbt(
            preset=preset,
            compressed=compressed,
            little_endian=little_endian,
            string_encoding=string_encoding,
            name=name,
        )

        if filepath_or_buffer is not None:
            if isinstance(filepath_or_buffer, str):
                with open(filepath_or_buffer, 'wb') as fp:
                    fp.write(data)
            else:
                filepath_or_buffer.write(data)
        return data

    def to_snbt(self, object indent: None | str | int = None) -> str:
        """Convert the data to the Stringified NBT format.

        :param indent:
            If None (the default) the SNBT will be on one line.
            If an int will be multi-line SNBT with this many spaces per indentation.
            If a string will be multi-line SNBT with this string as the indentation.
        :return: The SNBT string.
        """
        raise NotImplementedError

    def __eq__(self, object other: Any) -> bool:
        """Check if the instance is equal to another instance.

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

    def __repr__(self) -> str:
        """A string representation of the object to show how it can be constructed.

        >>> from amulet_nbt import ByteTag
        >>> tag = ByteTag(1)
        >>> repr(tag)  # "ByteTag(1)"
        """
        raise NotImplementedError

    def __str__(self) -> str:
        """A string representation of the object."""
        raise NotImplementedError

    def __reduce__(self):
        raise NotImplementedError

    def copy(self) -> Self:
        """Return a shallow copy of the class"""
        return copy(self)

    def __copy__(self):
        """A shallow copy of the class

        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.copy(tag)

        :return: A shallow copy of the class
        """
        raise NotImplementedError

    def __deepcopy__(self, memo=None):
        """A deep copy of the class

        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.deepcopy(tag)

        :return: A deep copy of the class
        """
        raise NotImplementedError


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self) -> int:
        """A hash of the data in the class."""
        raise NotImplementedError


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None
