from typing import Union, Iterable, SupportsBytes, List
from io import BytesIO
from copy import deepcopy
from math import floor, ceil
import sys

from .numeric cimport BaseNumericTag
from .const cimport ID_BYTE, ID_SHORT, ID_INT, ID_LONG
from .util cimport (
    write_byte,
    write_short,
    write_int,
    write_long,
    BufferContext,
    read_data,
    to_little_endian,
    read_byte,
)


cdef class BaseIntTag(BaseNumericTag):
    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> BaseIntTag:
        raise NotImplementedError

    def __and__(BaseIntTag self, other):
        raise NotImplementedError

    def __rand__(BaseIntTag self, other):
        raise NotImplementedError

    def __iand__(BaseIntTag self, other):
        raise NotImplementedError

    def __xor__(BaseIntTag self, other):
        raise NotImplementedError

    def __rxor__(BaseIntTag self, other):
        raise NotImplementedError

    def __ixor__(BaseIntTag self, other):
        raise NotImplementedError

    def __or__(BaseIntTag self, other):
        raise NotImplementedError

    def __ror__(BaseIntTag self, other):
        raise NotImplementedError

    def __ior__(BaseIntTag self, other):
        raise NotImplementedError

    def __lshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rlshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __ilshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __rrshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __irshift__(BaseIntTag self, other):
        raise NotImplementedError

    def __invert__(BaseIntTag self):
        raise NotImplementedError

    def __index__(self) -> int:
        raise NotImplementedError


cdef class TAG_Byte(BaseIntTag):
    """
    A class that behaves like an int but is stored in 1 byte.
    Can Store numbers between -(2^7) and (2^7 - 1)
    """
    tag_id = ID_BYTE

    def __init__(TAG_Byte self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def bit_length(self):
        return self.value_.bit_length()
    bit_length.__doc__ = int.bit_length.__doc__
    
    @property
    def denominator(self):
        """the denominator of a rational number in lowest terms"""
        return self.value_.denominator
    
    @property
    def imag(self):
        """the imaginary part of a complex number"""
        return self.value_.imag
    
    @property
    def numerator(self):
        """the numerator of a rational number in lowest terms"""
        return self.value_.numerator
    
    @property
    def real(self):
        """the real part of a complex number"""
        return self.value_.real
    
    def to_bytes(self, length, byteorder, *, object signed=False):
        return self.value_.to_bytes(length, byteorder, signed=signed)
    to_bytes.__doc__ = int.to_bytes.__doc__
    
    if sys.version_info >= (3, 8):
        def as_integer_ratio(self):
            return self.value_.as_integer_ratio()
        as_integer_ratio.__doc__ = int.as_integer_ratio.__doc__

    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = int.conjugate.__doc__

    def __str__(TAG_Byte self):
        return str(self.value_)

    def __dir__(TAG_Byte self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Byte self, other):
        return self.value_ == other

    def __ge__(TAG_Byte self, other):
        return self.value_ >= other

    def __gt__(TAG_Byte self, other):
        return self.value_ > other

    def __le__(TAG_Byte self, other):
        return self.value_ <= other

    def __lt__(TAG_Byte self, other):
        return self.value_ < other

    def __reduce__(TAG_Byte self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Byte self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Byte self):
        return self.__class__(self.value_)

    def __hash__(TAG_Byte self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Byte self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Byte self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Byte self, other):
        return self.value_ + other

    def __radd__(TAG_Byte self, other):
        return other + self.value_

    def __iadd__(TAG_Byte self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Byte self, other):
        return self.value_ - other

    def __rsub__(TAG_Byte self, other):
        return other - self.value_

    def __isub__(TAG_Byte self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Byte self, other):
        return self.value_ * other

    def __rmul__(TAG_Byte self, other):
        return other * self.value_

    def __imul__(TAG_Byte self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Byte self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Byte self, other):
        return other / self.value_

    def __itruediv__(TAG_Byte self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Byte self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Byte self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Byte self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Byte self, other):
        return self.value_ % other

    def __rmod__(TAG_Byte self, other):
        return other % self.value_

    def __imod__(TAG_Byte self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Byte self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Byte self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Byte self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Byte self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Byte self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(TAG_Byte self):
        return self.value_.__neg__()

    def __pos__(TAG_Byte self):
        return self.value_.__pos__()

    def __abs__(TAG_Byte self):
        return self.value_.__abs__()

    def __int__(TAG_Byte self):
        return self.value_.__int__()

    def __float__(TAG_Byte self):
        return self.value_.__float__()

    def __round__(TAG_Byte self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Byte self):
        return self.value_.__trunc__()

    def __floor__(TAG_Byte self):
        return floor(self.value_)

    def __ceil__(TAG_Byte self):
        return ceil(self.value_)

    def __bool__(TAG_Byte self):
        return self.value_.__bool__()

    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> TAG_Byte:
        return TAG_Byte(int.from_bytes(bytes, byteorder, signed))

    def __and__(TAG_Byte self, other):
        return self.value_ & other

    def __rand__(TAG_Byte self, other):
        return other & self.value_

    def __iand__(TAG_Byte self, other):
        res = self & other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __xor__(TAG_Byte self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Byte self, other):
        return other ^ self.value_

    def __ixor__(TAG_Byte self, other):
        res = self ^ other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __or__(TAG_Byte self, other):
        return self.value_ | other

    def __ror__(TAG_Byte self, other):
        return other | self.value_

    def __ior__(TAG_Byte self, other):
        res = self | other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __lshift__(TAG_Byte self, other):
        return self.value_ << other

    def __rlshift__(TAG_Byte self, other):
        return other << self.value_

    def __ilshift__(TAG_Byte self, other):
        res = self << other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __rshift__(TAG_Byte self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Byte self, other):
        return other >> self.value_

    def __irshift__(TAG_Byte self, other):
        res = self >> other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __invert__(TAG_Byte self):
        return self.value_.__invert__()

    def __index__(TAG_Byte self) -> int:
        return self.value_.__index__()

    cdef char _sanitise_value(TAG_Byte self, value):
        return (value & 0x7F) - (value & 0x80)

    cdef str _to_snbt(TAG_Byte self):
        return f"{self.value_}b"

    cdef void write_payload(TAG_Byte self, object buffer: BytesIO, bint little_endian) except *:
        write_byte(self.value_, buffer)

    @staticmethod
    cdef TAG_Byte read_payload(BufferContext buffer, bint little_endian):
        return TAG_Byte(read_byte(buffer))


cdef class TAG_Short(BaseIntTag):
    """
    A class that behaves like an int but is stored in 2 bytes.
    Can Store numbers between -(2^15) and (2^15 - 1)
    """
    tag_id = ID_SHORT

    def __init__(TAG_Short self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def bit_length(self):
        return self.value_.bit_length()
    bit_length.__doc__ = int.bit_length.__doc__
    
    @property
    def denominator(self):
        """the denominator of a rational number in lowest terms"""
        return self.value_.denominator
    
    @property
    def imag(self):
        """the imaginary part of a complex number"""
        return self.value_.imag
    
    @property
    def numerator(self):
        """the numerator of a rational number in lowest terms"""
        return self.value_.numerator
    
    @property
    def real(self):
        """the real part of a complex number"""
        return self.value_.real
    
    def to_bytes(self, length, byteorder, *, object signed=False):
        return self.value_.to_bytes(length, byteorder, signed=signed)
    to_bytes.__doc__ = int.to_bytes.__doc__
    
    if sys.version_info >= (3, 8):
        def as_integer_ratio(self):
            return self.value_.as_integer_ratio()
        as_integer_ratio.__doc__ = int.as_integer_ratio.__doc__

    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = int.conjugate.__doc__

    def __str__(TAG_Short self):
        return str(self.value_)

    def __dir__(TAG_Short self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Short self, other):
        return self.value_ == other

    def __ge__(TAG_Short self, other):
        return self.value_ >= other

    def __gt__(TAG_Short self, other):
        return self.value_ > other

    def __le__(TAG_Short self, other):
        return self.value_ <= other

    def __lt__(TAG_Short self, other):
        return self.value_ < other

    def __reduce__(TAG_Short self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Short self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Short self):
        return self.__class__(self.value_)

    def __hash__(TAG_Short self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Short self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Short self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Short self, other):
        return self.value_ + other

    def __radd__(TAG_Short self, other):
        return other + self.value_

    def __iadd__(TAG_Short self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Short self, other):
        return self.value_ - other

    def __rsub__(TAG_Short self, other):
        return other - self.value_

    def __isub__(TAG_Short self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Short self, other):
        return self.value_ * other

    def __rmul__(TAG_Short self, other):
        return other * self.value_

    def __imul__(TAG_Short self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Short self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Short self, other):
        return other / self.value_

    def __itruediv__(TAG_Short self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Short self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Short self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Short self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Short self, other):
        return self.value_ % other

    def __rmod__(TAG_Short self, other):
        return other % self.value_

    def __imod__(TAG_Short self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Short self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Short self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Short self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Short self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Short self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(TAG_Short self):
        return self.value_.__neg__()

    def __pos__(TAG_Short self):
        return self.value_.__pos__()

    def __abs__(TAG_Short self):
        return self.value_.__abs__()

    def __int__(TAG_Short self):
        return self.value_.__int__()

    def __float__(TAG_Short self):
        return self.value_.__float__()

    def __round__(TAG_Short self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Short self):
        return self.value_.__trunc__()

    def __floor__(TAG_Short self):
        return floor(self.value_)

    def __ceil__(TAG_Short self):
        return ceil(self.value_)

    def __bool__(TAG_Short self):
        return self.value_.__bool__()

    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> TAG_Short:
        return TAG_Short(int.from_bytes(bytes, byteorder, signed))

    def __and__(TAG_Short self, other):
        return self.value_ & other

    def __rand__(TAG_Short self, other):
        return other & self.value_

    def __iand__(TAG_Short self, other):
        res = self & other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __xor__(TAG_Short self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Short self, other):
        return other ^ self.value_

    def __ixor__(TAG_Short self, other):
        res = self ^ other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __or__(TAG_Short self, other):
        return self.value_ | other

    def __ror__(TAG_Short self, other):
        return other | self.value_

    def __ior__(TAG_Short self, other):
        res = self | other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __lshift__(TAG_Short self, other):
        return self.value_ << other

    def __rlshift__(TAG_Short self, other):
        return other << self.value_

    def __ilshift__(TAG_Short self, other):
        res = self << other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __rshift__(TAG_Short self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Short self, other):
        return other >> self.value_

    def __irshift__(TAG_Short self, other):
        res = self >> other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __invert__(TAG_Short self):
        return self.value_.__invert__()

    def __index__(TAG_Short self) -> int:
        return self.value_.__index__()

    cdef short _sanitise_value(TAG_Short self, value):
        return (value & 0x7FFF) - (value & 0x8000)

    cdef str _to_snbt(TAG_Short self):
        return f"{self.value_}s"

    cdef void write_payload(TAG_Short self, object buffer: BytesIO, bint little_endian) except *:
        write_short(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Short read_payload(BufferContext buffer, bint little_endian):
        cdef short *pointer = <short*> read_data(buffer, 2)
        cdef TAG_Short tag = TAG_Short.__new__(TAG_Short)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 2, little_endian)
        return tag


cdef class TAG_Int(BaseIntTag):
    """
    A class that behaves like an int but is stored in 4 bytes.
    Can Store numbers between -(2^31) and (2^31 - 1)
    """
    tag_id = ID_INT

    def __init__(TAG_Int self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def bit_length(self):
        return self.value_.bit_length()
    bit_length.__doc__ = int.bit_length.__doc__
    
    @property
    def denominator(self):
        """the denominator of a rational number in lowest terms"""
        return self.value_.denominator
    
    @property
    def imag(self):
        """the imaginary part of a complex number"""
        return self.value_.imag
    
    @property
    def numerator(self):
        """the numerator of a rational number in lowest terms"""
        return self.value_.numerator
    
    @property
    def real(self):
        """the real part of a complex number"""
        return self.value_.real
    
    def to_bytes(self, length, byteorder, *, object signed=False):
        return self.value_.to_bytes(length, byteorder, signed=signed)
    to_bytes.__doc__ = int.to_bytes.__doc__
    
    if sys.version_info >= (3, 8):
        def as_integer_ratio(self):
            return self.value_.as_integer_ratio()
        as_integer_ratio.__doc__ = int.as_integer_ratio.__doc__

    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = int.conjugate.__doc__

    def __str__(TAG_Int self):
        return str(self.value_)

    def __dir__(TAG_Int self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Int self, other):
        return self.value_ == other

    def __ge__(TAG_Int self, other):
        return self.value_ >= other

    def __gt__(TAG_Int self, other):
        return self.value_ > other

    def __le__(TAG_Int self, other):
        return self.value_ <= other

    def __lt__(TAG_Int self, other):
        return self.value_ < other

    def __reduce__(TAG_Int self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Int self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Int self):
        return self.__class__(self.value_)

    def __hash__(TAG_Int self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Int self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Int self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Int self, other):
        return self.value_ + other

    def __radd__(TAG_Int self, other):
        return other + self.value_

    def __iadd__(TAG_Int self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Int self, other):
        return self.value_ - other

    def __rsub__(TAG_Int self, other):
        return other - self.value_

    def __isub__(TAG_Int self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Int self, other):
        return self.value_ * other

    def __rmul__(TAG_Int self, other):
        return other * self.value_

    def __imul__(TAG_Int self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Int self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Int self, other):
        return other / self.value_

    def __itruediv__(TAG_Int self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Int self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Int self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Int self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Int self, other):
        return self.value_ % other

    def __rmod__(TAG_Int self, other):
        return other % self.value_

    def __imod__(TAG_Int self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Int self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Int self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Int self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Int self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Int self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(TAG_Int self):
        return self.value_.__neg__()

    def __pos__(TAG_Int self):
        return self.value_.__pos__()

    def __abs__(TAG_Int self):
        return self.value_.__abs__()

    def __int__(TAG_Int self):
        return self.value_.__int__()

    def __float__(TAG_Int self):
        return self.value_.__float__()

    def __round__(TAG_Int self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Int self):
        return self.value_.__trunc__()

    def __floor__(TAG_Int self):
        return floor(self.value_)

    def __ceil__(TAG_Int self):
        return ceil(self.value_)

    def __bool__(TAG_Int self):
        return self.value_.__bool__()

    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> TAG_Int:
        return TAG_Int(int.from_bytes(bytes, byteorder, signed))

    def __and__(TAG_Int self, other):
        return self.value_ & other

    def __rand__(TAG_Int self, other):
        return other & self.value_

    def __iand__(TAG_Int self, other):
        res = self & other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __xor__(TAG_Int self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Int self, other):
        return other ^ self.value_

    def __ixor__(TAG_Int self, other):
        res = self ^ other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __or__(TAG_Int self, other):
        return self.value_ | other

    def __ror__(TAG_Int self, other):
        return other | self.value_

    def __ior__(TAG_Int self, other):
        res = self | other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __lshift__(TAG_Int self, other):
        return self.value_ << other

    def __rlshift__(TAG_Int self, other):
        return other << self.value_

    def __ilshift__(TAG_Int self, other):
        res = self << other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __rshift__(TAG_Int self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Int self, other):
        return other >> self.value_

    def __irshift__(TAG_Int self, other):
        res = self >> other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __invert__(TAG_Int self):
        return self.value_.__invert__()

    def __index__(TAG_Int self) -> int:
        return self.value_.__index__()

    cdef int _sanitise_value(TAG_Int self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

    cdef str _to_snbt(TAG_Int self):
        return f"{self.value_}"

    cdef void write_payload(TAG_Int self, object buffer: BytesIO, bint little_endian) except *:
        write_int(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Int read_payload(BufferContext buffer, bint little_endian):
        cdef int*pointer = <int*> read_data(buffer, 4)
        cdef TAG_Int tag = TAG_Int.__new__(TAG_Int)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 4, little_endian)
        return tag


cdef class TAG_Long(BaseIntTag):
    """
    A class that behaves like an int but is stored in 8 bytes.
    Can Store numbers between -(2^63) and (2^63 - 1)
    """
    tag_id = ID_LONG

    def __init__(TAG_Long self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def bit_length(self):
        return self.value_.bit_length()
    bit_length.__doc__ = int.bit_length.__doc__
    
    @property
    def denominator(self):
        """the denominator of a rational number in lowest terms"""
        return self.value_.denominator
    
    @property
    def imag(self):
        """the imaginary part of a complex number"""
        return self.value_.imag
    
    @property
    def numerator(self):
        """the numerator of a rational number in lowest terms"""
        return self.value_.numerator
    
    @property
    def real(self):
        """the real part of a complex number"""
        return self.value_.real
    
    def to_bytes(self, length, byteorder, *, object signed=False):
        return self.value_.to_bytes(length, byteorder, signed=signed)
    to_bytes.__doc__ = int.to_bytes.__doc__
    
    if sys.version_info >= (3, 8):
        def as_integer_ratio(self):
            return self.value_.as_integer_ratio()
        as_integer_ratio.__doc__ = int.as_integer_ratio.__doc__

    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = int.conjugate.__doc__

    def __str__(TAG_Long self):
        return str(self.value_)

    def __dir__(TAG_Long self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_Long self, other):
        return self.value_ == other

    def __ge__(TAG_Long self, other):
        return self.value_ >= other

    def __gt__(TAG_Long self, other):
        return self.value_ > other

    def __le__(TAG_Long self, other):
        return self.value_ <= other

    def __lt__(TAG_Long self, other):
        return self.value_ < other

    def __reduce__(TAG_Long self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_Long self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_Long self):
        return self.__class__(self.value_)

    def __hash__(TAG_Long self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Long self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __repr__(TAG_Long self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Long self, other):
        return self.value_ + other

    def __radd__(TAG_Long self, other):
        return other + self.value_

    def __iadd__(TAG_Long self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__(TAG_Long self, other):
        return self.value_ - other

    def __rsub__(TAG_Long self, other):
        return other - self.value_

    def __isub__(TAG_Long self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__(TAG_Long self, other):
        return self.value_ * other

    def __rmul__(TAG_Long self, other):
        return other * self.value_

    def __imul__(TAG_Long self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__(TAG_Long self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Long self, other):
        return other / self.value_

    def __itruediv__(TAG_Long self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__(TAG_Long self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Long self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Long self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__(TAG_Long self, other):
        return self.value_ % other

    def __rmod__(TAG_Long self, other):
        return other % self.value_

    def __imod__(TAG_Long self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__(TAG_Long self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Long self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Long self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Long self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Long self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__(TAG_Long self):
        return self.value_.__neg__()

    def __pos__(TAG_Long self):
        return self.value_.__pos__()

    def __abs__(TAG_Long self):
        return self.value_.__abs__()

    def __int__(TAG_Long self):
        return self.value_.__int__()

    def __float__(TAG_Long self):
        return self.value_.__float__()

    def __round__(TAG_Long self, n=None):
        return round(self.value_, n)

    def __trunc__(TAG_Long self):
        return self.value_.__trunc__()

    def __floor__(TAG_Long self):
        return floor(self.value_)

    def __ceil__(TAG_Long self):
        return ceil(self.value_)

    def __bool__(TAG_Long self):
        return self.value_.__bool__()

    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> TAG_Long:
        return TAG_Long(int.from_bytes(bytes, byteorder, signed))

    def __and__(TAG_Long self, other):
        return self.value_ & other

    def __rand__(TAG_Long self, other):
        return other & self.value_

    def __iand__(TAG_Long self, other):
        res = self & other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __xor__(TAG_Long self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Long self, other):
        return other ^ self.value_

    def __ixor__(TAG_Long self, other):
        res = self ^ other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __or__(TAG_Long self, other):
        return self.value_ | other

    def __ror__(TAG_Long self, other):
        return other | self.value_

    def __ior__(TAG_Long self, other):
        res = self | other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __lshift__(TAG_Long self, other):
        return self.value_ << other

    def __rlshift__(TAG_Long self, other):
        return other << self.value_

    def __ilshift__(TAG_Long self, other):
        res = self << other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __rshift__(TAG_Long self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Long self, other):
        return other >> self.value_

    def __irshift__(TAG_Long self, other):
        res = self >> other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __invert__(TAG_Long self):
        return self.value_.__invert__()

    def __index__(TAG_Long self) -> int:
        return self.value_.__index__()

    cdef long long _sanitise_value(TAG_Long self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

    cdef str _to_snbt(TAG_Long self):
        return f"{self.value_}L"

    cdef void write_payload(TAG_Long self, object buffer: BytesIO, bint little_endian) except *:
        write_long(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Long read_payload(BufferContext buffer, bint little_endian):
        cdef long long *pointer = <long long *> read_data(buffer, 8)
        cdef TAG_Long tag = TAG_Long.__new__(TAG_Long)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag


cdef class Named_TAG_Byte(TAG_Byte):
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
        if isinstance(other, TAG_Byte) and super().__eq__(other):
            if isinstance(other, Named_TAG_Byte):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Byte(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Byte(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Byte, (self.value, self.name)


cdef class Named_TAG_Short(TAG_Short):
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
        if isinstance(other, TAG_Short) and super().__eq__(other):
            if isinstance(other, Named_TAG_Short):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Short(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Short(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Short, (self.value, self.name)


cdef class Named_TAG_Int(TAG_Int):
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
        if isinstance(other, TAG_Int) and super().__eq__(other):
            if isinstance(other, Named_TAG_Int):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Int(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Int(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Int, (self.value, self.name)


cdef class Named_TAG_Long(TAG_Long):
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
        if isinstance(other, TAG_Long) and super().__eq__(other):
            if isinstance(other, Named_TAG_Long):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return Named_TAG_Long(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return Named_TAG_Long(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return Named_TAG_Long, (self.value, self.name)
