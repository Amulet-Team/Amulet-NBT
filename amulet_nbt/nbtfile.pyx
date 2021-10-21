from typing import Iterable
from .value cimport BaseTag
from .compound cimport TAG_Compound


cdef class NBTFile:
    def __init__(self, BaseTag value=None, str name=""):
        if value is None:
            value = TAG_Compound()
        self.value = value
        self.name = name

    cpdef bytes to_nbt(self, bint compressed=True, bint little_endian=False):
        return self.value.to_nbt(self.name, compressed, little_endian)

    cpdef bytes save_to(
        self,
        object filepath_or_buffer=None,
        bint compressed=True,
        bint little_endian=False
    ):
        return self.value.save_to(filepath_or_buffer, compressed, little_endian, self.name)

    def __eq__(self, other):
        if isinstance(other, NBTFile):
            return self.name == other.name and self.value == other.value
        else:
            return self.value == other

    def __repr__(self):
        return f'{self.__class__.__name__}({repr(self.value)}, "{self.name}")'

    def __getattr__(self, item):
        return getattr(self.value, item)

    def __dir__(self) -> Iterable[str]:
        return list(set(dir(self.__class__) + dir(self.value)))
