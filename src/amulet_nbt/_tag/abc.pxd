cdef class AbstractBase:
    pass


cdef class AbstractBaseTag(AbstractBase):
    pass


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    pass


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    pass
