from .value import BaseImmutableTag
from .const import ID_STRING
from .util import write_string


def escape(string: str):
    return string.replace('\\', '\\\\').replace('"', '\\"')


def unescape(string: str):
    return string.replace('\\"', '"').replace("\\\\", "\\")


cdef class TAG_String(BaseImmutableTag):
    tag_id = ID_STRING
    cdef readonly unicode value

    def __init__(self, value = ""):
        self.value = str(value)

    def __len__(self) -> int:
        return len(self.value)

    cdef str _to_snbt(self):
        return f"\"{escape(self.value)}\""

    cdef void write_payload(self, buffer, little_endian) except *:
        write_string(self.value, buffer, little_endian)

    def __getitem__(self, item):
        return self.value.__getitem__(item)

    def __add__(self, other):
        return self.value + other

    def __radd__(self, other):
        return other + self.value

    def __iadd__(self, other):
        self.__class__(self + other)

    def __mul__(self, other):
        return self.value * other

    def __rmul__(self, other):
        return other * self.value

    def __imul__(self, other):
        self.__class__(self * other)
