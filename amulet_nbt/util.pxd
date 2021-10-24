cdef class BufferContext:
    cdef char *buffer
    cdef readonly size_t size
    cdef readonly size_t offset

    cpdef bytes get_buffer(self)

cdef char *read_data(BufferContext buffer, size_t tag_size) except *
cdef void to_little_endian(void *data_buffer, int num_bytes, bint little_endian=*)

cdef char read_byte(BufferContext buffer)
cdef int read_short(BufferContext buffer, bint little_endian)
cdef int read_int(BufferContext buffer, bint little_endian)
cdef str read_string(BufferContext buffer, bint little_endian)

cdef void cwrite(object obj, char*buf, size_t length)
cdef void write_string(str s, object buffer, bint little_endian)
cdef void write_array(object value, object buffer, char size, bint little_endian)
cdef void write_byte(char value, object buffer)
cdef void write_short(short value, object buffer, bint little_endian)
cdef void write_int(int value, object buffer, bint little_endian)
cdef void write_long(long long value, object buffer, bint little_endian)
cdef void write_float(float value, object buffer, bint little_endian)
cdef void write_double(double value, object buffer, bint little_endian)
