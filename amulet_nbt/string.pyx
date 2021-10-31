from io import BytesIO

from .value cimport BaseImmutableTag
from .const cimport ID_STRING
from .util cimport write_string, BufferContext, read_string


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class TAG_String(BaseImmutableTag):
    tag_id = ID_STRING

    def __init__(self, value = ""):
        self.value_ = str(value)

    def __len__(self) -> int:
        return len(self.value_)

    def __repr__(self):
        return f"{self.__class__.__name__}(\"{self.value_}\")"

    cdef str _to_snbt(self):
        return f"\"{escape(self.value_)}\""

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_string(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_String read_payload(BufferContext buffer, bint little_endian):
        cdef TAG_String tag = TAG_String.__new__(TAG_String)
        tag.value_ = read_string(buffer, little_endian)
        return tag

    def __getitem__(self, item):
        return self.value_.__getitem__(item)

    def __add__(self, other):
        return self.value_ + other

    def __radd__(self, other):
        return other + self.value_

    def __iadd__(self, other):
        self.__class__(self + other)

    def __mul__(self, other):
        return self.value_ * other

    def __rmul__(self, other):
        return other * self.value_

    def __imul__(self, other):
        self.__class__(self * other)
