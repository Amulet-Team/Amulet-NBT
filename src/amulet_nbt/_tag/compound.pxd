from libcpp cimport bool
from libcpp.string cimport string

from amulet_nbt._tag._cpp cimport CCompoundTagPtr, TagNode

from .abc cimport AbstractBaseTag, AbstractBaseMutableTag
from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport ListTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag


cdef bool is_compound_eq(CCompoundTagPtr a, CCompoundTagPtr b) noexcept nogil
cdef AbstractBaseTag wrap_node(TagNode* node)


cdef class CompoundTag(AbstractBaseMutableTag):
    cdef CCompoundTagPtr cpp

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr)
