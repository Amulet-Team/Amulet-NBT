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
    def __lshift__(self, other):
        raise NotImplementedError

    def __rlshift__(self, other):
        raise NotImplementedError

    def __ilshift__(self, other):
        raise NotImplementedError

    def __rshift__(self, other):
        raise NotImplementedError

    def __rrshift__(self, other):
        raise NotImplementedError

    def __irshift__(self, other):
        raise NotImplementedError

    def __and__(self, other):
        raise NotImplementedError

    def __rand__(self, other):
        raise NotImplementedError

    def __iand__(self, other):
        raise NotImplementedError

    def __xor__(self, other):
        raise NotImplementedError

    def __rxor__(self, other):
        raise NotImplementedError

    def __ixor__(self, other):
        raise NotImplementedError

    def __or__(self, other):
        raise NotImplementedError

    def __ror__(self, other):
        raise NotImplementedError

    def __ior__(self, other):
        raise NotImplementedError

    def __invert__(self):
        raise NotImplementedError


cdef class TAG_Byte(BaseIntTag):
    tag_id = ID_BYTE

    def __init__(self, value = 0):
        self.value_ = self._sanitise_value(int(value))

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

    def __lshift__(self, other):
        return self.value_ << other

    def __rlshift__(self, other):
        return other << self.value_

    def __ilshift__(self, other):
        return self.__class__(self << other)

    def __rshift__(self, other):
        return self.value_ >> other

    def __rrshift__(self, other):
        return other >> self.value_

    def __irshift__(self, other):
        return self.__class__(self >> other)

    def __and__(self, other):
        return self.value_ & other

    def __rand__(self, other):
        return other & self.value_

    def __iand__(self, other):
        return self.__class__(self & other)

    def __xor__(self, other):
        return self.value_ ^ other

    def __rxor__(self, other):
        return other ^ self.value_

    def __ixor__(self, other):
        return self.__class__(self ^ other)

    def __or__(self, other):
        return self.value_ | other

    def __ror__(self, other):
        return other | self.value_

    def __ior__(self, other):
        return self.__class__(self | other)

    def __invert__(self):
        return self.value_.__invert__()


    cdef char _sanitise_value(self, value):
        return (value & 0x7F) - (value & 0x80)

    cdef str _to_snbt(self):
        return f"{self.value_}b"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_byte(self.value_, buffer)

    @staticmethod
    cdef TAG_Byte read_payload(BufferContext buffer, bint little_endian):
        return TAG_Byte(read_byte(buffer))


cdef class TAG_Short(BaseIntTag):
    tag_id = ID_SHORT

    def __init__(self, value = 0):
        self.value_ = self._sanitise_value(int(value))

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

    def __lshift__(self, other):
        return self.value_ << other

    def __rlshift__(self, other):
        return other << self.value_

    def __ilshift__(self, other):
        return self.__class__(self << other)

    def __rshift__(self, other):
        return self.value_ >> other

    def __rrshift__(self, other):
        return other >> self.value_

    def __irshift__(self, other):
        return self.__class__(self >> other)

    def __and__(self, other):
        return self.value_ & other

    def __rand__(self, other):
        return other & self.value_

    def __iand__(self, other):
        return self.__class__(self & other)

    def __xor__(self, other):
        return self.value_ ^ other

    def __rxor__(self, other):
        return other ^ self.value_

    def __ixor__(self, other):
        return self.__class__(self ^ other)

    def __or__(self, other):
        return self.value_ | other

    def __ror__(self, other):
        return other | self.value_

    def __ior__(self, other):
        return self.__class__(self | other)

    def __invert__(self):
        return self.value_.__invert__()


    cdef short _sanitise_value(self, value):
        return (value & 0x7FFF) - (value & 0x8000)

    cdef str _to_snbt(self):
        return f"{self.value_}s"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
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

    def __init__(self, value = 0):
        self.value_ = self._sanitise_value(int(value))

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

    def __lshift__(self, other):
        return self.value_ << other

    def __rlshift__(self, other):
        return other << self.value_

    def __ilshift__(self, other):
        return self.__class__(self << other)

    def __rshift__(self, other):
        return self.value_ >> other

    def __rrshift__(self, other):
        return other >> self.value_

    def __irshift__(self, other):
        return self.__class__(self >> other)

    def __and__(self, other):
        return self.value_ & other

    def __rand__(self, other):
        return other & self.value_

    def __iand__(self, other):
        return self.__class__(self & other)

    def __xor__(self, other):
        return self.value_ ^ other

    def __rxor__(self, other):
        return other ^ self.value_

    def __ixor__(self, other):
        return self.__class__(self ^ other)

    def __or__(self, other):
        return self.value_ | other

    def __ror__(self, other):
        return other | self.value_

    def __ior__(self, other):
        return self.__class__(self | other)

    def __invert__(self):
        return self.value_.__invert__()


    cdef int _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF) - (value & 0x8000_0000)

    cdef str _to_snbt(self):
        return f"{self.value_}"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
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

    def __init__(self, value = 0):
        self.value_ = self._sanitise_value(int(value))

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

    def __lshift__(self, other):
        return self.value_ << other

    def __rlshift__(self, other):
        return other << self.value_

    def __ilshift__(self, other):
        return self.__class__(self << other)

    def __rshift__(self, other):
        return self.value_ >> other

    def __rrshift__(self, other):
        return other >> self.value_

    def __irshift__(self, other):
        return self.__class__(self >> other)

    def __and__(self, other):
        return self.value_ & other

    def __rand__(self, other):
        return other & self.value_

    def __iand__(self, other):
        return self.__class__(self & other)

    def __xor__(self, other):
        return self.value_ ^ other

    def __rxor__(self, other):
        return other ^ self.value_

    def __ixor__(self, other):
        return self.__class__(self ^ other)

    def __or__(self, other):
        return self.value_ | other

    def __ror__(self, other):
        return other | self.value_

    def __ior__(self, other):
        return self.__class__(self | other)

    def __invert__(self):
        return self.value_.__invert__()


    cdef long long _sanitise_value(self, value):
        return (value & 0x7FFF_FFFF_FFFF_FFFF) - (value & 0x8000_0000_0000_0000)

    cdef str _to_snbt(self):
        return f"{self.value_}L"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_long(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_Long read_payload(BufferContext buffer, bint little_endian):
        cdef long long *pointer = <long long *> read_data(buffer, 8)
        cdef TAG_Long tag = TAG_Long.__new__(TAG_Long)
        tag.value_ = pointer[0]
        to_little_endian(&tag.value_, 8, little_endian)
        return tag
