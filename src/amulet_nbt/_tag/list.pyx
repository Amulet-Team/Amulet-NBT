## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8
# distutils: sources = [src/amulet_nbt/_string_encoding/_cpp/utf8.cpp, src/amulet_nbt/_nbt_encoding/_binary/_cpp/read_nbt.cpp]

from typing import Any, Type
from collections.abc import Iterable

from libc.math cimport ceil
from libcpp cimport bool
from libcpp.pair cimport pair
from libcpp.memory cimport make_shared
from libcpp.string cimport string
from cython.operator cimport dereference
import amulet_nbt
from amulet_nbt._libcpp.variant cimport get, monostate
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._string_encoding._cpp.utf8 cimport utf8_escape_to_utf8, utf8_to_utf8_escape
from amulet_nbt._nbt_encoding._binary._cpp cimport read_named_tag
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_list_snbt

from amulet_nbt._tag._cpp cimport (
    TagNode,
    CListTag,
    CListTagPtr,
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
)
from .abc cimport AbstractBaseTag, AbstractBaseMutableTag
from .int cimport ByteTag, ShortTag, IntTag, LongTag
from .float cimport FloatTag, DoubleTag
from .string cimport StringTag
from .compound cimport CompoundTag
from .array cimport ByteArrayTag, IntArrayTag, LongArrayTag
from .deepcopy cimport CListTagPtr_deepcopy
from .compound cimport is_compound_eq


cdef inline bool _is_byte_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CByteList* byte_list_a = &get[CByteList](dereference(a))
    if dereference(b).index() != 1:
        return dereference(byte_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CByteList* byte_list_b = &get[CByteList](dereference(b))
    cdef size_t size = dereference(byte_list_a).size()
    cdef size_t i
    
    if size != dereference(byte_list_b).size():
        return False
        
    for i in range(size):
        if dereference(byte_list_a)[i] != dereference(byte_list_b)[i]:
            return False
    return True


cdef inline bool _is_short_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CShortList* short_list_a = &get[CShortList](dereference(a))
    if dereference(b).index() != 2:
        return dereference(short_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CShortList* short_list_b = &get[CShortList](dereference(b))
    cdef size_t size = dereference(short_list_a).size()
    cdef size_t i
    
    if size != dereference(short_list_b).size():
        return False
        
    for i in range(size):
        if dereference(short_list_a)[i] != dereference(short_list_b)[i]:
            return False
    return True


cdef inline bool _is_int_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CIntList* int_list_a = &get[CIntList](dereference(a))
    if dereference(b).index() != 3:
        return dereference(int_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CIntList* int_list_b = &get[CIntList](dereference(b))
    cdef size_t size = dereference(int_list_a).size()
    cdef size_t i
    
    if size != dereference(int_list_b).size():
        return False
        
    for i in range(size):
        if dereference(int_list_a)[i] != dereference(int_list_b)[i]:
            return False
    return True


cdef inline bool _is_long_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CLongList* long_list_a = &get[CLongList](dereference(a))
    if dereference(b).index() != 4:
        return dereference(long_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CLongList* long_list_b = &get[CLongList](dereference(b))
    cdef size_t size = dereference(long_list_a).size()
    cdef size_t i
    
    if size != dereference(long_list_b).size():
        return False
        
    for i in range(size):
        if dereference(long_list_a)[i] != dereference(long_list_b)[i]:
            return False
    return True


cdef inline bool _is_float_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CFloatList* float_list_a = &get[CFloatList](dereference(a))
    if dereference(b).index() != 5:
        return dereference(float_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CFloatList* float_list_b = &get[CFloatList](dereference(b))
    cdef size_t size = dereference(float_list_a).size()
    cdef size_t i
    
    if size != dereference(float_list_b).size():
        return False
        
    for i in range(size):
        if dereference(float_list_a)[i] != dereference(float_list_b)[i]:
            return False
    return True


cdef inline bool _is_double_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CDoubleList* double_list_a = &get[CDoubleList](dereference(a))
    if dereference(b).index() != 6:
        return dereference(double_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CDoubleList* double_list_b = &get[CDoubleList](dereference(b))
    cdef size_t size = dereference(double_list_a).size()
    cdef size_t i
    
    if size != dereference(double_list_b).size():
        return False
        
    for i in range(size):
        if dereference(double_list_a)[i] != dereference(double_list_b)[i]:
            return False
    return True


cdef inline bool _is_byte_array_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CByteArrayList* byte_array_list_a = &get[CByteArrayList](dereference(a))
    if dereference(b).index() != 7:
        return dereference(byte_array_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CByteArrayList* byte_array_list_b = &get[CByteArrayList](dereference(b))
    cdef size_t size = dereference(byte_array_list_a).size()
    cdef size_t i
    
    if size != dereference(byte_array_list_b).size():
        return False
        
    for i in range(size):
        if dereference(dereference(byte_array_list_a)[i]) != dereference(dereference(byte_array_list_b)[i]):
            return False
    return True


cdef inline bool _is_string_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CStringList* string_list_a = &get[CStringList](dereference(a))
    if dereference(b).index() != 8:
        return dereference(string_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CStringList* string_list_b = &get[CStringList](dereference(b))
    cdef size_t size = dereference(string_list_a).size()
    cdef size_t i
    
    if size != dereference(string_list_b).size():
        return False
        
    for i in range(size):
        if dereference(string_list_a)[i] != dereference(string_list_b)[i]:
            return False
    return True


cdef inline bool _is_list_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CListList* list_list_a = &get[CListList](dereference(a))
    if dereference(b).index() != 9:
        return dereference(list_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CListList* list_list_b = &get[CListList](dereference(b))
    cdef size_t size = dereference(list_list_a).size()
    cdef size_t i
    
    if size != dereference(list_list_b).size():
        return False
        
    for i in range(size):
        if not is_list_eq(dereference(list_list_a)[i], dereference(list_list_b)[i]):
            return False
    return True


cdef inline bool _is_compound_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CCompoundList* compound_list_a = &get[CCompoundList](dereference(a))
    if dereference(b).index() != 10:
        return dereference(compound_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CCompoundList* compound_list_b = &get[CCompoundList](dereference(b))
    cdef size_t size = dereference(compound_list_a).size()
    cdef size_t i
    
    if size != dereference(compound_list_b).size():
        return False
        
    for i in range(size):
        if not is_compound_eq(dereference(compound_list_a)[i], dereference(compound_list_b)[i]):
            return False
    return True


cdef inline bool _is_int_array_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CIntArrayList* int_array_list_a = &get[CIntArrayList](dereference(a))
    if dereference(b).index() != 11:
        return dereference(int_array_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CIntArrayList* int_array_list_b = &get[CIntArrayList](dereference(b))
    cdef size_t size = dereference(int_array_list_a).size()
    cdef size_t i
    
    if size != dereference(int_array_list_b).size():
        return False
        
    for i in range(size):
        if dereference(dereference(int_array_list_a)[i]) != dereference(dereference(int_array_list_b)[i]):
            return False
    return True


cdef inline bool _is_long_array_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CLongArrayList* long_array_list_a = &get[CLongArrayList](dereference(a))
    if dereference(b).index() != 12:
        return dereference(long_array_list_a).size() == 0 and ListTag_len(b) == 0
    cdef CLongArrayList* long_array_list_b = &get[CLongArrayList](dereference(b))
    cdef size_t size = dereference(long_array_list_a).size()
    cdef size_t i
    
    if size != dereference(long_array_list_b).size():
        return False
        
    for i in range(size):
        if dereference(dereference(long_array_list_a)[i]) != dereference(dereference(long_array_list_b)[i]):
            return False
    return True


cdef bool is_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef size_t index = dereference(a).index()
    if index == 0:
        return ListTag_len(b) == 0
    elif index == 1:
        return _is_byte_tag_list_eq(a, b)
    elif index == 2:
        return _is_short_tag_list_eq(a, b)
    elif index == 3:
        return _is_int_tag_list_eq(a, b)
    elif index == 4:
        return _is_long_tag_list_eq(a, b)
    elif index == 5:
        return _is_float_tag_list_eq(a, b)
    elif index == 6:
        return _is_double_tag_list_eq(a, b)
    elif index == 7:
        return _is_byte_array_tag_list_eq(a, b)
    elif index == 8:
        return _is_string_tag_list_eq(a, b)
    elif index == 9:
        return _is_list_tag_list_eq(a, b)
    elif index == 10:
        return _is_compound_tag_list_eq(a, b)
    elif index == 11:
        return _is_int_array_tag_list_eq(a, b)
    elif index == 12:
        return _is_long_array_tag_list_eq(a, b)
    return False


cdef inline size_t ListTag_len(CListTagPtr cpp) noexcept nogil:
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        return get[CByteList](dereference(cpp)).size()
    elif index == 2:
        return get[CShortList](dereference(cpp)).size()
    elif index == 3:
        return get[CIntList](dereference(cpp)).size()
    elif index == 4:
        return get[CLongList](dereference(cpp)).size()
    elif index == 5:
        return get[CFloatList](dereference(cpp)).size()
    elif index == 6:
        return get[CDoubleList](dereference(cpp)).size()
    elif index == 7:
        return get[CByteArrayList](dereference(cpp)).size()
    elif index == 8:
        return get[CStringList](dereference(cpp)).size()
    elif index == 9:
        return get[CListList](dereference(cpp)).size()
    elif index == 10:
        return get[CCompoundList](dereference(cpp)).size()
    elif index == 11:
        return get[CIntArrayList](dereference(cpp)).size()
    elif index == 12:
        return get[CLongArrayList](dereference(cpp)).size()

    return 0


cdef inline ByteTag ListTag_get_item_byte_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteList* byte_list = &get[CByteList](dereference(cpp))
    if item < 0:
        item += dereference(byte_list).size()
    if item < 0 or item >= dereference(byte_list).size():
        raise IndexError("ListTag index out of range")
    return ByteTag.wrap(dereference(byte_list)[item])


cdef inline ShortTag ListTag_get_item_short_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CShortList* short_list = &get[CShortList](dereference(cpp))
    if item < 0:
        item += dereference(short_list).size()
    if item < 0 or item >= dereference(short_list).size():
        raise IndexError("ListTag index out of range")
    return ShortTag.wrap(dereference(short_list)[item])


cdef inline IntTag ListTag_get_item_int_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntList* int_list = &get[CIntList](dereference(cpp))
    if item < 0:
        item += dereference(int_list).size()
    if item < 0 or item >= dereference(int_list).size():
        raise IndexError("ListTag index out of range")
    return IntTag.wrap(dereference(int_list)[item])


cdef inline LongTag ListTag_get_item_long_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongList* long_list = &get[CLongList](dereference(cpp))
    if item < 0:
        item += dereference(long_list).size()
    if item < 0 or item >= dereference(long_list).size():
        raise IndexError("ListTag index out of range")
    return LongTag.wrap(dereference(long_list)[item])


cdef inline FloatTag ListTag_get_item_float_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CFloatList* float_list = &get[CFloatList](dereference(cpp))
    if item < 0:
        item += dereference(float_list).size()
    if item < 0 or item >= dereference(float_list).size():
        raise IndexError("ListTag index out of range")
    return FloatTag.wrap(dereference(float_list)[item])


cdef inline DoubleTag ListTag_get_item_double_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CDoubleList* double_list = &get[CDoubleList](dereference(cpp))
    if item < 0:
        item += dereference(double_list).size()
    if item < 0 or item >= dereference(double_list).size():
        raise IndexError("ListTag index out of range")
    return DoubleTag.wrap(dereference(double_list)[item])


cdef inline ByteArrayTag ListTag_get_item_byte_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteArrayList* byte_array_list = &get[CByteArrayList](dereference(cpp))
    if item < 0:
        item += dereference(byte_array_list).size()
    if item < 0 or item >= dereference(byte_array_list).size():
        raise IndexError("ListTag index out of range")
    return ByteArrayTag.wrap(dereference(byte_array_list)[item])


cdef inline StringTag ListTag_get_item_string_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CStringList* string_list = &get[CStringList](dereference(cpp))
    if item < 0:
        item += dereference(string_list).size()
    if item < 0 or item >= dereference(string_list).size():
        raise IndexError("ListTag index out of range")
    return StringTag.wrap(dereference(string_list)[item])


cdef inline ListTag ListTag_get_item_list_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CListList* list_list = &get[CListList](dereference(cpp))
    if item < 0:
        item += dereference(list_list).size()
    if item < 0 or item >= dereference(list_list).size():
        raise IndexError("ListTag index out of range")
    return ListTag.wrap(dereference(list_list)[item])


cdef inline CompoundTag ListTag_get_item_compound_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CCompoundList* compound_list = &get[CCompoundList](dereference(cpp))
    if item < 0:
        item += dereference(compound_list).size()
    if item < 0 or item >= dereference(compound_list).size():
        raise IndexError("ListTag index out of range")
    return CompoundTag.wrap(dereference(compound_list)[item])


cdef inline IntArrayTag ListTag_get_item_int_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntArrayList* int_array_list = &get[CIntArrayList](dereference(cpp))
    if item < 0:
        item += dereference(int_array_list).size()
    if item < 0 or item >= dereference(int_array_list).size():
        raise IndexError("ListTag index out of range")
    return IntArrayTag.wrap(dereference(int_array_list)[item])


cdef inline LongArrayTag ListTag_get_item_long_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongArrayList* long_array_list = &get[CLongArrayList](dereference(cpp))
    if item < 0:
        item += dereference(long_array_list).size()
    if item < 0 or item >= dereference(long_array_list).size():
        raise IndexError("ListTag index out of range")
    return LongArrayTag.wrap(dereference(long_array_list)[item])


cdef inline AbstractBaseTag ListTag_get_item(CListTagPtr cpp, ptrdiff_t item):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        return ListTag_get_item_byte_tag(cpp, item)
    elif index == 2:
        return ListTag_get_item_short_tag(cpp, item)
    elif index == 3:
        return ListTag_get_item_int_tag(cpp, item)
    elif index == 4:
        return ListTag_get_item_long_tag(cpp, item)
    elif index == 5:
        return ListTag_get_item_float_tag(cpp, item)
    elif index == 6:
        return ListTag_get_item_double_tag(cpp, item)
    elif index == 7:
        return ListTag_get_item_byte_array_tag(cpp, item)
    elif index == 8:
        return ListTag_get_item_string_tag(cpp, item)
    elif index == 9:
        return ListTag_get_item_list_tag(cpp, item)
    elif index == 10:
        return ListTag_get_item_compound_tag(cpp, item)
    elif index == 11:
        return ListTag_get_item_int_array_tag(cpp, item)
    elif index == 12:
        return ListTag_get_item_long_array_tag(cpp, item)
    else:
        raise IndexError("ListTag index out of range.")


cdef (size_t, size_t, ptrdiff_t) _slice_to_range(size_t target_len, object s):
    cdef ptrdiff_t start
    cdef ptrdiff_t stop
    cdef ptrdiff_t step

    if s.step is None:
        step = 1
    else:
        step = s.step

    if step > 0:
        if s.start is None:
            start = 0
        elif s.start < 0:
            start = s.start + target_len
        else:
            start = s.start
        start = min(max(0, start), target_len)
        if s.stop is None:
            stop = target_len
        elif s.stop < 0:
            stop = s.stop + target_len
        else:
            stop = s.stop
        stop = min(max(0, stop), target_len)

    elif step < 0:
        if s.start is None:
            start = target_len - 1
        elif s.start < 0:
            start = s.start + target_len
        else:
            start = s.start
        start = min(max(-1, start), target_len - 1)
        if s.stop is None:
            stop = -1
        elif s.stop < 0:
            stop = s.stop + target_len
        else:
            stop = s.stop
        stop = min(max(-1, stop), target_len - 1)

    elif step == 0:
        raise ValueError("slice step cannot be zero")
    else:
        raise RuntimeError

    return start, stop, step


cdef inline list ListTag_get_slice_byte_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CByteList* byte_list = &get[CByteList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(byte_list).size(), s)
    return [
        ByteTag.wrap(dereference(byte_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_short_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CShortList* short_list = &get[CShortList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(short_list).size(), s)
    return [
        ShortTag.wrap(dereference(short_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_int_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CIntList* int_list = &get[CIntList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(int_list).size(), s)
    return [
        IntTag.wrap(dereference(int_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_long_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CLongList* long_list = &get[CLongList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(long_list).size(), s)
    return [
        LongTag.wrap(dereference(long_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_float_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CFloatList* float_list = &get[CFloatList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(float_list).size(), s)
    return [
        FloatTag.wrap(dereference(float_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_double_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CDoubleList* double_list = &get[CDoubleList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(double_list).size(), s)
    return [
        DoubleTag.wrap(dereference(double_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_byte_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CByteArrayList* byte_array_list = &get[CByteArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(byte_array_list).size(), s)
    return [
        ByteArrayTag.wrap(dereference(byte_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_string_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CStringList* string_list = &get[CStringList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(string_list).size(), s)
    return [
        StringTag.wrap(dereference(string_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_list_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CListList* list_list = &get[CListList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(list_list).size(), s)
    return [
        ListTag.wrap(dereference(list_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_compound_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CCompoundList* compound_list = &get[CCompoundList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(compound_list).size(), s)
    return [
        CompoundTag.wrap(dereference(compound_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_int_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CIntArrayList* int_array_list = &get[CIntArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(int_array_list).size(), s)
    return [
        IntArrayTag.wrap(dereference(int_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice_long_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CLongArrayList* long_array_list = &get[CLongArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(long_array_list).size(), s)
    return [
        LongArrayTag.wrap(dereference(long_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list ListTag_get_slice(CListTagPtr cpp, object s):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        return ListTag_get_slice_byte_tag(cpp, s)
    elif index == 2:
        return ListTag_get_slice_short_tag(cpp, s)
    elif index == 3:
        return ListTag_get_slice_int_tag(cpp, s)
    elif index == 4:
        return ListTag_get_slice_long_tag(cpp, s)
    elif index == 5:
        return ListTag_get_slice_float_tag(cpp, s)
    elif index == 6:
        return ListTag_get_slice_double_tag(cpp, s)
    elif index == 7:
        return ListTag_get_slice_byte_array_tag(cpp, s)
    elif index == 8:
        return ListTag_get_slice_string_tag(cpp, s)
    elif index == 9:
        return ListTag_get_slice_list_tag(cpp, s)
    elif index == 10:
        return ListTag_get_slice_compound_tag(cpp, s)
    elif index == 11:
        return ListTag_get_slice_int_array_tag(cpp, s)
    elif index == 12:
        return ListTag_get_slice_long_array_tag(cpp, s)
    else:
        return []


cdef inline void ListTag_set_item_byte_tag(CListTagPtr cpp, ptrdiff_t item, ByteTag value):
    cdef CByteList* byte_list
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
        if item < 0:
            item += dereference(byte_list).size()
        if item < 0 or item >= dereference(byte_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(byte_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CByteList]()
        byte_list = &get[CByteList](dereference(cpp))
        dereference(byte_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_short_tag(CListTagPtr cpp, ptrdiff_t item, ShortTag value):
    cdef CShortList* short_list
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
        if item < 0:
            item += dereference(short_list).size()
        if item < 0 or item >= dereference(short_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(short_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CShortList]()
        short_list = &get[CShortList](dereference(cpp))
        dereference(short_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_int_tag(CListTagPtr cpp, ptrdiff_t item, IntTag value):
    cdef CIntList* int_list
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
        if item < 0:
            item += dereference(int_list).size()
        if item < 0 or item >= dereference(int_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(int_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CIntList]()
        int_list = &get[CIntList](dereference(cpp))
        dereference(int_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_long_tag(CListTagPtr cpp, ptrdiff_t item, LongTag value):
    cdef CLongList* long_list
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
        if item < 0:
            item += dereference(long_list).size()
        if item < 0 or item >= dereference(long_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(long_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CLongList]()
        long_list = &get[CLongList](dereference(cpp))
        dereference(long_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_float_tag(CListTagPtr cpp, ptrdiff_t item, FloatTag value):
    cdef CFloatList* float_list
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
        if item < 0:
            item += dereference(float_list).size()
        if item < 0 or item >= dereference(float_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(float_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CFloatList]()
        float_list = &get[CFloatList](dereference(cpp))
        dereference(float_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_double_tag(CListTagPtr cpp, ptrdiff_t item, DoubleTag value):
    cdef CDoubleList* double_list
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
        if item < 0:
            item += dereference(double_list).size()
        if item < 0 or item >= dereference(double_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(double_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CDoubleList]()
        double_list = &get[CDoubleList](dereference(cpp))
        dereference(double_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_byte_array_tag(CListTagPtr cpp, ptrdiff_t item, ByteArrayTag value):
    cdef CByteArrayList* byte_array_list
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
        if item < 0:
            item += dereference(byte_array_list).size()
        if item < 0 or item >= dereference(byte_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(byte_array_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CByteArrayList]()
        byte_array_list = &get[CByteArrayList](dereference(cpp))
        dereference(byte_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_string_tag(CListTagPtr cpp, ptrdiff_t item, StringTag value):
    cdef CStringList* string_list
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
        if item < 0:
            item += dereference(string_list).size()
        if item < 0 or item >= dereference(string_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(string_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CStringList]()
        string_list = &get[CStringList](dereference(cpp))
        dereference(string_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_list_tag(CListTagPtr cpp, ptrdiff_t item, ListTag value):
    cdef CListList* list_list
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
        if item < 0:
            item += dereference(list_list).size()
        if item < 0 or item >= dereference(list_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(list_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CListList]()
        list_list = &get[CListList](dereference(cpp))
        dereference(list_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_compound_tag(CListTagPtr cpp, ptrdiff_t item, CompoundTag value):
    cdef CCompoundList* compound_list
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
        if item < 0:
            item += dereference(compound_list).size()
        if item < 0 or item >= dereference(compound_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(compound_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CCompoundList]()
        compound_list = &get[CCompoundList](dereference(cpp))
        dereference(compound_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_int_array_tag(CListTagPtr cpp, ptrdiff_t item, IntArrayTag value):
    cdef CIntArrayList* int_array_list
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
        if item < 0:
            item += dereference(int_array_list).size()
        if item < 0 or item >= dereference(int_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(int_array_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CIntArrayList]()
        int_array_list = &get[CIntArrayList](dereference(cpp))
        dereference(int_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item_long_array_tag(CListTagPtr cpp, ptrdiff_t item, LongArrayTag value):
    cdef CLongArrayList* long_array_list
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
        if item < 0:
            item += dereference(long_array_list).size()
        if item < 0 or item >= dereference(long_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(long_array_list)[item] = value.cpp
    elif ListTag_len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CLongArrayList]()
        long_array_list = &get[CLongArrayList](dereference(cpp))
        dereference(long_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_item(CListTagPtr cpp, ptrdiff_t item, AbstractBaseTag value):
    if isinstance(value, ByteTag):
        ListTag_set_item_byte_tag(cpp, item, value)
    elif isinstance(value, ShortTag):
        ListTag_set_item_short_tag(cpp, item, value)
    elif isinstance(value, IntTag):
        ListTag_set_item_int_tag(cpp, item, value)
    elif isinstance(value, LongTag):
        ListTag_set_item_long_tag(cpp, item, value)
    elif isinstance(value, FloatTag):
        ListTag_set_item_float_tag(cpp, item, value)
    elif isinstance(value, DoubleTag):
        ListTag_set_item_double_tag(cpp, item, value)
    elif isinstance(value, ByteArrayTag):
        ListTag_set_item_byte_array_tag(cpp, item, value)
    elif isinstance(value, StringTag):
        ListTag_set_item_string_tag(cpp, item, value)
    elif isinstance(value, ListTag):
        ListTag_set_item_list_tag(cpp, item, value)
    elif isinstance(value, CompoundTag):
        ListTag_set_item_compound_tag(cpp, item, value)
    elif isinstance(value, IntArrayTag):
        ListTag_set_item_int_array_tag(cpp, item, value)
    elif isinstance(value, LongArrayTag):
        ListTag_set_item_long_array_tag(cpp, item, value)
    else:
        raise TypeError(f"Unsupported type {type(value)}")


cdef inline size_t _iter_count(size_t start, size_t stop, ptrdiff_t step):
    cdef double iter_count = ceil((stop - start)/step)
    if iter_count < 0:
        return 0
    else:
        return <size_t>iter_count


cdef inline void ListTag_set_slice_byte_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, ByteTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CByteList* byte_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef ByteTag el
    cdef size_t size
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(byte_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(byte_list)[item] = el.cpp
        elif step == 1:
            dereference(byte_list).erase(
                dereference(byte_list).begin() + start,
                dereference(byte_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(byte_list).insert(dereference(byte_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CByteList]()
            byte_list = &get[CByteList](dereference(cpp))
            for el in value:
                dereference(byte_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_short_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, ShortTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CShortList* short_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef ShortTag el
    cdef size_t size
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(short_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(short_list)[item] = el.cpp
        elif step == 1:
            dereference(short_list).erase(
                dereference(short_list).begin() + start,
                dereference(short_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(short_list).insert(dereference(short_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CShortList]()
            short_list = &get[CShortList](dereference(cpp))
            for el in value:
                dereference(short_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_int_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, IntTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CIntList* int_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef IntTag el
    cdef size_t size
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(int_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(int_list)[item] = el.cpp
        elif step == 1:
            dereference(int_list).erase(
                dereference(int_list).begin() + start,
                dereference(int_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(int_list).insert(dereference(int_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CIntList]()
            int_list = &get[CIntList](dereference(cpp))
            for el in value:
                dereference(int_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_long_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, LongTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CLongList* long_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef LongTag el
    cdef size_t size
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(long_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(long_list)[item] = el.cpp
        elif step == 1:
            dereference(long_list).erase(
                dereference(long_list).begin() + start,
                dereference(long_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(long_list).insert(dereference(long_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CLongList]()
            long_list = &get[CLongList](dereference(cpp))
            for el in value:
                dereference(long_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_float_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, FloatTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CFloatList* float_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef FloatTag el
    cdef size_t size
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(float_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(float_list)[item] = el.cpp
        elif step == 1:
            dereference(float_list).erase(
                dereference(float_list).begin() + start,
                dereference(float_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(float_list).insert(dereference(float_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CFloatList]()
            float_list = &get[CFloatList](dereference(cpp))
            for el in value:
                dereference(float_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_double_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, DoubleTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CDoubleList* double_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef DoubleTag el
    cdef size_t size
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(double_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(double_list)[item] = el.cpp
        elif step == 1:
            dereference(double_list).erase(
                dereference(double_list).begin() + start,
                dereference(double_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(double_list).insert(dereference(double_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CDoubleList]()
            double_list = &get[CDoubleList](dereference(cpp))
            for el in value:
                dereference(double_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_byte_array_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, ByteArrayTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CByteArrayList* byte_array_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef ByteArrayTag el
    cdef size_t size
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(byte_array_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(byte_array_list)[item] = el.cpp
        elif step == 1:
            dereference(byte_array_list).erase(
                dereference(byte_array_list).begin() + start,
                dereference(byte_array_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(byte_array_list).insert(dereference(byte_array_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CByteArrayList]()
            byte_array_list = &get[CByteArrayList](dereference(cpp))
            for el in value:
                dereference(byte_array_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_string_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, StringTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CStringList* string_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef StringTag el
    cdef size_t size
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(string_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(string_list)[item] = el.cpp
        elif step == 1:
            dereference(string_list).erase(
                dereference(string_list).begin() + start,
                dereference(string_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(string_list).insert(dereference(string_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CStringList]()
            string_list = &get[CStringList](dereference(cpp))
            for el in value:
                dereference(string_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_list_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, ListTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CListList* list_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef ListTag el
    cdef size_t size
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(list_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(list_list)[item] = el.cpp
        elif step == 1:
            dereference(list_list).erase(
                dereference(list_list).begin() + start,
                dereference(list_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(list_list).insert(dereference(list_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CListList]()
            list_list = &get[CListList](dereference(cpp))
            for el in value:
                dereference(list_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_compound_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, CompoundTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CCompoundList* compound_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef CompoundTag el
    cdef size_t size
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(compound_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(compound_list)[item] = el.cpp
        elif step == 1:
            dereference(compound_list).erase(
                dereference(compound_list).begin() + start,
                dereference(compound_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(compound_list).insert(dereference(compound_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CCompoundList]()
            compound_list = &get[CCompoundList](dereference(cpp))
            for el in value:
                dereference(compound_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_int_array_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, IntArrayTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CIntArrayList* int_array_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef IntArrayTag el
    cdef size_t size
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(int_array_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(int_array_list)[item] = el.cpp
        elif step == 1:
            dereference(int_array_list).erase(
                dereference(int_array_list).begin() + start,
                dereference(int_array_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(int_array_list).insert(dereference(int_array_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CIntArrayList]()
            int_array_list = &get[CIntArrayList](dereference(cpp))
            for el in value:
                dereference(int_array_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void ListTag_set_slice_long_array_tag(CListTagPtr cpp, object s, list value):
    if not all(isinstance(v, LongArrayTag) for v in value):
        raise TypeError("All elements of a ListTag must have the same type.")
    
    cdef CLongArrayList* long_array_list
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    cdef size_t iter_count
    cdef LongArrayTag el
    cdef size_t size
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
        
        start, stop, step = _slice_to_range(dereference(long_array_list).size(), s)
        iter_count = _iter_count(start, stop, step)
        
        if iter_count == len(value):
            for item, el in zip(range(start, stop, step), value):
                dereference(long_array_list)[item] = el.cpp
        elif step == 1:
            dereference(long_array_list).erase(
                dereference(long_array_list).begin() + start,
                dereference(long_array_list).begin() + stop,
            )
            for item, el in enumerate(value):
                dereference(long_array_list).insert(dereference(long_array_list).begin() + start + item, el.cpp)
        else:
            raise ValueError(f"attempt to assign sequence of size {len(value)} to extended slice of size {{iter_count}}")
        
    else:
        size = ListTag_len(cpp)
        start, stop, step = _slice_to_range(size, s)
        iter_count = _iter_count(start, stop, step)
        if size == iter_count:
            if step == -1:
                value = reversed(value)
            elif step != 1:
                raise RuntimeError
                
            dereference(cpp).emplace[CLongArrayList]()
            long_array_list = &get[CLongArrayList](dereference(cpp))
            for el in value:
                dereference(long_array_list).push_back(el.cpp)
        else:
            raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_slice_empty(CListTagPtr cpp, object s):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        ListTag_set_slice_byte_tag(cpp, s, [])
    elif index == 2:
        ListTag_set_slice_short_tag(cpp, s, [])
    elif index == 3:
        ListTag_set_slice_int_tag(cpp, s, [])
    elif index == 4:
        ListTag_set_slice_long_tag(cpp, s, [])
    elif index == 5:
        ListTag_set_slice_float_tag(cpp, s, [])
    elif index == 6:
        ListTag_set_slice_double_tag(cpp, s, [])
    elif index == 7:
        ListTag_set_slice_byte_array_tag(cpp, s, [])
    elif index == 8:
        ListTag_set_slice_string_tag(cpp, s, [])
    elif index == 9:
        ListTag_set_slice_list_tag(cpp, s, [])
    elif index == 10:
        ListTag_set_slice_compound_tag(cpp, s, [])
    elif index == 11:
        ListTag_set_slice_int_array_tag(cpp, s, [])
    elif index == 12:
        ListTag_set_slice_long_array_tag(cpp, s, [])


cdef inline void ListTag_set_slice(CListTagPtr cpp, object s, object value):
    cdef list arr = value
    if arr:
        # Items in the array
        if isinstance(arr[0], ByteTag):
            ListTag_set_slice_byte_tag(cpp, s, arr)
        elif isinstance(arr[0], ShortTag):
            ListTag_set_slice_short_tag(cpp, s, arr)
        elif isinstance(arr[0], IntTag):
            ListTag_set_slice_int_tag(cpp, s, arr)
        elif isinstance(arr[0], LongTag):
            ListTag_set_slice_long_tag(cpp, s, arr)
        elif isinstance(arr[0], FloatTag):
            ListTag_set_slice_float_tag(cpp, s, arr)
        elif isinstance(arr[0], DoubleTag):
            ListTag_set_slice_double_tag(cpp, s, arr)
        elif isinstance(arr[0], ByteArrayTag):
            ListTag_set_slice_byte_array_tag(cpp, s, arr)
        elif isinstance(arr[0], StringTag):
            ListTag_set_slice_string_tag(cpp, s, arr)
        elif isinstance(arr[0], ListTag):
            ListTag_set_slice_list_tag(cpp, s, arr)
        elif isinstance(arr[0], CompoundTag):
            ListTag_set_slice_compound_tag(cpp, s, arr)
        elif isinstance(arr[0], IntArrayTag):
            ListTag_set_slice_int_array_tag(cpp, s, arr)
        elif isinstance(arr[0], LongArrayTag):
            ListTag_set_slice_long_array_tag(cpp, s, arr)
        else:
            raise TypeError(f"Unsupported type {type(value)}")
    else:
        # array is empty
        _set_slice_empty(cpp, s)


cdef inline void ListTag_del_item_byte_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteList* byte_list = &get[CByteList](dereference(cpp))
    if item < 0:
        item += dereference(byte_list).size()
    if item < 0 or item >= dereference(byte_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(byte_list).erase(dereference(byte_list).begin() + item)


cdef inline void ListTag_del_item_short_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CShortList* short_list = &get[CShortList](dereference(cpp))
    if item < 0:
        item += dereference(short_list).size()
    if item < 0 or item >= dereference(short_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(short_list).erase(dereference(short_list).begin() + item)


cdef inline void ListTag_del_item_int_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntList* int_list = &get[CIntList](dereference(cpp))
    if item < 0:
        item += dereference(int_list).size()
    if item < 0 or item >= dereference(int_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(int_list).erase(dereference(int_list).begin() + item)


cdef inline void ListTag_del_item_long_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongList* long_list = &get[CLongList](dereference(cpp))
    if item < 0:
        item += dereference(long_list).size()
    if item < 0 or item >= dereference(long_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(long_list).erase(dereference(long_list).begin() + item)


cdef inline void ListTag_del_item_float_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CFloatList* float_list = &get[CFloatList](dereference(cpp))
    if item < 0:
        item += dereference(float_list).size()
    if item < 0 or item >= dereference(float_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(float_list).erase(dereference(float_list).begin() + item)


cdef inline void ListTag_del_item_double_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CDoubleList* double_list = &get[CDoubleList](dereference(cpp))
    if item < 0:
        item += dereference(double_list).size()
    if item < 0 or item >= dereference(double_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(double_list).erase(dereference(double_list).begin() + item)


cdef inline void ListTag_del_item_byte_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteArrayList* byte_array_list = &get[CByteArrayList](dereference(cpp))
    if item < 0:
        item += dereference(byte_array_list).size()
    if item < 0 or item >= dereference(byte_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(byte_array_list).erase(dereference(byte_array_list).begin() + item)


cdef inline void ListTag_del_item_string_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CStringList* string_list = &get[CStringList](dereference(cpp))
    if item < 0:
        item += dereference(string_list).size()
    if item < 0 or item >= dereference(string_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(string_list).erase(dereference(string_list).begin() + item)


cdef inline void ListTag_del_item_list_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CListList* list_list = &get[CListList](dereference(cpp))
    if item < 0:
        item += dereference(list_list).size()
    if item < 0 or item >= dereference(list_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(list_list).erase(dereference(list_list).begin() + item)


cdef inline void ListTag_del_item_compound_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CCompoundList* compound_list = &get[CCompoundList](dereference(cpp))
    if item < 0:
        item += dereference(compound_list).size()
    if item < 0 or item >= dereference(compound_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(compound_list).erase(dereference(compound_list).begin() + item)


cdef inline void ListTag_del_item_int_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntArrayList* int_array_list = &get[CIntArrayList](dereference(cpp))
    if item < 0:
        item += dereference(int_array_list).size()
    if item < 0 or item >= dereference(int_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(int_array_list).erase(dereference(int_array_list).begin() + item)


cdef inline void ListTag_del_item_long_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongArrayList* long_array_list = &get[CLongArrayList](dereference(cpp))
    if item < 0:
        item += dereference(long_array_list).size()
    if item < 0 or item >= dereference(long_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(long_array_list).erase(dereference(long_array_list).begin() + item)


cdef inline void ListTag_del_item(CListTagPtr cpp, ptrdiff_t item):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        ListTag_del_item_byte_tag(cpp, item)
    elif index == 2:
        ListTag_del_item_short_tag(cpp, item)
    elif index == 3:
        ListTag_del_item_int_tag(cpp, item)
    elif index == 4:
        ListTag_del_item_long_tag(cpp, item)
    elif index == 5:
        ListTag_del_item_float_tag(cpp, item)
    elif index == 6:
        ListTag_del_item_double_tag(cpp, item)
    elif index == 7:
        ListTag_del_item_byte_array_tag(cpp, item)
    elif index == 8:
        ListTag_del_item_string_tag(cpp, item)
    elif index == 9:
        ListTag_del_item_list_tag(cpp, item)
    elif index == 10:
        ListTag_del_item_compound_tag(cpp, item)
    elif index == 11:
        ListTag_del_item_int_array_tag(cpp, item)
    elif index == 12:
        ListTag_del_item_long_array_tag(cpp, item)
    else:
        raise IndexError("ListTag assignment index out of range.")


cdef inline void ListTag_del_slice_byte_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CByteList* byte_list
    byte_list = &get[CByteList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(byte_list).size(), s)
    
    if step == 1:
        dereference(byte_list).erase(
            dereference(byte_list).begin() + start,
            dereference(byte_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(byte_list).erase(dereference(byte_list).begin() + item)


cdef inline void ListTag_del_slice_short_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CShortList* short_list
    short_list = &get[CShortList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(short_list).size(), s)
    
    if step == 1:
        dereference(short_list).erase(
            dereference(short_list).begin() + start,
            dereference(short_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(short_list).erase(dereference(short_list).begin() + item)


cdef inline void ListTag_del_slice_int_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CIntList* int_list
    int_list = &get[CIntList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(int_list).size(), s)
    
    if step == 1:
        dereference(int_list).erase(
            dereference(int_list).begin() + start,
            dereference(int_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(int_list).erase(dereference(int_list).begin() + item)


cdef inline void ListTag_del_slice_long_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CLongList* long_list
    long_list = &get[CLongList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(long_list).size(), s)
    
    if step == 1:
        dereference(long_list).erase(
            dereference(long_list).begin() + start,
            dereference(long_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(long_list).erase(dereference(long_list).begin() + item)


cdef inline void ListTag_del_slice_float_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CFloatList* float_list
    float_list = &get[CFloatList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(float_list).size(), s)
    
    if step == 1:
        dereference(float_list).erase(
            dereference(float_list).begin() + start,
            dereference(float_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(float_list).erase(dereference(float_list).begin() + item)


cdef inline void ListTag_del_slice_double_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CDoubleList* double_list
    double_list = &get[CDoubleList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(double_list).size(), s)
    
    if step == 1:
        dereference(double_list).erase(
            dereference(double_list).begin() + start,
            dereference(double_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(double_list).erase(dereference(double_list).begin() + item)


cdef inline void ListTag_del_slice_byte_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CByteArrayList* byte_array_list
    byte_array_list = &get[CByteArrayList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(byte_array_list).size(), s)
    
    if step == 1:
        dereference(byte_array_list).erase(
            dereference(byte_array_list).begin() + start,
            dereference(byte_array_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(byte_array_list).erase(dereference(byte_array_list).begin() + item)


cdef inline void ListTag_del_slice_string_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CStringList* string_list
    string_list = &get[CStringList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(string_list).size(), s)
    
    if step == 1:
        dereference(string_list).erase(
            dereference(string_list).begin() + start,
            dereference(string_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(string_list).erase(dereference(string_list).begin() + item)


cdef inline void ListTag_del_slice_list_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CListList* list_list
    list_list = &get[CListList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(list_list).size(), s)
    
    if step == 1:
        dereference(list_list).erase(
            dereference(list_list).begin() + start,
            dereference(list_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(list_list).erase(dereference(list_list).begin() + item)


cdef inline void ListTag_del_slice_compound_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CCompoundList* compound_list
    compound_list = &get[CCompoundList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(compound_list).size(), s)
    
    if step == 1:
        dereference(compound_list).erase(
            dereference(compound_list).begin() + start,
            dereference(compound_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(compound_list).erase(dereference(compound_list).begin() + item)


cdef inline void ListTag_del_slice_int_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CIntArrayList* int_array_list
    int_array_list = &get[CIntArrayList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(int_array_list).size(), s)
    
    if step == 1:
        dereference(int_array_list).erase(
            dereference(int_array_list).begin() + start,
            dereference(int_array_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(int_array_list).erase(dereference(int_array_list).begin() + item)


cdef inline void ListTag_del_slice_long_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef size_t step
    cdef size_t item

    cdef CLongArrayList* long_array_list
    long_array_list = &get[CLongArrayList](dereference(cpp))

    start, stop, step = _slice_to_range(dereference(long_array_list).size(), s)
    
    if step == 1:
        dereference(long_array_list).erase(
            dereference(long_array_list).begin() + start,
            dereference(long_array_list).begin() + stop,
        )
    else:
        for item in range(start, stop, step):
            dereference(long_array_list).erase(dereference(long_array_list).begin() + item)


cdef inline void ListTag_del_slice(CListTagPtr cpp, object s):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        ListTag_del_slice_byte_tag(cpp, s)
    elif index == 2:
        ListTag_del_slice_short_tag(cpp, s)
    elif index == 3:
        ListTag_del_slice_int_tag(cpp, s)
    elif index == 4:
        ListTag_del_slice_long_tag(cpp, s)
    elif index == 5:
        ListTag_del_slice_float_tag(cpp, s)
    elif index == 6:
        ListTag_del_slice_double_tag(cpp, s)
    elif index == 7:
        ListTag_del_slice_byte_array_tag(cpp, s)
    elif index == 8:
        ListTag_del_slice_string_tag(cpp, s)
    elif index == 9:
        ListTag_del_slice_list_tag(cpp, s)
    elif index == 10:
        ListTag_del_slice_compound_tag(cpp, s)
    elif index == 11:
        ListTag_del_slice_int_array_tag(cpp, s)
    elif index == 12:
        ListTag_del_slice_long_array_tag(cpp, s)


cdef inline void ListTag_insert_byte_tag(CListTagPtr cpp, ptrdiff_t item, ByteTag value):
    cdef CByteList* byte_list
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CByteList]()
        byte_list = &get[CByteList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(byte_list).size()
    item = min(max(0, item), dereference(byte_list).size())

    dereference(byte_list).insert(dereference(byte_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_short_tag(CListTagPtr cpp, ptrdiff_t item, ShortTag value):
    cdef CShortList* short_list
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CShortList]()
        short_list = &get[CShortList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(short_list).size()
    item = min(max(0, item), dereference(short_list).size())

    dereference(short_list).insert(dereference(short_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_int_tag(CListTagPtr cpp, ptrdiff_t item, IntTag value):
    cdef CIntList* int_list
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CIntList]()
        int_list = &get[CIntList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(int_list).size()
    item = min(max(0, item), dereference(int_list).size())

    dereference(int_list).insert(dereference(int_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_long_tag(CListTagPtr cpp, ptrdiff_t item, LongTag value):
    cdef CLongList* long_list
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CLongList]()
        long_list = &get[CLongList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(long_list).size()
    item = min(max(0, item), dereference(long_list).size())

    dereference(long_list).insert(dereference(long_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_float_tag(CListTagPtr cpp, ptrdiff_t item, FloatTag value):
    cdef CFloatList* float_list
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CFloatList]()
        float_list = &get[CFloatList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(float_list).size()
    item = min(max(0, item), dereference(float_list).size())

    dereference(float_list).insert(dereference(float_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_double_tag(CListTagPtr cpp, ptrdiff_t item, DoubleTag value):
    cdef CDoubleList* double_list
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CDoubleList]()
        double_list = &get[CDoubleList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(double_list).size()
    item = min(max(0, item), dereference(double_list).size())

    dereference(double_list).insert(dereference(double_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_byte_array_tag(CListTagPtr cpp, ptrdiff_t item, ByteArrayTag value):
    cdef CByteArrayList* byte_array_list
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CByteArrayList]()
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(byte_array_list).size()
    item = min(max(0, item), dereference(byte_array_list).size())

    dereference(byte_array_list).insert(dereference(byte_array_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_string_tag(CListTagPtr cpp, ptrdiff_t item, StringTag value):
    cdef CStringList* string_list
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CStringList]()
        string_list = &get[CStringList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(string_list).size()
    item = min(max(0, item), dereference(string_list).size())

    dereference(string_list).insert(dereference(string_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_list_tag(CListTagPtr cpp, ptrdiff_t item, ListTag value):
    cdef CListList* list_list
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CListList]()
        list_list = &get[CListList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(list_list).size()
    item = min(max(0, item), dereference(list_list).size())

    dereference(list_list).insert(dereference(list_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_compound_tag(CListTagPtr cpp, ptrdiff_t item, CompoundTag value):
    cdef CCompoundList* compound_list
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CCompoundList]()
        compound_list = &get[CCompoundList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(compound_list).size()
    item = min(max(0, item), dereference(compound_list).size())

    dereference(compound_list).insert(dereference(compound_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_int_array_tag(CListTagPtr cpp, ptrdiff_t item, IntArrayTag value):
    cdef CIntArrayList* int_array_list
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CIntArrayList]()
        int_array_list = &get[CIntArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(int_array_list).size()
    item = min(max(0, item), dereference(int_array_list).size())

    dereference(int_array_list).insert(dereference(int_array_list).begin() + item, value.cpp)


cdef inline void ListTag_insert_long_array_tag(CListTagPtr cpp, ptrdiff_t item, LongArrayTag value):
    cdef CLongArrayList* long_array_list
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CLongArrayList]()
        long_array_list = &get[CLongArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(long_array_list).size()
    item = min(max(0, item), dereference(long_array_list).size())

    dereference(long_array_list).insert(dereference(long_array_list).begin() + item, value.cpp)


cdef inline void ListTag_insert(CListTagPtr cpp, ptrdiff_t item, AbstractBaseTag value):
    if isinstance(value, ByteTag):
        ListTag_insert_byte_tag(cpp, item, value)
    elif isinstance(value, ShortTag):
        ListTag_insert_short_tag(cpp, item, value)
    elif isinstance(value, IntTag):
        ListTag_insert_int_tag(cpp, item, value)
    elif isinstance(value, LongTag):
        ListTag_insert_long_tag(cpp, item, value)
    elif isinstance(value, FloatTag):
        ListTag_insert_float_tag(cpp, item, value)
    elif isinstance(value, DoubleTag):
        ListTag_insert_double_tag(cpp, item, value)
    elif isinstance(value, ByteArrayTag):
        ListTag_insert_byte_array_tag(cpp, item, value)
    elif isinstance(value, StringTag):
        ListTag_insert_string_tag(cpp, item, value)
    elif isinstance(value, ListTag):
        ListTag_insert_list_tag(cpp, item, value)
    elif isinstance(value, CompoundTag):
        ListTag_insert_compound_tag(cpp, item, value)
    elif isinstance(value, IntArrayTag):
        ListTag_insert_int_array_tag(cpp, item, value)
    elif isinstance(value, LongArrayTag):
        ListTag_insert_long_array_tag(cpp, item, value)
    else:
        raise TypeError(f"Unsupported type {type(value)}")


cdef inline void ListTag_append_byte_tag(CListTagPtr cpp, ByteTag value):
    cdef CByteList* byte_list
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CByteList]()
        byte_list = &get[CByteList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(byte_list).push_back(value.cpp)


cdef inline void ListTag_append_short_tag(CListTagPtr cpp, ShortTag value):
    cdef CShortList* short_list
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CShortList]()
        short_list = &get[CShortList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(short_list).push_back(value.cpp)


cdef inline void ListTag_append_int_tag(CListTagPtr cpp, IntTag value):
    cdef CIntList* int_list
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CIntList]()
        int_list = &get[CIntList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(int_list).push_back(value.cpp)


cdef inline void ListTag_append_long_tag(CListTagPtr cpp, LongTag value):
    cdef CLongList* long_list
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CLongList]()
        long_list = &get[CLongList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(long_list).push_back(value.cpp)


cdef inline void ListTag_append_float_tag(CListTagPtr cpp, FloatTag value):
    cdef CFloatList* float_list
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CFloatList]()
        float_list = &get[CFloatList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(float_list).push_back(value.cpp)


cdef inline void ListTag_append_double_tag(CListTagPtr cpp, DoubleTag value):
    cdef CDoubleList* double_list
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CDoubleList]()
        double_list = &get[CDoubleList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(double_list).push_back(value.cpp)


cdef inline void ListTag_append_byte_array_tag(CListTagPtr cpp, ByteArrayTag value):
    cdef CByteArrayList* byte_array_list
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CByteArrayList]()
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(byte_array_list).push_back(value.cpp)


cdef inline void ListTag_append_string_tag(CListTagPtr cpp, StringTag value):
    cdef CStringList* string_list
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CStringList]()
        string_list = &get[CStringList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(string_list).push_back(value.cpp)


cdef inline void ListTag_append_list_tag(CListTagPtr cpp, ListTag value):
    cdef CListList* list_list
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CListList]()
        list_list = &get[CListList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(list_list).push_back(value.cpp)


cdef inline void ListTag_append_compound_tag(CListTagPtr cpp, CompoundTag value):
    cdef CCompoundList* compound_list
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CCompoundList]()
        compound_list = &get[CCompoundList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(compound_list).push_back(value.cpp)


cdef inline void ListTag_append_int_array_tag(CListTagPtr cpp, IntArrayTag value):
    cdef CIntArrayList* int_array_list
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CIntArrayList]()
        int_array_list = &get[CIntArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(int_array_list).push_back(value.cpp)


cdef inline void ListTag_append_long_array_tag(CListTagPtr cpp, LongArrayTag value):
    cdef CLongArrayList* long_array_list
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
    elif ListTag_len(cpp) == 0:
        dereference(cpp).emplace[CLongArrayList]()
        long_array_list = &get[CLongArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")

    dereference(long_array_list).push_back(value.cpp)


cdef inline void ListTag_append(CListTagPtr cpp, AbstractBaseTag value):
    if isinstance(value, ByteTag):
        ListTag_append_byte_tag(cpp, value)
    elif isinstance(value, ShortTag):
        ListTag_append_short_tag(cpp, value)
    elif isinstance(value, IntTag):
        ListTag_append_int_tag(cpp, value)
    elif isinstance(value, LongTag):
        ListTag_append_long_tag(cpp, value)
    elif isinstance(value, FloatTag):
        ListTag_append_float_tag(cpp, value)
    elif isinstance(value, DoubleTag):
        ListTag_append_double_tag(cpp, value)
    elif isinstance(value, ByteArrayTag):
        ListTag_append_byte_array_tag(cpp, value)
    elif isinstance(value, StringTag):
        ListTag_append_string_tag(cpp, value)
    elif isinstance(value, ListTag):
        ListTag_append_list_tag(cpp, value)
    elif isinstance(value, CompoundTag):
        ListTag_append_compound_tag(cpp, value)
    elif isinstance(value, IntArrayTag):
        ListTag_append_int_array_tag(cpp, value)
    elif isinstance(value, LongArrayTag):
        ListTag_append_long_array_tag(cpp, value)
    else:
        raise TypeError(f"Unsupported type {type(value)}")


def _unpickle(string data) -> ListTag:
    cdef pair[string, TagNode] named_tag = read_named_tag(data, endian.big, utf8_to_utf8_escape)
    return ListTag.wrap(get[CListTagPtr](named_tag.second))


cdef class ListTag(AbstractBaseMutableTag):
    """A Python wrapper around a C++ vector.

    All contained data must be of the same NBT data type.
    """
    tag_id: int = 9

    def __init__(self, object value: Iterable[AbstractBaseTag] = (), char element_tag_id = 1) -> None:
        self.cpp = make_shared[CListTag]()
        if element_tag_id == 0:
            dereference(self.cpp).emplace[monostate]()
        elif element_tag_id == 1:
            dereference(self.cpp).emplace[CByteList]()
        elif element_tag_id == 2:
            dereference(self.cpp).emplace[CShortList]()
        elif element_tag_id == 3:
            dereference(self.cpp).emplace[CIntList]()
        elif element_tag_id == 4:
            dereference(self.cpp).emplace[CLongList]()
        elif element_tag_id == 5:
            dereference(self.cpp).emplace[CFloatList]()
        elif element_tag_id == 6:
            dereference(self.cpp).emplace[CDoubleList]()
        elif element_tag_id == 7:
            dereference(self.cpp).emplace[CByteArrayList]()
        elif element_tag_id == 8:
            dereference(self.cpp).emplace[CStringList]()
        elif element_tag_id == 9:
            dereference(self.cpp).emplace[CListList]()
        elif element_tag_id == 10:
            dereference(self.cpp).emplace[CCompoundList]()
        elif element_tag_id == 11:
            dereference(self.cpp).emplace[CIntArrayList]()
        elif element_tag_id == 12:
            dereference(self.cpp).emplace[CLongArrayList]()
        else:
            raise ValueError(f"element_tag_id must be between 0 and 12. Got {element_tag_id}")

        for tag in value:
            self.append(tag)

    @staticmethod
    cdef ListTag wrap(CListTagPtr cpp):
        cdef ListTag tag = ListTag.__new__(ListTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CListTagPtr](self.cpp)
        return node

    @property
    def py_list(self) -> list[ByteTag] | list[ShortTag] | list[IntTag] | list[LongTag] | list[FloatTag] | list[
        DoubleTag] | list[StringTag] | list[CompoundTag] | list[ByteArrayTag] | list[IntArrayTag] | list[LongArrayTag]:
        """A python list representation of the class.

        The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """
        return list(self)

    @property
    def py_data(self) -> Any:
        return list(self)

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CListTagPtr](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        cdef string indent_str
        if indent is None:
            write_list_snbt(snbt, self.cpp)
        else:
            if isinstance(indent, int):
                indent_str = " " * indent
            elif isinstance(indent, str):
                indent_str = indent
            else:
                raise TypeError("indent must be a str, int or None")
            write_list_snbt(snbt, self.cpp, indent_str, 0)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, ListTag):
            return False
        cdef ListTag tag = other
        return is_list_eq(self.cpp, tag.cpp)

    def __repr__(self) -> str:
        return f"ListTag({list(self)!r}, {self.element_tag_id})"

    def __str__(self) -> str:
        return str(list(self))

    def __reduce__(self):
        cdef bytes nbt = self.write_nbt(b"", endian.big, utf8_escape_to_utf8)
        return _unpickle, (nbt,)

    def __copy__(self) -> ListTag:
        return ListTag.wrap(
            make_shared[CListTag](dereference(self.cpp))
        )

    def __deepcopy__(self, memo=None) -> ListTag:
        return ListTag.wrap(CListTagPtr_deepcopy(self.cpp))

    @property
    def element_tag_id(self) -> int:
        """The numerical id of the element type in this list.

        Will be an int in the range 0-12.
        """
        return dereference(self.cpp).index()

    @property
    def element_class(self) -> (
        None |
        Type[ByteTag] |
        Type[ShortTag] |
        Type[IntTag] |
        Type[LongTag] |
        Type[FloatTag] |
        Type[DoubleTag] |
        Type[StringTag] |
        Type[ByteArrayTag] |
        Type[ListTag] |
        Type[CompoundTag] |
        Type[IntArrayTag] |
        Type[LongArrayTag]
    ):
        """The python class for the tag type contained in this list or None if the list tag is in the 0 state."""
        return (
            None,
            ByteTag,
            ShortTag,
            IntTag,
            LongTag,
            FloatTag,
            DoubleTag,
            StringTag,
            ByteArrayTag,
            ListTag,
            CompoundTag,
            IntArrayTag,
            LongArrayTag,
        )[self.element_tag_id]

    # Sized
    def __len__(self) -> int:
        """The number of elements in the list."""
        return ListTag_len(self.cpp)

    # Sequence
    def __getitem__(self, object item):
        """Get an item or slice of items from the list."""
        if isinstance(item, int):
            return ListTag_get_item(self.cpp, item)
        elif isinstance(item, slice):
            return ListTag_get_slice(self.cpp, item)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def __iter__(self):
        """Iterate through items in the list."""
        i = 0
        try:
            while True:
                v = self[i]
                yield v
                i += 1
        except IndexError:
            return

    def __contains__(self, value):
        """Check if the item is in the list."""
        for v in self:
            if v is value or v == value:
                return True
        return False

    def __reversed__(self):
        """A reversed iterator for the list."""
        for i in reversed(range(len(self))):
            yield self[i]

    def index(self, value, start=0, stop=None):
        '''S.index(value, [start, [stop]]) -> integer -- return first index of value.
           Raises ValueError if the value is not present.

           Supporting start and stop arguments is optional, but
           recommended.
        '''
        if start is not None and start < 0:
            start = max(len(self) + start, 0)
        if stop is not None and stop < 0:
            stop += len(self)

        i = start
        while stop is None or i < stop:
            try:
                v = self[i]
            except IndexError:
                break
            if v is value or v == value:
                return i
            i += 1
        raise ValueError

    def count(self, value):
        'S.count(value) -> integer -- return number of occurrences of value'
        return sum(1 for v in self if v is value or v == value)

    # MutableSequence
    def __setitem__(self, object item, object value):
        if isinstance(item, int):
            ListTag_set_item(self.cpp, item, value)
        elif isinstance(item, slice):
            ListTag_set_slice(self.cpp, item, value)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def __delitem__(self, object item):
        if isinstance(item, int):
            ListTag_del_item(self.cpp, item)
        elif isinstance(item, slice):
            ListTag_del_slice(self.cpp, item)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def insert(self, ptrdiff_t index, AbstractBaseTag value not None):
        ListTag_insert(self.cpp, index, value)

    def append(self, AbstractBaseTag value not None):
        'S.append(value) -- append value to the end of the sequence'
        ListTag_append(self.cpp, value)

    def clear(self):
        cdef size_t index = dereference(self.cpp).index()
        if index == 1:
            get[CByteList](dereference(self.cpp)).clear()
        elif index == 2:
            get[CShortList](dereference(self.cpp)).clear()
        elif index == 3:
            get[CIntList](dereference(self.cpp)).clear()
        elif index == 4:
            get[CLongList](dereference(self.cpp)).clear()
        elif index == 5:
            get[CFloatList](dereference(self.cpp)).clear()
        elif index == 6:
            get[CDoubleList](dereference(self.cpp)).clear()
        elif index == 7:
            get[CByteArrayList](dereference(self.cpp)).clear()
        elif index == 8:
            get[CStringList](dereference(self.cpp)).clear()
        elif index == 9:
            get[CListList](dereference(self.cpp)).clear()
        elif index == 10:
            get[CCompoundList](dereference(self.cpp)).clear()
        elif index == 11:
            get[CIntArrayList](dereference(self.cpp)).clear()
        elif index == 12:
            get[CLongArrayList](dereference(self.cpp)).clear()

    def reverse(self):
        'S.reverse() -- reverse *IN PLACE*'
        n = len(self)
        for i in range(n//2):
            self[i], self[n-i-1] = self[n-i-1], self[i]

    def extend(self, values):
        'S.extend(iterable) -- extend sequence by appending elements from the iterable'
        if values is self:
            values = list(values)
        for v in values:
            self.append(v)

    def pop(self, index=-1):
        '''S.pop([index]) -> item -- remove and return item at index (default last).
           Raise IndexError if list is empty or index is out of range.
        '''
        v = self[index]
        del self[index]
        return v

    def remove(self, value):
        '''S.remove(value) -- remove first occurrence of value.
           Raise ValueError if the value is not present.
        '''
        del self[self.index(value)]

    def __iadd__(self, values):
        self.extend(values)
        return self

    def copy(self) -> ListTag:
        """Return a shallow copy of the class"""
        return ListTag(self, dereference(self.cpp).index())

    def get_byte(self, ptrdiff_t index) -> amulet_nbt.ByteTag:
        """Get the tag at index if it is a ByteTag.
    
        :param index: The index to get
        :return: The ByteTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteTag
        """
        cdef ByteTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_short(self, ptrdiff_t index) -> amulet_nbt.ShortTag:
        """Get the tag at index if it is a ShortTag.
    
        :param index: The index to get
        :return: The ShortTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ShortTag
        """
        cdef ShortTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_int(self, ptrdiff_t index) -> amulet_nbt.IntTag:
        """Get the tag at index if it is a IntTag.
    
        :param index: The index to get
        :return: The IntTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntTag
        """
        cdef IntTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_long(self, ptrdiff_t index) -> amulet_nbt.LongTag:
        """Get the tag at index if it is a LongTag.
    
        :param index: The index to get
        :return: The LongTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongTag
        """
        cdef LongTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_float(self, ptrdiff_t index) -> amulet_nbt.FloatTag:
        """Get the tag at index if it is a FloatTag.
    
        :param index: The index to get
        :return: The FloatTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a FloatTag
        """
        cdef FloatTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_double(self, ptrdiff_t index) -> amulet_nbt.DoubleTag:
        """Get the tag at index if it is a DoubleTag.
    
        :param index: The index to get
        :return: The DoubleTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a DoubleTag
        """
        cdef DoubleTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_string(self, ptrdiff_t index) -> amulet_nbt.StringTag:
        """Get the tag at index if it is a StringTag.
    
        :param index: The index to get
        :return: The StringTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a StringTag
        """
        cdef StringTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_list(self, ptrdiff_t index) -> amulet_nbt.ListTag:
        """Get the tag at index if it is a ListTag.
    
        :param index: The index to get
        :return: The ListTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ListTag
        """
        cdef ListTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_compound(self, ptrdiff_t index) -> amulet_nbt.CompoundTag:
        """Get the tag at index if it is a CompoundTag.
    
        :param index: The index to get
        :return: The CompoundTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a CompoundTag
        """
        cdef CompoundTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_byte_array(self, ptrdiff_t index) -> amulet_nbt.ByteArrayTag:
        """Get the tag at index if it is a ByteArrayTag.
    
        :param index: The index to get
        :return: The ByteArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """
        cdef ByteArrayTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_int_array(self, ptrdiff_t index) -> amulet_nbt.IntArrayTag:
        """Get the tag at index if it is a IntArrayTag.
    
        :param index: The index to get
        :return: The IntArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntArrayTag
        """
        cdef IntArrayTag tag = ListTag_get_item(self.cpp, index)
        return tag

    def get_long_array(self, ptrdiff_t index) -> amulet_nbt.LongArrayTag:
        """Get the tag at index if it is a LongArrayTag.
    
        :param index: The index to get
        :return: The LongArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongArrayTag
        """
        cdef LongArrayTag tag = ListTag_get_item(self.cpp, index)
        return tag
