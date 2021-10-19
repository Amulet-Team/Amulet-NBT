import numpy
cimport numpy

from .value import BaseMutableTag
from .errors import NBTError
from .const import CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from .util import write_array


cdef class BaseArrayTag(BaseMutableTag):
    cdef public object value
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    def __init__(self, object value = None):
        if value is None:
            value = numpy.zeros((0,), self.big_endian_data_type)
        elif isinstance(value, (list, tuple)):
            value = numpy.array(value, self.big_endian_data_type)
        elif isinstance(value, (TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array)):
            value = value.value
        if isinstance(value, numpy.ndarray):
            if value.dtype != self.big_endian_data_type:
                value = value.astype(self.big_endian_data_type)
        else:
            raise NBTError(f'Unexpected object {value} given to {self.__class__.__name__}')

        self.value = value

    def __eq__(self, other):
        return numpy.array_equal(self.value, other)

    def __getitem__(self, item):
        return self.value.__getitem__(item)

    def __setitem__(self, key, value):
        self.value.__setitem__(key, value)

    def __array__(self):
        return self.value

    def __len__(self):
        return len(self.value)

    def __add__(self, other):
        return (self.value + other).astype(self.big_endian_data_type)

    def __radd__(self, other):
        return (other + self.value).astype(self.big_endian_data_type)

    def __iadd__(self, other):
        self.value += other
        return self

    def __sub__(self, other):
        return (self.value - other).astype(self.big_endian_data_type)

    def __rsub__(self, other):
        return (other - self.value).astype(self.big_endian_data_type)

    def __isub__(self, other):
        self.value -= other
        return self

    def __mul__(self, other):
        return (self.value - other).astype(self.big_endian_data_type)

    def __rmul__(self, other):
        return (other * self.value).astype(self.big_endian_data_type)

    def __imul__(self, other):
        self.value *= other
        return self

    def __matmul__(self, other):
        return (self.value @ other).astype(self.big_endian_data_type)

    def __rmatmul__(self, other):
        return (other @ self.value).astype(self.big_endian_data_type)

    def __imatmul__(self, other):
        self.value @= other
        return self

    def __truediv__(self, other):
        return (self.value / other).astype(self.big_endian_data_type)

    def __rtruediv__(self, other):
        return (other / self.value).astype(self.big_endian_data_type)

    def __itruediv__(self, other):
        self.value /= other
        return self

    def __floordiv__(self, other):
        return (self.value // other).astype(self.big_endian_data_type)

    def __rfloordiv__(self, other):
        return (other // self.value).astype(self.big_endian_data_type)

    def __ifloordiv__(self, other):
        self.value //= other
        return self

    def __mod__(self, other):
        return (self.value % other).astype(self.big_endian_data_type)

    def __rmod__(self, other):
        return (other % self.value).astype(self.big_endian_data_type)

    def __imod__(self, other):
        self.value %= other
        return self

    def __divmod__(self, other):
        return divmod(self.value, other)

    def __rdivmod__(self, other):
        return divmod(other, self.value)

    def __pow__(self, power, modulo):
        return pow(self.value, power, modulo).astype(self.big_endian_data_type)

    def __rpow__(self, other, modulo):
        return pow(other, self.value, modulo).astype(self.big_endian_data_type)

    def __ipow__(self, other):
        self.value **= other
        return self

    def __lshift__(self, other):
        return (self.value << other).astype(self.big_endian_data_type)

    def __rlshift__(self, other):
        return (other << self.value).astype(self.big_endian_data_type)

    def __ilshift__(self, other):
        self.value <<= other
        return self

    def __rshift__(self, other):
        return (self.value >> other).astype(self.big_endian_data_type)

    def __rrshift__(self, other):
        return (other >> self.value).astype(self.big_endian_data_type)

    def __irshift__(self, other):
        self.value >>= other
        return self

    def __and__(self, other):
        return (self.value & other).astype(self.big_endian_data_type)

    def __rand__(self, other):
        return (other & self.value).astype(self.big_endian_data_type)

    def __iand__(self, other):
        self.value &= other
        return self

    def __xor__(self, other):
        return (self.value ^ other).astype(self.big_endian_data_type)

    def __rxor__(self, other):
        return (other ^ self.value).astype(self.big_endian_data_type)

    def __ixor__(self, other):
        self.value ^= other
        return self

    def __or__(self, other):
        return (self.value | other).astype(self.big_endian_data_type)

    def __ror__(self, other):
        return (other | self.value).astype(self.big_endian_data_type)

    def __ior__(self, other):
        self.value |= other
        return self

    def __neg__(self):
        return self.value.__neg__().astype(self.big_endian_data_type)

    def __pos__(self):
        return self.value.__pos__().astype(self.big_endian_data_type)

    def __abs__(self):
        return self.value.__abs__().astype(self.big_endian_data_type)


BaseArrayType = BaseArrayTag


cdef class TAG_Byte_Array(BaseArrayTag):
    tag_id = ID_BYTE_ARRAY
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[B;{'B, '.join(tags)}B]"

    cdef void write_payload(self, buffer, little_endian) except *:
        data_type = self.little_endian_data_type if little_endian else self.big_endian_data_type
        if self.value.dtype != data_type:
            if self.value.dtype != self.big_endian_data_type if little_endian else self.little_endian_data_type:
                print(f'[Warning] Mismatch array dtype. Expected: {data_type.str}, got: {self.value.dtype.str}')
            self.value = self.value.astype(data_type)
        write_array(self.value, buffer, 1, little_endian)


cdef class TAG_Int_Array(BaseArrayTag):
    tag_id = ID_INT_ARRAY
    big_endian_data_type = numpy.dtype(">i4")
    little_endian_data_type = numpy.dtype("<i4")

    cdef str _to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(self, buffer, little_endian) except *:
        data_type = self.little_endian_data_type if little_endian else self.big_endian_data_type
        if self.value.dtype != data_type:
            if self.value.dtype != self.big_endian_data_type if little_endian else self.little_endian_data_type:
                print(f'[Warning] Mismatch array dtype. Expected: {data_type.str}, got: {self.value.dtype.str}')
            self.value = self.value.astype(data_type)
        write_array(self.value, buffer, 4, little_endian)


cdef class TAG_Long_Array(BaseArrayTag):
    tag_id = ID_LONG_ARRAY
    big_endian_data_type = numpy.dtype(">i8")
    little_endian_data_type = numpy.dtype("<i8")

    cdef str _to_snbt(self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(self, buffer, little_endian) except *:
        data_type = self.little_endian_data_type if little_endian else self.big_endian_data_type
        if self.value.dtype != data_type:
            if self.value.dtype != self.big_endian_data_type if little_endian else self.little_endian_data_type:
                print(f'[Warning] Mismatch array dtype. Expected: {data_type.str}, got: {self.value.dtype.str}')
            self.value = self.value.astype(data_type)
        write_array(self.value, buffer, 8, little_endian)
