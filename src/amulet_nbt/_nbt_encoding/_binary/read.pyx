# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# distutils: sources = [src/amulet_nbt/_nbt_encoding/_binary/_cpp/read.cpp]

import gzip
import zlib
from typing import Union, BinaryIO
import os
import warnings

from libcpp cimport bool
from libcpp.pair cimport pair
from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian

from amulet_nbt._tag._cpp cimport TagNode
from amulet_nbt._nbt_encoding._binary._cpp cimport read_named_tag
from amulet_nbt._tag.compound cimport wrap_node
from amulet_nbt._tag.named_tag cimport NamedTag
from amulet_nbt._string_encoding cimport StringEncoding
from amulet_nbt._string_encoding import mutf8_encoding
from amulet_nbt._errors import NBTLoadError, NBTFormatError


cdef class ReadOffset:
    pass


cdef string get_buffer(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    bint compressed=True,
):
    cdef string data
    if isinstance(filepath_or_buffer, str):
        # if a string load from the file path
        if not os.path.isfile(filepath_or_buffer):
            raise NBTLoadError(f"There is no file at {filepath_or_buffer}")
        with open(filepath_or_buffer, "rb") as f:
            data = f.read()
    elif isinstance(filepath_or_buffer, bytes):
        data = filepath_or_buffer
    elif isinstance(filepath_or_buffer, memoryview):
        data = filepath_or_buffer.tobytes()
    elif hasattr(filepath_or_buffer, "read"):
        buffer_data = filepath_or_buffer.read()
        if not isinstance(buffer_data, bytes):
            raise NBTLoadError(f"buffer.read() must return a bytes object. Got {type(buffer_data)} instead.")
        data = buffer_data
    else:
        raise NBTLoadError("buffer did not have a read method.")

    if compressed:
        try:
            data = gzip.decompress(data)
        except (IOError, zlib.error):
            pass
    return data


def load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    bint compressed: bool=True,
    bint little_endian: bool = False,
    StringEncoding string_encoding not None = mutf8_encoding,
    ReadOffset read_context = None,
    ReadOffset read_offset = None,
) -> NamedTag:
    if read_context is not None:
        warnings.warn("read_context argument is depreciated. Use read_offset instead.", DeprecationWarning)
        read_offset = read_context

    cdef string buffer = get_buffer(filepath_or_buffer, compressed)
    cdef size_t offset = 0
    cdef endian endianness = endian.little if little_endian else endian.big
    cdef pair[string, TagNode] named_tag

    try:
        named_tag = read_named_tag(buffer, endianness, string_encoding.decode_cpp, offset)

        if read_offset is not None:
            read_offset.offset = offset

        return NamedTag(wrap_node(&named_tag.second), named_tag.first)
    except Exception as e:
        raise NBTFormatError("Failed parsing binary NBT") from e


def load_array(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    int count = 1,
    bint compressed: bool=True,
    bint little_endian: bool = False,
    StringEncoding string_encoding = mutf8_encoding,
    ReadOffset read_context = None,
    ReadOffset read_offset = None,
) -> list[NamedTag]:
    if count < -1:
        raise ValueError("Count must be -1 or higher")

    if read_context is not None:
        warnings.warn("read_context argument is depreciated. Use read_offset instead.", DeprecationWarning)
        read_offset = read_context

    cdef string buffer = get_buffer(filepath_or_buffer, compressed)
    cdef size_t offset = 0
    cdef endian endianness = endian.little if little_endian else endian.big
    cdef pair[string, TagNode] named_tag
    cdef list results = []
    cdef size_t i
    try:
        if count == -1:
            while offset < buffer.size():
                named_tag = read_named_tag(buffer, endianness, string_encoding.decode_cpp, offset)
                results.append(
                    NamedTag(wrap_node(&named_tag.second), named_tag.first)
                )
        else:
            for i in range(count):
                named_tag = read_named_tag(buffer, endianness, string_encoding.decode_cpp, offset)
                results.append(
                    NamedTag(wrap_node(&named_tag.second), named_tag.first)
                )

        if read_offset is not None:
            read_offset.offset = offset

        return results
    except Exception as e:
        raise NBTFormatError("Failed parsing binary NBT") from e
