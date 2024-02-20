from cpython.bytes cimport PyBytes_FromStringAndSize, PyBytes_AsString
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy
import codecs
import re

from . import __major__
from ._value cimport AbstractBaseTag
from ._errors import NBTFormatError
from ._dtype import DecoderType, EncoderType


cdef class BufferContext:
    def __cinit__(self):
        self.buffer = NULL
        self.size = 0
        self.offset = 0

    def __init__(
        self,
        bytes buffer = b"",
        size_t offset = 0
    ):
        self.size = len(buffer)
        self.buffer = <char*> malloc(self.size * sizeof(char))
        memcpy(self.buffer, PyBytes_AsString(buffer), self.size)
        if 0 <= offset <= self.size:
            self.offset = offset
        else:
            raise ValueError("offset must be between 0 and the length of the buffer.")

    cpdef bytes get_buffer(self):
        return PyBytes_FromStringAndSize(self.buffer, self.size)

    def __dealloc__(self):
        if self.buffer is not NULL:
            free(self.buffer)


cdef char *read_data(BufferContext buffer, size_t tag_size) except NULL:
    cdef char *value = buffer.buffer + buffer.offset
    buffer.offset += tag_size
    if buffer.offset > buffer.size:
        raise NBTFormatError(
            f"NBT Stream too short. Asked for {tag_size:d} bytes, {buffer.offset - buffer.size:d} more than the buffer."
        )
    return value

cdef void to_little_endian(void *data_buffer, int num_bytes, bint little_endian = False):
    if little_endian:
        return

    cdef unsigned char *buf = <unsigned char *> data_buffer
    cdef int i

    for i in range((num_bytes + 1) // 2):
        buf[i], buf[num_bytes - i - 1] = buf[num_bytes - i - 1], buf[i]


cdef inline char read_byte(BufferContext buffer) except? -1:
    return read_data(buffer, 1)[0]


cdef inline int read_int(BufferContext buffer, bint little_endian) except? -1:
    cdef int*pointer = <int*> read_data(buffer, 4)
    cdef int value = pointer[0]
    to_little_endian(&value, 4, little_endian)
    return value


cdef inline str read_string(BufferContext buffer, bint little_endian, string_decoder: DecoderType):
    return string_decoder(read_bytes(buffer, little_endian))

cdef inline bytes read_bytes(BufferContext buffer, bint little_endian):
    cdef unsigned short *pointer = <unsigned short *> read_data(buffer, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2, little_endian)
    cdef char *c = read_data(buffer, length)
    return PyBytes_FromStringAndSize(c, length)

cdef inline void cwrite(object obj, char*buf, size_t length):
    obj.write(buf[:length])

cdef inline void write_string(str s, object buffer, bint little_endian, string_encoder: EncoderType):
    cdef bytes b = string_encoder(s)
    write_bytes(b, buffer, little_endian)

cdef inline void write_bytes(bytes b, object buffer, bint little_endian):
    cdef char *c = b
    cdef size_t length = len(b)
    if length > 2**16-1:
        raise RuntimeError("String cannot be longer than 2**16 - 1")
    write_short(<short> length, buffer, little_endian)
    cwrite(buffer, c, length)

cdef inline void write_array(object value, object buffer, char size, bint little_endian):
    value = value.tobytes()
    cdef char*s = value
    cdef size_t length = len(value) // size
    if length > 2**31-1:
        raise RuntimeError("Array cannot be longer than 2**31 - 1")
    cdef int length_int = <int> length
    to_little_endian(&length_int, 4, little_endian)
    cwrite(buffer, <char*> &length_int, 4)
    cwrite(buffer, s, len(value))

cdef inline void write_byte(char value, object buffer):
    cwrite(buffer, &value, 1)

cdef inline void write_short(short value, object buffer, bint little_endian):
    to_little_endian(&value, 2, little_endian)
    cwrite(buffer, <char*> &value, 2)

cdef inline void write_int(int value, object buffer, bint little_endian):
    to_little_endian(&value, 4, little_endian)
    cwrite(buffer, <char*> &value, 4)

cdef inline void write_long(long long value, object buffer, bint little_endian):
    to_little_endian(&value, 8, little_endian)
    cwrite(buffer, <char*> &value, 8)

cdef inline void write_float(float value, object buffer, bint little_endian):
    to_little_endian(&value, 4, little_endian)
    cwrite(buffer, <char*> &value, 4)

cdef inline void write_double(double value, object buffer, bint little_endian):
    to_little_endian(&value, 8, little_endian)
    cwrite(buffer, <char*> &value, 8)


# Functions for string encoding

cpdef str utf8_decoder(bytes b):
    """Standard UTF-8 decoder"""
    return b.decode()


cpdef bytes utf8_encoder(str s):
    """Standard UTF-8 encoder"""
    return s.encode()


def _escape_replace(err):
    if isinstance(err, UnicodeDecodeError):
        return f"␛x{err.object[err.start]:02x}", err.start+1
    raise err


codecs.register_error("escapereplace", _escape_replace)


cpdef str utf8_escape_decoder(bytes b):
    """UTF-8 decoder that escapes error bytes to the form ␛xFF"""
    return b.decode(errors="escapereplace")

EscapePattern = re.compile(b"\xe2\x90\x9bx([0-9a-zA-Z]{2})")  # ␛xFF

cpdef bytes _utf8_unescape(object m):
    return bytes([int(m.groups()[0], 16)])

cpdef bytes utf8_escape_encoder(str s):
    """UTF-8 encoder that converts ␛x[0-9a-fA-F]{2} back to individual bytes"""
    return EscapePattern.sub(_utf8_unescape, s.encode())

if __major__ <= 2:
    def primitive_conversion(obj):
        return obj.py_data if isinstance(obj, AbstractBaseTag) else obj
