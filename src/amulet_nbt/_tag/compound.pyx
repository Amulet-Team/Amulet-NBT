## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

from collections.abc import MutableMapping, Iterable

from libcpp.string cimport string
from libcpp cimport bool
from cython.operator cimport dereference, postincrement

from amulet_nbt._nbt cimport CCompoundTag, CCompoundTagPtr, CIntTag, TagNode
from amulet_nbt._libcpp.variant cimport get
from amulet_nbt._tag.abc cimport AbstractBaseTag, AbstractBaseMutableTag
from .int cimport IntTag

from amulet_nbt._nbt cimport (
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CStringTag,
    CListTag,
    CCompoundTag,
    CByteArrayTag,
    CIntArrayTag,
    CLongArrayTag,
    CListTagPtr,
    CCompoundTagPtr,
    CByteArrayTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr,
    CByteList,
    CShortList,
    CIntList,
    CLongList,
    CFloatList,
    CDoubleList,
    CByteArrayList,
    CStringList,
    CListList,
    CCompoundList,
    CIntArrayList,
    CLongArrayList,
    TagNode,
)

cdef inline bool _is_byte_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 1:
        return False
    
    return get[CByteTag](dereference(a)) == get[CByteTag](dereference(b))


cdef inline bool _is_short_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 2:
        return False
    
    return get[CShortTag](dereference(a)) == get[CShortTag](dereference(b))


cdef inline bool _is_int_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 3:
        return False
    
    return get[CIntTag](dereference(a)) == get[CIntTag](dereference(b))


cdef inline bool _is_long_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 4:
        return False
    
    return get[CLongTag](dereference(a)) == get[CLongTag](dereference(b))


cdef inline bool _is_float_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 5:
        return False
    
    return get[CFloatTag](dereference(a)) == get[CFloatTag](dereference(b))


cdef inline bool _is_double_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 6:
        return False
    
    return get[CDoubleTag](dereference(a)) == get[CDoubleTag](dereference(b))


cdef inline bool _is_byte_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 7:
        return False
    
    return dereference(get[CByteArrayTagPtr](dereference(a))) == dereference(get[CByteArrayTagPtr](dereference(b)))


cdef inline bool _is_string_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 8:
        return False
    
    return get[CStringTag](dereference(a)) == get[CStringTag](dereference(b))


cdef inline bool _is_list_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 9:
        return False
    
    return is_list_eq(get[CListTagPtr](dereference(a)), get[CListTagPtr](dereference(b)))


cdef inline bool _is_compound_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 10:
        return False
    
    return is_compound_eq(get[CCompoundTagPtr](dereference(a)), get[CCompoundTagPtr](dereference(b)))


cdef inline bool _is_int_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 11:
        return False
    
    return dereference(get[CIntArrayTagPtr](dereference(a))) == dereference(get[CIntArrayTagPtr](dereference(b)))


cdef inline bool _is_long_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() != 12:
        return False
    
    return dereference(get[CLongArrayTagPtr](dereference(a))) == dereference(get[CLongArrayTagPtr](dereference(b)))


cdef bool is_compound_eq(CCompoundTagPtr a, CCompoundTagPtr b) noexcept nogil:
    if dereference(a).size() != dereference(b).size():
        return False

    cdef CCompoundTag.iterator it1 = dereference(a).begin()
    cdef CCompoundTag.iterator it2
    cdef string key
    cdef TagNode* node
    cdef size_t node_index

    while it1 != dereference(a).end():
        key = dereference(it1).first
        it2 = dereference(b).find(key)
        if it2 == dereference(b).end():
            return False
        node = &dereference(it1).second
        node_index = dereference(node).index()
        if node_index == 1:
            return _is_byte_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 2:
            return _is_short_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 3:
            return _is_int_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 4:
            return _is_long_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 5:
            return _is_float_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 6:
            return _is_double_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 7:
            return _is_byte_array_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 8:
            return _is_string_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 9:
            return _is_list_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 10:
            return _is_compound_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 11:
            return _is_int_array_tag_node_eq(node, &dereference(it2).second)
        elif node_index == 12:
            return _is_long_array_tag_node_eq(node, &dereference(it2).second)
        postincrement(it1)
    return True


cdef class CompoundTag(AbstractBaseMutableTag):
    """
    A Python wrapper around a C++ unordered map.
    Note that this class is not thread safe and inherits all the limitations of a C++ map.
    """

    def __init__(self, *args, **kwargs) -> None:
        self.update(*args, **kwargs)

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr cpp):
        cdef CompoundTag tag = CompoundTag.__new__(CompoundTag)
        tag.cpp = cpp
        return tag

    def __contains__(self, string key):
        return dereference(self.cpp).contains(key)

    def __setitem__(self, string key, AbstractBaseTag value) -> None:
        cdef TagNode node
        if isinstance(value, IntTag):
            node.emplace[CIntTag]((<IntTag> value).cpp)
        else:
            raise TypeError
        dereference(self.cpp)[<string> key] = node

    def __delitem__(self, string key) -> None:
        dereference(self.cpp).erase(key)

    def __getitem__(self, string key) -> AbstractBaseTag:
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            raise KeyError(key)

        cdef TagNode node = dereference(it).second
        cdef size_t index = node.index()
        if index == 3:
            return IntTag(get[CIntTag](node))
        else:
            raise RuntimeError

    def get(self, string key, object default = None, object cls = AbstractBaseTag):
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                raise e
            else:
                return default
        else:
            if isinstance(tag, cls):
                return tag
            elif default is None:
                raise TypeError(f"Expected tag to be of type {cls.__name__} but got {type(tag).__name__}")
            else:
                return default

    def setdefault(self, string key, AbstractBaseTag value = None, object cls = AbstractBaseTag):
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            self[key] = value
        else:
            if not isinstance(tag, cls):
                self[key] = value

    def __len__(self) -> size_t:
        return dereference(self.cpp).size()

    def __iter__(self) -> Iterable[str | bytes]:
        cdef list keys = []
        cdef CCompoundTag.iterator it = dereference(self.cpp).begin()
        cdef string key
        while it != dereference(self.cpp).end():
            key = dereference(it).first
            try:
                yield key
            except UnicodeDecodeError as e:
                yield <bytes>key
            postincrement(it)
        return keys

    def clear(self):
        dereference(self.cpp).clear()
