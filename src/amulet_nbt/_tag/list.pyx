## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.

from collections.abc import MutableSequence

from libc.stdint cimport int64_t
from libcpp cimport bool
from libcpp.memory cimport make_shared
from cython.operator cimport dereference
from amulet_nbt._libcpp.variant cimport get

from amulet_nbt._nbt cimport (
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CByteArrayTagPtr,
    CStringTag,
    CListTag,
    CListTagPtr,
    CCompoundTagPtr,
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
)
from amulet_nbt._tag.abc cimport AbstractBaseTag, AbstractBaseMutableTag
from amulet_nbt._tag.array cimport ByteArrayTag, IntArrayTag, LongArrayTag
from amulet_nbt._tag.compound cimport CompoundTag
from amulet_nbt._tag.float cimport FloatTag, DoubleTag
from amulet_nbt._tag.int cimport ByteTag, ShortTag, IntTag, LongTag
from amulet_nbt._tag.string cimport StringTag
# from amulet_nbt._const cimport ID_LIST, CommaSpace, CommaNewline
# from amulet_nbt._dtype import AnyNBT, EncoderType


cdef inline bool _is_byte_tag_list_eq(CListTagPtr a, CListTagPtr b) noexcept nogil:
    cdef CByteList* byte_list_a = &get[CByteList](dereference(a))
    if dereference(b).index() != 1:
        return dereference(byte_list_a).size() == 0 and _len(b) == 0
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
        return dereference(short_list_a).size() == 0 and _len(b) == 0
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
        return dereference(int_list_a).size() == 0 and _len(b) == 0
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
        return dereference(long_list_a).size() == 0 and _len(b) == 0
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
        return dereference(float_list_a).size() == 0 and _len(b) == 0
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
        return dereference(double_list_a).size() == 0 and _len(b) == 0
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
        return dereference(byte_array_list_a).size() == 0 and _len(b) == 0
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
        return dereference(string_list_a).size() == 0 and _len(b) == 0
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
        return dereference(list_list_a).size() == 0 and _len(b) == 0
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
        return dereference(compound_list_a).size() == 0 and _len(b) == 0
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
        return dereference(int_array_list_a).size() == 0 and _len(b) == 0
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
        return dereference(long_array_list_a).size() == 0 and _len(b) == 0
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
    if index == 1:
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


cdef inline size_t _len(CListTagPtr cpp):
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

    else:
        raise RuntimeError


cdef inline ByteTag _get_byte_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteList* byte_list = &get[CByteList](dereference(cpp))
    if item < 0:
        item += dereference(byte_list).size()
    if item < 0 or item >= dereference(byte_list).size():
        raise IndexError("ListTag index out of range")
    return ByteTag.wrap(dereference(byte_list)[item])


cdef inline ShortTag _get_short_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CShortList* short_list = &get[CShortList](dereference(cpp))
    if item < 0:
        item += dereference(short_list).size()
    if item < 0 or item >= dereference(short_list).size():
        raise IndexError("ListTag index out of range")
    return ShortTag.wrap(dereference(short_list)[item])


cdef inline IntTag _get_int_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntList* int_list = &get[CIntList](dereference(cpp))
    if item < 0:
        item += dereference(int_list).size()
    if item < 0 or item >= dereference(int_list).size():
        raise IndexError("ListTag index out of range")
    return IntTag.wrap(dereference(int_list)[item])


cdef inline LongTag _get_long_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongList* long_list = &get[CLongList](dereference(cpp))
    if item < 0:
        item += dereference(long_list).size()
    if item < 0 or item >= dereference(long_list).size():
        raise IndexError("ListTag index out of range")
    return LongTag.wrap(dereference(long_list)[item])


cdef inline FloatTag _get_float_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CFloatList* float_list = &get[CFloatList](dereference(cpp))
    if item < 0:
        item += dereference(float_list).size()
    if item < 0 or item >= dereference(float_list).size():
        raise IndexError("ListTag index out of range")
    return FloatTag.wrap(dereference(float_list)[item])


cdef inline DoubleTag _get_double_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CDoubleList* double_list = &get[CDoubleList](dereference(cpp))
    if item < 0:
        item += dereference(double_list).size()
    if item < 0 or item >= dereference(double_list).size():
        raise IndexError("ListTag index out of range")
    return DoubleTag.wrap(dereference(double_list)[item])


cdef inline ByteArrayTag _get_byte_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteArrayList* byte_array_list = &get[CByteArrayList](dereference(cpp))
    if item < 0:
        item += dereference(byte_array_list).size()
    if item < 0 or item >= dereference(byte_array_list).size():
        raise IndexError("ListTag index out of range")
    return ByteArrayTag.wrap(dereference(byte_array_list)[item])


cdef inline StringTag _get_string_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CStringList* string_list = &get[CStringList](dereference(cpp))
    if item < 0:
        item += dereference(string_list).size()
    if item < 0 or item >= dereference(string_list).size():
        raise IndexError("ListTag index out of range")
    return StringTag.wrap(dereference(string_list)[item])


cdef inline ListTag _get_list_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CListList* list_list = &get[CListList](dereference(cpp))
    if item < 0:
        item += dereference(list_list).size()
    if item < 0 or item >= dereference(list_list).size():
        raise IndexError("ListTag index out of range")
    return ListTag.wrap(dereference(list_list)[item])


cdef inline CompoundTag _get_compound_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CCompoundList* compound_list = &get[CCompoundList](dereference(cpp))
    if item < 0:
        item += dereference(compound_list).size()
    if item < 0 or item >= dereference(compound_list).size():
        raise IndexError("ListTag index out of range")
    return CompoundTag.wrap(dereference(compound_list)[item])


cdef inline IntArrayTag _get_int_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntArrayList* int_array_list = &get[CIntArrayList](dereference(cpp))
    if item < 0:
        item += dereference(int_array_list).size()
    if item < 0 or item >= dereference(int_array_list).size():
        raise IndexError("ListTag index out of range")
    return IntArrayTag.wrap(dereference(int_array_list)[item])


cdef inline LongArrayTag _get_long_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongArrayList* long_array_list = &get[CLongArrayList](dereference(cpp))
    if item < 0:
        item += dereference(long_array_list).size()
    if item < 0 or item >= dereference(long_array_list).size():
        raise IndexError("ListTag index out of range")
    return LongArrayTag.wrap(dereference(long_array_list)[item])


cdef inline AbstractBaseTag _get_item(CListTagPtr cpp, ptrdiff_t item):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        return _get_byte_tag(cpp, item)
    elif index == 2:
        return _get_short_tag(cpp, item)
    elif index == 3:
        return _get_int_tag(cpp, item)
    elif index == 4:
        return _get_long_tag(cpp, item)
    elif index == 5:
        return _get_float_tag(cpp, item)
    elif index == 6:
        return _get_double_tag(cpp, item)
    elif index == 7:
        return _get_byte_array_tag(cpp, item)
    elif index == 8:
        return _get_string_tag(cpp, item)
    elif index == 9:
        return _get_list_tag(cpp, item)
    elif index == 10:
        return _get_compound_tag(cpp, item)
    elif index == 11:
        return _get_int_array_tag(cpp, item)
    elif index == 12:
        return _get_long_array_tag(cpp, item)
    else:
        raise RuntimeError("ListTag type has not been set.")


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


cdef inline list _get_slice_byte_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CByteList* byte_list
    byte_list = &get[CByteList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(byte_list).size(), s)
    return [
        ByteTag.wrap(dereference(byte_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_short_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CShortList* short_list
    short_list = &get[CShortList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(short_list).size(), s)
    return [
        ShortTag.wrap(dereference(short_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_int_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CIntList* int_list
    int_list = &get[CIntList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(int_list).size(), s)
    return [
        IntTag.wrap(dereference(int_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_long_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CLongList* long_list
    long_list = &get[CLongList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(long_list).size(), s)
    return [
        LongTag.wrap(dereference(long_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_float_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CFloatList* float_list
    float_list = &get[CFloatList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(float_list).size(), s)
    return [
        FloatTag.wrap(dereference(float_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_double_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CDoubleList* double_list
    double_list = &get[CDoubleList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(double_list).size(), s)
    return [
        DoubleTag.wrap(dereference(double_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_byte_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CByteArrayList* byte_array_list
    byte_array_list = &get[CByteArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(byte_array_list).size(), s)
    return [
        ByteArrayTag.wrap(dereference(byte_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_string_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CStringList* string_list
    string_list = &get[CStringList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(string_list).size(), s)
    return [
        StringTag.wrap(dereference(string_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_list_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CListList* list_list
    list_list = &get[CListList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(list_list).size(), s)
    return [
        ListTag.wrap(dereference(list_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_compound_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CCompoundList* compound_list
    compound_list = &get[CCompoundList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(compound_list).size(), s)
    return [
        CompoundTag.wrap(dereference(compound_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_int_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CIntArrayList* int_array_list
    int_array_list = &get[CIntArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(int_array_list).size(), s)
    return [
        IntArrayTag.wrap(dereference(int_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice_long_array_tag(CListTagPtr cpp, object s):
    cdef size_t start
    cdef size_t stop
    cdef ptrdiff_t step
    cdef size_t item
    
    cdef CLongArrayList* long_array_list
    long_array_list = &get[CLongArrayList](dereference(cpp))
    
    start, stop, step = _slice_to_range(dereference(long_array_list).size(), s)
    return [
        LongArrayTag.wrap(dereference(long_array_list)[item])
        for item in range(start, stop, step)
    ]


cdef inline list _get_slice(CListTagPtr cpp, object s):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        return _get_slice_byte_tag(cpp, s)
    elif index == 2:
        return _get_slice_short_tag(cpp, s)
    elif index == 3:
        return _get_slice_int_tag(cpp, s)
    elif index == 4:
        return _get_slice_long_tag(cpp, s)
    elif index == 5:
        return _get_slice_float_tag(cpp, s)
    elif index == 6:
        return _get_slice_double_tag(cpp, s)
    elif index == 7:
        return _get_slice_byte_array_tag(cpp, s)
    elif index == 8:
        return _get_slice_string_tag(cpp, s)
    elif index == 9:
        return _get_slice_list_tag(cpp, s)
    elif index == 10:
        return _get_slice_compound_tag(cpp, s)
    elif index == 11:
        return _get_slice_int_array_tag(cpp, s)
    elif index == 12:
        return _get_slice_long_array_tag(cpp, s)
    else:
        raise RuntimeError("ListTag type has not been set.")


cdef inline void _set_byte_tag(CListTagPtr cpp, ptrdiff_t item, ByteTag value):
    cdef CByteList* byte_list
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
        if item < 0:
            item += dereference(byte_list).size()
        if item < 0 or item >= dereference(byte_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(byte_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CByteList]()
        byte_list = &get[CByteList](dereference(cpp))
        dereference(byte_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_short_tag(CListTagPtr cpp, ptrdiff_t item, ShortTag value):
    cdef CShortList* short_list
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
        if item < 0:
            item += dereference(short_list).size()
        if item < 0 or item >= dereference(short_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(short_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CShortList]()
        short_list = &get[CShortList](dereference(cpp))
        dereference(short_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_int_tag(CListTagPtr cpp, ptrdiff_t item, IntTag value):
    cdef CIntList* int_list
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
        if item < 0:
            item += dereference(int_list).size()
        if item < 0 or item >= dereference(int_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(int_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CIntList]()
        int_list = &get[CIntList](dereference(cpp))
        dereference(int_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_long_tag(CListTagPtr cpp, ptrdiff_t item, LongTag value):
    cdef CLongList* long_list
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
        if item < 0:
            item += dereference(long_list).size()
        if item < 0 or item >= dereference(long_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(long_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CLongList]()
        long_list = &get[CLongList](dereference(cpp))
        dereference(long_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_float_tag(CListTagPtr cpp, ptrdiff_t item, FloatTag value):
    cdef CFloatList* float_list
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
        if item < 0:
            item += dereference(float_list).size()
        if item < 0 or item >= dereference(float_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(float_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CFloatList]()
        float_list = &get[CFloatList](dereference(cpp))
        dereference(float_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_double_tag(CListTagPtr cpp, ptrdiff_t item, DoubleTag value):
    cdef CDoubleList* double_list
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
        if item < 0:
            item += dereference(double_list).size()
        if item < 0 or item >= dereference(double_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(double_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CDoubleList]()
        double_list = &get[CDoubleList](dereference(cpp))
        dereference(double_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_byte_array_tag(CListTagPtr cpp, ptrdiff_t item, ByteArrayTag value):
    cdef CByteArrayList* byte_array_list
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
        if item < 0:
            item += dereference(byte_array_list).size()
        if item < 0 or item >= dereference(byte_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(byte_array_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CByteArrayList]()
        byte_array_list = &get[CByteArrayList](dereference(cpp))
        dereference(byte_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_string_tag(CListTagPtr cpp, ptrdiff_t item, StringTag value):
    cdef CStringList* string_list
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
        if item < 0:
            item += dereference(string_list).size()
        if item < 0 or item >= dereference(string_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(string_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CStringList]()
        string_list = &get[CStringList](dereference(cpp))
        dereference(string_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_list_tag(CListTagPtr cpp, ptrdiff_t item, ListTag value):
    cdef CListList* list_list
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
        if item < 0:
            item += dereference(list_list).size()
        if item < 0 or item >= dereference(list_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(list_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CListList]()
        list_list = &get[CListList](dereference(cpp))
        dereference(list_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_compound_tag(CListTagPtr cpp, ptrdiff_t item, CompoundTag value):
    cdef CCompoundList* compound_list
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
        if item < 0:
            item += dereference(compound_list).size()
        if item < 0 or item >= dereference(compound_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(compound_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CCompoundList]()
        compound_list = &get[CCompoundList](dereference(cpp))
        dereference(compound_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_int_array_tag(CListTagPtr cpp, ptrdiff_t item, IntArrayTag value):
    cdef CIntArrayList* int_array_list
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
        if item < 0:
            item += dereference(int_array_list).size()
        if item < 0 or item >= dereference(int_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(int_array_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CIntArrayList]()
        int_array_list = &get[CIntArrayList](dereference(cpp))
        dereference(int_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_long_array_tag(CListTagPtr cpp, ptrdiff_t item, LongArrayTag value):
    cdef CLongArrayList* long_array_list
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
        if item < 0:
            item += dereference(long_array_list).size()
        if item < 0 or item >= dereference(long_array_list).size():
            raise IndexError("ListTag assignment index out of range")
        dereference(long_array_list)[item] = value.cpp
    elif _len(cpp) == 1 and (item == 0 or item == -1):
        dereference(cpp).emplace[CLongArrayList]()
        long_array_list = &get[CLongArrayList](dereference(cpp))
        dereference(long_array_list).push_back(value.cpp)
    else:
        raise TypeError("NBT ListTag item mismatch.")


cdef inline void _set_item(CListTagPtr cpp, ptrdiff_t item, AbstractBaseTag value):
    if isinstance(value, ByteTag):
        _set_byte_tag(cpp, item, value)
    elif isinstance(value, ShortTag):
        _set_short_tag(cpp, item, value)
    elif isinstance(value, IntTag):
        _set_int_tag(cpp, item, value)
    elif isinstance(value, LongTag):
        _set_long_tag(cpp, item, value)
    elif isinstance(value, FloatTag):
        _set_float_tag(cpp, item, value)
    elif isinstance(value, DoubleTag):
        _set_double_tag(cpp, item, value)
    elif isinstance(value, ByteArrayTag):
        _set_byte_array_tag(cpp, item, value)
    elif isinstance(value, StringTag):
        _set_string_tag(cpp, item, value)
    elif isinstance(value, ListTag):
        _set_list_tag(cpp, item, value)
    elif isinstance(value, CompoundTag):
        _set_compound_tag(cpp, item, value)
    elif isinstance(value, IntArrayTag):
        _set_int_array_tag(cpp, item, value)
    elif isinstance(value, LongArrayTag):
        _set_long_array_tag(cpp, item, value)
    else:
        raise TypeError(f"Unsupported type {type(value)}")


cdef inline void _set_slice(CListTagPtr cpp, object s, object value):
    pass


cdef inline void _del_byte_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteList* byte_list = &get[CByteList](dereference(cpp))
    if item < 0:
        item += dereference(byte_list).size()
    if item < 0 or item >= dereference(byte_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(byte_list).erase(dereference(byte_list).begin() + item)


cdef inline void _del_short_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CShortList* short_list = &get[CShortList](dereference(cpp))
    if item < 0:
        item += dereference(short_list).size()
    if item < 0 or item >= dereference(short_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(short_list).erase(dereference(short_list).begin() + item)


cdef inline void _del_int_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntList* int_list = &get[CIntList](dereference(cpp))
    if item < 0:
        item += dereference(int_list).size()
    if item < 0 or item >= dereference(int_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(int_list).erase(dereference(int_list).begin() + item)


cdef inline void _del_long_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongList* long_list = &get[CLongList](dereference(cpp))
    if item < 0:
        item += dereference(long_list).size()
    if item < 0 or item >= dereference(long_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(long_list).erase(dereference(long_list).begin() + item)


cdef inline void _del_float_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CFloatList* float_list = &get[CFloatList](dereference(cpp))
    if item < 0:
        item += dereference(float_list).size()
    if item < 0 or item >= dereference(float_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(float_list).erase(dereference(float_list).begin() + item)


cdef inline void _del_double_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CDoubleList* double_list = &get[CDoubleList](dereference(cpp))
    if item < 0:
        item += dereference(double_list).size()
    if item < 0 or item >= dereference(double_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(double_list).erase(dereference(double_list).begin() + item)


cdef inline void _del_byte_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CByteArrayList* byte_array_list = &get[CByteArrayList](dereference(cpp))
    if item < 0:
        item += dereference(byte_array_list).size()
    if item < 0 or item >= dereference(byte_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(byte_array_list).erase(dereference(byte_array_list).begin() + item)


cdef inline void _del_string_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CStringList* string_list = &get[CStringList](dereference(cpp))
    if item < 0:
        item += dereference(string_list).size()
    if item < 0 or item >= dereference(string_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(string_list).erase(dereference(string_list).begin() + item)


cdef inline void _del_list_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CListList* list_list = &get[CListList](dereference(cpp))
    if item < 0:
        item += dereference(list_list).size()
    if item < 0 or item >= dereference(list_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(list_list).erase(dereference(list_list).begin() + item)


cdef inline void _del_compound_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CCompoundList* compound_list = &get[CCompoundList](dereference(cpp))
    if item < 0:
        item += dereference(compound_list).size()
    if item < 0 or item >= dereference(compound_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(compound_list).erase(dereference(compound_list).begin() + item)


cdef inline void _del_int_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CIntArrayList* int_array_list = &get[CIntArrayList](dereference(cpp))
    if item < 0:
        item += dereference(int_array_list).size()
    if item < 0 or item >= dereference(int_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(int_array_list).erase(dereference(int_array_list).begin() + item)


cdef inline void _del_long_array_tag(CListTagPtr cpp, ptrdiff_t item):
    cdef CLongArrayList* long_array_list = &get[CLongArrayList](dereference(cpp))
    if item < 0:
        item += dereference(long_array_list).size()
    if item < 0 or item >= dereference(long_array_list).size():
        raise IndexError("ListTag assignment index out of range")
    dereference(long_array_list).erase(dereference(long_array_list).begin() + item)


cdef inline void _del_item(CListTagPtr cpp, ptrdiff_t item):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        _del_byte_tag(cpp, item)
    elif index == 2:
        _del_short_tag(cpp, item)
    elif index == 3:
        _del_int_tag(cpp, item)
    elif index == 4:
        _del_long_tag(cpp, item)
    elif index == 5:
        _del_float_tag(cpp, item)
    elif index == 6:
        _del_double_tag(cpp, item)
    elif index == 7:
        _del_byte_array_tag(cpp, item)
    elif index == 8:
        _del_string_tag(cpp, item)
    elif index == 9:
        _del_list_tag(cpp, item)
    elif index == 10:
        _del_compound_tag(cpp, item)
    elif index == 11:
        _del_int_array_tag(cpp, item)
    elif index == 12:
        _del_long_array_tag(cpp, item)
    else:
        raise RuntimeError("ListTag type has not been set.")


cdef inline void _del_slice_byte_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_short_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_int_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_long_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_float_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_double_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_byte_array_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_string_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_list_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_compound_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_int_array_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice_long_array_tag(CListTagPtr cpp, object s):
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


cdef inline void _del_slice(CListTagPtr cpp, object s):
    cdef size_t index = dereference(cpp).index()
    if index == 1:
        _del_slice_byte_tag(cpp, s)
    elif index == 2:
        _del_slice_short_tag(cpp, s)
    elif index == 3:
        _del_slice_int_tag(cpp, s)
    elif index == 4:
        _del_slice_long_tag(cpp, s)
    elif index == 5:
        _del_slice_float_tag(cpp, s)
    elif index == 6:
        _del_slice_double_tag(cpp, s)
    elif index == 7:
        _del_slice_byte_array_tag(cpp, s)
    elif index == 8:
        _del_slice_string_tag(cpp, s)
    elif index == 9:
        _del_slice_list_tag(cpp, s)
    elif index == 10:
        _del_slice_compound_tag(cpp, s)
    elif index == 11:
        _del_slice_int_array_tag(cpp, s)
    elif index == 12:
        _del_slice_long_array_tag(cpp, s)
    else:
        raise RuntimeError("ListTag type has not been set.")


cdef inline void _insert_byte_tag(CListTagPtr cpp, ptrdiff_t item, ByteTag value):
    cdef CByteList* byte_list
    
    if dereference(cpp).index() == 1:
        byte_list = &get[CByteList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CByteList]()
        byte_list = &get[CByteList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(byte_list).size()
    item = min(max(0, item), dereference(byte_list).size())

    dereference(byte_list).insert(dereference(byte_list).begin() + item, value.cpp)


cdef inline void _insert_short_tag(CListTagPtr cpp, ptrdiff_t item, ShortTag value):
    cdef CShortList* short_list
    
    if dereference(cpp).index() == 2:
        short_list = &get[CShortList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CShortList]()
        short_list = &get[CShortList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(short_list).size()
    item = min(max(0, item), dereference(short_list).size())

    dereference(short_list).insert(dereference(short_list).begin() + item, value.cpp)


cdef inline void _insert_int_tag(CListTagPtr cpp, ptrdiff_t item, IntTag value):
    cdef CIntList* int_list
    
    if dereference(cpp).index() == 3:
        int_list = &get[CIntList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CIntList]()
        int_list = &get[CIntList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(int_list).size()
    item = min(max(0, item), dereference(int_list).size())

    dereference(int_list).insert(dereference(int_list).begin() + item, value.cpp)


cdef inline void _insert_long_tag(CListTagPtr cpp, ptrdiff_t item, LongTag value):
    cdef CLongList* long_list
    
    if dereference(cpp).index() == 4:
        long_list = &get[CLongList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CLongList]()
        long_list = &get[CLongList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(long_list).size()
    item = min(max(0, item), dereference(long_list).size())

    dereference(long_list).insert(dereference(long_list).begin() + item, value.cpp)


cdef inline void _insert_float_tag(CListTagPtr cpp, ptrdiff_t item, FloatTag value):
    cdef CFloatList* float_list
    
    if dereference(cpp).index() == 5:
        float_list = &get[CFloatList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CFloatList]()
        float_list = &get[CFloatList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(float_list).size()
    item = min(max(0, item), dereference(float_list).size())

    dereference(float_list).insert(dereference(float_list).begin() + item, value.cpp)


cdef inline void _insert_double_tag(CListTagPtr cpp, ptrdiff_t item, DoubleTag value):
    cdef CDoubleList* double_list
    
    if dereference(cpp).index() == 6:
        double_list = &get[CDoubleList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CDoubleList]()
        double_list = &get[CDoubleList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(double_list).size()
    item = min(max(0, item), dereference(double_list).size())

    dereference(double_list).insert(dereference(double_list).begin() + item, value.cpp)


cdef inline void _insert_byte_array_tag(CListTagPtr cpp, ptrdiff_t item, ByteArrayTag value):
    cdef CByteArrayList* byte_array_list
    
    if dereference(cpp).index() == 7:
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CByteArrayList]()
        byte_array_list = &get[CByteArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(byte_array_list).size()
    item = min(max(0, item), dereference(byte_array_list).size())

    dereference(byte_array_list).insert(dereference(byte_array_list).begin() + item, value.cpp)


cdef inline void _insert_string_tag(CListTagPtr cpp, ptrdiff_t item, StringTag value):
    cdef CStringList* string_list
    
    if dereference(cpp).index() == 8:
        string_list = &get[CStringList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CStringList]()
        string_list = &get[CStringList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(string_list).size()
    item = min(max(0, item), dereference(string_list).size())

    dereference(string_list).insert(dereference(string_list).begin() + item, value.cpp)


cdef inline void _insert_list_tag(CListTagPtr cpp, ptrdiff_t item, ListTag value):
    cdef CListList* list_list
    
    if dereference(cpp).index() == 9:
        list_list = &get[CListList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CListList]()
        list_list = &get[CListList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(list_list).size()
    item = min(max(0, item), dereference(list_list).size())

    dereference(list_list).insert(dereference(list_list).begin() + item, value.cpp)


cdef inline void _insert_compound_tag(CListTagPtr cpp, ptrdiff_t item, CompoundTag value):
    cdef CCompoundList* compound_list
    
    if dereference(cpp).index() == 10:
        compound_list = &get[CCompoundList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CCompoundList]()
        compound_list = &get[CCompoundList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(compound_list).size()
    item = min(max(0, item), dereference(compound_list).size())

    dereference(compound_list).insert(dereference(compound_list).begin() + item, value.cpp)


cdef inline void _insert_int_array_tag(CListTagPtr cpp, ptrdiff_t item, IntArrayTag value):
    cdef CIntArrayList* int_array_list
    
    if dereference(cpp).index() == 11:
        int_array_list = &get[CIntArrayList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CIntArrayList]()
        int_array_list = &get[CIntArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(int_array_list).size()
    item = min(max(0, item), dereference(int_array_list).size())

    dereference(int_array_list).insert(dereference(int_array_list).begin() + item, value.cpp)


cdef inline void _insert_long_array_tag(CListTagPtr cpp, ptrdiff_t item, LongArrayTag value):
    cdef CLongArrayList* long_array_list
    
    if dereference(cpp).index() == 12:
        long_array_list = &get[CLongArrayList](dereference(cpp))
    elif _len(cpp) == 0:
        dereference(cpp).emplace[CLongArrayList]()
        long_array_list = &get[CLongArrayList](dereference(cpp))
    else:
        raise TypeError("ListTag can only contain one NBT data type.")
    
    if item < 0:
        item += dereference(long_array_list).size()
    item = min(max(0, item), dereference(long_array_list).size())

    dereference(long_array_list).insert(dereference(long_array_list).begin() + item, value.cpp)


cdef inline void _insert(CListTagPtr cpp, ptrdiff_t item, AbstractBaseTag value):
    if isinstance(value, ByteTag):
        _insert_byte_tag(cpp, item, value)
    elif isinstance(value, ShortTag):
        _insert_short_tag(cpp, item, value)
    elif isinstance(value, IntTag):
        _insert_int_tag(cpp, item, value)
    elif isinstance(value, LongTag):
        _insert_long_tag(cpp, item, value)
    elif isinstance(value, FloatTag):
        _insert_float_tag(cpp, item, value)
    elif isinstance(value, DoubleTag):
        _insert_double_tag(cpp, item, value)
    elif isinstance(value, ByteArrayTag):
        _insert_byte_array_tag(cpp, item, value)
    elif isinstance(value, StringTag):
        _insert_string_tag(cpp, item, value)
    elif isinstance(value, ListTag):
        _insert_list_tag(cpp, item, value)
    elif isinstance(value, CompoundTag):
        _insert_compound_tag(cpp, item, value)
    elif isinstance(value, IntArrayTag):
        _insert_int_array_tag(cpp, item, value)
    elif isinstance(value, LongArrayTag):
        _insert_long_array_tag(cpp, item, value)
    else:
        raise TypeError(f"Unsupported type {type(value)}")


cdef class ListTag(AbstractBaseMutableTag, MutableSequence):
    """
    This class behaves like a python list.
    All contained data must be of the same NBT data type.
    """
    # tag_id = ID_LIST

    def __init__(ListTag self, object value = (), char list_data_type = 1):
        self.cpp = make_shared[CListTag]()
        if list_data_type == 1:
            dereference(self.cpp).emplace[CByteList]()
        elif list_data_type == 2:
            dereference(self.cpp).emplace[CShortList]()
        elif list_data_type == 3:
            dereference(self.cpp).emplace[CIntList]()
        elif list_data_type == 4:
            dereference(self.cpp).emplace[CLongList]()
        elif list_data_type == 5:
            dereference(self.cpp).emplace[CFloatList]()
        elif list_data_type == 6:
            dereference(self.cpp).emplace[CDoubleList]()
        elif list_data_type == 7:
            dereference(self.cpp).emplace[CByteArrayList]()
        elif list_data_type == 8:
            dereference(self.cpp).emplace[CStringList]()
        elif list_data_type == 9:
            dereference(self.cpp).emplace[CListList]()
        elif list_data_type == 10:
            dereference(self.cpp).emplace[CCompoundList]()
        elif list_data_type == 11:
            dereference(self.cpp).emplace[CIntArrayList]()
        elif list_data_type == 12:
            dereference(self.cpp).emplace[CLongArrayList]()
        else:
            raise ValueError(f"list_data_type must be between 1 and 12. Got {list_data_type}")

        for tag in value:
            self.append(tag)

    @staticmethod
    cdef ListTag wrap(CListTagPtr cpp):
        cdef ListTag tag = ListTag.__new__(ListTag)
        tag.cpp = cpp
        return tag

# {/{include("amulet_nbt/tpf/AbstractBaseMutableTag.pyx.tpf", cls_name="ListTag")}/}
    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CListTagPtr](self.cpp)
        return node


    @property
    def py_list(ListTag self) -> List[AnyNBT]:
        """
        A python list representation of the class.
        The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """
        return list(self)

    @property
    def py_data(self):
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        return list(self)

    # cdef void _check_tag(ListTag self, AbstractBaseTag value, bint fix_if_empty=True) except *:
    #     if value is None:
    #         raise TypeError("List values must be NBT Tags")
    #     if fix_if_empty and not self.value_:
    #         self.list_data_type = value.tag_id
    #     elif value.tag_id != self.list_data_type:
    #         raise TypeError(
    #             f"Invalid type {value.__class__.__name__} for ListTag(list_data_type={self.list_data_type})"
    #         )
    #
    # cdef void _check_tag_iterable(ListTag self, list value) except *:
    #     cdef int i
    #     cdef AbstractBaseTag tag
    #     for i, tag in enumerate(value):
    #         self._check_tag(tag, not i)

    # def __repr__(ListTag self):
    #     return f"{self.__class__.__name__}({repr(list(self))}, {self.list_data_type})"

    # def __contains__(ListTag self, object item) -> bool:
    #     if not isinstance(item, AbstractBaseTag):
    #         return False
    #     elif isinstance(item, ByteTag):
    #     elif isinstance(item, ShortTag):
    #     elif isinstance(item, IntTag):
    #     elif isinstance(item, LongTag):
    #     elif isinstance(item, FloatTag):
    #     elif isinstance(item, DoubleTag):
    #     elif isinstance(item, StringTag):
    #     elif isinstance(item, ByteArrayTag):
    #     elif isinstance(item, ListTag):
    #     elif isinstance(item, CompoundTag):
    #     elif isinstance(item, IntArrayTag):
    #     elif isinstance(item, LongArrayTag):
    #
    #     if list_data_type == 1:
    #         dereference(self.cpp).emplace[vector[CByteTag]]()
    #     elif list_data_type == 2:
    #         dereference(self.cpp).emplace[vector[CShortTag]]()
    #     elif list_data_type == 3:
    #         dereference(self.cpp).emplace[vector[CIntTag]]()
    #     elif list_data_type == 4:
    #         dereference(self.cpp).emplace[vector[CLongTag]]()
    #     elif list_data_type == 5:
    #         dereference(self.cpp).emplace[vector[CFloatTag]]()
    #     elif list_data_type == 6:
    #         dereference(self.cpp).emplace[vector[CDoubleTag]]()
    #     elif list_data_type == 7:
    #         dereference(self.cpp).emplace[vector[CByteArrayTagPtr]]()
    #     elif list_data_type == 8:
    #         dereference(self.cpp).emplace[vector[CStringTag]]()
    #     elif list_data_type == 9:
    #         dereference(self.cpp).emplace[vector[CListTagPtr]]()
    #     elif list_data_type == 10:
    #         dereference(self.cpp).emplace[vector[CCompoundTagPtr]]()
    #     elif list_data_type == 11:
    #         dereference(self.cpp).emplace[vector[CIntArrayTagPtr]]()
    #     elif list_data_type == 12:
    #         dereference(self.cpp).emplace[vector[CLongArrayTagPtr]]()
    #
    #
    #         and item.tag_id == self.list_data_type and self.value_.__contains__(item)

    def __len__(ListTag self) -> int:
        return _len(self.cpp)

    def __getitem__(ListTag self, object item):
        if isinstance(item, int):
            return _get_item(self.cpp, item)
        elif isinstance(item, slice):
            return _get_slice(self.cpp, item)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def __setitem__(ListTag self, object item, object value):
        if isinstance(item, int):
            _set_item(self.cpp, item, value)
        elif isinstance(item, slice):
            _set_slice(self.cpp, item, value)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def __delitem__(ListTag self, object item):
        if isinstance(item, int):
            _del_item(self.cpp, item)
        elif isinstance(item, slice):
            _del_slice(self.cpp, item)
        else:
            raise TypeError(f"Unsupported item type {type(item)}")

    def copy(ListTag self):
        """Return a shallow copy of the class"""
        return ListTag(self, dereference(self.cpp).index())

    def insert(ListTag self, ptrdiff_t index, AbstractBaseTag value not None):
        _insert(self.cpp, index, value)

# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="ByteTag", tag_name="byte")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="ShortTag", tag_name="short")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="IntTag", tag_name="int")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="LongTag", tag_name="long")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="FloatTag", tag_name="float")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="DoubleTag", tag_name="double")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="StringTag", tag_name="string")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="ListTag", tag_name="list")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="CompoundTag", tag_name="compound")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="ByteArrayTag", tag_name="byte_array")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="IntArrayTag", tag_name="int_array")}/}
# {/{include("amulet_nbt/tpf/ListGet.pyx.tpf", tag_cls_name="LongArrayTag", tag_name="long_array")}/}
