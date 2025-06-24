#include <pybind11/pybind11.h>

#include <exception>

#include <amulet/pybind11_extensions/compatibility.hpp>

#include <amulet/nbt/common.hpp>

namespace py = pybind11;
namespace pyext = Amulet::pybind11_extensions;

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

void init_module(py::module m)
{
    pyext::init_compiler_config(m);
    pyext::check_compatibility(py::module::import("amulet.zlib"), m);

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

    // Tag Alias's
    m.attr("TAG_Byte") = m.attr("ByteTag");
    m.attr("TAG_Short") = m.attr("ShortTag");
    m.attr("TAG_Int") = m.attr("IntTag");
    m.attr("TAG_Long") = m.attr("LongTag");
    m.attr("TAG_Float") = m.attr("FloatTag");
    m.attr("TAG_Double") = m.attr("DoubleTag");
    m.attr("TAG_Byte_Array") = m.attr("ByteArrayTag");
    m.attr("TAG_String") = m.attr("StringTag");
    m.attr("TAG_List") = m.attr("ListTag");
    m.attr("TAG_Compound") = m.attr("CompoundTag");
    m.attr("TAG_Int_Array") = m.attr("IntArrayTag");
    m.attr("TAG_Long_Array") = m.attr("LongArrayTag");

    init_named_tag(m);

    init_bnbt(m);
    init_snbt(m);
}

PYBIND11_MODULE(_amulet_nbt, m)
{
    py::options options;
    options.disable_function_signatures();
    m.def("init", &init_module, py::doc("init(arg0: types.ModuleType) -> None"));
    options.enable_function_signatures();
}
