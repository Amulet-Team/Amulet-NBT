from ._value cimport AbstractBaseImmutableTag


cdef class BaseNumericTag(AbstractBaseImmutableTag):
    def __int__(self):
        raise NotImplementedError

    def __float__(self):
        raise NotImplementedError

    def __bool__(self):
        raise NotImplementedError
