from libcpp.memory cimport make_shared
from cython.operator cimport dereference, postincrement

from amulet_nbt._libcpp.variant cimport get

from amulet_nbt._tag._cpp cimport (
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

cdef CCompoundTagPtr CCompoundTagPtr_deepcopy(CCompoundTagPtr tag) noexcept nogil:
    # Start with a shallow copy and deep copy items as required
    tag = make_shared[CCompoundTag](dereference(tag))

    cdef CCompoundTag.iterator it = dereference(tag).begin()
    cdef size_t index
    while it != dereference(tag).end():
        index = dereference(it).second.index()
        if index == 7:
            dereference(it).second.emplace[CByteArrayTagPtr](
                make_shared[CByteArrayTag](
                    dereference(get[CByteArrayTagPtr](dereference(it).second))
                )
            )
        elif index == 9:
            dereference(it).second.emplace[CListTagPtr](
                CListTagPtr_deepcopy(
                    get[CListTagPtr](dereference(it).second)
                )
            )
        elif index == 10:
            dereference(it).second.emplace[CCompoundTagPtr](
                CCompoundTagPtr_deepcopy(
                    get[CCompoundTagPtr](dereference(it).second)
                )
            )
        elif index == 11:
            dereference(it).second.emplace[CIntArrayTagPtr](
                make_shared[CIntArrayTag](dereference(get[CIntArrayTagPtr](dereference(it).second)))
            )
        elif index == 12:
            dereference(it).second.emplace[CLongArrayTagPtr](
                make_shared[CLongArrayTag](dereference(get[CLongArrayTagPtr](dereference(it).second)))
            )
        postincrement(it)
    return tag


cdef inline void _deepcopy_list_list(CListTagPtr tag) noexcept nogil:
    cdef CListList* arr = &get[CListList](dereference(tag))
    cdef size_t index
    for index in range(dereference(arr).size()):
        dereference(arr)[index] = CListTagPtr_deepcopy(dereference(arr)[index])


cdef inline void _deepcopy_compound_list(CListTagPtr tag) noexcept nogil:
    cdef CCompoundList* arr = &get[CCompoundList](dereference(tag))
    cdef size_t index
    for index in range(dereference(arr).size()):
        dereference(arr)[index] = CCompoundTagPtr_deepcopy(dereference(arr)[index])


cdef inline void _deepcopy_byte_array_list(CListTagPtr tag) noexcept nogil:
    cdef CByteArrayList* arr = &get[CByteArrayList](dereference(tag))
    cdef size_t index
    for index in range(dereference(arr).size()):
        dereference(arr)[index] = make_shared[CByteArrayTag](dereference(dereference(arr)[index]))


cdef inline void _deepcopy_int_array_list(CListTagPtr tag) noexcept nogil:
    cdef CIntArrayList* arr = &get[CIntArrayList](dereference(tag))
    cdef size_t index
    for index in range(dereference(arr).size()):
        dereference(arr)[index] = make_shared[CIntArrayTag](dereference(dereference(arr)[index]))


cdef inline void _deepcopy_long_array_list(CListTagPtr tag) noexcept nogil:
    cdef CLongArrayList* arr = &get[CLongArrayList](dereference(tag))
    cdef size_t index
    for index in range(dereference(arr).size()):
        dereference(arr)[index] = make_shared[CLongArrayTag](dereference(dereference(arr)[index]))


cdef CListTagPtr CListTagPtr_deepcopy(CListTagPtr tag) noexcept nogil:
    # Start with a shallow copy and deep copy as required
    tag = make_shared[CListTag](dereference(tag))

    cdef size_t index = dereference(tag).index()
    if index == 7:
        _deepcopy_byte_array_list(tag)
    elif index == 9:
        _deepcopy_list_list(tag)
    elif index == 10:
        _deepcopy_compound_list(tag)
    elif index == 11:
        _deepcopy_int_array_list(tag)
    elif index == 12:
        _deepcopy_long_array_list(tag)

    return tag
