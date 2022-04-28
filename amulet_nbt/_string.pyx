from typing import Iterator
from io import BytesIO
from copy import deepcopy

from ._value cimport BaseImmutableTag
from ._const cimport ID_STRING
from ._util cimport write_bytes, read_bytes, BufferContext


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class StringTag(BaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(StringTag self, value = ""):
        if isinstance(value, bytes):
            self.value_ = value
        elif isinstance(value, StringTag):
            self.value_ = value.py_bytes
        else:
            self.value_ = str(value).encode("utf-8")

    def __str__(StringTag self):
        return str(self.value_)

    def __eq__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(StringTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(StringTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(StringTag self):
        return self.__class__(self.value_)

    def __hash__(StringTag self):
        return hash((self.tag_id, self.value_))

    def __ge__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__(StringTag self, other):
        cdef StringTag other_
        if isinstance(other, StringTag):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented


    @property
    def py_str(StringTag self) -> str:
        """
        A python string representation of the class.
        The returned data is immutable so changes will not mirror the instance.

        :raises UnicodeDecodeError: if the byte string is not a valid utf-8 byte string.
        """
        return self.value_.decode("utf-8")

    @property
    def py_bytes(StringTag self) -> bytes:
        """
        A python bytes representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.value_

    @property
    def py_data(self):
        return self.py_bytes

    def __repr__(StringTag self):
        try:
            return f"{self.__class__.__name__}(\"{self.py_str}\")"
        except UnicodeDecodeError:
            return f"{self.__class__.__name__}(b\"{repr(self.value_)[2:-1]}\")"

    cdef str _to_snbt(StringTag self):
        try:
            return f"\"{escape(self.py_str)}\""
        except UnicodeDecodeError as e:
            raise UnicodeDecodeError(f"Cannot display TAG_String byte sequence in string format {repr(self.value_)}") from e

    cdef void write_payload(StringTag self, object buffer: BytesIO, bint little_endian) except *:
        write_bytes(self.value_, buffer, little_endian)

    @staticmethod
    cdef StringTag read_payload(BufferContext buffer, bint little_endian):
        cdef StringTag tag = StringTag.__new__(StringTag)
        tag.value_ = read_bytes(buffer, little_endian)
        return tag

    def __str__(StringTag self):
        return self.py_str
