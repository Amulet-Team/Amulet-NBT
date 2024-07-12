#include <fstream>
#include <stdexcept>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/wrapper.hpp>
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
    py::object compress = py::module::import("gzip").attr("compress");

    py::class_<Amulet::AbstractBaseTag> AbstractBaseTag(m, "AbstractBaseTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseTag.def_property_readonly_static(
            "tag_id",
            abstract_method<py::object>
        );
        AbstractBaseTag.def_property_readonly(
            "py_data",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name."\
        );
        auto to_nbt = [compress](
            const Amulet::AbstractBaseTag& self,
            std::string name,
            bool compressed,
            std::endian endianness,
            Amulet::StringEncode string_encoder
        ) -> py::bytes {
            py::bytes data = self.to_nbt(name, endianness, string_encoder);
            if (compressed){
                return compress(data);
            }
            return data;
        };
        AbstractBaseTag.def(
            "to_nbt",
            [to_nbt](
                const Amulet::AbstractBaseTag& self,
                Amulet::EncodingPreset preset,
                std::string name
            ){
                return to_nbt(
                    self,
                    name,
                    preset.compressed,
                    preset.endianness,
                    preset.string_encoding.encode
                );
            },
            py::kw_only(),
            py::arg("preset") = java_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "to_nbt",
            [to_nbt](
                const Amulet::AbstractBaseTag& self,
                bool compressed,
                bool little_endian,
                Amulet::StringEncoding string_encoding,
                std::string name
            ){
                return to_nbt(
                    self,
                    name,
                    compressed,
                    little_endian ? std::endian::little : std::endian::big,
                    string_encoding.encode
                );
            },
            py::kw_only(),
            py::arg("compressed") = true,
            py::arg("little_endian") = false,
            py::arg("string_encoding") = mutf8_encoding,
            py::arg("name") = ""
        );
        auto save_to = [to_nbt](
            const Amulet::AbstractBaseTag& self,
            py::object filepath_or_writable,
            std::string name,
            bool compressed,
            std::endian endianness,
            Amulet::StringEncode string_encoder
        ){
            py::bytes py_data = to_nbt(self, name, compressed, endianness, string_encoder);
            if (!filepath_or_writable.is(py::none())){
                if (py::isinstance<py::str>(filepath_or_writable)){
                    std::string data = py_data.cast<std::string>();
                    std::ofstream file(filepath_or_writable.cast<std::string>(), std::ios::out | std::ios::binary | std::ios::trunc);
                    file.write(data.c_str(), data.size());
                } else {
                    filepath_or_writable.attr("write")(py_data);
                }
            }
            return py_data;
        };
        AbstractBaseTag.def(
            "save_to",
            [save_to](
                const Amulet::AbstractBaseTag& self,
                py::object filepath_or_writable,
                Amulet::EncodingPreset preset,
                std::string name
            ){
                return save_to(
                    self,
                    filepath_or_writable,
                    name,
                    preset.compressed,
                    preset.endianness,
                    preset.string_encoding.encode
                );
            },
            py::arg("filepath_or_writable") = py::none(),
            py::pos_only(),
            py::kw_only(),
            py::arg("preset") = java_encoding,
            py::arg("name") = ""
        );
        AbstractBaseTag.def(
            "save_to",
            [save_to](
                const Amulet::AbstractBaseTag& self,
                py::object filepath_or_writable,
                bool compressed,
                bool little_endian,
                Amulet::StringEncoding string_encoding,
                std::string name
            ){
                return save_to(
                    self,
                    filepath_or_writable,
                    name,
                    compressed,
                    little_endian ? std::endian::little : std::endian::big,
                    string_encoding.encode
                );
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
                const Amulet::AbstractBaseTag& self,
                py::object indent
            ){
                if (indent.is(py::none())){
                    return self.to_snbt();
                } else if (py::isinstance<py::int_>(indent)){
                    return self.to_snbt(std::string(indent.cast<size_t>(), ' '));
                } else if (py::isinstance<py::str>(indent)){
                    return self.to_snbt(indent.cast<std::string>());
                } else {
                    throw std::invalid_argument("indent must be None, int or str");
                }
            },
            py::arg("indent") = py::none()
        );
        AbstractBaseTag.def(
            "__eq__",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "Check if the instance is equal to another instance.\n"
            "\n"
            "This will only return True if the tag type is the same and the data contained is the same."
        );
        AbstractBaseTag.def(
            "__repr__",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A string representation of the object to show how it can be constructed."
        );
        AbstractBaseTag.def(
            "__str__",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__copy__",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__deepcopy__",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A string representation of the object."
        );

    py::class_<Amulet::AbstractBaseImmutableTag, Amulet::AbstractBaseTag> AbstractBaseImmutableTag(m, "AbstractBaseImmutableTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseImmutableTag.def(
            "__hash__",
            abstract_method<const Amulet::AbstractBaseImmutableTag&>,
            "A hash of the data in the class."
        );

    py::class_<Amulet::AbstractBaseNumericTag, Amulet::AbstractBaseImmutableTag> AbstractBaseNumericTag(m, "AbstractBaseNumericTag",
        "Abstract Base Class for all numeric tag classes"
    );
        AbstractBaseNumericTag.def(
            "__int__",
            abstract_method<const Amulet::AbstractBaseNumericTag&>,
            "Get a python int representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__float__",
            abstract_method<const Amulet::AbstractBaseNumericTag&>,
            "Get a python float representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__bool__",
            abstract_method<const Amulet::AbstractBaseNumericTag&>,
            "Get a python bool representation of the class."
        );

    py::class_<Amulet::AbstractBaseIntTag, Amulet::AbstractBaseNumericTag> AbstractBaseIntTag(m, "AbstractBaseIntTag",
        "Abstract Base Class for all int tag classes"
    );
        AbstractBaseIntTag.def_property_readonly(
            "py_int",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A python int representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<Amulet::AbstractBaseFloatTag, Amulet::AbstractBaseNumericTag> AbstractBaseFloatTag(m, "AbstractBaseFloatTag",
        "Abstract Base Class for all float tag classes."
    );
        AbstractBaseFloatTag.def_property_readonly(
            "py_float",
            abstract_method<const Amulet::AbstractBaseTag&>,
            "A python float representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<Amulet::AbstractBaseMutableTag, Amulet::AbstractBaseTag> AbstractBaseMutableTag(m, "AbstractBaseMutableTag",
        "Abstract Base Class for all mutable tags."
    );
        AbstractBaseMutableTag.attr("__hash__") = py::none();

    py::class_<Amulet::AbstractBaseArrayTag, Amulet::AbstractBaseMutableTag> AbstractBaseArrayTag(m, "AbstractBaseArrayTag",
        "Abstract Base Class for all array tag classes."
    );
}
