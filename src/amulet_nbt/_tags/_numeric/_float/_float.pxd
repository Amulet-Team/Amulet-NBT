from ._numeric cimport AbstractBaseNumericTag
from ._util cimport BufferContext
from nbt cimport FloatTag as CFloatTag, DoubleTag as CDoubleTag

cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    pass

cdef class FloatTag(AbstractBaseFloatTag):
    cdef CFloatTag value_

cdef class DoubleTag(AbstractBaseFloatTag):
    cdef CDoubleTag value_
