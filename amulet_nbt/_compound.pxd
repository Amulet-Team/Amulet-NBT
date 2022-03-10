from ._value cimport BaseMutableTag


cdef class CompoundTag(BaseMutableTag):
    cdef dict value_

    @staticmethod
    cdef _check_dict(dict value)
