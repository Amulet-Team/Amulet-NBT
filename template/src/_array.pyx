import numpy
cimport numpy
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
    @property
    def shape(self):
{{get_clean_docstring(numpy.ndarray.shape)}}
        raise NotImplementedError
    # shape.__doc__ = numpy.ndarray.shape.__doc__

    @property
    def strides(self):
{{get_clean_docstring(numpy.ndarray.strides)}}
        raise NotImplementedError
    # strides.__doc__ = numpy.ndarray.strides.__doc__

    def __repr__(BaseArrayTag self):
        raise NotImplementedError

    def __eq__(BaseArrayTag self, other):
        raise NotImplementedError

    def __getitem__(BaseArrayTag self, item):
        raise NotImplementedError

    def __setitem__(BaseArrayTag self, key, value):
        raise NotImplementedError

    def __array__(BaseArrayTag self, dtype=None):
        raise NotImplementedError

    def __len__(BaseArrayTag self):
        raise NotImplementedError

    def __add__(BaseArrayTag self, other):
        raise NotImplementedError

    def __radd__(BaseArrayTag self, other):
        raise NotImplementedError

    def __iadd__(BaseArrayTag self, other):
        raise NotImplementedError

    def __sub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rsub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __isub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __mul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __matmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmatmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imatmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __truediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rtruediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __itruediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __floordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rfloordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ifloordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __mod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __divmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rdivmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __pow__(BaseArrayTag self, power, modulo):
        raise NotImplementedError

    def __rpow__(BaseArrayTag self, other, modulo):
        raise NotImplementedError

    def __ipow__(BaseArrayTag self, other):
        raise NotImplementedError

    def __lshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rlshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ilshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rrshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __irshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __and__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rand__(BaseArrayTag self, other):
        raise NotImplementedError

    def __iand__(BaseArrayTag self, other):
        raise NotImplementedError

    def __xor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rxor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ixor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __or__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ror__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ior__(BaseArrayTag self, other):
        raise NotImplementedError

    def __neg__(BaseArrayTag self):
        raise NotImplementedError

    def __pos__(BaseArrayTag self):
        raise NotImplementedError

    def __abs__(BaseArrayTag self):
        raise NotImplementedError


BaseArrayType = BaseArrayTag


{{include(
    "BaseArrayTag.pyx",
    native_data_type='numpy.dtype("int8")',
    big_endian_data_type='numpy.dtype("int8")',
    little_endian_data_type='numpy.dtype("int8")',
    width=1,
    dtype="byte",
    snbt_prefix="B",
    snbt_suffix="B",
)}}


{{include(
    "BaseArrayTag.pyx",
    native_data_type='numpy.int32',
    big_endian_data_type='numpy.dtype(">i4")',
    little_endian_data_type='numpy.dtype("<i4")',
    width=4,
    dtype="int",
    snbt_prefix="I",
    snbt_suffix="",
)}}


{{include(
    "BaseArrayTag.pyx",
    native_data_type='numpy.int64',
    big_endian_data_type='numpy.dtype(">i8")',
    little_endian_data_type='numpy.dtype("<i8")',
    width=8,
    dtype="long",
    snbt_prefix="L",
    snbt_suffix="L",
)}}
