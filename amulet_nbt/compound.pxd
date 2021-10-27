from .value cimport BaseTag, BaseMutableTag


cdef class TAG_Compound(BaseMutableTag):
    cdef dict _value

    @staticmethod
    cdef _check_dict(dict value)

    cpdef setdefault(self, str key, BaseTag value)
