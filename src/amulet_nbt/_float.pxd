from ._numeric cimport AbstractBaseNumericTag
from ._util cimport BufferContext

cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    pass

cdef FloatTag read_float_tag(BufferContext buffer, bint little_endian)

cdef class FloatTag(AbstractBaseFloatTag):
    cdef float value_

cdef DoubleTag read_double_tag(BufferContext buffer, bint little_endian)

cdef class DoubleTag(AbstractBaseFloatTag):
    cdef double value_
