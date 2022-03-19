from typing import Union, Iterable, SupportsBytes, List
from io import BytesIO
from copy import deepcopy
from math import floor, ceil
import sys

from ._numeric cimport BaseNumericTag
from ._const cimport ID_BYTE, ID_SHORT, ID_INT, ID_LONG
from ._util cimport (
    write_byte,
    write_short,
    write_int,
    write_long,
    BufferContext,
    read_data,
    to_little_endian,
    read_byte,
    read_string,
)
{{py:from template import include}}


cdef class BaseIntTag(BaseNumericTag):
    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> BaseIntTag:
        raise NotImplementedError

    def __and__(BaseIntTag self, other):
        raise NotImplementedError

    def __rand__(BaseIntTag self, other):
        raise NotImplementedError

    def __iand__(BaseIntTag self, other):
        raise NotImplementedError

    def __xor__(BaseIntTag self, other):
        raise NotImplementedError

    def __rxor__(BaseIntTag self, other):
        raise NotImplementedError

    def __ixor__(BaseIntTag self, other):
        raise NotImplementedError

    def __or__(BaseIntTag self, other):
        raise NotImplementedError

    def __ror__(BaseIntTag self, other):
        raise NotImplementedError

    def __ior__(BaseIntTag self, other):
        raise NotImplementedError

    def __lshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rlshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __ilshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rrshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __irshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __invert__(BaseIntTag self):
        raise NotImplementedError

    def __index__(self) -> int:
        raise NotImplementedError


cdef inline void _read_byte_tag_payload(ByteTag tag, BufferContext buffer, bint little_endian):
    tag.value_ = read_byte(buffer)


cdef class ByteTag(BaseIntTag):
    """
    A class that behaves like an int but is stored in 1 byte.
    Can Store numbers between -(2^7) and (2^7 - 1)
    """
    tag_id = ID_BYTE

    def __init__(ByteTag self, value = 0):
        self.value_ = self._sanitise_value(int(value))

{{include("BaseIntTag.pyx.in", cls_name="ByteTag")}}

    cdef char _sanitise_value(ByteTag self, value):
        return (value & 0x7F) - (value & 0x80)

    cdef str _to_snbt(ByteTag self):
        return f"{self.value_}b"

    cdef void write_payload(ByteTag self, object buffer: BytesIO, bint little_endian) except *:
        write_byte(self.value_, buffer)

    @staticmethod
    cdef ByteTag read_payload(BufferContext buffer, bint little_endian):
        cdef ByteTag tag = ByteTag.__new__(ByteTag)
        _read_byte_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_short_tag_payload(ShortTag tag, BufferContext buffer, bint little_endian):
    cdef short *pointer = <short*> read_data(buffer, 2)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 2, little_endian)


cdef class ShortTag(BaseIntTag):
    """
    A class that behaves like an int but is stored in 2 bytes.
    Can Store numbers between -(2^15) and (2^15 - 1)
    """
    tag_id = ID_SHORT

    def __init__(ShortTag self, value = 0):
        self.value_ = self._sanitise_value(int(value))

{{include("BaseIntTag.pyx.in", cls_name="ShortTag")}}

    cdef short _sanitise_value(ShortTag self, value):
        return (value & 0x7FFF) - (value & 0x8000)

    cdef str _to_snbt(ShortTag self):
        return f"{self.value_}s"

    cdef void write_payload(ShortTag self, object buffer: BytesIO, bint little_endian) except *:
        write_short(self.value_, buffer, little_endian)

    @staticmethod
    cdef ShortTag read_payload(BufferContext buffer, bint little_endian):
        cdef ShortTag tag = ShortTag.__new__(ShortTag)
        _read_short_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_int_tag_payload(IntTag tag, BufferContext buffer, bint little_endian):
    cdef int*pointer = <int*> read_data(buffer, 4)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 4, little_endian)


cdef class IntTag(BaseIntTag):
    """
    A class that behaves like an int but is stored in 4 bytes.
    Can Store numbers between -(2^31) and (2^31 - 1)
    """
    tag_id = ID_INT

    def __init__(IntTag self, value = 0):
        self.value_ = self._sanitise_value(int(value))

{{include("BaseIntTag.pyx.in", cls_name="IntTag")}}

    cdef int _sanitise_value(IntTag self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

    cdef str _to_snbt(IntTag self):
        return f"{self.value_}"

    cdef void write_payload(IntTag self, object buffer: BytesIO, bint little_endian) except *:
        write_int(self.value_, buffer, little_endian)

    @staticmethod
    cdef IntTag read_payload(BufferContext buffer, bint little_endian):
        cdef IntTag tag = IntTag.__new__(IntTag)
        _read_int_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_long_tag_payload(LongTag tag, BufferContext buffer, bint little_endian):
    cdef long long *pointer = <long long *> read_data(buffer, 8)
    tag.value_ = pointer[0]
    to_little_endian(&tag.value_, 8, little_endian)


cdef class LongTag(BaseIntTag):
    """
    A class that behaves like an int but is stored in 8 bytes.
    Can Store numbers between -(2^63) and (2^63 - 1)
    """
    tag_id = ID_LONG

    def __init__(LongTag self, value = 0):
        self.value_ = self._sanitise_value(int(value))

{{include("BaseIntTag.pyx.in", cls_name="LongTag")}}

    cdef long long _sanitise_value(LongTag self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

    cdef str _to_snbt(LongTag self):
        return f"{self.value_}L"

    cdef void write_payload(LongTag self, object buffer: BytesIO, bint little_endian) except *:
        write_long(self.value_, buffer, little_endian)

    @staticmethod
    cdef LongTag read_payload(BufferContext buffer, bint little_endian):
        cdef LongTag tag = LongTag.__new__(LongTag)
        _read_long_tag_payload(tag, buffer, little_endian)
        return tag
