from cpython.unicode cimport PyUnicode_DecodeUTF8, PyUnicode_DecodeCharmap
from cpython.bytes cimport PyBytes_FromStringAndSize, PyBytes_AsString
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy

from ._errors import NBTFormatError


CHAR_MAP = "".join(map(chr, range(256)))


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


cdef char *read_data(BufferContext buffer, size_t tag_size) except *:
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


cdef inline char read_byte(BufferContext buffer):
    return read_data(buffer, 1)[0]


cdef inline int read_int(BufferContext buffer, bint little_endian):
    cdef int*pointer = <int*> read_data(buffer, 4)
    cdef int value = pointer[0]
    to_little_endian(&value, 4, little_endian)
    return value


cdef inline str read_string(BufferContext buffer, bint little_endian):
    cdef unsigned short *pointer = <unsigned short *> read_data(buffer, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2, little_endian)
    b = read_data(buffer, length)
    try:
        return PyUnicode_DecodeUTF8(b, length, "strict")
    except:
        return PyUnicode_DecodeCharmap(b, length, CHAR_MAP, "strict")

cdef inline bytes read_bytes(BufferContext buffer, bint little_endian):
    cdef unsigned short *pointer = <unsigned short *> read_data(buffer, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2, little_endian)
    b = read_data(buffer, length)
    return PyBytes_FromStringAndSize(b, length)

cdef inline void cwrite(object obj, char*buf, size_t length):
    obj.write(buf[:length])

cdef inline void write_string(str s, object buffer, bint little_endian):
    cdef bytes b = s.encode("utf-8")
    write_bytes(b, buffer, little_endian)

cdef inline void write_bytes(bytes b, object buffer, bint little_endian):
    cdef char *c = b
    cdef short length = <short> len(b)
    write_short(length, buffer, little_endian)
    cwrite(buffer, c, length)

cdef inline void write_array(object value, object buffer, char size, bint little_endian):
    value = value.tobytes()
    cdef char*s = value
    cdef int length = <int> len(value) // size
    to_little_endian(&length, 4, little_endian)
    cwrite(buffer, <char*> &length, 4)
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
