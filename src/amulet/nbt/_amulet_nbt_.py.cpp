#include <pybind11/pybind11.h>

#include <exception>

#include <amulet/nbt/common.hpp>

namespace py = pybind11;

void init_encoding(py::module&);

void init_abc(py::module&);
void init_int(py::module&);
void init_float(py::module&);
void init_string(py::module&);
void init_array(py::module&);
void init_list(py::module&);
void init_compound(py::module&);

void init_named_tag(py::module&);

void init_bnbt(py::module& m);
void init_snbt(py::module& m);

void init_amulet_nbt(py::module m)
{
    // Convert cast_error to type_error
    py::register_local_exception_translator([](std::exception_ptr p) {
        try {
            if (p) {
                std::rethrow_exception(p);
            }
        } catch (const py::cast_error& e) {
            py::set_error(PyExc_TypeError, e.what());
        }
    });

    py::register_exception_translator([](std::exception_ptr p) {
        try {
            if (p) {
                std::rethrow_exception(p);
            }
        } catch (const Amulet::NBT::type_error& e) {
            py::set_error(PyExc_TypeError, e.what());
        }
    });

    init_encoding(m);
    init_abc(m);
    init_int(m);
    init_float(m);
    init_string(m);
    init_array(m);
    init_compound(m);
    init_list(m);

    py::object ByteTag = m.attr("ByteTag");
    py::object ShortTag = m.attr("ShortTag");
    py::object IntTag = m.attr("IntTag");
    py::object LongTag = m.attr("LongTag");
    py::object FloatTag = m.attr("FloatTag");
    py::object DoubleTag = m.attr("DoubleTag");
    py::object ByteArrayTag = m.attr("ByteArrayTag");
    py::object StringTag = m.attr("StringTag");
    py::object ListTag = m.attr("ListTag");
    py::object CompoundTag = m.attr("CompoundTag");
    py::object IntArrayTag = m.attr("IntArrayTag");
    py::object LongArrayTag = m.attr("LongArrayTag");

    // Tag Alias's
    m.attr("TAG_Byte") = ByteTag;
    m.attr("TAG_Short") = ShortTag;
    m.attr("TAG_Int") = IntTag;
    m.attr("TAG_Long") = LongTag;
    m.attr("TAG_Float") = FloatTag;
    m.attr("TAG_Double") = DoubleTag;
    m.attr("TAG_Byte_Array") = ByteArrayTag;
    m.attr("TAG_String") = StringTag;
    m.attr("TAG_List") = ListTag;
    m.attr("TAG_Compound") = CompoundTag;
    m.attr("TAG_Int_Array") = IntArrayTag;
    m.attr("TAG_Long_Array") = LongArrayTag;

    m.attr("SNBTType") = py::module::import("builtins").attr("str");

    py::object IntType = ByteTag | ShortTag | IntTag | LongTag;
    py::object FloatType = FloatTag | DoubleTag;
    py::object NumberType = IntType | FloatType;
    py::object ArrayType = ByteArrayTag | IntArrayTag | LongArrayTag;
    py::object AnyNBT = NumberType | StringTag | ListTag | CompoundTag | ArrayType;

    m.attr("IntType") = IntType;
    m.attr("FloatType") = FloatType;
    m.attr("NumberType") = NumberType;
    m.attr("ArrayType") = ArrayType;
    m.attr("AnyNBT") = AnyNBT;

    init_named_tag(m);

    init_bnbt(m);
    init_snbt(m);
}
