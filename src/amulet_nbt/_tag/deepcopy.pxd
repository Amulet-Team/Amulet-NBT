from amulet_nbt._tag._cpp cimport CListTagPtr, CCompoundTagPtr

cdef CCompoundTagPtr CCompoundTagPtr_deepcopy(CCompoundTagPtr) noexcept nogil
cdef CListTagPtr CListTagPtr_deepcopy(CListTagPtr) noexcept nogil
