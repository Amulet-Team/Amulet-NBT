from ._value cimport BaseImmutableTag


cdef class BaseNumericTag(BaseImmutableTag):
    def __int__(self):
        raise NotImplementedError

    def __float__(self):
        raise NotImplementedError

    def __bool__(self):
        raise NotImplementedError
