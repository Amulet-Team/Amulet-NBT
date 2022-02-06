import warnings
from typing import Iterable
from copy import deepcopy

from .value cimport BaseTag
from .compound cimport TAG_Compound


cdef class NBTFile:
    def __init__(self, BaseTag value=None, str name=""):
        if value is None:
            value = TAG_Compound()
        self.value = value
        self.name = name

    def to_nbt(self, *, bint compressed=True, bint little_endian=False):
        return self.value.to_nbt(compressed=compressed, little_endian=little_endian, name=self.name)

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False
    ):
        return self.value.save_to(filepath_or_buffer, compressed=compressed, little_endian=little_endian, name=self.name)

    def __eq__(self, other):
        if isinstance(other, NBTFile):
            return self.name == other.name and self.value == other.value
        else:
            return self.value == other

    def __repr__(self):
        return f'{self.__class__.__name__}({repr(self.value)}, "{self.name}")'

    def __dir__(self) -> Iterable[str]:
        return list(set(list(super().__dir__()) + dir(self.value)))

    def __copy__(self):
        return NBTFile(self.value, self.name)

    def __deepcopy__(self, memodict=None):
        return NBTFile(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return NBTFile, (self.value, self.name)

    # All of the methods below are depreciated. You should use the .value attribute to get the object.
    def __getattr__(self, item):
        warnings.warn("__getattr__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        return getattr(self.value, item)

    def __getitem__(self, item):
        warnings.warn("__getitem__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        return self.value[item]

    def __setitem__(self, key, value):
        warnings.warn("__setitem__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        self.value[key] = value

    def __len__(self) -> int:
        warnings.warn("__len__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        return self.value.__len__()

    def __delitem__(self, key: str):
        warnings.warn("__delitem__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        del self.value[key]

    def __contains__(self, key: str) -> bool:
        warnings.warn("__contains__ is deprecated. Use .value to get the object instead.", DeprecationWarning)
        return key in self.value
