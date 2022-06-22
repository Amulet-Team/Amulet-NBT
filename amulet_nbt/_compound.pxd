from ._value cimport AbstractBaseMutableTag
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
from ._list cimport CyListTag


cdef CyCompoundTag read_compound_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType)

cdef class CyCompoundTag(AbstractBaseMutableTag):
    cdef dict value_
    
    cpdef ByteTag get_byte(self, str key, ByteTag default=*)
    cpdef ShortTag get_short(self, str key, ShortTag default=*)
    cpdef IntTag get_int(self, str key, IntTag default=*)
    cpdef LongTag get_long(self, str key, LongTag default=*)
    cpdef FloatTag get_float(self, str key, FloatTag default=*)
    cpdef DoubleTag get_double(self, str key, DoubleTag default=*)
    cpdef StringTag get_string(self, str key, StringTag default=*)
    cpdef CyListTag get_list(self, str key, CyListTag default=*)
    cpdef CyCompoundTag get_compound(self, str key, CyCompoundTag default=*)
    cpdef ByteArrayTag get_byte_array(self, str key, ByteArrayTag default=*)
    cpdef IntArrayTag get_int_array(self, str key, IntArrayTag default=*)
    cpdef LongArrayTag get_long_array(self, str key, LongArrayTag default=*)

    cpdef ByteTag setdefault_byte(self, str key, ByteTag default= *)
    cpdef ShortTag setdefault_short(self, str key, ShortTag default= *)
    cpdef IntTag setdefault_int(self, str key, IntTag default= *)
    cpdef LongTag setdefault_long(self, str key, LongTag default= *)
    cpdef FloatTag setdefault_float(self, str key, FloatTag default= *)
    cpdef DoubleTag setdefault_double(self, str key, DoubleTag default= *)
    cpdef StringTag setdefault_string(self, str key, StringTag default= *)
    cpdef CyListTag setdefault_list(self, str key, CyListTag default= *)
    cpdef CyCompoundTag setdefault_compound(self, str key, CyCompoundTag default= *)
    cpdef ByteArrayTag setdefault_byte_array(self, str key, ByteArrayTag default= *)
    cpdef IntArrayTag setdefault_int_array(self, str key, IntArrayTag default= *)
    cpdef LongArrayTag setdefault_long_array(self, str key, LongArrayTag default= *)
