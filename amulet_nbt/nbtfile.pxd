from .value cimport BaseTag

cdef class NBTFile:
    cdef public str name
    cdef public BaseTag value
