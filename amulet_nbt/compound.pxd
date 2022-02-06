from .value cimport BaseMutableTag


cdef class TAG_Compound(BaseMutableTag):
    cdef dict value_

    @staticmethod
    cdef _check_dict(dict value)


cdef class Named_TAG_Compound(TAG_Compound):
    cdef public str name
