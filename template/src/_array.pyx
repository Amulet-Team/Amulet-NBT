import numpy
cimport numpy
from numpy import ndarray
from numpy cimport ndarray
from io import BytesIO
from copy import copy, deepcopy

from ._value cimport BaseMutableTag
from ._const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from ._util cimport write_array, BufferContext, read_int, read_data
from ._list cimport ListTag
{{py:
import numpy
from template import include, gen_wrapper, get_clean_docstring
}}


cdef class BaseArrayTag(BaseMutableTag):
    data_type = big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    def __init__(BaseArrayTag self, object value = ()):
        self.value_ = numpy.array(value, self.data_type).ravel()

{{gen_wrapper(
    "value_",
    numpy.ndarray,
    [
        "T",
        "dtype",
        "flags",
        "flat",
        "imag",
        "itemsize",
        "nbytes",
        "ndim",
        "real",
        "size",
        "all",
        "any",
        "argmax",
        "argmin",
        "argpartition",
        "argsort",
        "astype",
        "byteswap",
        "choose",
        "clip",
        "compress",
        "conj",
        "conjugate",
        "cumprod",
        "cumsum",
        "diagonal",
        "dot",
        "dump",
        "dumps",
        "fill",
        "flatten",
        "getfield",
        "item",
        "itemset",
        "max",
        "mean",
        "min",
        "newbyteorder",
        "nonzero",
        "partition",
        "prod",
        "ptp",
        "put",
        "ravel",
        "repeat",
        "reshape",
        "round",
        "searchsorted",
        "setfield",
        "setflags",
        "sort",
        "squeeze",
        "std",
        "sum",
        "swapaxes",
        "take",
        "tobytes",
        "tofile",
        "tolist",
        "tostring",
        "trace",
        "transpose",
        "var",
        "view"
    ]
)}}
{{include("BaseMutableTag.pyx.in", cls_name="BaseArrayTag")}}
    @property
    def shape(self):
{{get_clean_docstring(numpy.ndarray.shape)}}
        return tuple(self.value_.shape[i] for i in range(self.value_.ndim))
    # shape.__doc__ = numpy.ndarray.shape.__doc__

    @property
    def strides(self):
{{get_clean_docstring(numpy.ndarray.strides)}}
        return tuple(self.value_.strides[i] for i in range(self.value_.ndim))
    # strides.__doc__ = numpy.ndarray.strides.__doc__

    def resize(*args, **kwargs):
        raise Exception("The TAG_Array classes are 1D arrays and cannot be resized in place. Try reshape to get a copy.")

    cdef numpy.ndarray _as_endianness(BaseArrayTag self, bint little_endian = False):
        return self.value_.astype(self.little_endian_data_type if little_endian else self.big_endian_data_type)

    def __repr__(BaseArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(BaseArrayTag self, other):
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def __getitem__(BaseArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(BaseArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(BaseArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(BaseArrayTag self):
        return len(self.value_)

    def __add__(BaseArrayTag self, other):
        return (self.value_ + other).astype(self.data_type)

    def __radd__(BaseArrayTag self, other):
        return (other + self.value_).astype(self.data_type)

    def __iadd__(BaseArrayTag self, other):
        self.value_ += other
        return self

    def __sub__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rsub__(BaseArrayTag self, other):
        return (other - self.value_).astype(self.data_type)

    def __isub__(BaseArrayTag self, other):
        self.value_ -= other
        return self

    def __mul__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rmul__(BaseArrayTag self, other):
        return (other * self.value_).astype(self.data_type)

    def __imul__(BaseArrayTag self, other):
        self.value_ *= other
        return self

    def __matmul__(BaseArrayTag self, other):
        return (self.value_ @ other).astype(self.data_type)

    def __rmatmul__(BaseArrayTag self, other):
        return (other @ self.value_).astype(self.data_type)

    def __imatmul__(BaseArrayTag self, other):
        self.value_ @= other
        return self

    def __truediv__(BaseArrayTag self, other):
        return (self.value_ / other).astype(self.data_type)

    def __rtruediv__(BaseArrayTag self, other):
        return (other / self.value_).astype(self.data_type)

    def __itruediv__(BaseArrayTag self, other):
        self.value_ /= other
        return self

    def __floordiv__(BaseArrayTag self, other):
        return (self.value_ // other).astype(self.data_type)

    def __rfloordiv__(BaseArrayTag self, other):
        return (other // self.value_).astype(self.data_type)

    def __ifloordiv__(BaseArrayTag self, other):
        self.value_ //= other
        return self

    def __mod__(BaseArrayTag self, other):
        return (self.value_ % other).astype(self.data_type)

    def __rmod__(BaseArrayTag self, other):
        return (other % self.value_).astype(self.data_type)

    def __imod__(BaseArrayTag self, other):
        self.value_ %= other
        return self

    def __divmod__(BaseArrayTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(BaseArrayTag self, other):
        return divmod(other, self.value_)

    def __pow__(BaseArrayTag self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.data_type)

    def __rpow__(BaseArrayTag self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.data_type)

    def __ipow__(BaseArrayTag self, other):
        self.value_ **= other
        return self

    def __lshift__(BaseArrayTag self, other):
        return (self.value_ << other).astype(self.data_type)

    def __rlshift__(BaseArrayTag self, other):
        return (other << self.value_).astype(self.data_type)

    def __ilshift__(BaseArrayTag self, other):
        self.value_ <<= other
        return self

    def __rshift__(BaseArrayTag self, other):
        return (self.value_ >> other).astype(self.data_type)

    def __rrshift__(BaseArrayTag self, other):
        return (other >> self.value_).astype(self.data_type)

    def __irshift__(BaseArrayTag self, other):
        self.value_ >>= other
        return self

    def __and__(BaseArrayTag self, other):
        return (self.value_ & other).astype(self.data_type)

    def __rand__(BaseArrayTag self, other):
        return (other & self.value_).astype(self.data_type)

    def __iand__(BaseArrayTag self, other):
        self.value_ &= other
        return self

    def __xor__(BaseArrayTag self, other):
        return (self.value_ ^ other).astype(self.data_type)

    def __rxor__(BaseArrayTag self, other):
        return (other ^ self.value_).astype(self.data_type)

    def __ixor__(BaseArrayTag self, other):
        self.value_ ^= other
        return self

    def __or__(BaseArrayTag self, other):
        return (self.value_ | other).astype(self.data_type)

    def __ror__(BaseArrayTag self, other):
        return (other | self.value_).astype(self.data_type)

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


cdef inline void _read_byte_array_tag_payload(ByteArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef char*arr = read_data(buffer, length)
    data_type = ByteArrayTag.little_endian_data_type if little_endian else ByteArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:length], dtype=data_type, count=length), ByteArrayTag.data_type).ravel()


cdef class ByteArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a byte."""
    tag_id = ID_BYTE_ARRAY
    data_type = big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(ByteArrayTag self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(ByteArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 1, little_endian)

    @staticmethod
    cdef ByteArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef ByteArrayTag tag = ByteArrayTag.__new__(ByteArrayTag)
        _read_byte_array_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_int_array_tag_payload(IntArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 4
    cdef char*arr = read_data(buffer, byte_length)
    cdef object data_type = IntArrayTag.little_endian_data_type if little_endian else IntArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), IntArrayTag.data_type).ravel()


cdef class IntArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 4 bytes."""
    tag_id = ID_INT_ARRAY
    data_type = numpy.int32
    big_endian_data_type = numpy.dtype(">i4")
    little_endian_data_type = numpy.dtype("<i4")

    cdef str _to_snbt(IntArrayTag self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(IntArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 4, little_endian)

    @staticmethod
    cdef IntArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef IntArrayTag tag = IntArrayTag.__new__(IntArrayTag)
        _read_int_array_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_long_array_tag_payload(LongArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 8
    cdef char*arr = read_data(buffer, byte_length)
    cdef object data_type = LongArrayTag.little_endian_data_type if little_endian else LongArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), LongArrayTag.data_type).ravel()


cdef class LongArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 8 bytes."""
    tag_id = ID_LONG_ARRAY
    data_type = numpy.int64
    big_endian_data_type = numpy.dtype(">i8")
    little_endian_data_type = numpy.dtype("<i8")

    cdef str _to_snbt(LongArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(LongArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 8, little_endian)

    @staticmethod
    cdef LongArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef LongArrayTag tag = LongArrayTag.__new__(LongArrayTag)
        _read_long_array_tag_payload(tag, buffer, little_endian)
        return tag
