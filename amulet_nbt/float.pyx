from io import BytesIO

from .numeric cimport BaseNumericTag
from .const cimport ID_FLOAT, ID_DOUBLE
from .util cimport write_float, write_double, BufferContext


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class TAG_Float(BaseFloatTag):
    tag_id = ID_FLOAT

    def __init__(self, value = 0):
        self.value = float(value)

    cdef str _to_snbt(self):
        return f"{self.value:.20f}".rstrip('0') + "f"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_float(self.value, buffer, little_endian)

    @staticmethod
    cdef TAG_Float read_payload(BufferContext buffer, bint little_endian):
        raise NotImplementedError


cdef class TAG_Double(BaseFloatTag):
    tag_id = ID_DOUBLE

    def __init__(self, value = 0):
        self.value = float(value)

    cdef str _to_snbt(self):
        return f"{self.value:.20f}".rstrip('0') + "d"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value, buffer, little_endian)

    @staticmethod
    cdef TAG_Double read_payload(BufferContext buffer, bint little_endian):
        raise NotImplementedError
