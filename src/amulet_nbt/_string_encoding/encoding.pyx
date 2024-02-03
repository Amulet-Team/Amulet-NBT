# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20

from ._cpp.utf8 cimport utf8_to_utf8 as c_utf8_to_utf8
from ._cpp.mutf8 cimport (
    mutf8_to_utf8 as c_mutf8_to_utf8,
    utf8_to_mutf8 as c_utf8_to_mutf8
)


cdef class StringEncoding:
    cpdef bytes encode(self, bytes data):
        return self.encode_cpp(data)

    cpdef bytes decode(self, bytes data):
        return self.decode_cpp(data)


cdef StringEncoding mutf8_encoding = StringEncoding()
mutf8_encoding.decode_cpp = c_mutf8_to_utf8
mutf8_encoding.encode_cpp = c_utf8_to_mutf8

cdef StringEncoding utf8_encoding = StringEncoding()
utf8_encoding.decode_cpp = c_utf8_to_utf8
utf8_encoding.encode_cpp = c_utf8_to_utf8

# TODO: implement this
cdef StringEncoding utf8_escape_encoding = StringEncoding()
utf8_escape_encoding.decode_cpp = c_utf8_to_utf8
utf8_escape_encoding.encode_cpp = c_utf8_to_utf8
