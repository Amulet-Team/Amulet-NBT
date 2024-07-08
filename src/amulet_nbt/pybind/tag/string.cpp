#include <amulet_nbt/tag/wrapper.hpp>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

namespace py = pybind11;

void init_string(py::module& m) {
    py::class_<Amulet::StringTagWrapper, Amulet::AbstractBaseImmutableTag> StringTag(m, "StringTag",
        "A class that behaves like a string."
    );
        StringTag.def_property_readonly_static("tag_id", [](py::object) {return 8;});
        StringTag.def(
            py::init([](py::object value) {
                return Amulet::StringTagWrapper(value.cast<Amulet::StringTag>());
            }),
            py::arg("value") = "",
            py::doc("__init__(self: amulet_nbt.StringTag, value: str | bytes) -> None")
        );
        StringTag.def_readonly(
            "py_str",
            &Amulet::StringTagWrapper::tag,
            py::doc(
                "The data stored in the class as a python string.\n"
                "\n"
                "In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError."
            )
        );
        StringTag.def_property_readonly(
            "py_bytes",
            [](const Amulet::StringTagWrapper& self){
                return py::bytes(self.tag);
            },
            py::doc(
                "The bytes stored in the class."
            )
        );
        StringTag.def_property_readonly(
            "py_data",
            [](const Amulet::StringTagWrapper& self){
                return py::bytes(self.tag);
            },
            py::doc(
                "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
                "\n"
                "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
                "This is here for convenience to get a python representation under the same property name.\n"
            )
        );
        StringTag.def(
            "__repr__",
            [](const Amulet::StringTagWrapper& self){
                try {
                    return "StringTag(" + py::repr(py::str(self.tag)).cast<std::string>() + ")";
                } catch (py::error_already_set&){
                    return "StringTag(" + py::repr(py::bytes(self.tag)).cast<std::string>() + ")";
                }
            }
        );
        StringTag.def(
            "__str__",
            [](const Amulet::StringTagWrapper& self){
                return self.tag;
            }
        );
        StringTag.def(
            "__bytes__",
            [](const Amulet::StringTagWrapper& self){
                return py::bytes(self.tag);
            }
        );
        StringTag.def(
            "__copy__",
            [](const Amulet::StringTagWrapper& self){
                return self;
            }
        );
        StringTag.def(
            "__deepcopy__",
            [](const Amulet::StringTagWrapper& self, py::dict){
                return self;
            },
            py::arg("memo")
        );
        StringTag.def(
            "__hash__",
            [](const Amulet::StringTagWrapper& self){
                return py::hash(py::make_tuple(8, py::bytes(self.tag)));
            }
        );
        StringTag.def(
            "__bool__",
            [](const Amulet::StringTagWrapper& self){
                return !self.tag.empty();
            }
        );
        StringTag.def(
            "__eq__",
            [](const Amulet::StringTagWrapper& self, const Amulet::StringTagWrapper& other){
                return self.tag == other.tag;
            },
            py::is_operator()
        );
        StringTag.def(
            "__ge__",
            [](const Amulet::StringTagWrapper& self, const Amulet::StringTagWrapper& other){
                return self.tag >= other.tag;
            },
            py::is_operator()
        );
        StringTag.def(
            "__gt__",
            [](const Amulet::StringTagWrapper& self, const Amulet::StringTagWrapper& other){
                return self.tag > other.tag;
            },
            py::is_operator()
        );
        StringTag.def(
            "__le__",
            [](const Amulet::StringTagWrapper& self, const Amulet::StringTagWrapper& other){
                return self.tag <= other.tag;
            },
            py::is_operator()
        );
        StringTag.def(
            "__lt__",
            [](const Amulet::StringTagWrapper& self, const Amulet::StringTagWrapper& other){
                return self.tag < other.tag;
            },
            py::is_operator()
        );
}
