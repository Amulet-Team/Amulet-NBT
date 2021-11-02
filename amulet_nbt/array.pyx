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

    def __init__(self, object value = ()):
        cdef numpy.ndarray arr
        if isinstance(value, BaseArrayTag):
            arr = value.value.flatten()
        elif isinstance(value, numpy.ndarray):
            arr = value.flatten()
        else:
            arr = numpy.array(value, self.big_endian_data_type).ravel()

        if arr.dtype != self.big_endian_data_type:
            arr = arr.astype(self.big_endian_data_type)

        self.value_ = arr

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

    @property
    def value(self):
        return copy(self.value_)

    __hash__ = None


    cdef void _fix_dtype(self):
        if self.value_.dtype != self.big_endian_data_type:
            print(f'[Warning] Mismatch array dtype. Expected: {self.big_endian_data_type}, got: {self.value_.dtype}')
            self.value_ = self.value_.astype(self.big_endian_data_type)

    cdef numpy.ndarray _as_endianness(self, bint little_endian = False):
        self._fix_dtype()
        if little_endian:
            return self.value_.astype(self.little_endian_data_type)
        else:
            return self.value_

    @property
    def dtype(self):
        return self.value_.dtype

    def __repr__(self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(self, other):
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, TAG_List)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def __getitem__(self, item):
        return self.value_.__getitem__(item)

    def __setitem__(self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(self):
        return self.value_

    def __len__(self):
        return len(self.value_)

    def __add__(self, other):
        return (self.value_ + other).astype(self.big_endian_data_type)

    def __radd__(self, other):
        return (other + self.value_).astype(self.big_endian_data_type)

    def __iadd__(self, other):
        self.value_ += other
        return self

    def __sub__(self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rsub__(self, other):
        return (other - self.value_).astype(self.big_endian_data_type)

    def __isub__(self, other):
        self.value_ -= other
        return self

    def __mul__(self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rmul__(self, other):
        return (other * self.value_).astype(self.big_endian_data_type)

    def __imul__(self, other):
        self.value_ *= other
        return self

    def __matmul__(self, other):
        return (self.value_ @ other).astype(self.big_endian_data_type)

    def __rmatmul__(self, other):
        return (other @ self.value_).astype(self.big_endian_data_type)

    def __imatmul__(self, other):
        self.value_ @= other
        return self

    def __truediv__(self, other):
        return (self.value_ / other).astype(self.big_endian_data_type)

    def __rtruediv__(self, other):
        return (other / self.value_).astype(self.big_endian_data_type)

    def __itruediv__(self, other):
        self.value_ /= other
        return self

    def __floordiv__(self, other):
        return (self.value_ // other).astype(self.big_endian_data_type)

    def __rfloordiv__(self, other):
        return (other // self.value_).astype(self.big_endian_data_type)

    def __ifloordiv__(self, other):
        self.value_ //= other
        return self

    def __mod__(self, other):
        return (self.value_ % other).astype(self.big_endian_data_type)

    def __rmod__(self, other):
        return (other % self.value_).astype(self.big_endian_data_type)

    def __imod__(self, other):
        self.value_ %= other
        return self

    def __divmod__(self, other):
        return divmod(self.value_, other)

    def __rdivmod__(self, other):
        return divmod(other, self.value_)

    def __pow__(self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.big_endian_data_type)

    def __rpow__(self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.big_endian_data_type)

    def __ipow__(self, other):
        self.value_ **= other
        return self

    def __lshift__(self, other):
        return (self.value_ << other).astype(self.big_endian_data_type)

    def __rlshift__(self, other):
        return (other << self.value_).astype(self.big_endian_data_type)

    def __ilshift__(self, other):
        self.value_ <<= other
        return self

    def __rshift__(self, other):
        return (self.value_ >> other).astype(self.big_endian_data_type)

    def __rrshift__(self, other):
        return (other >> self.value_).astype(self.big_endian_data_type)

    def __irshift__(self, other):
        self.value_ >>= other
        return self

    def __and__(self, other):
        return (self.value_ & other).astype(self.big_endian_data_type)

    def __rand__(self, other):
        return (other & self.value_).astype(self.big_endian_data_type)

    def __iand__(self, other):
        self.value_ &= other
        return self

    def __xor__(self, other):
        return (self.value_ ^ other).astype(self.big_endian_data_type)

    def __rxor__(self, other):
        return (other ^ self.value_).astype(self.big_endian_data_type)

    def __ixor__(self, other):
        self.value_ ^= other
        return self

    def __or__(self, other):
        return (self.value_ | other).astype(self.big_endian_data_type)

    def __ror__(self, other):
        return (other | self.value_).astype(self.big_endian_data_type)

    def __ior__(self, other):
        self.value_ |= other
        return self

    def __neg__(self):
        return self.value_.__neg__()

    def __pos__(self):
        return self.value_.__pos__()

    def __abs__(self):
        return self.value_.__abs__()


BaseArrayType = BaseArrayTag


cdef class TAG_Byte_Array(BaseArrayTag):
    tag_id = ID_BYTE_ARRAY
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
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

    cdef str _to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
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

    cdef str _to_snbt(self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 8, little_endian)

    @staticmethod
    cdef TAG_Long_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef int byte_length = length * 8
        cdef char*arr = read_data(buffer, byte_length)
        cdef object data_type = TAG_Long_Array.little_endian_data_type if little_endian else TAG_Long_Array.big_endian_data_type
        return TAG_Long_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))
