{{py:
import numpy
from template import include, get_clean_docstring
}}
cdef inline void _read_{{dtype}}_array_tag_payload({{dtype.capitalize()}}ArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * {{width}}
    cdef char*arr = read_data(buffer, byte_length)
    data_type = {{little_endian_data_type}} if little_endian else {{big_endian_data_type}}
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), {{native_data_type}}).ravel()


cdef class {{dtype.capitalize()}}ArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a {{dtype}}."""
    tag_id = ID_{{dtype.upper()}}_ARRAY

    def __init__({{dtype.capitalize()}}ArrayTag self, object value = ()):
        self.value_ = numpy.array(value, {{native_data_type}}).ravel()

    cdef str _to_snbt({{dtype.capitalize()}}ArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}{{snbt_suffix}}")
        return f"[{{snbt_prefix}};{CommaSpace.join(tags)}]"

    cdef void write_payload({{dtype.capitalize()}}ArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(
            numpy.asarray(self.value_, {{little_endian_data_type}} if little_endian else {{big_endian_data_type}}),
            buffer,
            {{width}},
            little_endian
        )

    @staticmethod
    cdef {{dtype.capitalize()}}ArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef {{dtype.capitalize()}}ArrayTag tag = {{dtype.capitalize()}}ArrayTag.__new__({{dtype.capitalize()}}ArrayTag)
        _read_{{dtype}}_array_tag_payload(tag, buffer, little_endian)
        return tag

{{include("BaseMutableTag.pyx", cls_name=f"{dtype.capitalize()}ArrayTag")}}
    @property
    def shape(self):
{{get_clean_docstring(numpy.ndarray.shape)}}
        return (self.value_.shape[0],)
    # shape.__doc__ = numpy.ndarray.shape.__doc__

    @property
    def strides(self):
{{get_clean_docstring(numpy.ndarray.strides)}}
        return (self.value_.strides[0],)
    # strides.__doc__ = numpy.ndarray.strides.__doc__

    def __repr__({{dtype.capitalize()}}ArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__({{dtype.capitalize()}}ArrayTag self, other):
        warnings.warn("The behaviour of __eq__ on arrays will change in the future. You should use eq_other to ensure the return is always a bool.", FutureWarning)
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def eq_other(self, other):
        return numpy.array_equal(self.value_, other)

    def __getitem__({{dtype.capitalize()}}ArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__({{dtype.capitalize()}}ArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__({{dtype.capitalize()}}ArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__({{dtype.capitalize()}}ArrayTag self):
        return len(self.value_)

    def __add__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ + other).astype(self.data_type)

    def __radd__({{dtype.capitalize()}}ArrayTag self, other):
        return (other + self.value_).astype(self.data_type)

    def __iadd__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ += other
        return self

    def __sub__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rsub__({{dtype.capitalize()}}ArrayTag self, other):
        return (other - self.value_).astype(self.data_type)

    def __isub__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ -= other
        return self

    def __mul__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rmul__({{dtype.capitalize()}}ArrayTag self, other):
        return (other * self.value_).astype(self.data_type)

    def __imul__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ *= other
        return self

    def __matmul__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ @ other).astype(self.data_type)

    def __rmatmul__({{dtype.capitalize()}}ArrayTag self, other):
        return (other @ self.value_).astype(self.data_type)

    def __imatmul__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ @= other
        return self

    def __truediv__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ / other).astype(self.data_type)

    def __rtruediv__({{dtype.capitalize()}}ArrayTag self, other):
        return (other / self.value_).astype(self.data_type)

    def __itruediv__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ /= other
        return self

    def __floordiv__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ // other).astype(self.data_type)

    def __rfloordiv__({{dtype.capitalize()}}ArrayTag self, other):
        return (other // self.value_).astype(self.data_type)

    def __ifloordiv__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ //= other
        return self

    def __mod__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ % other).astype(self.data_type)

    def __rmod__({{dtype.capitalize()}}ArrayTag self, other):
        return (other % self.value_).astype(self.data_type)

    def __imod__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ %= other
        return self

    def __divmod__({{dtype.capitalize()}}ArrayTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__({{dtype.capitalize()}}ArrayTag self, other):
        return divmod(other, self.value_)

    def __pow__({{dtype.capitalize()}}ArrayTag self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.data_type)

    def __rpow__({{dtype.capitalize()}}ArrayTag self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.data_type)

    def __ipow__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ **= other
        return self

    def __lshift__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ << other).astype(self.data_type)

    def __rlshift__({{dtype.capitalize()}}ArrayTag self, other):
        return (other << self.value_).astype(self.data_type)

    def __ilshift__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ <<= other
        return self

    def __rshift__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ >> other).astype(self.data_type)

    def __rrshift__({{dtype.capitalize()}}ArrayTag self, other):
        return (other >> self.value_).astype(self.data_type)

    def __irshift__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ >>= other
        return self

    def __and__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ & other).astype(self.data_type)

    def __rand__({{dtype.capitalize()}}ArrayTag self, other):
        return (other & self.value_).astype(self.data_type)

    def __iand__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ &= other
        return self

    def __xor__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ ^ other).astype(self.data_type)

    def __rxor__({{dtype.capitalize()}}ArrayTag self, other):
        return (other ^ self.value_).astype(self.data_type)

    def __ixor__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ ^= other
        return self

    def __or__({{dtype.capitalize()}}ArrayTag self, other):
        return (self.value_ | other).astype(self.data_type)

    def __ror__({{dtype.capitalize()}}ArrayTag self, other):
        return (other | self.value_).astype(self.data_type)

    def __ior__({{dtype.capitalize()}}ArrayTag self, other):
        self.value_ |= other
        return self

    def __neg__({{dtype.capitalize()}}ArrayTag self):
        return self.value_.__neg__()

    def __pos__({{dtype.capitalize()}}ArrayTag self):
        return self.value_.__pos__()

    def __abs__({{dtype.capitalize()}}ArrayTag self):
        return self.value_.__abs__()

    @property
    def dtype(self):
        return {{native_data_type}}

    @property
    def itemsize(self) -> int:
        return {{width}}

    @property
    def size(self) -> int:
        return self.value_.size

    @property
    def nbytes(self) -> int:
        return self.itemsize * self.size

    @property
    def ndim(self) -> int:
        return 1