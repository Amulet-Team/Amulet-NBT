from ._value cimport AbstractBaseTag, AbstractBaseMutableTag
from ._util cimport BufferContext
from ._dtype import DecoderType
from ._int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from ._float cimport (
    FloatTag,
    DoubleTag,
)
from ._array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from ._string cimport StringTag
from ._compound cimport CyCompoundTag


cdef CyListTag read_list_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType)

cdef class CyListTag(AbstractBaseMutableTag):
    cdef list value_
    cdef readonly char list_data_type

    cdef void _check_tag(self, AbstractBaseTag value, bint fix_if_empty=*) except *
    cdef void _check_tag_iterable(self, list value) except *

    cpdef ByteTag get_byte(self, int index)
    cpdef ShortTag get_short(self, int index)
    cpdef IntTag get_int(self, int index)
    cpdef LongTag get_long(self, int index)
    cpdef FloatTag get_float(self, int index)
    cpdef DoubleTag get_double(self, int index)
    cpdef StringTag get_string(self, int index)
    cpdef CyListTag get_list(self, int index)
    cpdef CyCompoundTag get_compound(self, int index)
    cpdef ByteArrayTag get_byte_array(self, int index)
    cpdef IntArrayTag get_int_array(self, int index)
    cpdef LongArrayTag get_long_array(self, int index)
