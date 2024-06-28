# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS

from amulet_nbt._nbt_encoding._string._cpp cimport (
    write_node_snbt,
    write_byte_snbt,
    write_short_snbt,
    write_int_snbt,
    write_long_snbt,
    write_float_snbt,
    write_double_snbt,
    write_byte_array_snbt,
    write_string_snbt,
    write_list_snbt,
    write_compound_snbt,
    write_int_array_snbt,
    write_long_array_snbt,
)
