# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS

from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding.encoding import mutf8_encoding, utf8_escape_encoding


cdef EncodingPreset _java_encoding = EncodingPreset()
_java_encoding.compressed = True
_java_encoding.endianness = endian.big
_java_encoding.string_encoding = mutf8_encoding
java_encoding = _java_encoding


cdef EncodingPreset _bedrock_encoding = EncodingPreset()
_bedrock_encoding.compressed = False
_bedrock_encoding.endianness = endian.little
_bedrock_encoding.string_encoding = utf8_escape_encoding
bedrock_encoding = _bedrock_encoding
