from io import BytesIO
from copy import deepcopy

from ._numeric cimport AbstractBaseNumericTag
from ._const cimport ID_FLOAT, ID_DOUBLE
from ._util cimport write_float, write_double, BufferContext, read_data, to_little_endian, read_string
{{py:from template import include}}


cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    @property
    def py_float(AbstractBaseNumericTag self) -> float:
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        raise NotImplementedError

    @property
    def py_data(self):
        return self.py_float



cdef inline void _read_float_tag_payload(FloatTag tag, BufferContext buffer, bint little_endian):
    cdef float*pointer = <float*> read_data(buffer, 4)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 4, little_endian)


cdef class FloatTag(AbstractBaseFloatTag):
    """A class that behaves like a float but is stored as a single precision float."""
    tag_id = ID_FLOAT

    def __init__(FloatTag self, value = 0):
        self.value_ = float(value)

{{include("AbstractBaseFloatTag.pyx", cls_name="FloatTag")}}

    cdef str _to_snbt(FloatTag self):
        return f"{self.value_}f"

    cdef void write_payload(FloatTag self, object buffer: BytesIO, bint little_endian) except *:
        write_float(self.value_, buffer, little_endian)

    @staticmethod
    cdef FloatTag read_payload(BufferContext buffer, bint little_endian):
        cdef FloatTag tag = FloatTag.__new__(FloatTag)
        _read_float_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_double_tag_payload(DoubleTag tag, BufferContext buffer, bint little_endian):
    cdef double *pointer = <double *> read_data(buffer, 8)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 8, little_endian)


cdef class DoubleTag(AbstractBaseFloatTag):
    """A class that behaves like a float but is stored as a double precision float."""
    tag_id = ID_DOUBLE

    def __init__(DoubleTag self, value = 0):
        self.value_ = float(value)

{{include("AbstractBaseFloatTag.pyx", cls_name="DoubleTag")}}

    cdef str _to_snbt(DoubleTag self):
        return f"{self.value_}d"

    cdef void write_payload(DoubleTag self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef DoubleTag read_payload(BufferContext buffer, bint little_endian):
        cdef DoubleTag tag = DoubleTag.__new__(DoubleTag)
        _read_double_tag_payload(tag, buffer, little_endian)
        return tag