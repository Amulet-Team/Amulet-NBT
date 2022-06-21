from ._dtype import EncoderType


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
        bint little_endian,
        string_encoder: EncoderType,
    ) except *

    cdef void write_payload(
        self,
        object buffer,
        bint little_endian,
        string_encoder: EncoderType,
    ) except *

cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    pass

cdef class AbstractBaseMutableTag(AbstractBaseTag):
    pass
