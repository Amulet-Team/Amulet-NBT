from typing import Iterator
from io import BytesIO
from copy import deepcopy

from ._value cimport BaseImmutableTag
from ._const cimport ID_STRING
from ._util cimport write_string, BufferContext, read_string


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')

cdef inline void _read_string_tag_payload(StringTag tag, BufferContext buffer, bint little_endian):
    tag.value_ = read_string(buffer, little_endian)


cdef class StringTag(BaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(StringTag self, value = ""):
        self.value_ = str(value)

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
        """
        return self.value_

    @property
    def py_data(self):
        return self.py_str

    def __len__(StringTag self) -> int:
        return len(self.value_)

    def __repr__(StringTag self):
        return f"{self.__class__.__name__}(\"{self.value_}\")"

    cdef str _to_snbt(StringTag self):
        return f"\"{escape(self.value_)}\""

    cdef void write_payload(StringTag self, object buffer: BytesIO, bint little_endian) except *:
        write_string(self.value_, buffer, little_endian)

    @staticmethod
    cdef StringTag read_payload(BufferContext buffer, bint little_endian):
        cdef StringTag tag = StringTag.__new__(StringTag)
        _read_string_tag_payload(tag, buffer, little_endian)
        return tag

    def __getitem__(StringTag self, item):
        return self.value_.__getitem__(item)

    def __contains__(StringTag self, str item) -> bool:
        return item in self.value_

    def __iter__(StringTag self) -> Iterator[str]:
        return self.value_.__iter__()
