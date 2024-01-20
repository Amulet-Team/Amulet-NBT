## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20
# cython: c_string_type=str, c_string_encoding=utf8

from collections.abc import MutableMapping, Iterable

from libcpp.string cimport string
from cython.operator cimport dereference, postincrement

from amulet_nbt._nbt cimport CCompoundTag, CCompoundTagPtr, CIntTag, TagNode
from amulet_nbt._libcpp.variant cimport get
from amulet_nbt._tag.abc cimport AbstractBaseTag, AbstractBaseMutableTag
from .int cimport IntTag


cdef class CompoundTag(AbstractBaseMutableTag, MutableMapping):
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
