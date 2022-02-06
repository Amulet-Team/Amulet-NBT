from typing import List
from io import BytesIO
from copy import deepcopy
from math import floor, ceil

from .numeric cimport BaseNumericTag
from .const cimport ID_FLOAT, ID_DOUBLE
from .util cimport write_float, write_double, BufferContext, read_data, to_little_endian


cdef class BaseFloatTag(BaseNumericTag):
    pass


cdef class FloatTag(BaseFloatTag):
    """A class that behaves like a float but is stored as a single precision float."""
    tag_id = ID_FLOAT

    def __init__(FloatTag self, value = 0):
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
    
    def __str__(FloatTag self):
        return str(self.value_)

    def __dir__(FloatTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(FloatTag self, other):
        return self.value_ == other

    def __ge__(FloatTag self, other):
        return self.value_ >= other

    def __gt__(FloatTag self, other):
        return self.value_ > other

    def __le__(FloatTag self, other):
        return self.value_ <= other

    def __lt__(FloatTag self, other):
        return self.value_ < other

    def __reduce__(FloatTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(FloatTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(FloatTag self):
        return self.__class__(self.value_)

    def __hash__(FloatTag self):
        return hash((self.tag_id, self.value_))

    @property
    def value(FloatTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(FloatTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(FloatTag self, other):
        return self.value_ + other

    def __radd__(FloatTag self, other):
        return other + self.value_

    def __iadd__(FloatTag self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(FloatTag self, other):
        return self.value_ - other

    def __rsub__(FloatTag self, other):
        return other - self.value_

    def __isub__(FloatTag self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(FloatTag self, other):
        return self.value_ * other

    def __rmul__(FloatTag self, other):
        return other * self.value_

    def __imul__(FloatTag self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(FloatTag self, other):
        return self.value_ / other

    def __rtruediv__(FloatTag self, other):
        return other / self.value_

    def __itruediv__(FloatTag self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(FloatTag self, other):
        return self.value_ // other

    def __rfloordiv__(FloatTag self, other):
        return other // self.value_

    def __ifloordiv__(FloatTag self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(FloatTag self, other):
        return self.value_ % other

    def __rmod__(FloatTag self, other):
        return other % self.value_

    def __imod__(FloatTag self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(FloatTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(FloatTag self, other):
        return divmod(other, self.value_)

    def __pow__(FloatTag self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(FloatTag self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(FloatTag self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(FloatTag self):
        return self.value_.__neg__()

    def __pos__(FloatTag self):
        return self.value_.__pos__()

    def __abs__(FloatTag self):
        return self.value_.__abs__()

    def __int__(FloatTag self):
        return self.value_.__int__()

    def __float__(FloatTag self):
        return self.value_.__float__()

    def __round__(FloatTag self, n=None):
        return round(self.value_, n)

    def __trunc__(FloatTag self):
        return self.value_.__trunc__()

    def __floor__(FloatTag self):
        return floor(self.value_)

    def __ceil__(FloatTag self):
        return ceil(self.value_)

    def __bool__(FloatTag self):
        return self.value_.__bool__()

    cdef str _to_snbt(FloatTag self):
        return f"{self.value_}f"

    cdef void write_payload(FloatTag self, object buffer: BytesIO, bint little_endian) except *:
        write_float(self.value_, buffer, little_endian)

    @staticmethod
    cdef FloatTag read_payload(BufferContext buffer, bint little_endian):
        cdef float*pointer = <float*> read_data(buffer, 4)
        cdef FloatTag tag = FloatTag.__new__(FloatTag)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 4, little_endian)
        return tag


cdef class DoubleTag(BaseFloatTag):
    """A class that behaves like a float but is stored as a double precision float."""
    tag_id = ID_DOUBLE

    def __init__(DoubleTag self, value = 0):
        self.value_ = float(value)

    def __str__(DoubleTag self):
        return str(self.value_)

    def __dir__(DoubleTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(DoubleTag self, other):
        return self.value_ == other

    def __ge__(DoubleTag self, other):
        return self.value_ >= other

    def __gt__(DoubleTag self, other):
        return self.value_ > other

    def __le__(DoubleTag self, other):
        return self.value_ <= other

    def __lt__(DoubleTag self, other):
        return self.value_ < other

    def __reduce__(DoubleTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(DoubleTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(DoubleTag self):
        return self.__class__(self.value_)

    def __hash__(DoubleTag self):
        return hash((self.tag_id, self.value_))

    @property
    def value(DoubleTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(DoubleTag self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(DoubleTag self, other):
        return self.value_ + other

    def __radd__(DoubleTag self, other):
        return other + self.value_

    def __iadd__(DoubleTag self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(DoubleTag self, other):
        return self.value_ - other

    def __rsub__(DoubleTag self, other):
        return other - self.value_

    def __isub__(DoubleTag self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(DoubleTag self, other):
        return self.value_ * other

    def __rmul__(DoubleTag self, other):
        return other * self.value_

    def __imul__(DoubleTag self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(DoubleTag self, other):
        return self.value_ / other

    def __rtruediv__(DoubleTag self, other):
        return other / self.value_

    def __itruediv__(DoubleTag self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(DoubleTag self, other):
        return self.value_ // other

    def __rfloordiv__(DoubleTag self, other):
        return other // self.value_

    def __ifloordiv__(DoubleTag self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(DoubleTag self, other):
        return self.value_ % other

    def __rmod__(DoubleTag self, other):
        return other % self.value_

    def __imod__(DoubleTag self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(DoubleTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(DoubleTag self, other):
        return divmod(other, self.value_)

    def __pow__(DoubleTag self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(DoubleTag self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(DoubleTag self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(DoubleTag self):
        return self.value_.__neg__()

    def __pos__(DoubleTag self):
        return self.value_.__pos__()

    def __abs__(DoubleTag self):
        return self.value_.__abs__()

    def __int__(DoubleTag self):
        return self.value_.__int__()

    def __float__(DoubleTag self):
        return self.value_.__float__()

    def __round__(DoubleTag self, n=None):
        return round(self.value_, n)

    def __trunc__(DoubleTag self):
        return self.value_.__trunc__()

    def __floor__(DoubleTag self):
        return floor(self.value_)

    def __ceil__(DoubleTag self):
        return ceil(self.value_)

    def __bool__(DoubleTag self):
        return self.value_.__bool__()

    cdef str _to_snbt(DoubleTag self):
        return f"{self.value_}d"

    cdef void write_payload(DoubleTag self, object buffer: BytesIO, bint little_endian) except *:
        write_double(self.value_, buffer, little_endian)

    @staticmethod
    cdef DoubleTag read_payload(BufferContext buffer, bint little_endian):
        cdef double *pointer = <double *> read_data(buffer, 8)
        cdef DoubleTag tag = DoubleTag.__new__(DoubleTag)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag


cdef class NamedFloatTag(FloatTag):
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
        if isinstance(other, FloatTag) and super().__eq__(other):
            if isinstance(other, NamedFloatTag):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return NamedFloatTag(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return NamedFloatTag(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return NamedFloatTag, (self.value, self.name)


cdef class NamedDoubleTag(DoubleTag):
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
        if isinstance(other, DoubleTag) and super().__eq__(other):
            if isinstance(other, NamedDoubleTag):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return NamedDoubleTag(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return NamedDoubleTag(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return NamedDoubleTag, (self.value, self.name)
