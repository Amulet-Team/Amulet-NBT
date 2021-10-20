from .value cimport BaseTag

cdef class NBTFile:
    cdef public str name
    cdef public BaseTag value

    cpdef bytes save_to(
        self,
        object filepath_or_buffer=*,
        bint compressed=*,
        bint little_endian=*
    )
