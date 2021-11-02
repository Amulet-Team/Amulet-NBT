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

    def __init__(self, value = 0):
        self.value_ = float(value)

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

    def __repr__(self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(self, other):
        return self.value_ + other

    def __radd__(self, other):
        return other + self.value_

    def __iadd__(self, other):
        return self.__class__(self + other)

    def __sub__(self, other):
        return self.value_ - other

    def __rsub__(self, other):
        return other - self.value_

    def __isub__(self, other):
        return self.__class__(self - other)

    def __mul__(self, other):
        return self.value_ * other

    def __rmul__(self, other):
        return other * self.value_

    def __imul__(self, other):
        return self.__class__(self * other)

    def __truediv__(self, other):
        return self.value_ / other

    def __rtruediv__(self, other):
        return other / self.value_

    def __itruediv__(self, other):
        return self.__class__(self / other)

    def __floordiv__(self, other):
        return self.value_ // other

    def __rfloordiv__(self, other):
        return other // self.value_

    def __ifloordiv__(self, other):
        return self.__class__(self // other)

    def __mod__(self, other):
        return self.value_ % other

    def __rmod__(self, other):
        return other % self.value_

    def __imod__(self, other):
        return self.__class__(self % other)

    def __divmod__(self, other):
        return divmod(self.value_, other)

    def __rdivmod__(self, other):
        return divmod(other, self.value_)

    def __pow__(self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(self, other):
        return self.__class__(pow(self, other))

    def __neg__(self):
        return self.value_.__neg__()

    def __pos__(self):
        return self.value_.__pos__()

    def __abs__(self):
        return self.value_.__abs__()

    def __int__(self):
        return self.value_.__int__()

    def __float__(self):
        return self.value_.__float__()

    def __round__(self, n=None):
        return round(self.value_, n)

    def __trunc__(self):
        return self.value_.__trunc__()

    def __floor__(self):
        return floor(self.value_)

    def __ceil__(self):
        return ceil(self.value_)

    def __bool__(self):
        return self.value_.__bool__()


    cdef str _to_snbt(self):
        return f"{self.value_}f"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
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

    def __init__(self, value = 0):
        self.value_ = float(value)

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

    def __repr__(self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(self, other):
        return self.value_ + other

    def __radd__(self, other):
        return other + self.value_

    def __iadd__(self, other):
        return self.__class__(self + other)

    def __sub__(self, other):
        return self.value_ - other

    def __rsub__(self, other):
        return other - self.value_

    def __isub__(self, other):
        return self.__class__(self - other)

    def __mul__(self, other):
        return self.value_ * other

    def __rmul__(self, other):
        return other * self.value_

    def __imul__(self, other):
        return self.__class__(self * other)

    def __truediv__(self, other):
        return self.value_ / other

    def __rtruediv__(self, other):
        return other / self.value_

    def __itruediv__(self, other):
        return self.__class__(self / other)

    def __floordiv__(self, other):
        return self.value_ // other

    def __rfloordiv__(self, other):
        return other // self.value_

    def __ifloordiv__(self, other):
        return self.__class__(self // other)

    def __mod__(self, other):
        return self.value_ % other

    def __rmod__(self, other):
        return other % self.value_

    def __imod__(self, other):
        return self.__class__(self % other)

    def __divmod__(self, other):
        return divmod(self.value_, other)

    def __rdivmod__(self, other):
        return divmod(other, self.value_)

    def __pow__(self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(self, other):
        return self.__class__(pow(self, other))

    def __neg__(self):
        return self.value_.__neg__()

    def __pos__(self):
        return self.value_.__pos__()

    def __abs__(self):
        return self.value_.__abs__()

    def __int__(self):
        return self.value_.__int__()

    def __float__(self):
        return self.value_.__float__()

    def __round__(self, n=None):
        return round(self.value_, n)

    def __trunc__(self):
        return self.value_.__trunc__()

    def __floor__(self):
        return floor(self.value_)

    def __ceil__(self):
        return ceil(self.value_)

    def __bool__(self):
        return self.value_.__bool__()


    cdef str _to_snbt(self):
        return f"{self.value_}d"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Double read_payload(BufferContext buffer, bint little_endian):
        cdef double *pointer = <double *> read_data(buffer, 8)
        cdef TAG_Double tag = TAG_Double.__new__(TAG_Double)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag
