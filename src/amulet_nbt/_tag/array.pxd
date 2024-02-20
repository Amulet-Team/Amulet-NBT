from amulet_nbt._tag.abc cimport AbstractBaseMutableTag
from amulet_nbt._tag._cpp cimport (
    CByteArrayTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr
)


cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    pass


cdef class ByteArrayTag(AbstractBaseArrayTag):
    cdef CByteArrayTagPtr cpp

    @staticmethod
    cdef ByteArrayTag wrap(CByteArrayTagPtr)


cdef class IntArrayTag(AbstractBaseArrayTag):
    cdef CIntArrayTagPtr cpp

    @staticmethod
    cdef IntArrayTag wrap(CIntArrayTagPtr)


cdef class LongArrayTag(AbstractBaseArrayTag):
    cdef CLongArrayTagPtr cpp

    @staticmethod
    cdef LongArrayTag wrap(CLongArrayTagPtr)
