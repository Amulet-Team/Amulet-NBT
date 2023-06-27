from ._value cimport AbstractBaseImmutableTag


cdef class AbstractBaseNumericTag(AbstractBaseImmutableTag):
    """Abstract Base Class for all numeric Tag classes"""
    def __int__(self):
        raise NotImplementedError

    def __float__(self):
        raise NotImplementedError

    def __bool__(self):
        raise NotImplementedError
