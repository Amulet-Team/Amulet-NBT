import numpy
cimport numpy
from io import BytesIO
from copy import copy, deepcopy

from ._value cimport BaseMutableTag
from ._const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from ._util cimport write_array, BufferContext, read_int, read_data
{{py:
import numpy
from template import include
}}


cdef class BaseArrayTag(BaseMutableTag):
    def __getitem__(BaseArrayTag self, item):
        raise NotImplementedError

    def __setitem__(BaseArrayTag self, key, value):
        raise NotImplementedError

    def __array__(BaseArrayTag self, dtype=None):
        raise NotImplementedError

    def __len__(BaseArrayTag self):
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