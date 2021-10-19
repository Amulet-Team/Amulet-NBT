from .numeric import BaseNumericTag
from .const import ID_FLOAT, ID_DOUBLE
from .util import write_float, write_double


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class TAG_Float(BaseFloatTag):
    tag_id = ID_FLOAT
    cdef readonly float value

    def __init__(self, value = 0):
        self.value = float(value)

    cdef str _to_snbt(self):
        return f"{self.value:.20f}".rstrip('0') + "f"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_float(self.value, buffer, little_endian)


cdef class TAG_Double(BaseFloatTag):
    tag_id = ID_DOUBLE
    cdef readonly double value

    def __init__(self, value = 0):
        self.value = float(value)

    cdef str _to_snbt(self):
        return f"{self.value:.20f}".rstrip('0') + "d"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_double(self.value, buffer, little_endian)
