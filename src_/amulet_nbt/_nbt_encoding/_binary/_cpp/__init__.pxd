# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS

from amulet_nbt._nbt_encoding._binary._cpp.read_nbt cimport read_named_tag
from amulet_nbt._nbt_encoding._binary._cpp.write_nbt cimport write_named_tag
