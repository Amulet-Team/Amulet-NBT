from amulet_nbt._tags._value cimport AbstractBaseMutableTag
from amulet_nbt._nbt cimport ByteArrayTagPtr as CByteArrayTagPtr, IntArrayTagPtr as CIntArrayTagPtr, LongArrayTagPtr as CLongArrayTagPtr

cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    pass

cdef class ByteArrayTag(AbstractBaseArrayTag):
    cdef CByteArrayTagPtr value_

cdef class IntArrayTag(AbstractBaseArrayTag):
    cdef CIntArrayTagPtr value_

cdef class LongArrayTag(AbstractBaseArrayTag):
    cdef CLongArrayTagPtr value_
