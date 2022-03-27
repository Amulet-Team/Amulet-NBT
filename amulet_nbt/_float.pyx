from typing import List
from io import BytesIO
from copy import deepcopy
from math import floor, ceil

from ._numeric cimport BaseNumericTag
from ._const cimport ID_FLOAT, ID_DOUBLE
from ._util cimport write_float, write_double, BufferContext, read_data, to_little_endian, read_string


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef inline void _read_float_tag_payload(FloatTag tag, BufferContext buffer, bint little_endian):
    cdef float*pointer = <float*> read_data(buffer, 4)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 4, little_endian)


cdef class FloatTag(BaseFloatTag):
    """A class that behaves like a float but is stored as a single precision float."""
    tag_id = ID_FLOAT

    def __init__(FloatTag self, value = 0):
        self.value_ = float(value)

    def __str__(FloatTag self):
        return str(self.value_)

    def __eq__(FloatTag self, other):
        cdef FloatTag other_
        if isinstance(other, FloatTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(FloatTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(FloatTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(FloatTag self):
        return self.__class__(self.value_)

    @property
    def py_data(FloatTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(FloatTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(FloatTag self, other):
        cdef FloatTag other_
        if isinstance(other, FloatTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(FloatTag self, other):
        cdef FloatTag other_
        if isinstance(other, FloatTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(FloatTag self, other):
        cdef FloatTag other_
        if isinstance(other, FloatTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(FloatTag self, other):
        cdef FloatTag other_
        if isinstance(other, FloatTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(FloatTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(FloatTag self):
        return self.value_.__int__()

    def __float__(FloatTag self):
        return self.value_.__float__()

    def __bool__(FloatTag self):
        return self.value_.__bool__()

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


cdef class DoubleTag(BaseFloatTag):
    """A class that behaves like a float but is stored as a double precision float."""
    tag_id = ID_DOUBLE

    def __init__(DoubleTag self, value = 0):
        self.value_ = float(value)

    def __str__(DoubleTag self):
        return str(self.value_)

    def __eq__(DoubleTag self, other):
        cdef DoubleTag other_
        if isinstance(other, DoubleTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(DoubleTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(DoubleTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(DoubleTag self):
        return self.__class__(self.value_)

    @property
    def py_data(DoubleTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(DoubleTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(DoubleTag self, other):
        cdef DoubleTag other_
        if isinstance(other, DoubleTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(DoubleTag self, other):
        cdef DoubleTag other_
        if isinstance(other, DoubleTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(DoubleTag self, other):
        cdef DoubleTag other_
        if isinstance(other, DoubleTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(DoubleTag self, other):
        cdef DoubleTag other_
        if isinstance(other, DoubleTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(DoubleTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(DoubleTag self):
        return self.value_.__int__()

    def __float__(DoubleTag self):
        return self.value_.__float__()

    def __bool__(DoubleTag self):
        return self.value_.__bool__()

    cdef str _to_snbt(DoubleTag self):
        return f"{self.value_}d"

    cdef void write_payload(DoubleTag self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef DoubleTag read_payload(BufferContext buffer, bint little_endian):
        cdef DoubleTag tag = DoubleTag.__new__(DoubleTag)
        _read_double_tag_payload(tag, buffer, little_endian)
        return tag