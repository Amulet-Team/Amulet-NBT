#include <bit>
#include <cstdint>
#include <fstream>
#include <memory>
#include <stdexcept>
#include <string>
#include <variant>
#include <vector>

#include <pybind11/numpy.h>
#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>

namespace py = pybind11;

template <typename Tag, typename Native>
void PyArray(py::module& m, std::string name)
{
    py::object asarray = py::module::import("numpy").attr("asarray");
    py::object AbstractBaseArrayTag = m.attr("AbstractBaseArrayTag");
    std::string qualname = "amulet.nbt." + name;
    const std::uint8_t bit_width = sizeof(Native) * 8;
    std::string docstring = "This class stores a fixed size signed " + std::to_string(bit_width) + " bit vector.";
    py::classh<Tag> cls(m, name.c_str(), AbstractBaseArrayTag, py::buffer_protocol(), docstring.c_str());
    cls.def_property_readonly_static("tag_id", [](py::object) { return Amulet::NBT::tag_id<Tag>::value; });
    cls.def(
        py::init([](py::typing::Iterable<Native> value) {
            std::vector<Native> vec;
            for (py::handle handle : value) {
                py::object obj;
                if (!PyIndex_Check(handle.ptr())) {
                    obj = py::reinterpret_steal<py::object>(PyNumber_Long(handle.ptr()));
                    if (!obj) {
                        throw py::error_already_set();
                    }
                    handle = obj;
                }
                unsigned long long i = PyLong_AsUnsignedLongLongMask(handle.ptr());
                vec.push_back(static_cast<Native>(i));
            }
            return std::make_shared<Tag>(std::move(vec));
        }),
        py::arg("value") = py::tuple());
    cls.def_buffer(
        [](Tag& self) -> py::buffer_info {
            return py::buffer_info(
                self.data(),
                sizeof(Native),
                py::format_descriptor<Native>::format(),
                1,
                { self.size() },
                { sizeof(Native) });
        });
    cls.def_property_readonly(
        "np_array",
        [](const Amulet::pybind11_extensions::PyObjectCpp<Tag>& self) -> py::array_t<Native> {
            return self;
        },
        py::doc(
            "A numpy array holding the same internal data.\n"
            "\n"
            "Changes to the array will also modify the internal state."));
    cls.def_property_readonly(
        "py_data",
        [asarray](const Amulet::pybind11_extensions::PyObjectCpp<Tag>& self) -> py::object {
            return py::array_t<Native>(self);
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
            std::string out = qualname + "([";
            for (size_t i = 0; i < self.size(); i++) {
                if (i) {
                    out += ", ";
                };
                out += std::to_string(self[i]);
            };
            out += "])";
            return out;
        });
    cls.def(
        "__str__",
        [](const Tag& self) {
            std::string out = "[";
            for (size_t i = 0; i < self.size(); i++) {
                if (i) {
                    out += ", ";
                };
                out += std::to_string(self[i]);
            };
            out += "]";
            return out;
        });
    cls.def(
        py::pickle(
            [](const Tag& self) {
                return py::bytes(Amulet::NBT::encode_nbt("", self, std::endian::big, Amulet::NBT::utf8_to_mutf8));
            },
            [](py::bytes state) {
                return std::get<std::shared_ptr<Tag>>(
                    Amulet::NBT::decode_nbt(state, std::endian::big, Amulet::NBT::mutf8_to_utf8).tag_node);
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
        "__eq__",
        [](const Tag& self, const Tag& other) {
            return self == other;
        },
        py::is_operator());
    cls.def(
        "__len__",
        [](const Tag& self) {
            return self.size();
        });
    cls.def(
        "__iter__",
        [](const Tag& self) { return py::make_iterator(self.begin(), self.end()); },
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);
    cls.def(
        "__reversed__",
        [](const Tag& self) { return py::make_iterator(self.rbegin(), self.rend()); },
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);
    cls.def(
        "__getitem__",
        [asarray](const Tag& self, py::object item) {
            return asarray(self).attr("__getitem__")(item);
        });
    cls.def(
        "__setitem__",
        [asarray](const Tag& self, py::object item, py::object value) {
            asarray(self)[item] = value;
        });
    cls.def(
        "__contains__",
        [asarray](const Tag& self, py::object value) -> py::bool_ {
            return asarray(self).contains(value);
        },
        py::arg("item"));
}

void init_array(py::module& m)
{
    PyArray<Amulet::NBT::ByteArrayTag, std::int8_t>(m, "ByteArrayTag");
    PyArray<Amulet::NBT::IntArrayTag, std::int32_t>(m, "IntArrayTag");
    PyArray<Amulet::NBT::LongArrayTag, std::int64_t>(m, "LongArrayTag");
};
