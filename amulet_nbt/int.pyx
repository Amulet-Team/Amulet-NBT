from io import BytesIO

from .numeric cimport BaseNumericTag
from .const cimport ID_BYTE, ID_SHORT, ID_INT, ID_LONG
from .util cimport (
    write_byte,
    write_short,
    write_int,
    write_long,
    BufferContext,
    read_data,
    to_little_endian,
    read_byte,
)


cdef class BaseIntTag(BaseNumericTag):
    def __lshift__(self, other):
        return self.value << other

    def __rlshift__(self, other):
        return other << self.value

    def __ilshift__(self, other):
        return self.__class__(self << other)

    def __rshift__(self, other):
        return self.value >> other

    def __rrshift__(self, other):
        return other >> self.value

    def __irshift__(self, other):
        return self.__class__(self >> other)

    def __and__(self, other):
        return self.value & other

    def __rand__(self, other):
        return other & self.value

    def __iand__(self, other):
        return self.__class__(self & other)

    def __xor__(self, other):
        return self.value ^ other

    def __rxor__(self, other):
        return other ^ self.value

    def __ixor__(self, other):
        return self.__class__(self ^ other)

    def __or__(self, other):
        return self.value | other

    def __ror__(self, other):
        return other | self.value

    def __ior__(self, other):
        return self.__class__(self | other)

    def __invert__(self):
        return self.value.__invert__()


cdef class TAG_Byte(BaseIntTag):
    tag_id = ID_BYTE

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef char _sanitise_value(self, value):
        return (value & 0x7F) - (value & 0x80)

    cdef str _to_snbt(self):
        return f"{self.value}b"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_byte(self.value, buffer)

    @staticmethod
    cdef TAG_Byte read_payload(BufferContext buffer, bint little_endian):
        return TAG_Byte(read_byte(buffer))


cdef class TAG_Short(BaseIntTag):
    tag_id = ID_SHORT

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef short _sanitise_value(self, value):
        return (value & 0x7FFF) - (value & 0x8000)

    cdef str _to_snbt(self):
        return f"{self.value}s"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_short(self.value, buffer, little_endian)

    @staticmethod
    cdef TAG_Short read_payload(BufferContext buffer, bint little_endian):
        cdef short *pointer = <short*> read_data(buffer, 2)
        cdef TAG_Short tag = TAG_Short.__new__(TAG_Short)
        tag.value = pointer[0]
        to_little_endian(&tag.value, 2, little_endian)
        return tag


cdef class TAG_Int(BaseIntTag):
    tag_id = ID_INT

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef int _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

    cdef str _to_snbt(self):
        return f"{self.value}"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_int(self.value, buffer, little_endian)

    @staticmethod
    cdef TAG_Int read_payload(BufferContext buffer, bint little_endian):
        cdef int*pointer = <int*> read_data(buffer, 4)
        cdef TAG_Int tag = TAG_Int.__new__(TAG_Int)
        tag.value = pointer[0]
        to_little_endian(&tag.value, 4, little_endian)
        return tag


cdef class TAG_Long(BaseIntTag):
    tag_id = ID_LONG

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef long long _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

    cdef str _to_snbt(self):
        return f"{self.value}L"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_long(self.value, buffer, little_endian)

    @staticmethod
    cdef TAG_Long read_payload(BufferContext buffer, bint little_endian):
        cdef long long *pointer = <long long *> read_data(buffer, 8)
        cdef TAG_Long tag = TAG_Long.__new__(TAG_Long)
        tag.value = pointer[0]
        to_little_endian(&tag.value, 8, little_endian)
        return tag
