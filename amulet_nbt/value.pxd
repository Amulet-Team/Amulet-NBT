from .util cimport BufferContext

cdef class BaseTag:
    cpdef str to_snbt(
        self,
        object indent=*,
        object indent_chr=*
    )
    cdef str _to_snbt(self)

    cdef str _pretty_to_snbt(
        self,
        str indent_chr,
        int indent_count=*,
        bint leading_indent=*
    )

    cdef void write_tag(
        self,
        object buffer,
        str name,
        bint little_endian
    ) except *

    cdef void write_payload(
        self,
        object buffer,
        bint little_endian
    ) except *

    @staticmethod
    cdef BaseTag read_payload(
        BufferContext buffer,
        bint little_endian
    )

    cpdef bint strict_equals(self, other)

cdef class BaseImmutableTag(BaseTag):
    pass

cdef class BaseMutableTag(BaseTag):
    pass
