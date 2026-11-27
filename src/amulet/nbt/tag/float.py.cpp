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
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>

namespace py = pybind11;

template <typename Tag, typename Native>
void init_float_tag(py::module& m, std::string name)
{
    std::string qualname = "amulet.nbt." + name;
    const char* docstring = (std::is_same_v<Native, float> ? "A 32 bit float class." : "A 64 bit float class.");
    py::classh<Tag, Amulet::NBT::AbstractBaseFloatTag> cls(m, name.c_str(), docstring);
    cls.def_property_readonly_static("tag_id", [](py::object) { return Amulet::NBT::tag_id<Tag>::value; });
    cls.def(
        py::init<Native>(),
        py::arg("value") = 0.0);
    cls.def_property_readonly(
        "py_float",
        [](const Tag& self) -> Native {
            return self;
        },
        py::doc(
            "A python float representation of the class.\n"
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
            return qualname + "(" + py::repr(py::cast(static_cast<Native>(self))).cast<std::string>() + ")";
        });
    cls.def(
        "__str__",
        [](const Tag& self) {
            return py::repr(py::cast(static_cast<Native>(self)));
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
        [](const Tag& self) -> py::int_ {
            return py::cast(static_cast<Native>(self));
        });
    cls.def(
        "__float__",
        [](const Tag& self) -> Native {
            return self;
        });
    cls.def(
        "__bool__",
        [](const Tag& self) {
            return self != 0.0;
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

void init_float(py::module& m)
{
    init_float_tag<Amulet::NBT::FloatTag, float>(m, "FloatTag");
    init_float_tag<Amulet::NBT::DoubleTag, double>(m, "DoubleTag");
}
