from .value cimport BaseMutableTag


cdef class TAG_Compound(BaseMutableTag):
    cdef dict value_

    @staticmethod
    cdef _check_dict(dict value)
