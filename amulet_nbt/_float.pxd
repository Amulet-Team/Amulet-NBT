from ._numeric cimport AbstractBaseNumericTag

cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    pass

cdef class FloatTag(AbstractBaseFloatTag):
    cdef float value_

cdef class DoubleTag(AbstractBaseFloatTag):
    cdef double value_
