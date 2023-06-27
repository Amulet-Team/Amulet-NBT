from ._value cimport AbstractBaseMutableTag
from ._util cimport BufferContext
from nbt cimport ByteArrayTagPtr as CByteArrayTagPtr, IntArrayTagPtr as CIntArrayTagPtr, LongArrayTagPtr as CLongArrayTagPtr

cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    pass

cdef class ByteArrayTag(AbstractBaseArrayTag):
    cdef CByteArrayTagPtr value_

cdef class IntArrayTag(AbstractBaseArrayTag):
    cdef CIntArrayTagPtr value_

cdef class LongArrayTag(AbstractBaseArrayTag):
    cdef CLongArrayTagPtr value_
