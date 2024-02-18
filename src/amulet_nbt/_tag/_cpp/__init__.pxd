# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS


from amulet_nbt._tag._cpp.nbt cimport (
    TagNode,
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
)

from amulet_nbt._tag._cpp.array cimport Array
