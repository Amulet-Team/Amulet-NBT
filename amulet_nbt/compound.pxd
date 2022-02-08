from .value cimport BaseMutableTag
from .util cimport BufferContext


cdef class CompoundTag(BaseMutableTag):
    cdef dict value_

    @staticmethod
    cdef _check_dict(dict value)


cdef class NamedCompoundTag(CompoundTag):
    cdef public str name

    @staticmethod
    cdef NamedCompoundTag read_named_payload(BufferContext buffer, bint little_endian)
