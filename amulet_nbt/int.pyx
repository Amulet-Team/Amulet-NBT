from .numeric import BaseNumericTag
from .const import ID_BYTE, ID_SHORT, ID_INT, ID_LONG
from .util import write_byte, write_short, write_int, write_long


cdef class BaseIntegerTag(BaseNumericTag):
    def __lshift__(self, other):
        return self.value << other

    def __rlshift__(self, other):
        return other << self.value

    def __ilshift__(self, other):
        self.__class__(self << other)

    def __rshift__(self, other):
        return self.value >> other

    def __rrshift__(self, other):
        return other >> self.value

    def __irshift__(self, other):
        self.__class__(self >> other)

    def __and__(self, other):
        return self.value & other

    def __rand__(self, other):
        return other & self.value

    def __iand__(self, other):
        self.__class__(self & other)

    def __xor__(self, other):
        return self.value ^ other

    def __rxor__(self, other):
        return other ^ self.value

    def __ixor__(self, other):
        self.__class__(self ^ other)

    def __or__(self, other):
        return self.value | other

    def __ror__(self, other):
        return other | self.value

    def __ior__(self, other):
        self.__class__(self | other)

    def __invert__(self):
        return self.value.__invert__()


cdef class TAG_Byte(BaseIntegerTag):
    tag_id = ID_BYTE
    cdef readonly char value

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef char _sanitise_value(self, value):
        return (value & 0x7F) - (value & 0x80)

    cdef str _to_snbt(self):
        return f"{self.value}b"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_byte(self.value, buffer)


cdef class TAG_Short(BaseIntegerTag):
    tag_id = ID_SHORT
    cdef readonly short value

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef short _sanitise_value(self, value):
        return (value & 0x7FFF) - (value & 0x8000)

    cdef str _to_snbt(self):
        return f"{self.value}s"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_short(self.value, buffer, little_endian)


cdef class TAG_Int(BaseIntegerTag):
    tag_id = ID_INT
    cdef readonly int value

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef int _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

    cdef str _to_snbt(self):
        return f"{self.value}"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_int(self.value, buffer, little_endian)


cdef class TAG_Long(BaseIntegerTag):
    tag_id = ID_LONG
    cdef readonly long long value

    def __init__(self, value = 0):
        self.value = self._sanitise_value(int(value))

    cdef long long _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

    cdef str _to_snbt(self):
        return f"{self.value}L"

    cdef void write_payload(self, buffer, little_endian) except *:
        write_long(self.value, buffer, little_endian)
