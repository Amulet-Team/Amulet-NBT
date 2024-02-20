from amulet_nbt._tag.numeric cimport AbstractBaseNumericTag
from amulet_nbt._tag._cpp cimport CFloatTag, CDoubleTag


cdef class AbstractBaseFloatTag(AbstractBaseNumericTag):
    pass


cdef class FloatTag(AbstractBaseFloatTag):
    cdef CFloatTag cpp

    @staticmethod
    cdef FloatTag wrap(CFloatTag)


cdef class DoubleTag(AbstractBaseFloatTag):
    cdef CDoubleTag cpp

    @staticmethod
    cdef DoubleTag wrap(CDoubleTag)
