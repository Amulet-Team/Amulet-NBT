from typing import Iterator
from io import BytesIO
from copy import deepcopy

from ._value cimport AbstractBaseImmutableTag
from ._const cimport ID_STRING
from ._util cimport write_bytes, read_bytes, BufferContext
{{py:from template import include}}


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class StringTag(AbstractBaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(StringTag self, value = ""):
        if isinstance(value, bytes):
            self.value_ = value
        elif isinstance(value, StringTag):
            self.value_ = value.py_bytes
        else:
            self.value_ = str(value).encode("utf-8")

{{include("AbstractBaseImmutableTag.pyx", cls_name="StringTag")}}


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
