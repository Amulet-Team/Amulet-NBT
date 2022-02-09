from .value cimport BaseTag


cdef class BaseNamedTag:
    cdef readonly BaseTag tag
    cdef readonly str name


cdef class NamedByteTag(BaseNamedTag):
    pass


cdef class NamedShortTag(BaseNamedTag):
    pass


cdef class NamedIntTag(BaseNamedTag):
    pass


cdef class NamedLongTag(BaseNamedTag):
    pass


cdef class NamedFloatTag(BaseNamedTag):
    pass


cdef class NamedDoubleTag(BaseNamedTag):
    pass


cdef class NamedByteArrayTag(BaseNamedTag):
    pass


cdef class NamedStringTag(BaseNamedTag):
    pass


cdef class NamedListTag(BaseNamedTag):
    pass


cdef class NamedCompoundTag(BaseNamedTag):
    pass


cdef class NamedIntArrayTag(BaseNamedTag):
    pass


cdef class NamedLongArrayTag(BaseNamedTag):
    pass
