from typing import List
from io import BytesIO
from copy import deepcopy
from math import floor, ceil

from .numeric cimport BaseNumericTag
from .const cimport ID_FLOAT, ID_DOUBLE
from .util cimport write_float, write_double, BufferContext, read_data, to_little_endian


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class TAG_Float(BaseFloatTag):
    """A class that behaves like a float but is stored as a single precision float."""
    tag_id = ID_FLOAT

    def __init__(TAG_Float self, value = 0):
        self.value_ = float(value)

    def as_integer_ratio(self):
        return self.value_.as_integer_ratio()
    as_integer_ratio.__doc__ = float.as_integer_ratio.__doc__
    
    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = float.conjugate.__doc__
    
    def hex(self):
        return self.value_.hex()
    hex.__doc__ = float.hex.__doc__
    
    @property
    def imag(self):
        """the imaginary part of a complex number"""
        return self.value_.imag
    
    def is_integer(self):
        return self.value_.is_integer()
    is_integer.__doc__ = float.is_integer.__doc__
    
    @property
    def real(self):
        """the real part of a complex number"""
        return self.value_.real
    
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
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Float self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Float self, other):
        return self.value_ + other

    def __radd__(TAG_Float self, other):
        return other + self.value_

    def __iadd__(TAG_Float self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Float self, other):
        return self.value_ - other

    def __rsub__(TAG_Float self, other):
        return other - self.value_

    def __isub__(TAG_Float self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Float self, other):
        return self.value_ * other

    def __rmul__(TAG_Float self, other):
        return other * self.value_

    def __imul__(TAG_Float self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Float self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Float self, other):
        return other / self.value_

    def __itruediv__(TAG_Float self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Float self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Float self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Float self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Float self, other):
        return self.value_ % other

    def __rmod__(TAG_Float self, other):
        return other % self.value_

    def __imod__(TAG_Float self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Float self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Float self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Float self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Float self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Float self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

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
    """A class that behaves like a float but is stored as a double precision float."""
    tag_id = ID_DOUBLE

    def __init__(TAG_Double self, value = 0):
        self.value_ = float(value)

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
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Double self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Double self, other):
        return self.value_ + other

    def __radd__(TAG_Double self, other):
        return other + self.value_

    def __iadd__(TAG_Double self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Double self, other):
        return self.value_ - other

    def __rsub__(TAG_Double self, other):
        return other - self.value_

    def __isub__(TAG_Double self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Double self, other):
        return self.value_ * other

    def __rmul__(TAG_Double self, other):
        return other * self.value_

    def __imul__(TAG_Double self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Double self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Double self, other):
        return other / self.value_

    def __itruediv__(TAG_Double self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Double self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Double self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Double self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Double self, other):
        return self.value_ % other

    def __rmod__(TAG_Double self, other):
        return other % self.value_

    def __imod__(TAG_Double self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Double self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Double self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Double self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Double self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Double self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

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


cdef class Named_TAG_Float(TAG_Float):
    def __init__(self, object value=0, str name=""):
        super().__init__(value)
        self.name = name

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def __eq__(self, other):
        if isinstance(other, TAG_Float) and super().__eq__(other):
            if isinstance(other, Named_TAG_Float):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Float(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Float(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Float, (self.value, self.name)


cdef class Named_TAG_Double(TAG_Double):
    def __init__(self, object value=0, str name=""):
        super().__init__(value)
        self.name = name

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def __eq__(self, other):
        if isinstance(other, TAG_Double) and super().__eq__(other):
            if isinstance(other, Named_TAG_Double):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Double(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Double(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Double, (self.value, self.name)
