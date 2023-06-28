from amulet_nbt._tags._numeric cimport AbstractBaseNumericTag
from amulet_nbt._nbt cimport ByteTag as CByteTag, ShortTag as CShortTag, IntTag as CIntTag, LongTag as CLongTag

cdef class AbstractBaseIntTag(AbstractBaseNumericTag):
    pass

cdef class ByteTag(AbstractBaseIntTag):
    cdef CByteTag value_
    cdef CByteTag _sanitise_value(self, value)

cdef class ShortTag(AbstractBaseIntTag):
    cdef CShortTag value_
    cdef CShortTag _sanitise_value(self, value)

cdef class IntTag(AbstractBaseIntTag):
    cdef CIntTag value_
    cdef CIntTag _sanitise_value(self, value)

cdef class LongTag(AbstractBaseIntTag):
    cdef CLongTag value_
    cdef CLongTag _sanitise_value(self, value)
