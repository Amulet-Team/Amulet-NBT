from .value cimport BaseImmutableTag

cdef class TAG_String(BaseImmutableTag):
    cdef unicode value_

cdef class Named_TAG_String(TAG_String):
    cdef public str name
