from amulet_nbt._tag.abc cimport AbstractBaseImmutableTag


cdef class AbstractBaseNumericTag(AbstractBaseImmutableTag):
    """Abstract Base Class for all numeric Tag classes"""
    def __int__(self):
        """Get a python int representation of the class."""
        raise NotImplementedError

    def __float__(self):
        """Get a python float representation of the class."""
        raise NotImplementedError

    def __bool__(self):
        """Get a python bool representation of the class."""
        raise NotImplementedError
