import numpy
cimport numpy
from io import BytesIO
from copy import copy, deepcopy

from .value cimport BaseMutableTag
from .const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from .util cimport write_array, BufferContext, read_int, read_data
from .list cimport TAG_List


cdef class BaseArrayTag(BaseMutableTag):
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    def __init__(BaseArrayTag self, object value = ()):
        self.value_ = numpy.array(value, self.big_endian_data_type).ravel()

    def __getattr__(BaseArrayTag self, item):
        if item == "value_":
            raise AttributeError("Python class does not have access to the underlying data.")
        return getattr(self.value_, item)

    def __str__(BaseArrayTag self):
        return str(self.value_)

    def __dir__(BaseArrayTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(BaseArrayTag self, other):
        return self.value_ == other

    def __ge__(BaseArrayTag self, other):
        return self.value_ >= other

    def __gt__(BaseArrayTag self, other):
        return self.value_ > other

    def __le__(BaseArrayTag self, other):
        return self.value_ <= other

    def __lt__(BaseArrayTag self, other):
        return self.value_ < other

    def __reduce__(BaseArrayTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(BaseArrayTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(BaseArrayTag self):
        return self.__class__(self.value_)

    @property
    def value(BaseArrayTag self):
        return copy(self.value_)

    __hash__ = None

    cdef void _fix_dtype(BaseArrayTag self):
        if self.value_.dtype != self.big_endian_data_type:
            print(f'[Warning] Mismatch array dtype. Expected: {self.big_endian_data_type}, got: {self.value_.dtype}')
            self.value_ = self.value_.astype(self.big_endian_data_type)

    cdef numpy.ndarray _as_endianness(BaseArrayTag self, bint little_endian = False):
        self._fix_dtype()
        if little_endian:
            return self.value_.astype(self.little_endian_data_type)
        else:
            return self.value_

    @property
    def dtype(BaseArrayTag self):
        return self.value_.dtype

    def __repr__(BaseArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(BaseArrayTag self, other):
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, TAG_List)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def __getitem__(BaseArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(BaseArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(BaseArrayTag self):
        return self.value_

    def __len__(BaseArrayTag self):
        return len(self.value_)

    def __add__(BaseArrayTag self, other):
        return (self.value_ + other).astype(self.big_endian_data_type)

    def __radd__(BaseArrayTag self, other):
        return (other + self.value_).astype(self.big_endian_data_type)

    def __iadd__(BaseArrayTag self, other):
        self.value_ += other
        return self

    def __sub__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rsub__(BaseArrayTag self, other):
        return (other - self.value_).astype(self.big_endian_data_type)

    def __isub__(BaseArrayTag self, other):
        self.value_ -= other
        return self

    def __mul__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rmul__(BaseArrayTag self, other):
        return (other * self.value_).astype(self.big_endian_data_type)

    def __imul__(BaseArrayTag self, other):
        self.value_ *= other
        return self

    def __matmul__(BaseArrayTag self, other):
        return (self.value_ @ other).astype(self.big_endian_data_type)

    def __rmatmul__(BaseArrayTag self, other):
        return (other @ self.value_).astype(self.big_endian_data_type)

    def __imatmul__(BaseArrayTag self, other):
        self.value_ @= other
        return self

    def __truediv__(BaseArrayTag self, other):
        return (self.value_ / other).astype(self.big_endian_data_type)

    def __rtruediv__(BaseArrayTag self, other):
        return (other / self.value_).astype(self.big_endian_data_type)

    def __itruediv__(BaseArrayTag self, other):
        self.value_ /= other
        return self

    def __floordiv__(BaseArrayTag self, other):
        return (self.value_ // other).astype(self.big_endian_data_type)

    def __rfloordiv__(BaseArrayTag self, other):
        return (other // self.value_).astype(self.big_endian_data_type)

    def __ifloordiv__(BaseArrayTag self, other):
        self.value_ //= other
        return self

    def __mod__(BaseArrayTag self, other):
        return (self.value_ % other).astype(self.big_endian_data_type)

    def __rmod__(BaseArrayTag self, other):
        return (other % self.value_).astype(self.big_endian_data_type)

    def __imod__(BaseArrayTag self, other):
        self.value_ %= other
        return self

    def __divmod__(BaseArrayTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(BaseArrayTag self, other):
        return divmod(other, self.value_)

    def __pow__(BaseArrayTag self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.big_endian_data_type)

    def __rpow__(BaseArrayTag self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.big_endian_data_type)

    def __ipow__(BaseArrayTag self, other):
        self.value_ **= other
        return self

    def __lshift__(BaseArrayTag self, other):
        return (self.value_ << other).astype(self.big_endian_data_type)

    def __rlshift__(BaseArrayTag self, other):
        return (other << self.value_).astype(self.big_endian_data_type)

    def __ilshift__(BaseArrayTag self, other):
        self.value_ <<= other
        return self

    def __rshift__(BaseArrayTag self, other):
        return (self.value_ >> other).astype(self.big_endian_data_type)

    def __rrshift__(BaseArrayTag self, other):
        return (other >> self.value_).astype(self.big_endian_data_type)

    def __irshift__(BaseArrayTag self, other):
        self.value_ >>= other
        return self

    def __and__(BaseArrayTag self, other):
        return (self.value_ & other).astype(self.big_endian_data_type)

    def __rand__(BaseArrayTag self, other):
        return (other & self.value_).astype(self.big_endian_data_type)

    def __iand__(BaseArrayTag self, other):
        self.value_ &= other
        return self

    def __xor__(BaseArrayTag self, other):
        return (self.value_ ^ other).astype(self.big_endian_data_type)

    def __rxor__(BaseArrayTag self, other):
        return (other ^ self.value_).astype(self.big_endian_data_type)

    def __ixor__(BaseArrayTag self, other):
        self.value_ ^= other
        return self

    def __or__(BaseArrayTag self, other):
        return (self.value_ | other).astype(self.big_endian_data_type)

    def __ror__(BaseArrayTag self, other):
        return (other | self.value_).astype(self.big_endian_data_type)

    def __ior__(BaseArrayTag self, other):
        self.value_ |= other
        return self

    def __neg__(BaseArrayTag self):
        return self.value_.__neg__()

    def __pos__(BaseArrayTag self):
        return self.value_.__pos__()

    def __abs__(BaseArrayTag self):
        return self.value_.__abs__()


BaseArrayType = BaseArrayTag


cdef class TAG_Byte_Array(BaseArrayTag):
    tag_id = ID_BYTE_ARRAY
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(TAG_Byte_Array self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Byte_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 1, little_endian)

    @staticmethod
    cdef TAG_Byte_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef char*arr = read_data(buffer, length)
        data_type = TAG_Byte_Array.little_endian_data_type if little_endian else TAG_Byte_Array.big_endian_data_type
        return TAG_Byte_Array(numpy.frombuffer(arr[:length], dtype=data_type, count=length))


cdef class TAG_Int_Array(BaseArrayTag):
    tag_id = ID_INT_ARRAY
    big_endian_data_type = numpy.dtype(">i4")
    little_endian_data_type = numpy.dtype("<i4")

    cdef str _to_snbt(TAG_Int_Array self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Int_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 4, little_endian)

    @staticmethod
    cdef TAG_Int_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef int byte_length = length * 4
        cdef char*arr = read_data(buffer, byte_length)
        cdef object data_type = TAG_Int_Array.little_endian_data_type if little_endian else TAG_Int_Array.big_endian_data_type
        return TAG_Int_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))


cdef class TAG_Long_Array(BaseArrayTag):
    tag_id = ID_LONG_ARRAY
    big_endian_data_type = numpy.dtype(">i8")
    little_endian_data_type = numpy.dtype("<i8")

    cdef str _to_snbt(TAG_Long_Array self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Long_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 8, little_endian)

    @staticmethod
    cdef TAG_Long_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef int byte_length = length * 8
        cdef char*arr = read_data(buffer, byte_length)
        cdef object data_type = TAG_Long_Array.little_endian_data_type if little_endian else TAG_Long_Array.big_endian_data_type
        return TAG_Long_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))
