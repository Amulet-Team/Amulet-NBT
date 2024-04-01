## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8
# distutils: sources = [src/amulet_nbt/_string_encoding/_cpp/utf8.cpp, src/amulet_nbt/_nbt_encoding/_binary/_cpp/read_nbt.cpp]

from typing import Any
import copy
import gzip
from libcpp.string cimport string
from libcpp cimport bool
from libcpp.pair cimport pair
import amulet_nbt
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding cimport StringEncoding
from amulet_nbt._string_encoding import mutf8_encoding
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._string_encoding._cpp.utf8 cimport utf8_escape_to_utf8, utf8_to_utf8_escape
from amulet_nbt._nbt_encoding._binary._cpp cimport read_named_tag
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._binary.encoding_preset cimport EncodingPreset
from amulet_nbt._nbt_encoding._string cimport write_node_snbt

from .abc cimport AbstractBase, AbstractBaseTag
from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport ListTag
from .compound cimport wrap_node, CompoundTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag


def _unpickle(string data):
    cdef pair[string, TagNode] named_tag = read_named_tag(data, endian.big, utf8_to_utf8_escape)
    return NamedTag.wrap(named_tag.first, named_tag.second)


cdef class NamedTag(AbstractBase):
    def __init__(self, AbstractBaseTag tag: amulet_nbt.AbstractBaseTag = None, string name: str | bytes = b"") -> None:
        if tag is None:
            tag = CompoundTag()
        self.tag_node = tag.to_node()
        self.tag_name = name

    @staticmethod
    cdef NamedTag wrap(string name, TagNode node):
        cdef NamedTag self = NamedTag.__new__(NamedTag)
        self.tag_name = name
        self.tag_node = node
        return self

    @property
    def tag(self) -> AbstractBaseTag:
        return wrap_node(&self.tag_node)

    @tag.setter
    def tag(self, AbstractBaseTag tag not None) -> None:
        self.tag_node = tag.to_node()

    @property
    def name(self) -> str | bytes:
        try:
            return <str> self.tag_name
        except UnicodeDecodeError as e:
            return <bytes> self.tag_name

    @name.setter
    def name(self, name) -> None:
        self.tag_name = name

    cdef string write_nbt(self, endian endianness, CStringEncode string_encode):
        return write_named_tag[TagNode](self.tag_name, self.tag_node, endianness, string_encode)

    def to_nbt(
        self,
        *,
        EncodingPreset preset: amulet_nbt.EncodingPreset = None,
        bool compressed: bool = True,
        bool little_endian: bool = False,
        StringEncoding string_encoding: amulet_nbt.StringEncoding = mutf8_encoding,
    ) -> bytes:
        """Get the data in binary NBT format.

        :param preset: A class containing endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoding: A function to encode strings to bytes.
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
            endianness,
            string_encoding.encode_cpp
        )

        if compressed:
            return gzip.compress(data)
        return data

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        EncodingPreset preset: amulet_nbt.EncodingPreset = None,
        bool compressed: bool = True,
        bool little_endian: bool = False,
        StringEncoding string_encoding: amulet_nbt.StringEncoding = mutf8_encoding,
    ) -> bytes:
        """Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param preset: A class containing endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :return: The binary NBT representation of the class.
        """
        data = self.to_nbt(
            preset=preset,
            compressed=compressed,
            little_endian=little_endian,
            string_encoding=string_encoding,
        )

        if filepath_or_buffer is not None:
            if isinstance(filepath_or_buffer, str):
                with open(filepath_or_buffer, 'wb') as fp:
                    fp.write(data)
            else:
                filepath_or_buffer.write(data)
        return data

    def to_snbt(self, object indent = None) -> str:
        """Convert the data to the Stringified NBT format.

        :param indent:
            If None (the default) the SNBT will be on one line.
            If an int will be multi-line SNBT with this many spaces per indentation.
            If a string will be multi-line SNBT with this string as the indentation.
        :return: The SNBT string.
        """
        cdef string snbt
        cdef string indent_str
        if indent is None:
            write_node_snbt(snbt, self.tag_node)
        else:
            if isinstance(indent, int):
                indent_str = " " * indent
            elif isinstance(indent, str):
                indent_str = indent
            else:
                raise TypeError("indent must be a str, int or None")
            write_node_snbt(snbt, self.tag_node, indent_str, 0)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        cdef NamedTag other_
        if isinstance(other, NamedTag):
            other_ = other
            return self.name == other_.name and self.tag == other_.tag
        return NotImplemented

    def __repr__(self) -> str:
        return f'NamedTag({self.tag!r}, "{self.name}")'

    def __reduce__(self):
        cdef bytes nbt = self.write_nbt(endian.big, utf8_escape_to_utf8)
        return _unpickle, (nbt,)

    def __copy__(self) -> NamedTag:
        return NamedTag(self.tag, self.name)

    def __deepcopy__(self, memodict={}) -> NamedTag:
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
