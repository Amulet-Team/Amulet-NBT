#include <bit>
#include <fstream>
#include <string>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/io/binary_writer.hpp>
#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace py = pybind11;

void init_string(py::module& m)
{
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    py::class_<Amulet::NBT::StringTag, Amulet::NBT::AbstractBaseImmutableTag> StringTag(m, "StringTag",
        "A class that behaves like a string.");
    StringTag.def_property_readonly_static("tag_id", [](py::object) { return 8; });
    StringTag.def(
        py::init([](py::object value) {
            if (py::isinstance<Amulet::NBT::StringTag>(value)) {
                return value.cast<Amulet::NBT::StringTag>();
            } else if (py::isinstance<py::bytes>(value) || py::isinstance<py::str>(value)) {
                return Amulet::NBT::StringTag(value.cast<std::string>());
            } else {
                return Amulet::NBT::StringTag(py::str(value).cast<std::string>());
            }
        }),
        py::arg("value") = "",
        py::doc("__init__(self: amulet.nbt.StringTag, value: str | bytes) -> None"));
    StringTag.def_property_readonly(
        "py_str",
        [](const Amulet::NBT::StringTag& self) -> std::string {
            return self;
        },
        py::doc(
            "The data stored in the class as a python string.\n"
            "\n"
            "In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError."));
    StringTag.def_property_readonly(
        "py_bytes",
        [](const Amulet::NBT::StringTag& self) {
            return py::bytes(self);
        },
        py::doc(
            "The bytes stored in the class."));
    StringTag.def_property_readonly(
        "py_str_or_bytes",
        [](const Amulet::NBT::StringTag& self) -> std::variant<py::str, py::bytes> {
            try {
                return py::str(self);
            } catch (py::error_already_set&) {
                return py::bytes(self);
            }
        },
        py::doc("If the payload is UTF-8 returns a string else returns bytes."));
    StringTag.def_property_readonly(
        "py_data",
        [](const Amulet::NBT::StringTag& self) {
            return py::bytes(self);
        },
        py::doc(
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
            "\n"
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
            "This is here for convenience to get a python representation under the same property name.\n"));
    SerialiseTag(StringTag)
        StringTag.def(
            "__repr__",
            [](const Amulet::NBT::StringTag& self) {
                try {
                    return "StringTag(" + py::repr(py::str(self)).cast<std::string>() + ")";
                } catch (py::error_already_set&) {
                    return "StringTag(" + py::repr(py::bytes(self)).cast<std::string>() + ")";
                }
            });
    StringTag.def(
        "__str__",
        [](const Amulet::NBT::StringTag& self) -> std::string {
            return self;
        });
    StringTag.def(
        "__bytes__",
        [](const Amulet::NBT::StringTag& self) {
            return py::bytes(self);
        });
    StringTag.def(
        py::pickle(
            [](const Amulet::NBT::StringTag& self) {
                return py::bytes(self);
            },
            [](py::bytes state) {
                return Amulet::NBT::StringTag(state);
            }));
    StringTag.def(
        "__copy__",
        [](const Amulet::NBT::StringTag& self) {
            return shallow_copy(self);
        });
    StringTag.def(
        "__deepcopy__",
        [](const Amulet::NBT::StringTag& self, py::dict) {
            return deep_copy(self);
        },
        py::arg("memo"));
    StringTag.def(
        "__hash__",
        [](const Amulet::NBT::StringTag& self) {
            return py::hash(py::make_tuple(8, py::bytes(self)));
        });
    StringTag.def(
        "__bool__",
        [](const Amulet::NBT::StringTag& self) {
            return !self.empty();
        });
    StringTag.def(
        "__eq__",
        [](const Amulet::NBT::StringTag& self, const Amulet::NBT::StringTag& other) {
            return self == other;
        },
        py::is_operator());
    StringTag.def(
        "__ge__",
        [](const Amulet::NBT::StringTag& self, const Amulet::NBT::StringTag& other) {
            return self >= other;
        },
        py::is_operator());
    StringTag.def(
        "__gt__",
        [](const Amulet::NBT::StringTag& self, const Amulet::NBT::StringTag& other) {
            return self > other;
        },
        py::is_operator());
    StringTag.def(
        "__le__",
        [](const Amulet::NBT::StringTag& self, const Amulet::NBT::StringTag& other) {
            return self <= other;
        },
        py::is_operator());
    StringTag.def(
        "__lt__",
        [](const Amulet::NBT::StringTag& self, const Amulet::NBT::StringTag& other) {
            return self < other;
        },
        py::is_operator());
}
