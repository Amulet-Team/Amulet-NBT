import numpy
cimport numpy
numpy.import_array()
from ._value cimport AbstractBaseMutableTag
from ._util cimport BufferContext

cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    pass

cdef ByteArrayTag read_byte_array_tag(BufferContext buffer, bint little_endian)

cdef class ByteArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_

cdef IntArrayTag read_int_array_tag(BufferContext buffer, bint little_endian)

cdef class IntArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_

cdef LongArrayTag read_long_array_tag(BufferContext buffer, bint little_endian)

cdef class LongArrayTag(AbstractBaseArrayTag):
    cdef numpy.ndarray value_
