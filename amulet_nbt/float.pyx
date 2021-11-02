from io import BytesIO
from copy import copy, deepcopy
from math import floor, ceil

from .numeric cimport BaseNumericTag
from .const cimport ID_FLOAT, ID_DOUBLE
from .util cimport write_float, write_double, BufferContext, read_data, to_little_endian


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class TAG_Float(BaseFloatTag):
    tag_id = ID_FLOAT

    def __init__(TAG_Float self, value = 0):
        self.value_ = float(value)

    def __getattr__(TAG_Float self, item):
        return getattr(self.value_, item)

    def __str__(TAG_Float self):
        return str(self.value_)

    def __dir__(TAG_Float self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Float self, other):
        return self.value_ == other

    def __ge__(TAG_Float self, other):
        return self.value_ >= other

    def __gt__(TAG_Float self, other):
        return self.value_ > other

    def __le__(TAG_Float self, other):
        return self.value_ <= other

    def __lt__(TAG_Float self, other):
        return self.value_ < other

    def __reduce__(TAG_Float self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Float self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Float self):
        return self.__class__(self.value_)

    def __hash__(TAG_Float self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Float self):
        return self.value_
    def __repr__(TAG_Float self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Float self, other):
        return self.value_ + other

    def __radd__(TAG_Float self, other):
        return other + self.value_

    def __iadd__(TAG_Float self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Float self, other):
        return self.value_ - other

    def __rsub__(TAG_Float self, other):
        return other - self.value_

    def __isub__(TAG_Float self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Float self, other):
        return self.value_ * other

    def __rmul__(TAG_Float self, other):
        return other * self.value_

    def __imul__(TAG_Float self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Float self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Float self, other):
        return other / self.value_

    def __itruediv__(TAG_Float self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Float self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Float self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Float self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Float self, other):
        return self.value_ % other

    def __rmod__(TAG_Float self, other):
        return other % self.value_

    def __imod__(TAG_Float self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Float self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Float self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Float self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Float self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Float self, other):
        return self.__class__(pow(self, other))

    def __neg__(TAG_Float self):
        return self.value_.__neg__()

    def __pos__(TAG_Float self):
        return self.value_.__pos__()

    def __abs__(TAG_Float self):
        return self.value_.__abs__()

    def __int__(TAG_Float self):
        return self.value_.__int__()

    def __float__(TAG_Float self):
        return self.value_.__float__()

    def __round__(TAG_Float self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Float self):
        return self.value_.__trunc__()

    def __floor__(TAG_Float self):
        return floor(self.value_)

    def __ceil__(TAG_Float self):
        return ceil(self.value_)

    def __bool__(TAG_Float self):
        return self.value_.__bool__()

    cdef str _to_snbt(TAG_Float self):
        return f"{self.value_}f"

    cdef void write_payload(TAG_Float self, object buffer: BytesIO, bint little_endian) except *:
        write_float(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Float read_payload(BufferContext buffer, bint little_endian):
        cdef float*pointer = <float*> read_data(buffer, 4)
        cdef TAG_Float tag = TAG_Float.__new__(TAG_Float)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 4, little_endian)
        return tag


cdef class TAG_Double(BaseFloatTag):
    tag_id = ID_DOUBLE

    def __init__(TAG_Double self, value = 0):
        self.value_ = float(value)

    def __getattr__(TAG_Double self, item):
        return getattr(self.value_, item)

    def __str__(TAG_Double self):
        return str(self.value_)

    def __dir__(TAG_Double self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Double self, other):
        return self.value_ == other

    def __ge__(TAG_Double self, other):
        return self.value_ >= other

    def __gt__(TAG_Double self, other):
        return self.value_ > other

    def __le__(TAG_Double self, other):
        return self.value_ <= other

    def __lt__(TAG_Double self, other):
        return self.value_ < other

    def __reduce__(TAG_Double self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Double self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Double self):
        return self.__class__(self.value_)

    def __hash__(TAG_Double self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Double self):
        return self.value_
    def __repr__(TAG_Double self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Double self, other):
        return self.value_ + other

    def __radd__(TAG_Double self, other):
        return other + self.value_

    def __iadd__(TAG_Double self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Double self, other):
        return self.value_ - other

    def __rsub__(TAG_Double self, other):
        return other - self.value_

    def __isub__(TAG_Double self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Double self, other):
        return self.value_ * other

    def __rmul__(TAG_Double self, other):
        return other * self.value_

    def __imul__(TAG_Double self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Double self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Double self, other):
        return other / self.value_

    def __itruediv__(TAG_Double self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Double self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Double self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Double self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Double self, other):
        return self.value_ % other

    def __rmod__(TAG_Double self, other):
        return other % self.value_

    def __imod__(TAG_Double self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Double self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Double self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Double self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Double self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Double self, other):
        return self.__class__(pow(self, other))

    def __neg__(TAG_Double self):
        return self.value_.__neg__()

    def __pos__(TAG_Double self):
        return self.value_.__pos__()

    def __abs__(TAG_Double self):
        return self.value_.__abs__()

    def __int__(TAG_Double self):
        return self.value_.__int__()

    def __float__(TAG_Double self):
        return self.value_.__float__()

    def __round__(TAG_Double self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Double self):
        return self.value_.__trunc__()

    def __floor__(TAG_Double self):
        return floor(self.value_)

    def __ceil__(TAG_Double self):
        return ceil(self.value_)

    def __bool__(TAG_Double self):
        return self.value_.__bool__()

    cdef str _to_snbt(TAG_Double self):
        return f"{self.value_}d"

    cdef void write_payload(TAG_Double self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Double read_payload(BufferContext buffer, bint little_endian):
        cdef double *pointer = <double *> read_data(buffer, 8)
        cdef TAG_Double tag = TAG_Double.__new__(TAG_Double)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag
