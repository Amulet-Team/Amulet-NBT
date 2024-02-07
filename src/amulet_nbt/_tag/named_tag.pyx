## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

import copy
import gzip
from libcpp.string cimport string
from libcpp cimport bool
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding cimport StringEncoding
from amulet_nbt._string_encoding import mutf8_encoding
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag

from .abc cimport AbstractBase, AbstractBaseTag
from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport ListTag
from .compound cimport wrap_node, CompoundTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag


cdef class NamedTag(AbstractBase):
    def __init__(self, AbstractBaseTag tag = None, string name = b""):
        if tag is None:
            tag = CompoundTag()
        self.tag_node = tag.to_node()
        self.tag_name = name

    @property
    def tag(self) -> AbstractBaseTag:
        return wrap_node(&self.tag_node)

    @tag.setter
    def tag(self, AbstractBaseTag tag not None):
        self.tag_node = tag.to_node()

    @property
    def name(self) -> str | bytes:
        try:
            return <str> self.tag_name
        except UnicodeDecodeError as e:
            return <bytes> self.tag_name

    @name.setter
    def name(self, name):
        self.tag_name = name

    def to_nbt(
        self,
        *,
        bool compressed=True,
        bool little_endian=False,
        string_encoding: StringEncoding = mutf8_encoding,
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
            endianness,
            string_encoding.encode_cpp
        )

        if compressed:
            return gzip.compress(data)
        return data

    cdef string write_tag(self, endian endianness, CStringEncode string_encode):
        return write_named_tag[TagNode](self.tag_name, self.tag_node, endianness, string_encode)

    def __eq__(self, other):
        cdef NamedTag other_
        if isinstance(other, NamedTag):
            other_ = other
            return self.name == other_.name and self.tag == other_.tag
        return NotImplemented

    def __repr__(self):
        return f'NamedTag({self.tag!r}, "{self.name}")'

    def __reduce__(self):
        return NamedTag, (self.tag, self.name)

    def __copy__(self):
        return NamedTag(self.tag, self.name)

    def __deepcopy__(self, memodict={}):
        return NamedTag(
            copy.deepcopy(self.tag),
            self.name
        )

    def __getitem__(self, ptrdiff_t item):
        if item < 0:
            item += 2
        if not 0 <= item <= 1:
            raise IndexError("Index out of range")
        return (self.name, self.tag)[item]

    def __iter__(self):
        yield self.name
        yield self.tag

    @property
    def byte(self) -> ByteTag:
        """Get the tag if it is a ByteTag.

        :return: The ByteTag.
        :raises: TypeError if the stored type is not a ByteTag
        """
        cdef ByteTag tag = self.tag
        return tag

    @property
    def short(self) -> ShortTag:
        """Get the tag if it is a ShortTag.

        :return: The ShortTag.
        :raises: TypeError if the stored type is not a ShortTag
        """
        cdef ShortTag tag = self.tag
        return tag

    @property
    def int(self) -> IntTag:
        """Get the tag if it is a IntTag.

        :return: The IntTag.
        :raises: TypeError if the stored type is not a IntTag
        """
        cdef IntTag tag = self.tag
        return tag

    @property
    def long(self) -> LongTag:
        """Get the tag if it is a LongTag.

        :return: The LongTag.
        :raises: TypeError if the stored type is not a LongTag
        """
        cdef LongTag tag = self.tag
        return tag

    @property
    def float(self) -> FloatTag:
        """Get the tag if it is a FloatTag.

        :return: The FloatTag.
        :raises: TypeError if the stored type is not a FloatTag
        """
        cdef FloatTag tag = self.tag
        return tag

    @property
    def double(self) -> DoubleTag:
        """Get the tag if it is a DoubleTag.

        :return: The DoubleTag.
        :raises: TypeError if the stored type is not a DoubleTag
        """
        cdef DoubleTag tag = self.tag
        return tag

    @property
    def string(self) -> StringTag:
        """Get the tag if it is a StringTag.

        :return: The StringTag.
        :raises: TypeError if the stored type is not a StringTag
        """
        cdef StringTag tag = self.tag
        return tag

    @property
    def list(self) -> ListTag:
        """Get the tag if it is a ListTag.

        :return: The ListTag.
        :raises: TypeError if the stored type is not a ListTag
        """
        cdef ListTag tag = self.tag
        return tag

    @property
    def compound(self) -> CompoundTag:
        """Get the tag if it is a CompoundTag.

        :return: The CompoundTag.
        :raises: TypeError if the stored type is not a CompoundTag
        """
        cdef CompoundTag tag = self.tag
        return tag

    @property
    def byte_array(self) -> ByteArrayTag:
        """Get the tag if it is a ByteArrayTag.

        :return: The ByteArrayTag.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """
        cdef ByteArrayTag tag = self.tag
        return tag

    @property
    def int_array(self) -> IntArrayTag:
        """Get the tag if it is a IntArrayTag.

        :return: The IntArrayTag.
        :raises: TypeError if the stored type is not a IntArrayTag
        """
        cdef IntArrayTag tag = self.tag
        return tag

    @property
    def long_array(self) -> LongArrayTag:
        """Get the tag if it is a LongArrayTag.

        :return: The LongArrayTag.
        :raises: TypeError if the stored type is not a LongArrayTag
        """
        cdef LongArrayTag tag = self.tag
        return tag
