from libcpp.string cimport string
from amulet_nbt._tag._cpp cimport (
    TagNode,
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CStringTag,
    CListTagPtr,
    CCompoundTagPtr,
    CByteArrayTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr,
)


cdef extern from "write_snbt.hpp" nogil:
    void write_node_snbt(string&, const TagNode&) except +
    void write_byte_snbt(string&, const CByteTag&) except +
    void write_short_snbt(string&, const CShortTag&) except +
    void write_int_snbt(string&, const CIntTag&) except +
    void write_long_snbt(string&, const CLongTag&) except +
    void write_float_snbt(string&, const CFloatTag&) except +
    void write_double_snbt(string&, const CDoubleTag&) except +
    void write_byte_array_snbt(string&, const CByteArrayTagPtr&) except +
    void write_string_snbt(string&, const CStringTag&) except +
    void write_list_snbt(string&, const CListTagPtr&) except +
    void write_compound_snbt(string&, const CCompoundTagPtr&) except +
    void write_int_array_snbt(string&, const CIntArrayTagPtr&) except +
    void write_long_array_snbt(string&, const CLongArrayTagPtr&) except +

    # Multi-line variants
    void write_node_snbt(string&, const TagNode&, const string&, size_t) except +
    void write_list_snbt(string&, const CListTagPtr&, const string&, size_t) except +
    void write_compound_snbt(string&, const CCompoundTagPtr&, const string&, size_t) except +
