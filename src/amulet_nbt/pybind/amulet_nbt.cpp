#include <exception>

#include <pybind11/pybind11.h>

#include <amulet_nbt/common.hpp>
#include <iostream>

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

void init_amulet_nbt(py::module& m) {
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
        } catch (const AmuletNBT::type_error& e) {
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

    // Paths
    py::object path_join = py::module::import("os.path").attr("join");
    m.def(
        "get_include",
        [m, path_join](){
            return path_join(m.attr("__path__").attr("__getitem__")(0), py::str("include"));
        },
        py::doc("C++ include directory")
    );
    m.def(
        "get_source",
        [m, path_join](){
            return path_join(m.attr("__path__").attr("__getitem__")(0), py::str("cpp"));
        },
        py::doc("C++ source directory")
    );

    // NBT types
    py::object PyStr = py::module::import("builtins").attr("str");
    m.attr("SNBTType") = PyStr;
    m.attr("IntType") = m.attr("ByteTag") | m.attr("ShortTag") | m.attr("IntTag") | m.attr("LongTag");
    m.attr("FloatType") = m.attr("FloatTag") | m.attr("DoubleTag");
    m.attr("NumberType") = m.attr("IntType") | m.attr("FloatType");
    m.attr("ArrayType") = m.attr("ByteArrayTag") | m.attr("IntArrayTag") | m.attr("LongArrayTag");
    m.attr("AnyNBT") = m.attr("NumberType") | m.attr("StringTag") | m.attr("ListTag") | m.attr("CompoundTag") | m.attr("ArrayType");

    py::list all;
    all.append("__version__");
    all.append("__major__");
    all.append("get_include");
    all.append("AbstractBaseTag");
    all.append("AbstractBaseImmutableTag");
    all.append("AbstractBaseMutableTag");
    all.append("AbstractBaseNumericTag");
    all.append("AbstractBaseIntTag");
    all.append("ByteTag");
    all.append("TAG_Byte");
    all.append("ShortTag");
    all.append("TAG_Short");
    all.append("IntTag");
    all.append("TAG_Int");
    all.append("LongTag");
    all.append("TAG_Long");
    all.append("AbstractBaseFloatTag");
    all.append("FloatTag");
    all.append("TAG_Float");
    all.append("DoubleTag");
    all.append("TAG_Double");
    all.append("AbstractBaseArrayTag");
    all.append("ByteArrayTag");
    all.append("TAG_Byte_Array");
    all.append("IntArrayTag");
    all.append("TAG_Int_Array");
    all.append("LongArrayTag");
    all.append("TAG_Long_Array");
    all.append("StringTag");
    all.append("TAG_String");
    all.append("ListTag");
    all.append("TAG_List");
    all.append("CompoundTag");
    all.append("TAG_Compound");
    all.append("NamedTag");
    all.append("read_nbt");
    all.append("read_nbt_array");
    all.append("ReadOffset");
    all.append("read_snbt");
    all.append("SNBTType");
    all.append("IntType");
    all.append("FloatType");
    all.append("NumberType");
    all.append("ArrayType");
    all.append("AnyNBT");
    all.append("StringEncoding");
    all.append("mutf8_encoding");
    all.append("utf8_encoding");
    all.append("utf8_escape_encoding");
    all.append("EncodingPreset");
    all.append("java_encoding");
    all.append("bedrock_encoding");
    m.attr("__all__") = all;

    // Version numbers
    // For some reason the package is not initialised and you can't import submodules.
    m.def(
        "__getattr__",
        [m](py::object attr) -> py::object {
            if (py::isinstance<py::str>(attr)) {
                std::string name = attr.cast<std::string>();
                if (name == "__version__") {
                    m.attr("__version__") = py::module::import("amulet_nbt._version").attr("get_versions")()["version"];
                    return m.attr("__version__");
                }
                else if (name == "__major__") {
                    py::object PyInt = py::module::import("builtins").attr("int");
                    py::object re_match = py::module::import("re").attr("match");
                    py::object version = py::module::import("amulet_nbt._version").attr("get_versions")()["version"];
                    m.attr("__major__") = PyInt(re_match("\\d+", version).attr("group")());
                    return m.attr("__major__");
                }
            }
            throw py::attribute_error("module amulet_nbt has no attribute " + py::repr(attr).cast<std::string>());
        }
    );
}

// The compiler requires __init__ and the runtime requires amulet_nbt.
// There may be a better way to do this but defining both seems to work.
PYBIND11_MODULE(__init__, m) { init_amulet_nbt(m); }
PYBIND11_MODULE(amulet_nbt, m) { init_amulet_nbt(m); }
