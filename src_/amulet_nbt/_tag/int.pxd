from amulet_nbt._tag.numeric cimport AbstractBaseNumericTag
from amulet_nbt._tag._cpp cimport CByteTag, CShortTag, CIntTag, CLongTag


cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    pass


cdef class ByteTag(AbstractBaseIntTag):
    cdef CByteTag cpp

    @staticmethod
    cdef ByteTag wrap(CByteTag)


cdef class ShortTag(AbstractBaseIntTag):
    cdef CShortTag cpp

    @staticmethod
    cdef ShortTag wrap(CShortTag)


cdef class IntTag(AbstractBaseIntTag):
    cdef CIntTag cpp

    @staticmethod
    cdef IntTag wrap(CIntTag)


cdef class LongTag(AbstractBaseIntTag):
    cdef CLongTag cpp

    @staticmethod
    cdef LongTag wrap(CLongTag)
