## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

from collections.abc import Mapping, Iterable, KeysView, ItemsView, ValuesView

from libcpp.string cimport string
from libcpp cimport bool
from cython.operator cimport dereference, postincrement

from amulet_nbt._nbt cimport CCompoundTag, CCompoundTagPtr, CIntTag, TagNode
from amulet_nbt._libcpp.variant cimport get
from amulet_nbt._tag.abc cimport AbstractBaseTag, AbstractBaseMutableTag

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

from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport is_list_eq, ListTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag


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


cdef AbstractBaseTag wrap_node(TagNode* node):
    cdef size_t index = dereference(node).index()
    if index == 1:
        return ByteTag.wrap(get[CByteTag](dereference(node)))
    elif index == 2:
        return ShortTag.wrap(get[CShortTag](dereference(node)))
    elif index == 3:
        return IntTag.wrap(get[CIntTag](dereference(node)))
    elif index == 4:
        return LongTag.wrap(get[CLongTag](dereference(node)))
    elif index == 5:
        return FloatTag.wrap(get[CFloatTag](dereference(node)))
    elif index == 6:
        return DoubleTag.wrap(get[CDoubleTag](dereference(node)))
    elif index == 7:
        return ByteArrayTag.wrap(get[CByteArrayTagPtr](dereference(node)))
    elif index == 8:
        return StringTag.wrap(get[CStringTag](dereference(node)))
    elif index == 9:
        return ListTag.wrap(get[CListTagPtr](dereference(node)))
    elif index == 10:
        return CompoundTag.wrap(get[CCompoundTagPtr](dereference(node)))
    elif index == 11:
        return IntArrayTag.wrap(get[CIntArrayTagPtr](dereference(node)))
    elif index == 12:
        return LongArrayTag.wrap(get[CLongArrayTagPtr](dereference(node)))
    else:
        raise RuntimeError


cdef class CompoundTag(AbstractBaseMutableTag):
    """
    A Python wrapper around a C++ unordered map.
    Note that this class is not thread safe and inherits all the limitations of a C++ unordered_map.
    """

    def __init__(self, *args, **kwargs) -> None:
        self.update(*args, **kwargs)

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr cpp):
        cdef CompoundTag tag = CompoundTag.__new__(CompoundTag)
        tag.cpp = cpp
        return tag

    def __eq__(CompoundTag self, object other):
        if not isinstance(other, CompoundTag):
            return False
        cdef CompoundTag tag = other
        return is_compound_eq(self.cpp, tag.cpp)

    # Sized
    def __len__(self) -> size_t:
        return dereference(self.cpp).size()

    # Iterable
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

    # Mapping
    def __getitem__(self, string key) -> AbstractBaseTag:
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            raise KeyError(key)

        return wrap_node(&dereference(it).second)

    def get(self, string key, object default = None, object cls = AbstractBaseTag):
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if default is None:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, cls):
            return tag
        elif default is None:
            raise TypeError(f"Expected tag to be of type {cls.__name__} but got {type(tag).__name__}")
        else:
            return default

    def __contains__(self, string key):
        return dereference(self.cpp).contains(key)

    def keys(self):
        return KeysView(self)

    def items(self):
        return ItemsView(self)

    def values(self):
        return ValuesView(self)

    # MutableMapping
    def __setitem__(self, string key, AbstractBaseTag value not None) -> None:
        cdef TagNode node
        if isinstance(value, ByteTag):
            node.emplace[CByteTag]((<ByteTag> value).cpp)
        elif isinstance(value, ShortTag):
            node.emplace[CShortTag]((<ShortTag> value).cpp)
        elif isinstance(value, IntTag):
            node.emplace[CIntTag]((<IntTag> value).cpp)
        elif isinstance(value, LongTag):
            node.emplace[CLongTag]((<LongTag> value).cpp)
        elif isinstance(value, FloatTag):
            node.emplace[CFloatTag]((<FloatTag> value).cpp)
        elif isinstance(value, DoubleTag):
            node.emplace[CDoubleTag]((<DoubleTag> value).cpp)
        elif isinstance(value, ByteArrayTag):
            node.emplace[CByteArrayTagPtr]((<ByteArrayTag> value).cpp)
        elif isinstance(value, StringTag):
            node.emplace[CStringTag]((<StringTag> value).cpp)
        elif isinstance(value, ListTag):
            node.emplace[CListTagPtr]((<ListTag> value).cpp)
        elif isinstance(value, CompoundTag):
            node.emplace[CCompoundTagPtr]((<CompoundTag> value).cpp)
        elif isinstance(value, IntArrayTag):
            node.emplace[CIntArrayTagPtr]((<IntArrayTag> value).cpp)
        elif isinstance(value, LongArrayTag):
            node.emplace[CLongArrayTagPtr]((<LongArrayTag> value).cpp)
        else:
            raise TypeError
        dereference(self.cpp)[<string> key] = node

    def __delitem__(self, string key) -> None:
        dereference(self.cpp).erase(key)

    __marker = object()

    def pop(self, string key, default=__marker):
        '''D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
          If key is not found, d is returned if given, otherwise KeyError is raised.
        '''
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)
        if it == dereference(self.cpp).end():
            if default is self.__marker:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        dereference(self.cpp).erase(it)
        return tag

    def popitem(self):
        '''D.popitem() -> (k, v), remove and return some (key, value) pair
           as a 2-tuple; but raise KeyError if D is empty.
        '''
        cdef CCompoundTag.iterator it = dereference(self.cpp).begin()
        if it == dereference(self.cpp).end():
            raise KeyError

        cdef string key = dereference(it).first
        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        dereference(self.cpp).erase(it)
        return key, tag

    def clear(self):
        dereference(self.cpp).clear()

    def update(self, other=(), /, **kwds):
        ''' D.update([E, ]**F) -> None.  Update D from mapping/iterable E and F.
            If E present and has a .keys() method, does:     for k in E: D[k] = E[k]
            If E present and lacks .keys() method, does:     for (k, v) in E: D[k] = v
            In either case, this is followed by: for k, v in F.items(): D[k] = v
        '''
        if isinstance(other, Mapping):
            for key in other:
                self[key] = other[key]
        elif hasattr(other, "keys"):
            for key in other.keys():
                self[key] = other[key]
        else:
            for key, value in other:
                self[key] = value
        for key, value in kwds.items():
            self[key] = value

    def setdefault(self, string key, AbstractBaseTag tag not None, object cls = AbstractBaseTag):
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            # if the key does not exist then set it
            self[key] = tag
            return tag

        cdef AbstractBaseTag existing_tag = wrap_node(&dereference(it).second)

        if not isinstance(tag, cls):
            # if the key exists but has the wrong type then set it
            self[key] = tag
            return tag

        return existing_tag
