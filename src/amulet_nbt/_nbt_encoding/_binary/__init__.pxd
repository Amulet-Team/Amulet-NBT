# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = -std=c++20 /std:c++20
# distutils: extra_link_args = -std=c++20 /std:c++20

from amulet_nbt._nbt_encoding._binary._cpp cimport read_named_tag, write_named_tag
