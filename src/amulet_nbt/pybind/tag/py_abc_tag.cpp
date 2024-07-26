#include <fstream>
#include <stdexcept>
#include <string>
#include <bit>
#include <ios>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;

template <typename T>
void abstract_method(T self, py::args, const py::kwargs&){
    PyErr_SetString(PyExc_NotImplementedError, "");
    throw py::error_already_set();
}


void init_abc(py::module& m) {
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    py::class_<AmuletNBT::AbstractBaseTag> AbstractBaseTag(m, "AbstractBaseTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseTag.def_property_readonly_static(
            "tag_id",
            abstract_method<py::object>
        );
        AbstractBaseTag.def_property_readonly(
            "py_data",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name."\
        );
        AbstractBaseTag.def(
            "to_nbt",
            [](
                const AmuletNBT::AbstractBaseTag& self,
                AmuletNBT::EncodingPreset preset,
                std::string name
            ){
                PyErr_SetString(PyExc_NotImplementedError, "");
                throw py::error_already_set();
            },
            py::kw_only(),
            py::arg("preset") = java_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "to_nbt",
            [](
                const AmuletNBT::AbstractBaseTag& self,
                bool compressed,
                bool little_endian,
                AmuletNBT::StringEncoding string_encoding,
                std::string name
            ){
                PyErr_SetString(PyExc_NotImplementedError, "");
                throw py::error_already_set();
            },
            py::kw_only(),
            py::arg("compressed") = true,
            py::arg("little_endian") = false,
            py::arg("string_encoding") = mutf8_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "save_to",
            [](
                const AmuletNBT::AbstractBaseTag& self,
                py::object filepath_or_writable,
                AmuletNBT::EncodingPreset preset,
                std::string name
            ){
                PyErr_SetString(PyExc_NotImplementedError, "");
                throw py::error_already_set();
            },
            py::arg("filepath_or_writable") = py::none(),
            py::pos_only(),
            py::kw_only(),
            py::arg("preset") = java_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "save_to",
            [](
                const AmuletNBT::AbstractBaseTag& self,
                py::object filepath_or_writable,
                bool compressed,
                bool little_endian,
                AmuletNBT::StringEncoding string_encoding,
                std::string name
            ){
                PyErr_SetString(PyExc_NotImplementedError, "");
                throw py::error_already_set();
            },
            py::arg("filepath_or_writable") = py::none(),
            py::pos_only(),
            py::kw_only(),
            py::arg("compressed") = true,
            py::arg("little_endian") = false,
            py::arg("string_encoding") = mutf8_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "to_snbt",
            [](
                const AmuletNBT::AbstractBaseTag& self,
                py::object indent
            ){
                PyErr_SetString(PyExc_NotImplementedError, "");
                throw py::error_already_set();
            },
            py::arg("indent") = py::none()
        );
        AbstractBaseTag.def(
            "__eq__",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "Check if the instance is equal to another instance.\n"
            "\n"
            "This will only return True if the tag type is the same and the data contained is the same."
        );
        AbstractBaseTag.def(
            "__repr__",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A string representation of the object to show how it can be constructed."
        );
        AbstractBaseTag.def(
            "__str__",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__copy__",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__deepcopy__",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A string representation of the object."
        );

    py::class_<AmuletNBT::AbstractBaseImmutableTag, AmuletNBT::AbstractBaseTag> AbstractBaseImmutableTag(m, "AbstractBaseImmutableTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseImmutableTag.def(
            "__hash__",
            abstract_method<const AmuletNBT::AbstractBaseImmutableTag&>,
            "A hash of the data in the class."
        );

    py::class_<AmuletNBT::AbstractBaseNumericTag, AmuletNBT::AbstractBaseImmutableTag> AbstractBaseNumericTag(m, "AbstractBaseNumericTag",
        "Abstract Base Class for all numeric tag classes"
    );
        AbstractBaseNumericTag.def(
            "__int__",
            abstract_method<const AmuletNBT::AbstractBaseNumericTag&>,
            "Get a python int representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__float__",
            abstract_method<const AmuletNBT::AbstractBaseNumericTag&>,
            "Get a python float representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__bool__",
            abstract_method<const AmuletNBT::AbstractBaseNumericTag&>,
            "Get a python bool representation of the class."
        );

    py::class_<AmuletNBT::AbstractBaseIntTag, AmuletNBT::AbstractBaseNumericTag> AbstractBaseIntTag(m, "AbstractBaseIntTag",
        "Abstract Base Class for all int tag classes"
    );
        AbstractBaseIntTag.def_property_readonly(
            "py_int",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A python int representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<AmuletNBT::AbstractBaseFloatTag, AmuletNBT::AbstractBaseNumericTag> AbstractBaseFloatTag(m, "AbstractBaseFloatTag",
        "Abstract Base Class for all float tag classes."
    );
        AbstractBaseFloatTag.def_property_readonly(
            "py_float",
            abstract_method<const AmuletNBT::AbstractBaseTag&>,
            "A python float representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<AmuletNBT::AbstractBaseMutableTag, AmuletNBT::AbstractBaseTag> AbstractBaseMutableTag(m, "AbstractBaseMutableTag",
        "Abstract Base Class for all mutable tags."
    );
        AbstractBaseMutableTag.attr("__hash__") = py::none();

    py::class_<AmuletNBT::AbstractBaseArrayTag, AmuletNBT::AbstractBaseMutableTag> AbstractBaseArrayTag(m, "AbstractBaseArrayTag",
        "Abstract Base Class for all array tag classes."
    );
}
