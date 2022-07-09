from ._dtype import DecoderType, EncoderType

cdef class BufferContext:
    cdef char *buffer
    cdef readonly size_t size
    cdef readonly size_t offset

    cpdef bytes get_buffer(self)

cdef char *read_data(BufferContext buffer, size_t tag_size) except NULL
cdef void to_little_endian(void *data_buffer, int num_bytes, bint little_endian=*)

cdef char read_byte(BufferContext buffer) except? -1
cdef int read_int(BufferContext buffer, bint little_endian) except? -1
cdef str read_string(BufferContext buffer, bint little_endian, string_decoder: DecoderType)
cdef bytes read_bytes(BufferContext buffer, bint little_endian)

cdef void cwrite(object obj, char*buf, size_t length)
cdef void write_string(str s, object buffer, bint little_endian, string_encoder: EncoderType)
cdef void write_bytes(bytes b, object buffer, bint little_endian)
cdef void write_array(object value, object buffer, char size, bint little_endian)
cdef void write_byte(char value, object buffer)
cdef void write_short(short value, object buffer, bint little_endian)
cdef void write_int(int value, object buffer, bint little_endian)
cdef void write_long(long long value, object buffer, bint little_endian)
cdef void write_float(float value, object buffer, bint little_endian)
cdef void write_double(double value, object buffer, bint little_endian)

cpdef str utf8_decoder(bytes b)
cpdef bytes utf8_encoder(str s)
cpdef str utf8_escape_decoder(bytes b)
cpdef bytes utf8_escape_encoder(str s)
