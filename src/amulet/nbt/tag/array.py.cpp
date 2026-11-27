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

template <typename T>
struct DType;

template <>
struct DType<std::int8_t> {
    using cls = Amulet::NBT::ByteArrayTag;
    static constexpr const char* class_name = "ByteArrayTag";
    static constexpr const char* qual_name = "amulet.nbt.ByteArrayTag";
    static constexpr const std::int8_t bit_width = 8;
    using PyObjectDtype = Amulet::pybind11_extensions::PyObjectStr<"numpy.int8">;
};

template <>
struct DType<std::int32_t> {
    using cls = Amulet::NBT::IntArrayTag;
    static constexpr const char* class_name = "IntArrayTag";
    static constexpr const char* qual_name = "amulet.nbt.IntArrayTag";
    static constexpr const std::int8_t bit_width = 32;
    using PyObjectDtype = Amulet::pybind11_extensions::PyObjectStr<"numpy.int32">;
};

template <>
struct DType<std::int64_t> {
    using cls = Amulet::NBT::LongArrayTag;
    static constexpr const char* class_name = "LongArrayTag";
    static constexpr const char* qual_name = "amulet.nbt.LongArrayTag";
    static constexpr const std::int8_t bit_width = 64;
    using PyObjectDtype = Amulet::pybind11_extensions::PyObjectStr<"numpy.int64">;
};

template <typename Native>
void init_array_tag(py::module& m)
{
    using Tag = typename DType<Native>::cls;
    py::object asarray = py::module::import("numpy").attr("asarray");
    py::object AbstractBaseArrayTag = m.attr("AbstractBaseArrayTag");
    std::string docstring = "This class stores a fixed size signed " + std::to_string(DType<Native>::bit_width) + " bit vector.";
    py::classh<Tag> cls(m, DType<Native>::class_name, AbstractBaseArrayTag, py::buffer_protocol(), docstring.c_str());
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
        [](const Amulet::pybind11_extensions::PyObjectCpp<Tag>& self) -> py::object {
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
        [](const Tag& self) {
            std::string out(DType<Native>::qual_name);
            out += "([";
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
        [asarray](const Tag& self, Amulet::pybind11_extensions::PyObjectCpp<py::int_> item) -> DType<Native>::PyObjectDtype {
            return asarray(self).attr("__getitem__")(item);
        },
        py::arg("item"));
    cls.def(
        "__getitem__",
        [asarray](const Tag& self, py::slice item) -> py::array_t<Native> {
            throw std::runtime_error("This is not accessible");
        },
        py::arg("item"));
    cls.def(
        "__getitem__",
        [asarray](const Tag& self, std::variant<py::typing::Iterable<Native>, py::typing::Iterable<bool>> item) -> py::array_t<Native> {
            throw std::runtime_error("This is not accessible");
        },
        py::arg("item"));
    cls.def(
        "__setitem__",
        [asarray](const Tag& self, Amulet::pybind11_extensions::PyObjectCpp<py::int_> item, Amulet::pybind11_extensions::PyObjectCpp<Native> value) {
            asarray(self)[item] = value;
        },
        py::arg("item"), py::arg("value"));
    cls.def(
        "__setitem__",
        [asarray](const Tag& self, py::slice, py::typing::Iterable<Native>) {
            throw std::runtime_error("This is not accessible");
        },
        py::arg("item"), py::arg("value"));
    cls.def(
        "__setitem__",
        [asarray](const Tag& self, std::variant<py::typing::Iterable<std::int64_t>, py::typing::Iterable<bool>>, py::typing::Iterable<std::int64_t>) {
            throw std::runtime_error("This is not accessible");
        },
        py::arg("item"), py::arg("value"));
    cls.def(
        "__contains__",
        [asarray](const Tag& self, py::object value) -> py::bool_ {
            return asarray(self).contains(value);
        },
        py::arg("item"));
}

void init_array(py::module& m)
{
    init_array_tag<std::int8_t>(m);
    init_array_tag<std::int32_t>(m);
    init_array_tag<std::int64_t>(m);
};
