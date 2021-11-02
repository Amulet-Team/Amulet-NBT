from io import BytesIO
from copy import copy, deepcopy

from .value cimport BaseImmutableTag
from .const cimport ID_STRING
from .util cimport write_string, BufferContext, read_string


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class TAG_String(BaseImmutableTag):
    tag_id = ID_STRING

    def __init__(self, value = ""):
        self.value_ = str(value)

    def __getattr__(self, item):
        if item == "value_":
            raise Exception
        return getattr(self.value_, item)

    def __str__(self):
        return str(self.value_)

    def __dir__(self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(self, other):
        return self.value_ == other

    def __ge__(self, other):
        return self.value_ >= other

    def __gt__(self, other):
        return self.value_ > other

    def __le__(self, other):
        return self.value_ <= other

    def __lt__(self, other):
        return self.value_ < other

    def __reduce__(self):
        return self.__class__, (self.value_,)

    def __deepcopy__(self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(self):
        return self.__class__(self.value_)

    # https://github.com/cython/cython/issues/3709
    def __eq__(self, other):
        return self.value_ == other

    def __hash__(self):
        return hash((self.tag_id, self.value_))

    @property
    def value(self):
        return self.value_


    def __len__(TAG_String self) -> int:
        return len(self.value_)

    def __repr__(TAG_String self):
        return f"{self.__class__.__name__}(\"{self.value_}\")"

    cdef str _to_snbt(TAG_String self):
        return f"\"{escape(self.value_)}\""

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_string(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_String read_payload(BufferContext buffer, bint little_endian):
        cdef TAG_String tag = TAG_String.__new__(TAG_String)
        tag.value_ = read_string(buffer, little_endian)
        return tag

    def __getitem__(TAG_String self, item):
        return self.value_.__getitem__(item)

    def __add__(TAG_String self, other):
        from cython cimport typeof
        print(self, typeof(self), type(self), other, typeof(other), type(other))
        return self.value_ + other

    def __radd__(TAG_String self, other):
        return other + self.value_

    def __iadd__(TAG_String self, other):
        self.__class__(self + other)

    def __mul__(TAG_String self, other):
        return self.value_ * other

    def __rmul__(TAG_String self, other):
        return other * self.value_

    def __imul__(TAG_String self, other):
        self.__class__(self * other)
