## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8
# distutils: sources = [src/amulet_nbt/_string_encoding/_cpp/utf8.cpp, src/amulet_nbt/_nbt_encoding/_binary/_cpp/read_nbt.cpp]

from __future__ import annotations

from collections.abc import Mapping, Iterator, Iterable, KeysView, ItemsView, ValuesView
from typing import Any, overload, Type, TypeVar, Literal

from libcpp.string cimport string
from libcpp cimport bool
from libcpp.pair cimport pair
from libcpp.memory cimport make_shared
from cython.operator cimport dereference, postincrement
import amulet_nbt
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._string_encoding._cpp.utf8 cimport utf8_escape_to_utf8, utf8_to_utf8_escape
from amulet_nbt._nbt_encoding._binary._cpp cimport read_named_tag
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_compound_snbt

from amulet_nbt._tag._cpp cimport CCompoundTag, CCompoundTagPtr, CIntTag, TagNode
from amulet_nbt._libcpp.variant cimport get
from .abc cimport AbstractBaseTag, AbstractBaseMutableTag

from amulet_nbt._tag._cpp cimport (
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CStringTag,
    CCompoundTag,
    CListTagPtr,
    CCompoundTagPtr,
    CByteArrayTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr,
    TagNode,
)

from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .list cimport is_list_eq, ListTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag
from .deepcopy cimport CCompoundTagPtr_deepcopy

import amulet_nbt

_T = TypeVar("_T")

cdef inline bool _is_byte_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 1:
        return get[CByteTag](dereference(a)) == get[CByteTag](dereference(b))
    return False


cdef inline bool _is_short_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 2:
        return get[CShortTag](dereference(a)) == get[CShortTag](dereference(b))
    return False


cdef inline bool _is_int_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 3:
        return get[CIntTag](dereference(a)) == get[CIntTag](dereference(b))
    return False


cdef inline bool _is_long_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 4:
        return get[CLongTag](dereference(a)) == get[CLongTag](dereference(b))
    return False


cdef inline bool _is_float_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 5:
        return get[CFloatTag](dereference(a)) == get[CFloatTag](dereference(b))
    return False


cdef inline bool _is_double_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 6:
        return get[CDoubleTag](dereference(a)) == get[CDoubleTag](dereference(b))
    return False


cdef inline bool _is_byte_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 7:
        return dereference(get[CByteArrayTagPtr](dereference(a))) == dereference(get[CByteArrayTagPtr](dereference(b)))
    return False


cdef inline bool _is_string_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 8:
        return get[CStringTag](dereference(a)) == get[CStringTag](dereference(b))
    return False


cdef inline bool _is_list_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 9:
        return is_list_eq(get[CListTagPtr](dereference(a)), get[CListTagPtr](dereference(b)))
    return False


cdef inline bool _is_compound_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 10:
        return is_compound_eq(get[CCompoundTagPtr](dereference(a)), get[CCompoundTagPtr](dereference(b)))
    return False


cdef inline bool _is_int_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 11:
        return dereference(get[CIntArrayTagPtr](dereference(a))) == dereference(get[CIntArrayTagPtr](dereference(b)))
    return False


cdef inline bool _is_long_array_tag_node_eq(TagNode* a, TagNode* b) noexcept nogil:
    if dereference(b).index() == 12:
        return dereference(get[CLongArrayTagPtr](dereference(a))) == dereference(get[CLongArrayTagPtr](dereference(b)))
    return False


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
            if not _is_byte_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 2:
            if not _is_short_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 3:
            if not _is_int_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 4:
            if not _is_long_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 5:
            if not _is_float_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 6:
            if not _is_double_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 7:
            if not _is_byte_array_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 8:
            if not _is_string_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 9:
            if not _is_list_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 10:
            if not _is_compound_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 11:
            if not _is_int_array_tag_node_eq(node, &dereference(it2).second):
                return False
        elif node_index == 12:
            if not _is_long_array_tag_node_eq(node, &dereference(it2).second):
                return False
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


_TagT = TypeVar("_TagT", bound=AbstractBaseTag)


def _unpickle(string data) -> CompoundTag:
    cdef pair[string, TagNode] named_tag = read_named_tag(data, endian.big, utf8_to_utf8_escape)
    return CompoundTag.wrap(get[CCompoundTagPtr](named_tag.second))


cdef class CompoundTag(AbstractBaseMutableTag):
    """A Python wrapper around a C++ unordered map.

    Note that this class is not thread safe and inherits all the limitations of a C++ unordered_map.
    """
    tag_id: int = 10

    def __init__(
        self,
        value: (
            Mapping[str | bytes, AbstractBaseTag]
            | Iterable[tuple[str | bytes, AbstractBaseTag]]
            | Mapping[str, AbstractBaseTag]
            | Mapping[bytes, AbstractBaseTag]
        ) = (),
        **kwargs: AbstractBaseTag,
    ) -> None:
        self.cpp = make_shared[CCompoundTag]()
        self.update(value, **kwargs)

    @staticmethod
    cdef CompoundTag wrap(CCompoundTagPtr cpp):
        cdef CompoundTag tag = CompoundTag.__new__(CompoundTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CCompoundTagPtr](self.cpp)
        return node

    @property
    def py_dict(self) -> dict[str, amulet_nbt.AnyNBT]:
        """A shallow copy of the CompoundTag as a python dictionary."""
        return dict(self)

    @property
    def py_data(self) -> Any:
        return dict(self)

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CCompoundTagPtr](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        cdef string indent_str
        if indent is None:
            write_compound_snbt(snbt, self.cpp)
        else:
            if isinstance(indent, int):
                indent_str = " " * indent
            elif isinstance(indent, str):
                indent_str = indent
            else:
                raise TypeError("indent must be a str, int or None")
            write_compound_snbt(snbt, self.cpp, indent_str, 0)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, CompoundTag):
            return False
        cdef CompoundTag tag = other
        return is_compound_eq(self.cpp, tag.cpp)

    def __repr__(self) -> str:
        return f"CompoundTag({dict(self)})"

    def __str__(self) -> str:
        return str(dict(self))

    def __reduce__(self):
        cdef bytes nbt = self.write_nbt(b"", endian.big, utf8_escape_to_utf8)
        return _unpickle, (nbt,)

    def __copy__(self) -> CompoundTag:
        return CompoundTag.wrap(
            make_shared[CCompoundTag](dereference(self.cpp))
        )

    def __deepcopy__(self, memo=None) -> CompoundTag:
        return CompoundTag.wrap(CCompoundTagPtr_deepcopy(self.cpp))

    # Sized
    def __len__(self) -> int:
        return dereference(self.cpp).size()

    # Iterable
    def __iter__(self) -> Iterator[str | bytes]:
        cdef CCompoundTag.iterator it = dereference(self.cpp).begin()
        cdef string key
        while it != dereference(self.cpp).end():
            key = dereference(it).first
            try:
                yield <str>key
            except UnicodeDecodeError as e:
                yield <bytes>key
            postincrement(it)

    # Mapping
    def __getitem__(self, string key: str | bytes) -> amulet_nbt.AbstractBaseTag:
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            raise KeyError(key)

        return wrap_node(&dereference(it).second)

    @overload
    def get(self, key: str | bytes) -> AnyNBT | None: ...
    @overload
    def get(self, key: str | bytes, default: _T) -> AnyNBT | _T: ...
    @overload
    def get(self, key: str | bytes, *, cls: Type[_TagT]) -> _TagT | None: ...
    @overload
    def get(self, key: str | bytes, default: _T, cls: Type[_TagT]) -> _TagT | _T: ...

    def get(
        self,
        string key: str | bytes,
        object default: _T = None,
        object cls: Type[_TagT] = AbstractBaseTag
    ) -> _TagT | _T:
        """Get an item from the CompoundTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param cls: The class that the stored tag must inherit from. If the type is incorrect default is returned.
        :return: The tag stored in the CompoundTag if the type is correct else default.
        :raises: KeyError if the key does not exist.
        :raises: TypeError if the stored type is not a subclass of cls.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, cls):
            return tag
        else:
            return default

    def __contains__(self, string key: str | bytes) -> bool:
        return dereference(self.cpp).contains(key)

    def keys(self) -> KeysView[str | bytes]:
        return KeysView(self)

    def items(self) -> ItemsView[str | bytes, amulet_nbt.AnyNBT]:
        return ItemsView(self)

    def values(self) -> ValuesView[amulet_nbt.AnyNBT]:
        return ValuesView(self)

    # MutableMapping
    def __setitem__(self, string key: str | bytes, AbstractBaseTag tag not None: amulet_nbt.AnyNBT) -> None:
        dereference(self.cpp)[<string> key] = tag.to_node()

    def __delitem__(self, string key: str | bytes) -> None:
        dereference(self.cpp).erase(key)

    __marker = object()

    def pop(self, string key, default=__marker) -> amulet_nbt.AnyNBT:
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

    def popitem(self) -> amulet_nbt.AnyNBT:
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

    def clear(self) -> None:
        dereference(self.cpp).clear()

    def update(self, other=(), /, **kwds) -> None:
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

    def setdefault(self, string key, AbstractBaseTag tag = None, object cls = AbstractBaseTag) -> amulet_nbt.AnyNBT:
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            # if the key does not exist then set it
            if tag is None:
                raise TypeError("Cannot setdefault a value of None.")
            self[key] = tag
            return tag

        cdef AbstractBaseTag existing_tag = wrap_node(&dereference(it).second)

        if not isinstance(existing_tag, cls):
            # if the key exists but has the wrong type then set it
            if tag is None:
                raise TypeError("Cannot setdefault a value of None.")
            self[key] = tag
            return tag

        return existing_tag

    @classmethod
    def fromkeys(cls, keys: Iterable[str], AbstractBaseTag value) -> CompoundTag:
        return cls(dict.fromkeys(keys, value))

    @overload
    def get_byte(self, key: str | bytes) -> amulet_nbt.ByteTag | None: ...
    @overload
    def get_byte(self, key: str | bytes, default: None) -> amulet_nbt.ByteTag | None: ...
    @overload
    def get_byte(self, key: str | bytes, default: amulet_nbt.ByteTag) -> amulet_nbt.ByteTag: ...
    @overload
    def get_byte(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ByteTag | None: ...
    @overload
    def get_byte(self, key: str | bytes, default: amulet_nbt.ByteTag, raise_errors: Literal[False]) -> amulet_nbt.ByteTag: ...
    @overload
    def get_byte(self, key: str | bytes, default: amulet_nbt.ByteTag | None, raise_errors: Literal[True]) -> amulet_nbt.ByteTag: ...
    @overload
    def get_byte(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ByteTag | None: ...
    @overload
    def get_byte(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ByteTag: ...

    def get_byte(self, string key: str | bytes, ByteTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ByteTag | _T:
        """Get the tag stored in key if it is a ByteTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ByteTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_byte(self, string key: str | bytes, ByteTag default: amulet_nbt.ByteTag | None = None) -> amulet_nbt.ByteTag:
        """Populate key if not defined or value is not ByteTag. Return the value stored.
    
        If default is a ByteTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ByteTag is used.
        :return: The ByteTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = ByteTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, ByteTag):
                if default is None:
                    tag = self[key] = ByteTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_byte(self, key: str | bytes) -> amulet_nbt.ByteTag | None: ...
    @overload
    def pop_byte(self, key: str | bytes, default: None) -> amulet_nbt.ByteTag | None: ...
    @overload
    def pop_byte(self, key: str | bytes, default: amulet_nbt.ByteTag) -> amulet_nbt.ByteTag: ...
    @overload
    def pop_byte(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ByteTag | None: ...
    @overload
    def pop_byte(self, key: str | bytes, default: amulet_nbt.ByteTag, raise_errors: Literal[False]) -> amulet_nbt.ByteTag: ...
    @overload
    def pop_byte(self, key: str | bytes, default: amulet_nbt.ByteTag | None, raise_errors: Literal[True]) -> amulet_nbt.ByteTag: ...
    @overload
    def pop_byte(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ByteTag | None: ...
    @overload
    def pop_byte(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ByteTag: ...

    def pop_byte(self, string key: str | bytes, ByteTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ByteTag | _T:
        """Remove the specified key and return the corresponding value if it is a ByteTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ByteTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_short(self, key: str | bytes) -> amulet_nbt.ShortTag | None: ...
    @overload
    def get_short(self, key: str | bytes, default: None) -> amulet_nbt.ShortTag | None: ...
    @overload
    def get_short(self, key: str | bytes, default: amulet_nbt.ShortTag) -> amulet_nbt.ShortTag: ...
    @overload
    def get_short(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ShortTag | None: ...
    @overload
    def get_short(self, key: str | bytes, default: amulet_nbt.ShortTag, raise_errors: Literal[False]) -> amulet_nbt.ShortTag: ...
    @overload
    def get_short(self, key: str | bytes, default: amulet_nbt.ShortTag | None, raise_errors: Literal[True]) -> amulet_nbt.ShortTag: ...
    @overload
    def get_short(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ShortTag | None: ...
    @overload
    def get_short(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ShortTag: ...

    def get_short(self, string key: str | bytes, ShortTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ShortTag | _T:
        """Get the tag stored in key if it is a ShortTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ShortTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ShortTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ShortTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_short(self, string key: str | bytes, ShortTag default: amulet_nbt.ShortTag | None = None) -> amulet_nbt.ShortTag:
        """Populate key if not defined or value is not ShortTag. Return the value stored.
    
        If default is a ShortTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ShortTag is used.
        :return: The ShortTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = ShortTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, ShortTag):
                if default is None:
                    tag = self[key] = ShortTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_short(self, key: str | bytes) -> amulet_nbt.ShortTag | None: ...
    @overload
    def pop_short(self, key: str | bytes, default: None) -> amulet_nbt.ShortTag | None: ...
    @overload
    def pop_short(self, key: str | bytes, default: amulet_nbt.ShortTag) -> amulet_nbt.ShortTag: ...
    @overload
    def pop_short(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ShortTag | None: ...
    @overload
    def pop_short(self, key: str | bytes, default: amulet_nbt.ShortTag, raise_errors: Literal[False]) -> amulet_nbt.ShortTag: ...
    @overload
    def pop_short(self, key: str | bytes, default: amulet_nbt.ShortTag | None, raise_errors: Literal[True]) -> amulet_nbt.ShortTag: ...
    @overload
    def pop_short(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ShortTag | None: ...
    @overload
    def pop_short(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ShortTag: ...

    def pop_short(self, string key: str | bytes, ShortTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ShortTag | _T:
        """Remove the specified key and return the corresponding value if it is a ShortTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ShortTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ShortTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ShortTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_int(self, key: str | bytes) -> amulet_nbt.IntTag | None: ...
    @overload
    def get_int(self, key: str | bytes, default: None) -> amulet_nbt.IntTag | None: ...
    @overload
    def get_int(self, key: str | bytes, default: amulet_nbt.IntTag) -> amulet_nbt.IntTag: ...
    @overload
    def get_int(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.IntTag | None: ...
    @overload
    def get_int(self, key: str | bytes, default: amulet_nbt.IntTag, raise_errors: Literal[False]) -> amulet_nbt.IntTag: ...
    @overload
    def get_int(self, key: str | bytes, default: amulet_nbt.IntTag | None, raise_errors: Literal[True]) -> amulet_nbt.IntTag: ...
    @overload
    def get_int(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.IntTag | None: ...
    @overload
    def get_int(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.IntTag: ...

    def get_int(self, string key: str | bytes, IntTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.IntTag | _T:
        """Get the tag stored in key if it is a IntTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, IntTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_int(self, string key: str | bytes, IntTag default: amulet_nbt.IntTag | None = None) -> amulet_nbt.IntTag:
        """Populate key if not defined or value is not IntTag. Return the value stored.
    
        If default is a IntTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default IntTag is used.
        :return: The IntTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = IntTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, IntTag):
                if default is None:
                    tag = self[key] = IntTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_int(self, key: str | bytes) -> amulet_nbt.IntTag | None: ...
    @overload
    def pop_int(self, key: str | bytes, default: None) -> amulet_nbt.IntTag | None: ...
    @overload
    def pop_int(self, key: str | bytes, default: amulet_nbt.IntTag) -> amulet_nbt.IntTag: ...
    @overload
    def pop_int(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.IntTag | None: ...
    @overload
    def pop_int(self, key: str | bytes, default: amulet_nbt.IntTag, raise_errors: Literal[False]) -> amulet_nbt.IntTag: ...
    @overload
    def pop_int(self, key: str | bytes, default: amulet_nbt.IntTag | None, raise_errors: Literal[True]) -> amulet_nbt.IntTag: ...
    @overload
    def pop_int(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.IntTag | None: ...
    @overload
    def pop_int(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.IntTag: ...

    def pop_int(self, string key: str | bytes, IntTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.IntTag | _T:
        """Remove the specified key and return the corresponding value if it is a IntTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, IntTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_long(self, key: str | bytes) -> amulet_nbt.LongTag | None: ...
    @overload
    def get_long(self, key: str | bytes, default: None) -> amulet_nbt.LongTag | None: ...
    @overload
    def get_long(self, key: str | bytes, default: amulet_nbt.LongTag) -> amulet_nbt.LongTag: ...
    @overload
    def get_long(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.LongTag | None: ...
    @overload
    def get_long(self, key: str | bytes, default: amulet_nbt.LongTag, raise_errors: Literal[False]) -> amulet_nbt.LongTag: ...
    @overload
    def get_long(self, key: str | bytes, default: amulet_nbt.LongTag | None, raise_errors: Literal[True]) -> amulet_nbt.LongTag: ...
    @overload
    def get_long(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.LongTag | None: ...
    @overload
    def get_long(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.LongTag: ...

    def get_long(self, string key: str | bytes, LongTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.LongTag | _T:
        """Get the tag stored in key if it is a LongTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, LongTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_long(self, string key: str | bytes, LongTag default: amulet_nbt.LongTag | None = None) -> amulet_nbt.LongTag:
        """Populate key if not defined or value is not LongTag. Return the value stored.
    
        If default is a LongTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default LongTag is used.
        :return: The LongTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = LongTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, LongTag):
                if default is None:
                    tag = self[key] = LongTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_long(self, key: str | bytes) -> amulet_nbt.LongTag | None: ...
    @overload
    def pop_long(self, key: str | bytes, default: None) -> amulet_nbt.LongTag | None: ...
    @overload
    def pop_long(self, key: str | bytes, default: amulet_nbt.LongTag) -> amulet_nbt.LongTag: ...
    @overload
    def pop_long(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.LongTag | None: ...
    @overload
    def pop_long(self, key: str | bytes, default: amulet_nbt.LongTag, raise_errors: Literal[False]) -> amulet_nbt.LongTag: ...
    @overload
    def pop_long(self, key: str | bytes, default: amulet_nbt.LongTag | None, raise_errors: Literal[True]) -> amulet_nbt.LongTag: ...
    @overload
    def pop_long(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.LongTag | None: ...
    @overload
    def pop_long(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.LongTag: ...

    def pop_long(self, string key: str | bytes, LongTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.LongTag | _T:
        """Remove the specified key and return the corresponding value if it is a LongTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, LongTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_float(self, key: str | bytes) -> amulet_nbt.FloatTag | None: ...
    @overload
    def get_float(self, key: str | bytes, default: None) -> amulet_nbt.FloatTag | None: ...
    @overload
    def get_float(self, key: str | bytes, default: amulet_nbt.FloatTag) -> amulet_nbt.FloatTag: ...
    @overload
    def get_float(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.FloatTag | None: ...
    @overload
    def get_float(self, key: str | bytes, default: amulet_nbt.FloatTag, raise_errors: Literal[False]) -> amulet_nbt.FloatTag: ...
    @overload
    def get_float(self, key: str | bytes, default: amulet_nbt.FloatTag | None, raise_errors: Literal[True]) -> amulet_nbt.FloatTag: ...
    @overload
    def get_float(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.FloatTag | None: ...
    @overload
    def get_float(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.FloatTag: ...

    def get_float(self, string key: str | bytes, FloatTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.FloatTag | _T:
        """Get the tag stored in key if it is a FloatTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The FloatTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a FloatTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, FloatTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_float(self, string key: str | bytes, FloatTag default: amulet_nbt.FloatTag | None = None) -> amulet_nbt.FloatTag:
        """Populate key if not defined or value is not FloatTag. Return the value stored.
    
        If default is a FloatTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default FloatTag is used.
        :return: The FloatTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = FloatTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, FloatTag):
                if default is None:
                    tag = self[key] = FloatTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_float(self, key: str | bytes) -> amulet_nbt.FloatTag | None: ...
    @overload
    def pop_float(self, key: str | bytes, default: None) -> amulet_nbt.FloatTag | None: ...
    @overload
    def pop_float(self, key: str | bytes, default: amulet_nbt.FloatTag) -> amulet_nbt.FloatTag: ...
    @overload
    def pop_float(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.FloatTag | None: ...
    @overload
    def pop_float(self, key: str | bytes, default: amulet_nbt.FloatTag, raise_errors: Literal[False]) -> amulet_nbt.FloatTag: ...
    @overload
    def pop_float(self, key: str | bytes, default: amulet_nbt.FloatTag | None, raise_errors: Literal[True]) -> amulet_nbt.FloatTag: ...
    @overload
    def pop_float(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.FloatTag | None: ...
    @overload
    def pop_float(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.FloatTag: ...

    def pop_float(self, string key: str | bytes, FloatTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.FloatTag | _T:
        """Remove the specified key and return the corresponding value if it is a FloatTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The FloatTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a FloatTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, FloatTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_double(self, key: str | bytes) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def get_double(self, key: str | bytes, default: None) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def get_double(self, key: str | bytes, default: amulet_nbt.DoubleTag) -> amulet_nbt.DoubleTag: ...
    @overload
    def get_double(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def get_double(self, key: str | bytes, default: amulet_nbt.DoubleTag, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag: ...
    @overload
    def get_double(self, key: str | bytes, default: amulet_nbt.DoubleTag | None, raise_errors: Literal[True]) -> amulet_nbt.DoubleTag: ...
    @overload
    def get_double(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def get_double(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.DoubleTag: ...

    def get_double(self, string key: str | bytes, DoubleTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.DoubleTag | _T:
        """Get the tag stored in key if it is a DoubleTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The DoubleTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a DoubleTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, DoubleTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_double(self, string key: str | bytes, DoubleTag default: amulet_nbt.DoubleTag | None = None) -> amulet_nbt.DoubleTag:
        """Populate key if not defined or value is not DoubleTag. Return the value stored.
    
        If default is a DoubleTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default DoubleTag is used.
        :return: The DoubleTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = DoubleTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, DoubleTag):
                if default is None:
                    tag = self[key] = DoubleTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_double(self, key: str | bytes) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def pop_double(self, key: str | bytes, default: None) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def pop_double(self, key: str | bytes, default: amulet_nbt.DoubleTag) -> amulet_nbt.DoubleTag: ...
    @overload
    def pop_double(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def pop_double(self, key: str | bytes, default: amulet_nbt.DoubleTag, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag: ...
    @overload
    def pop_double(self, key: str | bytes, default: amulet_nbt.DoubleTag | None, raise_errors: Literal[True]) -> amulet_nbt.DoubleTag: ...
    @overload
    def pop_double(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.DoubleTag | None: ...
    @overload
    def pop_double(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.DoubleTag: ...

    def pop_double(self, string key: str | bytes, DoubleTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.DoubleTag | _T:
        """Remove the specified key and return the corresponding value if it is a DoubleTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The DoubleTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a DoubleTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, DoubleTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_string(self, key: str | bytes) -> amulet_nbt.StringTag | None: ...
    @overload
    def get_string(self, key: str | bytes, default: None) -> amulet_nbt.StringTag | None: ...
    @overload
    def get_string(self, key: str | bytes, default: amulet_nbt.StringTag) -> amulet_nbt.StringTag: ...
    @overload
    def get_string(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.StringTag | None: ...
    @overload
    def get_string(self, key: str | bytes, default: amulet_nbt.StringTag, raise_errors: Literal[False]) -> amulet_nbt.StringTag: ...
    @overload
    def get_string(self, key: str | bytes, default: amulet_nbt.StringTag | None, raise_errors: Literal[True]) -> amulet_nbt.StringTag: ...
    @overload
    def get_string(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.StringTag | None: ...
    @overload
    def get_string(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.StringTag: ...

    def get_string(self, string key: str | bytes, StringTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.StringTag | _T:
        """Get the tag stored in key if it is a StringTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The StringTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a StringTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, StringTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_string(self, string key: str | bytes, StringTag default: amulet_nbt.StringTag | None = None) -> amulet_nbt.StringTag:
        """Populate key if not defined or value is not StringTag. Return the value stored.
    
        If default is a StringTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default StringTag is used.
        :return: The StringTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = StringTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, StringTag):
                if default is None:
                    tag = self[key] = StringTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_string(self, key: str | bytes) -> amulet_nbt.StringTag | None: ...
    @overload
    def pop_string(self, key: str | bytes, default: None) -> amulet_nbt.StringTag | None: ...
    @overload
    def pop_string(self, key: str | bytes, default: amulet_nbt.StringTag) -> amulet_nbt.StringTag: ...
    @overload
    def pop_string(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.StringTag | None: ...
    @overload
    def pop_string(self, key: str | bytes, default: amulet_nbt.StringTag, raise_errors: Literal[False]) -> amulet_nbt.StringTag: ...
    @overload
    def pop_string(self, key: str | bytes, default: amulet_nbt.StringTag | None, raise_errors: Literal[True]) -> amulet_nbt.StringTag: ...
    @overload
    def pop_string(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.StringTag | None: ...
    @overload
    def pop_string(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.StringTag: ...

    def pop_string(self, string key: str | bytes, StringTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.StringTag | _T:
        """Remove the specified key and return the corresponding value if it is a StringTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The StringTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a StringTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, StringTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_list(self, key: str | bytes) -> amulet_nbt.ListTag | None: ...
    @overload
    def get_list(self, key: str | bytes, default: None) -> amulet_nbt.ListTag | None: ...
    @overload
    def get_list(self, key: str | bytes, default: amulet_nbt.ListTag) -> amulet_nbt.ListTag: ...
    @overload
    def get_list(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ListTag | None: ...
    @overload
    def get_list(self, key: str | bytes, default: amulet_nbt.ListTag, raise_errors: Literal[False]) -> amulet_nbt.ListTag: ...
    @overload
    def get_list(self, key: str | bytes, default: amulet_nbt.ListTag | None, raise_errors: Literal[True]) -> amulet_nbt.ListTag: ...
    @overload
    def get_list(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ListTag | None: ...
    @overload
    def get_list(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ListTag: ...

    def get_list(self, string key: str | bytes, ListTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ListTag | _T:
        """Get the tag stored in key if it is a ListTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ListTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ListTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ListTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_list(self, string key: str | bytes, ListTag default: amulet_nbt.ListTag | None = None) -> amulet_nbt.ListTag:
        """Populate key if not defined or value is not ListTag. Return the value stored.
    
        If default is a ListTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ListTag is used.
        :return: The ListTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = ListTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, ListTag):
                if default is None:
                    tag = self[key] = ListTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_list(self, key: str | bytes) -> amulet_nbt.ListTag | None: ...
    @overload
    def pop_list(self, key: str | bytes, default: None) -> amulet_nbt.ListTag | None: ...
    @overload
    def pop_list(self, key: str | bytes, default: amulet_nbt.ListTag) -> amulet_nbt.ListTag: ...
    @overload
    def pop_list(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ListTag | None: ...
    @overload
    def pop_list(self, key: str | bytes, default: amulet_nbt.ListTag, raise_errors: Literal[False]) -> amulet_nbt.ListTag: ...
    @overload
    def pop_list(self, key: str | bytes, default: amulet_nbt.ListTag | None, raise_errors: Literal[True]) -> amulet_nbt.ListTag: ...
    @overload
    def pop_list(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ListTag | None: ...
    @overload
    def pop_list(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ListTag: ...

    def pop_list(self, string key: str | bytes, ListTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ListTag | _T:
        """Remove the specified key and return the corresponding value if it is a ListTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ListTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ListTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ListTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_compound(self, key: str | bytes) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def get_compound(self, key: str | bytes, default: None) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def get_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag) -> amulet_nbt.CompoundTag: ...
    @overload
    def get_compound(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def get_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag: ...
    @overload
    def get_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag | None, raise_errors: Literal[True]) -> amulet_nbt.CompoundTag: ...
    @overload
    def get_compound(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def get_compound(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.CompoundTag: ...

    def get_compound(self, string key: str | bytes, CompoundTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.CompoundTag | _T:
        """Get the tag stored in key if it is a CompoundTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The CompoundTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a CompoundTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, CompoundTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_compound(self, string key: str | bytes, CompoundTag default: amulet_nbt.CompoundTag | None = None) -> amulet_nbt.CompoundTag:
        """Populate key if not defined or value is not CompoundTag. Return the value stored.
    
        If default is a CompoundTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default CompoundTag is used.
        :return: The CompoundTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = CompoundTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, CompoundTag):
                if default is None:
                    tag = self[key] = CompoundTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_compound(self, key: str | bytes) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def pop_compound(self, key: str | bytes, default: None) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def pop_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag) -> amulet_nbt.CompoundTag: ...
    @overload
    def pop_compound(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def pop_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag: ...
    @overload
    def pop_compound(self, key: str | bytes, default: amulet_nbt.CompoundTag | None, raise_errors: Literal[True]) -> amulet_nbt.CompoundTag: ...
    @overload
    def pop_compound(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.CompoundTag | None: ...
    @overload
    def pop_compound(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.CompoundTag: ...

    def pop_compound(self, string key: str | bytes, CompoundTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.CompoundTag | _T:
        """Remove the specified key and return the corresponding value if it is a CompoundTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The CompoundTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a CompoundTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, CompoundTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_byte_array(self, key: str | bytes) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def get_byte_array(self, key: str | bytes, default: None) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def get_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def get_byte_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def get_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def get_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def get_byte_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def get_byte_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ByteArrayTag: ...

    def get_byte_array(self, string key: str | bytes, ByteArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ByteArrayTag | _T:
        """Get the tag stored in key if it is a ByteArrayTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ByteArrayTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_byte_array(self, string key: str | bytes, ByteArrayTag default: amulet_nbt.ByteArrayTag | None = None) -> amulet_nbt.ByteArrayTag:
        """Populate key if not defined or value is not ByteArrayTag. Return the value stored.
    
        If default is a ByteArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ByteArrayTag is used.
        :return: The ByteArrayTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = ByteArrayTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, ByteArrayTag):
                if default is None:
                    tag = self[key] = ByteArrayTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_byte_array(self, key: str | bytes) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def pop_byte_array(self, key: str | bytes, default: None) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def pop_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def pop_byte_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def pop_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def pop_byte_array(self, key: str | bytes, default: amulet_nbt.ByteArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.ByteArrayTag: ...
    @overload
    def pop_byte_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.ByteArrayTag | None: ...
    @overload
    def pop_byte_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.ByteArrayTag: ...

    def pop_byte_array(self, string key: str | bytes, ByteArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.ByteArrayTag | _T:
        """Remove the specified key and return the corresponding value if it is a ByteArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, ByteArrayTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_int_array(self, key: str | bytes) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def get_int_array(self, key: str | bytes, default: None) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def get_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag) -> amulet_nbt.IntArrayTag: ...
    @overload
    def get_int_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def get_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag: ...
    @overload
    def get_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.IntArrayTag: ...
    @overload
    def get_int_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def get_int_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.IntArrayTag: ...

    def get_int_array(self, string key: str | bytes, IntArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.IntArrayTag | _T:
        """Get the tag stored in key if it is a IntArrayTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, IntArrayTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_int_array(self, string key: str | bytes, IntArrayTag default: amulet_nbt.IntArrayTag | None = None) -> amulet_nbt.IntArrayTag:
        """Populate key if not defined or value is not IntArrayTag. Return the value stored.
    
        If default is a IntArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default IntArrayTag is used.
        :return: The IntArrayTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = IntArrayTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, IntArrayTag):
                if default is None:
                    tag = self[key] = IntArrayTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_int_array(self, key: str | bytes) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def pop_int_array(self, key: str | bytes, default: None) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def pop_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag) -> amulet_nbt.IntArrayTag: ...
    @overload
    def pop_int_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def pop_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag: ...
    @overload
    def pop_int_array(self, key: str | bytes, default: amulet_nbt.IntArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.IntArrayTag: ...
    @overload
    def pop_int_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.IntArrayTag | None: ...
    @overload
    def pop_int_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.IntArrayTag: ...

    def pop_int_array(self, string key: str | bytes, IntArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.IntArrayTag | _T:
        """Remove the specified key and return the corresponding value if it is a IntArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, IntArrayTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default


    @overload
    def get_long_array(self, key: str | bytes) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def get_long_array(self, key: str | bytes, default: None) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def get_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag) -> amulet_nbt.LongArrayTag: ...
    @overload
    def get_long_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def get_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag: ...
    @overload
    def get_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.LongArrayTag: ...
    @overload
    def get_long_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def get_long_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.LongArrayTag: ...

    def get_long_array(self, string key: str | bytes, LongArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.LongArrayTag | _T:
        """Get the tag stored in key if it is a LongArrayTag.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, LongArrayTag):
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

    def setdefault_long_array(self, string key: str | bytes, LongArrayTag default: amulet_nbt.LongArrayTag | None = None) -> amulet_nbt.LongArrayTag:
        """Populate key if not defined or value is not LongArrayTag. Return the value stored.
    
        If default is a LongArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default LongArrayTag is used.
        :return: The LongArrayTag stored in key
        """
        cdef AbstractBaseTag tag
        try:
            tag = self[key]
        except KeyError as e:
            if default is None:
                tag = self[key] = LongArrayTag()
            else:
                tag = self[key] = default
        else:
            if not isinstance(tag, LongArrayTag):
                if default is None:
                    tag = self[key] = LongArrayTag()
                else:
                    tag = self[key] = default
        return tag

    @overload
    def pop_long_array(self, key: str | bytes) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def pop_long_array(self, key: str | bytes, default: None) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def pop_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag) -> amulet_nbt.LongArrayTag: ...
    @overload
    def pop_long_array(self, key: str | bytes, default: None, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def pop_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag: ...
    @overload
    def pop_long_array(self, key: str | bytes, default: amulet_nbt.LongArrayTag | None, raise_errors: Literal[True]) -> amulet_nbt.LongArrayTag: ...
    @overload
    def pop_long_array(self, key: str | bytes, *, raise_errors: Literal[False]) -> amulet_nbt.LongArrayTag | None: ...
    @overload
    def pop_long_array(self, key: str | bytes, *, raise_errors: Literal[True]) -> amulet_nbt.LongArrayTag: ...

    def pop_long_array(self, string key: str | bytes, LongArrayTag default: _T = None, bool raise_errors: bool = False) -> amulet_nbt.LongArrayTag | _T:
        """Remove the specified key and return the corresponding value if it is a LongArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongArrayTag and raise_errors is True.
        """
        cdef CCompoundTag.iterator it = dereference(self.cpp).find(key)

        if it == dereference(self.cpp).end():
            if raise_errors:
                raise KeyError(key)
            else:
                return default

        cdef AbstractBaseTag tag = wrap_node(&dereference(it).second)
        if isinstance(tag, LongArrayTag):
            dereference(self.cpp).erase(it)
            return tag
        elif raise_errors:
            raise TypeError
        else:
            return default

