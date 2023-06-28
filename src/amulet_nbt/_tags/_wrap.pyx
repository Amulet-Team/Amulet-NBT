from libcpp.string cimport string

from cpython.unicode cimport PyUnicode_FromStringAndSize
from cython.operator cimport dereference

from amulet_nbt._nbt cimport (
    read_named_tag,
    TagNode,
    get,
    ByteTag as CByteTag,
    ShortTag as CShortTag,
    IntTag as CIntTag,
    LongTag as CLongTag,
    FloatTag as CFloatTag,
    DoubleTag as CDoubleTag,
    ByteArrayTag as CByteArrayTag,
    StringTag as CStringTag,
    ListTag as CListTag,
    CompoundTag as CCompoundTag,
    IntArrayTag as CIntArrayTag,
    LongArrayTag as CLongArrayTag,
)

from amulet_nbt._errors import NBTLoadError
from amulet_nbt._tags._value cimport AbstractBaseTag
from amulet_nbt._tags._numeric._int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag
)
from amulet_nbt._tags._numeric._float cimport (
    FloatTag,
    DoubleTag
)
from amulet_nbt._tags._array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from amulet_nbt._tags._string cimport StringTag
from amulet_nbt._tags._list cimport ListTag
from amulet_nbt._tags._compound cimport CompoundTag


cdef ByteTag wrap_byte_tag(TagNode node):
    cdef ByteTag tag = ByteTag.__new__(ByteTag)
    tag.value_ = get[CByteTag](node)
    return tag


cdef ShortTag wrap_short_tag(TagNode node):
    cdef ShortTag tag = ShortTag.__new__(ShortTag)
    tag.value_ = get[CShortTag](node)
    return tag


cdef IntTag wrap_int_tag(TagNode node):
    cdef IntTag tag = IntTag.__new__(IntTag)
    tag.value_ = get[CIntTag](node)
    return tag


cdef LongTag wrap_long_tag(TagNode node):
    cdef LongTag tag = LongTag.__new__(LongTag)
    tag.value_ = get[CLongTag](node)
    return tag


cdef FloatTag wrap_float_tag(TagNode node):
    cdef FloatTag tag = FloatTag.__new__(FloatTag)
    tag.value_ = get[CFloatTag](node)
    return tag


cdef DoubleTag wrap_double_tag(TagNode node):
    cdef DoubleTag tag = DoubleTag.__new__(DoubleTag)
    tag.value_ = get[CDoubleTag](node)
    return tag


cdef ByteArrayTag wrap_byte_array_tag(TagNode node):
    cdef ByteArrayTag tag = ByteArrayTag.__new__(ByteArrayTag)
    raise NotImplementedError


cdef StringTag wrap_string_tag(TagNode node):
    cdef StringTag tag = StringTag.__new__(StringTag)
    cdef string s = get[CStringTag](node)
    tag.value_ = PyUnicode_FromStringAndSize(s.c_str(), s.size())


cdef ListTag wrap_list_tag(TagNode node):
    cdef ListTag tag = ListTag.__new__(ListTag)
    raise NotImplementedError


cdef CompoundTag wrap_compound_tag(TagNode node):
    cdef CompoundTag tag = CompoundTag.__new__(CompoundTag)
    raise NotImplementedError


cdef IntArrayTag wrap_int_array_tag(TagNode node):
    cdef IntArrayTag tag = IntArrayTag.__new__(IntArrayTag)
    raise NotImplementedError


cdef LongArrayTag wrap_long_array_tag(TagNode node):
    cdef LongArrayTag tag = LongArrayTag.__new__(LongArrayTag)
    raise NotImplementedError


cdef AbstractBaseTag wrap_tag_node(TagNode node):
    cdef size_t tag_type = node.index()
    if tag_type == 1:
        return wrap_byte_tag(node)
    elif tag_type == 2:
        return wrap_short_tag(node)
    elif tag_type == 3:
        return wrap_int_tag(node)
    elif tag_type == 4:
        return wrap_long_tag(node)
    elif tag_type == 5:
        return wrap_float_tag(node)
    elif tag_type == 6:
        return wrap_double_tag(node)
    elif tag_type == 7:
        return wrap_byte_array_tag(node)
    elif tag_type == 8:
        return wrap_string_tag(node)
    elif tag_type == 9:
        return wrap_list_tag(node)
    elif tag_type == 10:
        return wrap_compound_tag(node)
    elif tag_type == 11:
        return wrap_int_array_tag(node)
    elif tag_type == 12:
        return wrap_long_array_tag(node)
    else:
        raise NBTLoadError(f"Tag {tag_type} does not exist.")
