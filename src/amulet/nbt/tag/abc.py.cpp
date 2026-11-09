#include <bit>
#include <fstream>
#include <ios>
#include <stdexcept>
#include <string>

#include <pybind11/numpy.h>
#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/pybind11_extensions/builtins.hpp>

#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace py = pybind11;

template <typename SelfT, typename ReturnT = void, typename... Args>
ReturnT abstract_method(SelfT self, Args... args)
{
    PyErr_SetString(PyExc_NotImplementedError, "");
    throw py::error_already_set();
}

void init_abc(py::module& m)
{
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    py::classh<Amulet::NBT::AbstractBaseTag> AbstractBaseTag(m, "AbstractBaseTag",
        "Abstract Base Class for all tag classes");
    AbstractBaseTag.def_property_readonly_static(
        "tag_id",
        [](py::object) {
            return -1;
        });
    AbstractBaseTag.def_property_readonly(
        "py_data",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::object>,
        "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
        "\n"
        "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
        "This is here for convenience to get a python representation under the same property name.");
    AbstractBaseTag.def(
        "to_nbt",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::bytes, const Amulet::NBT::EncodingPreset&, std::optional<std::string>>,
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("name") = "",
        py::doc(
            "Get the data in binary NBT format.\n"
            "\n"
            ":param preset: A class containing endianness and encoding presets.\n"
            ":param name: The root tag name, or `None` for unnamed tag.\n"
            ":return: The binary NBT representation of the class."));
    AbstractBaseTag.def(
        "to_nbt",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::bytes, bool, bool, const Amulet::NBT::StringEncoding&, std::optional<std::string>>,
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("name") = "",
        py::doc(
            "Get the data in binary NBT format.\n"
            "\n"
            ":param compressed: Should the bytes be compressed with gzip.\n"
            ":param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.\n"
            ":param string_encoding: The StringEncoding to use. Ignored if preset is defined.\n"
            ":param name: The root tag name, or `None` for unnamed tag.\n"
            ":return: The binary NBT representation of the class."));
    AbstractBaseTag.def(
        "save_to",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::bytes, py::object, const Amulet::NBT::EncodingPreset&, std::optional<std::string>>,
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("name") = "",
        py::doc(
            "Convert the data to the binary NBT format. Optionally write to a file.\n"
            "\n"
            "If filepath_or_writable is a valid file path in string form the data will be written to that file.\n"
            "\n"
            "If filepath_or_writable is a file like object the bytes will be written to it using .write method.\n"
            "\n"
            ":param filepath_or_writable: A path or writeable object to write the data to.\n"
            ":param preset: A class containing endianness and encoding presets.\n"
            ":param name: The root tag name, or `None` for unnamed tag.\n"
            ":return: The binary NBT representation of the class."));
    AbstractBaseTag.def(
        "save_to",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::bytes, py::object, bool, bool, const Amulet::NBT::StringEncoding&, std::optional<std::string>>,
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("name") = "",
        py::doc(
            "Convert the data to the binary NBT format. Optionally write to a file.\n"
            "\n"
            "If filepath_or_writable is a valid file path in string form the data will be written to that file.\n"
            "\n"
            "If filepath_or_writable is a file like object the bytes will be written to it using .write method.\n"
            "\n"
            ":param filepath_or_writable: A path or writeable object to write the data to.\n"
            ":param compressed: Should the bytes be compressed with gzip.\n"
            ":param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.\n"
            ":param string_encoding: The StringEncoding to use. Ignored if preset is defined.\n"
            ":param name: The root tag name, or `None` for unnamed tag.\n"
            ":return: The binary NBT representation of the class."));
    AbstractBaseTag.def(
        "to_snbt",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, std::string, Amulet::pybind11_extensions::PyObjectCpp<std::variant<py::none, py::str, py::int_>>>,
        py::arg("indent") = py::none(),
        py::doc(
            "Convert the data to the Stringified NBT format.\n"
            "\n"
            ":param indent:\n"
            "    If None (the default) the SNBT will be on one line.\n"
            "    If an int will be multi-line SNBT with this many spaces per indentation.\n"
            "    If a string will be multi-line SNBT with this string as the indentation.\n"
            ":return: The SNBT string."));
    AbstractBaseTag.def(
        "__eq__",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, bool, py::object>,
        "Check if the instance is equal to another instance.\n"
        "\n"
        "This will only return True if the tag type is the same and the data contained is the same.\n"
        "\n"
        ">>> from amulet.nbt import ByteTag, ShortTag\n"
        ">>> tag1 = ByteTag(1)\n"
        ">>> tag2 = ByteTag(2)\n"
        ">>> tag3 = ShortTag(1)\n"
        ">>> tag1 == tag1  # True\n"
        ">>> tag1 == tag2  # False\n"
        ">>> tag1 == tag3  # False",
        py::arg("other"));
    AbstractBaseTag.def(
        "__repr__",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::str>,
        "A string representation of the object to show how it can be constructed.\n"
        "\n"
        ">>> from amulet.nbt import ByteTag\n"
        ">>> tag = ByteTag(1)\n"
        ">>> repr(tag)  # \"ByteTag(1)\"");
    AbstractBaseTag.def(
        "__str__",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::str>,
        "A string representation of the object.");
    AbstractBaseTag.def(
        "__copy__",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, Amulet::pybind11_extensions::PyObjectStr<"typing.Self">>,
        py::doc("A shallow copy of the class\n"
                "\n"
                ">>> import copy\n"
                ">>> from amulet.nbt import ListTag\n"
                ">>> tag = ListTag()\n"
                ">>> tag2 = copy.copy(tag)"));
    AbstractBaseTag.def(
        "__deepcopy__",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, Amulet::pybind11_extensions::PyObjectStr<"typing.Self">, py::typing::Optional<py::typing::Dict<py::int_, py::object>>>,
        py::doc("A deep copy of the class\n"
                "\n"
                ">>> import copy\n"
                ">>> from amulet.nbt import ListTag\n"
                ">>> tag = ListTag()\n"
                ">>> tag2 = copy.deepcopy(tag)"),
        py::arg("memo") = py::none());

    py::classh<Amulet::NBT::AbstractBaseImmutableTag, Amulet::NBT::AbstractBaseTag> AbstractBaseImmutableTag(m, "AbstractBaseImmutableTag",
        "Abstract Base Class for all immutable tag classes");
    AbstractBaseImmutableTag.def(
        "__hash__",
        abstract_method<const Amulet::NBT::AbstractBaseImmutableTag&, py::int_>,
        "A hash of the data in the class.");

    py::classh<Amulet::NBT::AbstractBaseNumericTag, Amulet::NBT::AbstractBaseImmutableTag> AbstractBaseNumericTag(m, "AbstractBaseNumericTag",
        "Abstract Base Class for all numeric tag classes");
    AbstractBaseNumericTag.def(
        "__int__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, py::int_>,
        "Get a python int representation of the class.");
    AbstractBaseNumericTag.def(
        "__float__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, py::float_>,
        "Get a python float representation of the class.");
    AbstractBaseNumericTag.def(
        "__bool__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, py::bool_>,
        "Get a python bool representation of the class.");
    AbstractBaseNumericTag.def(
        "__ge__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, bool, py::object>,
        py::arg("other"),
        "Check if the tag is greater than or equal to another tag.");
    AbstractBaseNumericTag.def(
        "__gt__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, bool, py::object>,
        py::arg("other"),
        "Check if the tag is greater than another tag.");
    AbstractBaseNumericTag.def(
        "__le__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, bool, py::object>,
        py::arg("other"),
        "Check if the tag is less than or equal to another tag.");
    AbstractBaseNumericTag.def(
        "__lt__",
        abstract_method<const Amulet::NBT::AbstractBaseNumericTag&, bool, py::object>,
        py::arg("other"),
        "Check if the tag is less than another tag.");

    py::classh<Amulet::NBT::AbstractBaseIntTag, Amulet::NBT::AbstractBaseNumericTag> AbstractBaseIntTag(m, "AbstractBaseIntTag",
        "Abstract Base Class for all int tag classes");
    AbstractBaseIntTag.def_property_readonly(
        "py_int",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::int_>,
        "A python int representation of the class.\n"
        "\n"
        "The returned data is immutable so changes will not mirror the instance.");

    py::classh<Amulet::NBT::AbstractBaseFloatTag, Amulet::NBT::AbstractBaseNumericTag> AbstractBaseFloatTag(m, "AbstractBaseFloatTag",
        "Abstract Base Class for all float tag classes.");
    AbstractBaseFloatTag.def_property_readonly(
        "py_float",
        abstract_method<const Amulet::NBT::AbstractBaseTag&, py::float_>,
        "A python float representation of the class.\n"
        "\n"
        "The returned data is immutable so changes will not mirror the instance.");

    py::classh<Amulet::NBT::AbstractBaseMutableTag, Amulet::NBT::AbstractBaseTag> AbstractBaseMutableTag(m, "AbstractBaseMutableTag",
        "Abstract Base Class for all mutable tag classes.");
    AbstractBaseMutableTag.attr("__hash__") = py::none();

    py::classh<Amulet::NBT::AbstractBaseArrayTag, Amulet::NBT::AbstractBaseMutableTag> AbstractBaseArrayTag(m, "AbstractBaseArrayTag",
        "Abstract Base Class for all array tag classes.");
    AbstractBaseArrayTag.def_property_readonly(
        "np_array",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, py::array>,
        py::doc(
            "A numpy array holding the same internal data.\n"
            "\n"
            "Changes to the array will also modify the internal state."));
    AbstractBaseArrayTag.def(
        "__len__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, py::int_>,
        py::doc(
            "The length of the array.\n"
            "\n"
            ">>> from amulet.nbt import ByteArrayTag\n"
            ">>> tag = ByteArrayTag([1, 2, 3])\n"
            ">>> len(tag)  # 3"));
    AbstractBaseArrayTag.def(
        "__getitem__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, Amulet::pybind11_extensions::PyObjectStr<"numpy.int8 | numpy.int32 | numpy.int64">, py::int_>,
        py::arg("item"),
        py::doc(
            "Get item(s) from the array.\n"
            "\n"
            "This supports the full numpy protocol.\n"
            "If a numpy array is returned, the array data is the same as the data contained in this class.\n"
            "\n"
            ">>> from amulet.nbt import ByteArrayTag\n"
            ">>> import numpy\n"
            ">>> tag = ByteArrayTag([1, 2, 3])\n"
            ">>> tag[0]  # 1\n"
            ">>> tag[:1]  # numpy.array([1], dtype=numpy.int8)\n"
            ">>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)"));
    AbstractBaseArrayTag.def(
        "__getitem__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, std::variant<py::array_t<std::int8_t>, py::array_t<std::int32_t>, py::array_t<std::int64_t>>, py::slice>,
        py::arg("item"));
    AbstractBaseArrayTag.def(
        "__getitem__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, std::variant<py::array_t<std::int8_t>, py::array_t<std::int32_t>, py::array_t<std::int64_t>>, Amulet::pybind11_extensions::PyObjectStr<"numpy.typing.NDArray[numpy.integer]">>,
        py::arg("item"));
    AbstractBaseArrayTag.def(
        "__iter__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, std::variant<py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int8">>, py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int32">>, py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int64">>>>,
        py::doc(
            "Iterate through the items in the array.\n"
            "\n"
            ">>> from amulet.nbt import ByteArrayTag\n"
            ">>> tag = ByteArrayTag([1, 2, 3])\n"
            ">>> for num in tag:\n"
            ">>>     pass\n"
            ">>> iter(tag)"));
    AbstractBaseArrayTag.def(
        "__reversed__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, std::variant<py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int8">>, py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int32">>, py::typing::Iterable<Amulet::pybind11_extensions::PyObjectStr<"numpy.int64">>>>,
        py::doc(
            "Iterate through the items in the array in reverse order.\n"
            "\n"
            ">>> from amulet.nbt import ByteArrayTag\n"
            ">>> tag = ByteArrayTag([1, 2, 3])\n"
            ">>> for num in reversed(tag):\n"
            ">>>     pass"));
    AbstractBaseArrayTag.def(
        "__contains__",
        abstract_method<const Amulet::NBT::AbstractBaseArrayTag&, bool, py::object>,
        py::arg("item"),
        py::doc(
            "Check if an item is in the array.\n"
            "\n"
            ">>> from amulet.nbt import ByteArrayTag\n"
            ">>> tag = ByteArrayTag([1, 2, 3])\n"
            ">>> 1 in tag  # True\n"));
}
