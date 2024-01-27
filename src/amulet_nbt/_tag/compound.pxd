from libcpp cimport bool
from libcpp.string cimport string

from amulet_nbt._nbt cimport CCompoundTagPtr

from .abc cimport AbstractBaseMutableTag
from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport ListTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag


cdef bool is_compound_eq(CCompoundTagPtr a, CCompoundTagPtr b) noexcept nogil


cdef class CompoundTag(AbstractBaseMutableTag):
    cdef CCompoundTagPtr cpp

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr)

    cpdef ByteTag get_byte(self, string key, ByteTag default=*)
    cpdef ShortTag get_short(self, string key, ShortTag default=*)
    cpdef IntTag get_int(self, string key, IntTag default=*)
    cpdef LongTag get_long(self, string key, LongTag default=*)
    cpdef FloatTag get_float(self, string key, FloatTag default=*)
    cpdef DoubleTag get_double(self, string key, DoubleTag default=*)
    cpdef StringTag get_string(self, string key, StringTag default=*)
    cpdef ListTag get_list(self, string key, ListTag default=*)
    cpdef CompoundTag get_compound(self, string key, CompoundTag default=*)
    cpdef ByteArrayTag get_byte_array(self, string key, ByteArrayTag default=*)
    cpdef IntArrayTag get_int_array(self, string key, IntArrayTag default=*)
    cpdef LongArrayTag get_long_array(self, string key, LongArrayTag default=*)

    cpdef ByteTag setdefault_byte(self, string key, ByteTag default= *)
    cpdef ShortTag setdefault_short(self, string key, ShortTag default= *)
    cpdef IntTag setdefault_int(self, string key, IntTag default= *)
    cpdef LongTag setdefault_long(self, string key, LongTag default= *)
    cpdef FloatTag setdefault_float(self, string key, FloatTag default= *)
    cpdef DoubleTag setdefault_double(self, string key, DoubleTag default= *)
    cpdef StringTag setdefault_string(self, string key, StringTag default= *)
    cpdef ListTag setdefault_list(self, string key, ListTag default= *)
    cpdef CompoundTag setdefault_compound(self, string key, CompoundTag default= *)
    cpdef ByteArrayTag setdefault_byte_array(self, string key, ByteArrayTag default= *)
    cpdef IntArrayTag setdefault_int_array(self, string key, IntArrayTag default= *)
    cpdef LongArrayTag setdefault_long_array(self, string key, LongArrayTag default= *)
