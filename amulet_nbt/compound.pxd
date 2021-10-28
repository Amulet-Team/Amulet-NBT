from .value cimport BaseMutableTag


cdef class TAG_Compound(BaseMutableTag):
    cdef dict _value

    @staticmethod
    cdef _check_dict(dict value)
