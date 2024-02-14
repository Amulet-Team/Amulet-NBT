# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# distutils: sources = [src/amulet_nbt/_string_encoding/_cpp/mutf8.cpp, src/amulet_nbt/_string_encoding/_cpp/utf8.cpp]

from ._cpp.utf8 cimport utf8_to_utf8, utf8_escape_to_utf8, utf8_to_utf8_escape
from ._cpp.mutf8 cimport (
    mutf8_to_utf8,
    utf8_to_mutf8
)


cdef class StringEncoding:
    cpdef bytes encode(self, bytes data):
        return self.encode_cpp(data)

    cpdef bytes decode(self, bytes data):
        return self.decode_cpp(data)


cdef StringEncoding _mutf8_encoding = StringEncoding()
_mutf8_encoding.decode_cpp = mutf8_to_utf8
_mutf8_encoding.encode_cpp = utf8_to_mutf8
mutf8_encoding = _mutf8_encoding

cdef StringEncoding _utf8_encoding = StringEncoding()
_utf8_encoding.decode_cpp = utf8_to_utf8
_utf8_encoding.encode_cpp = utf8_to_utf8
utf8_encoding = _utf8_encoding

cdef StringEncoding _utf8_escape_encoding = StringEncoding()
_utf8_escape_encoding.decode_cpp = utf8_escape_to_utf8
_utf8_escape_encoding.encode_cpp = utf8_to_utf8_escape
utf8_escape_encoding = _utf8_escape_encoding
