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

    def __str__(ByteTag self):
        return str(self.value_)

    def __eq__(ByteTag self, other):
        cdef ByteTag other_
        if isinstance(other, ByteTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(ByteTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(ByteTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(ByteTag self):
        return self.__class__(self.value_)

    @property
    def py_data(ByteTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(ByteTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(ByteTag self, other):
        cdef ByteTag other_
        if isinstance(other, ByteTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(ByteTag self, other):
        cdef ByteTag other_
        if isinstance(other, ByteTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(ByteTag self, other):
        cdef ByteTag other_
        if isinstance(other, ByteTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(ByteTag self, other):
        cdef ByteTag other_
        if isinstance(other, ByteTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(ByteTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(ByteTag self):
        return self.value_.__int__()

    def __float__(ByteTag self):
        return self.value_.__float__()

    def __bool__(ByteTag self):
        return self.value_.__bool__()

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

    def __str__(ShortTag self):
        return str(self.value_)

    def __eq__(ShortTag self, other):
        cdef ShortTag other_
        if isinstance(other, ShortTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(ShortTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(ShortTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(ShortTag self):
        return self.__class__(self.value_)

    @property
    def py_data(ShortTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(ShortTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(ShortTag self, other):
        cdef ShortTag other_
        if isinstance(other, ShortTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(ShortTag self, other):
        cdef ShortTag other_
        if isinstance(other, ShortTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(ShortTag self, other):
        cdef ShortTag other_
        if isinstance(other, ShortTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(ShortTag self, other):
        cdef ShortTag other_
        if isinstance(other, ShortTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(ShortTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(ShortTag self):
        return self.value_.__int__()

    def __float__(ShortTag self):
        return self.value_.__float__()

    def __bool__(ShortTag self):
        return self.value_.__bool__()

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

    def __str__(IntTag self):
        return str(self.value_)

    def __eq__(IntTag self, other):
        cdef IntTag other_
        if isinstance(other, IntTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(IntTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(IntTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(IntTag self):
        return self.__class__(self.value_)

    @property
    def py_data(IntTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(IntTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(IntTag self, other):
        cdef IntTag other_
        if isinstance(other, IntTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(IntTag self, other):
        cdef IntTag other_
        if isinstance(other, IntTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(IntTag self, other):
        cdef IntTag other_
        if isinstance(other, IntTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(IntTag self, other):
        cdef IntTag other_
        if isinstance(other, IntTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(IntTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(IntTag self):
        return self.value_.__int__()

    def __float__(IntTag self):
        return self.value_.__float__()

    def __bool__(IntTag self):
        return self.value_.__bool__()

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

    def __str__(LongTag self):
        return str(self.value_)

    def __eq__(LongTag self, other):
        cdef LongTag other_
        if isinstance(other, LongTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(LongTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(LongTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(LongTag self):
        return self.__class__(self.value_)

    @property
    def py_data(LongTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __hash__(LongTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(LongTag self, other):
        cdef LongTag other_
        if isinstance(other, LongTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(LongTag self, other):
        cdef LongTag other_
        if isinstance(other, LongTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(LongTag self, other):
        cdef LongTag other_
        if isinstance(other, LongTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(LongTag self, other):
        cdef LongTag other_
        if isinstance(other, LongTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented

    def __repr__(LongTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__(LongTag self):
        return self.value_.__int__()

    def __float__(LongTag self):
        return self.value_.__float__()

    def __bool__(LongTag self):
        return self.value_.__bool__()

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