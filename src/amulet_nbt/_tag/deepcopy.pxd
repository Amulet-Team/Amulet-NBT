from amulet_nbt._nbt cimport CListTagPtr, CCompoundTagPtr

cdef CCompoundTagPtr CCompoundTagPtr_deepcopy(CCompoundTagPtr) noexcept nogil
cdef CListTagPtr CListTagPtr_deepcopy(CListTagPtr) noexcept nogil
