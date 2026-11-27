#include <fstream>
#include <string>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>

namespace py = pybind11;

template <typename Tag, typename Native>
void init_int_tag(py::module& m, std::string name)
{
    std::string qualname = "amulet.nbt." + name;
    std::uint8_t byte_width = sizeof(Native);
    std::uint8_t bit_pow = sizeof(Native) * 8 - 1;
    std::string docstring = (byte_width == 8 ? "An " : "A ") + std::to_string(byte_width)
        + " byte integer class.\n"
          "\n"
          "Can Store numbers between -(2^"
        + std::to_string(bit_pow) + ") and (2^" + std::to_string(bit_pow) + " - 1)";
    py::classh<Tag, Amulet::NBT::AbstractBaseIntTag> cls(m, name.c_str(), docstring.c_str());
    cls.def_property_readonly_static("tag_id", [](py::object) { return Amulet::NBT::tag_id<Tag>::value; });
    cls.def(
        py::init([](Amulet::pybind11_extensions::PyObjectCpp<Native> py_value) {
            py::int_ py_int(py_value);
            auto uint64_value = py_int.attr("__and__")(py::cast(UINT64_MAX)).cast<std::uint64_t>();
            return Tag(static_cast<Native>(uint64_value));
        }),
        py::arg("value") = 0);
    cls.def_property_readonly(
        "py_int",
        [](const Tag& self) -> Native {
            return self;
        },
        py::doc(
            "A python int representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."));
    cls.def_property_readonly(
        "py_data",
        [](const Tag& self) -> Native {
            return self;
        },
        py::doc(
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
            "\n"
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
            "This is here for convenience to get a python representation under the same property name.\n"));
    SerialiseTag(cls);
    cls.def(
        "__repr__",
        [qualname](const Tag& self) {
            return qualname + "(" + std::to_string(static_cast<Native>(self)) + ")";
        });
    cls.def(
        "__str__",
        [](const Tag& self) {
            return std::to_string(static_cast<Native>(self));
        });
    cls.def(
        py::pickle(
            [](const Tag& self) -> Native {
                return self;
            },
            [](Native state) {
                return Tag(state);
            }));
    cls.def(
        "__copy__",
        [](const Tag& self) {
            return shallow_copy(self);
        });
    cls.def(
        "__deepcopy__",
        [](const Tag& self, py::dict) {
            return deep_copy(self);
        },
        py::arg("memo"));
    cls.def(
        "__hash__",
        [](const Tag& self) {
            return py::hash(py::make_tuple(Amulet::NBT::tag_id<Tag>::value, static_cast<Native>(self)));
        });
    cls.def(
        "__int__",
        [](const Tag& self) -> Native {
            return self;
        });
    cls.def(
        "__float__",
        [](const Tag& self) -> py::float_ {
            return py::cast(static_cast<Native>(self));
        });
    cls.def(
        "__bool__",
        [](const Tag& self) {
            return self != 0;
        });
    cls.def(
        "__eq__",
        [](const Tag& self, const Tag& other) {
            return self == other;
        },
        py::is_operator());
    cls.def(
        "__ge__",
        [](const Tag& self, const Tag& other) {
            return self >= other;
        },
        py::is_operator());
    cls.def(
        "__gt__",
        [](const Tag& self, const Tag& other) {
            return self > other;
        },
        py::is_operator());
    cls.def(
        "__le__",
        [](const Tag& self, const Tag& other) {
            return self <= other;
        },
        py::is_operator());
    cls.def(
        "__lt__",
        [](const Tag& self, const Tag& other) {
            return self < other;
        },
        py::is_operator());
}

void init_int(py::module& m)
{
    init_int_tag<Amulet::NBT::ByteTag, std::int8_t>(m, "ByteTag");
    init_int_tag<Amulet::NBT::ShortTag, std::int16_t>(m, "ShortTag");
    init_int_tag<Amulet::NBT::IntTag, std::int32_t>(m, "IntTag");
    init_int_tag<Amulet::NBT::LongTag, std::int64_t>(m, "LongTag");
};
