from io import BytesIO

from .numeric cimport BaseNumericTag
from .const cimport ID_FLOAT, ID_DOUBLE
from .util cimport write_float, write_double, BufferContext, read_data, to_little_endian


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class TAG_Float(BaseFloatTag):
    tag_id = ID_FLOAT

    def __init__(self, value = 0):
        self.value_ = float(value)

    cdef str _to_snbt(self):
        return f"{self.value_}f"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_float(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Float read_payload(BufferContext buffer, bint little_endian):
        cdef float*pointer = <float*> read_data(buffer, 4)
        cdef TAG_Float tag = TAG_Float.__new__(TAG_Float)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 4, little_endian)
        return tag


cdef class TAG_Double(BaseFloatTag):
    tag_id = ID_DOUBLE

    def __init__(self, value = 0):
        self.value_ = float(value)

    cdef str _to_snbt(self):
        return f"{self.value_}d"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Double read_payload(BufferContext buffer, bint little_endian):
        cdef double *pointer = <double *> read_data(buffer, 8)
        cdef TAG_Double tag = TAG_Double.__new__(TAG_Double)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag
