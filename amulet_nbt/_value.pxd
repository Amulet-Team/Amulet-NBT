from ._util cimport BufferContext


cdef class AbstractBase:
    cpdef str to_snbt(
        self,
        object indent=*,
        object indent_chr=*
    )


cdef class AbstractBaseTag(AbstractBase):
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
    cdef AbstractBaseTag read_payload(
        BufferContext buffer,
        bint little_endian
    )

cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    pass

cdef class AbstractBaseMutableTag(AbstractBaseTag):
    pass
