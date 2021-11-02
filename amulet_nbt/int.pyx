from io import BytesIO
from copy import copy, deepcopy
from math import floor, ceil

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

    def __invert__(BaseIntTag self):
        raise NotImplementedError


cdef class TAG_Byte(BaseIntTag):
    tag_id = ID_BYTE

    def __init__(TAG_Byte self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def __getattr__(TAG_Byte self, item):
        return getattr(self.value_, item)

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

    # https://github.com/cython/cython/issues/3709
    def __eq__(TAG_Byte self, other):
        return self.value_ == other

    def __hash__(TAG_Byte self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Byte self):
        return self.value_
    def __repr__(TAG_Byte self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Byte self, other):
        return self.value_ + other

    def __radd__(TAG_Byte self, other):
        return other + self.value_

    def __iadd__(TAG_Byte self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Byte self, other):
        return self.value_ - other

    def __rsub__(TAG_Byte self, other):
        return other - self.value_

    def __isub__(TAG_Byte self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Byte self, other):
        return self.value_ * other

    def __rmul__(TAG_Byte self, other):
        return other * self.value_

    def __imul__(TAG_Byte self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Byte self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Byte self, other):
        return other / self.value_

    def __itruediv__(TAG_Byte self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Byte self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Byte self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Byte self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Byte self, other):
        return self.value_ % other

    def __rmod__(TAG_Byte self, other):
        return other % self.value_

    def __imod__(TAG_Byte self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Byte self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Byte self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Byte self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Byte self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Byte self, other):
        return self.__class__(pow(self, other))

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
    def __lshift__(TAG_Byte self, other):
        return self.value_ << other

    def __rlshift__(TAG_Byte self, other):
        return other << self.value_

    def __ilshift__(TAG_Byte self, other):
        return self.__class__(self << other)

    def __rshift__(TAG_Byte self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Byte self, other):
        return other >> self.value_

    def __irshift__(TAG_Byte self, other):
        return self.__class__(self >> other)

    def __and__(TAG_Byte self, other):
        return self.value_ & other

    def __rand__(TAG_Byte self, other):
        return other & self.value_

    def __iand__(TAG_Byte self, other):
        return self.__class__(self & other)

    def __xor__(TAG_Byte self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Byte self, other):
        return other ^ self.value_

    def __ixor__(TAG_Byte self, other):
        return self.__class__(self ^ other)

    def __or__(TAG_Byte self, other):
        return self.value_ | other

    def __ror__(TAG_Byte self, other):
        return other | self.value_

    def __ior__(TAG_Byte self, other):
        return self.__class__(self | other)

    def __invert__(TAG_Byte self):
        return self.value_.__invert__()

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
    tag_id = ID_SHORT

    def __init__(TAG_Short self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def __getattr__(TAG_Short self, item):
        return getattr(self.value_, item)

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

    # https://github.com/cython/cython/issues/3709
    def __eq__(TAG_Short self, other):
        return self.value_ == other

    def __hash__(TAG_Short self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Short self):
        return self.value_
    def __repr__(TAG_Short self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Short self, other):
        return self.value_ + other

    def __radd__(TAG_Short self, other):
        return other + self.value_

    def __iadd__(TAG_Short self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Short self, other):
        return self.value_ - other

    def __rsub__(TAG_Short self, other):
        return other - self.value_

    def __isub__(TAG_Short self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Short self, other):
        return self.value_ * other

    def __rmul__(TAG_Short self, other):
        return other * self.value_

    def __imul__(TAG_Short self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Short self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Short self, other):
        return other / self.value_

    def __itruediv__(TAG_Short self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Short self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Short self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Short self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Short self, other):
        return self.value_ % other

    def __rmod__(TAG_Short self, other):
        return other % self.value_

    def __imod__(TAG_Short self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Short self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Short self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Short self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Short self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Short self, other):
        return self.__class__(pow(self, other))

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
    def __lshift__(TAG_Short self, other):
        return self.value_ << other

    def __rlshift__(TAG_Short self, other):
        return other << self.value_

    def __ilshift__(TAG_Short self, other):
        return self.__class__(self << other)

    def __rshift__(TAG_Short self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Short self, other):
        return other >> self.value_

    def __irshift__(TAG_Short self, other):
        return self.__class__(self >> other)

    def __and__(TAG_Short self, other):
        return self.value_ & other

    def __rand__(TAG_Short self, other):
        return other & self.value_

    def __iand__(TAG_Short self, other):
        return self.__class__(self & other)

    def __xor__(TAG_Short self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Short self, other):
        return other ^ self.value_

    def __ixor__(TAG_Short self, other):
        return self.__class__(self ^ other)

    def __or__(TAG_Short self, other):
        return self.value_ | other

    def __ror__(TAG_Short self, other):
        return other | self.value_

    def __ior__(TAG_Short self, other):
        return self.__class__(self | other)

    def __invert__(TAG_Short self):
        return self.value_.__invert__()

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
    tag_id = ID_INT

    def __init__(TAG_Int self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def __getattr__(TAG_Int self, item):
        return getattr(self.value_, item)

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

    # https://github.com/cython/cython/issues/3709
    def __eq__(TAG_Int self, other):
        return self.value_ == other

    def __hash__(TAG_Int self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Int self):
        return self.value_
    def __repr__(TAG_Int self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Int self, other):
        return self.value_ + other

    def __radd__(TAG_Int self, other):
        return other + self.value_

    def __iadd__(TAG_Int self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Int self, other):
        return self.value_ - other

    def __rsub__(TAG_Int self, other):
        return other - self.value_

    def __isub__(TAG_Int self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Int self, other):
        return self.value_ * other

    def __rmul__(TAG_Int self, other):
        return other * self.value_

    def __imul__(TAG_Int self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Int self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Int self, other):
        return other / self.value_

    def __itruediv__(TAG_Int self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Int self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Int self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Int self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Int self, other):
        return self.value_ % other

    def __rmod__(TAG_Int self, other):
        return other % self.value_

    def __imod__(TAG_Int self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Int self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Int self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Int self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Int self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Int self, other):
        return self.__class__(pow(self, other))

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
    def __lshift__(TAG_Int self, other):
        return self.value_ << other

    def __rlshift__(TAG_Int self, other):
        return other << self.value_

    def __ilshift__(TAG_Int self, other):
        return self.__class__(self << other)

    def __rshift__(TAG_Int self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Int self, other):
        return other >> self.value_

    def __irshift__(TAG_Int self, other):
        return self.__class__(self >> other)

    def __and__(TAG_Int self, other):
        return self.value_ & other

    def __rand__(TAG_Int self, other):
        return other & self.value_

    def __iand__(TAG_Int self, other):
        return self.__class__(self & other)

    def __xor__(TAG_Int self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Int self, other):
        return other ^ self.value_

    def __ixor__(TAG_Int self, other):
        return self.__class__(self ^ other)

    def __or__(TAG_Int self, other):
        return self.value_ | other

    def __ror__(TAG_Int self, other):
        return other | self.value_

    def __ior__(TAG_Int self, other):
        return self.__class__(self | other)

    def __invert__(TAG_Int self):
        return self.value_.__invert__()

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
    tag_id = ID_LONG

    def __init__(TAG_Long self, value = 0):
        self.value_ = self._sanitise_value(int(value))

    def __getattr__(TAG_Long self, item):
        return getattr(self.value_, item)

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

    # https://github.com/cython/cython/issues/3709
    def __eq__(TAG_Long self, other):
        return self.value_ == other

    def __hash__(TAG_Long self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_Long self):
        return self.value_
    def __repr__(TAG_Long self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__(TAG_Long self, other):
        return self.value_ + other

    def __radd__(TAG_Long self, other):
        return other + self.value_

    def __iadd__(TAG_Long self, other):
        return self.__class__(self + other)

    def __sub__(TAG_Long self, other):
        return self.value_ - other

    def __rsub__(TAG_Long self, other):
        return other - self.value_

    def __isub__(TAG_Long self, other):
        return self.__class__(self - other)

    def __mul__(TAG_Long self, other):
        return self.value_ * other

    def __rmul__(TAG_Long self, other):
        return other * self.value_

    def __imul__(TAG_Long self, other):
        return self.__class__(self * other)

    def __truediv__(TAG_Long self, other):
        return self.value_ / other

    def __rtruediv__(TAG_Long self, other):
        return other / self.value_

    def __itruediv__(TAG_Long self, other):
        return self.__class__(self / other)

    def __floordiv__(TAG_Long self, other):
        return self.value_ // other

    def __rfloordiv__(TAG_Long self, other):
        return other // self.value_

    def __ifloordiv__(TAG_Long self, other):
        return self.__class__(self // other)

    def __mod__(TAG_Long self, other):
        return self.value_ % other

    def __rmod__(TAG_Long self, other):
        return other % self.value_

    def __imod__(TAG_Long self, other):
        return self.__class__(self % other)

    def __divmod__(TAG_Long self, other):
        return divmod(self.value_, other)

    def __rdivmod__(TAG_Long self, other):
        return divmod(other, self.value_)

    def __pow__(TAG_Long self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__(TAG_Long self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__(TAG_Long self, other):
        return self.__class__(pow(self, other))

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
    def __lshift__(TAG_Long self, other):
        return self.value_ << other

    def __rlshift__(TAG_Long self, other):
        return other << self.value_

    def __ilshift__(TAG_Long self, other):
        return self.__class__(self << other)

    def __rshift__(TAG_Long self, other):
        return self.value_ >> other

    def __rrshift__(TAG_Long self, other):
        return other >> self.value_

    def __irshift__(TAG_Long self, other):
        return self.__class__(self >> other)

    def __and__(TAG_Long self, other):
        return self.value_ & other

    def __rand__(TAG_Long self, other):
        return other & self.value_

    def __iand__(TAG_Long self, other):
        return self.__class__(self & other)

    def __xor__(TAG_Long self, other):
        return self.value_ ^ other

    def __rxor__(TAG_Long self, other):
        return other ^ self.value_

    def __ixor__(TAG_Long self, other):
        return self.__class__(self ^ other)

    def __or__(TAG_Long self, other):
        return self.value_ | other

    def __ror__(TAG_Long self, other):
        return other | self.value_

    def __ior__(TAG_Long self, other):
        return self.__class__(self | other)

    def __invert__(TAG_Long self):
        return self.value_.__invert__()

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
