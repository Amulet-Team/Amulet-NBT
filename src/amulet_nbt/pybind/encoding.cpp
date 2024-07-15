#include <fstream>
#include <bit>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/wrapper.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;


void init_encoding(py::module& m) {
    py::class_<Amulet::StringEncoding> StringEncoding(m, "StringEncoding");
        StringEncoding.def(
            "encode",
            [](const Amulet::StringEncoding& self, py::bytes data) -> py::bytes {
                return self.encode(data);
            }
        );
        StringEncoding.def(
            "decode",
            [](const Amulet::StringEncoding& self, py::bytes data) -> py::bytes {
                return self.decode(data);
            }
        );

    Amulet::StringEncoding utf8_encoding = Amulet::StringEncoding(Amulet::utf8_to_utf8, Amulet::utf8_to_utf8);
    Amulet::StringEncoding utf8_escape_encoding = Amulet::StringEncoding(Amulet::utf8_to_utf8_escape, Amulet::utf8_escape_to_utf8);
    Amulet::StringEncoding mutf8_encoding = Amulet::StringEncoding(Amulet::utf8_to_mutf8, Amulet::mutf8_to_utf8);

    m.attr("utf8_encoding") = utf8_encoding;
    m.attr("utf8_escape_encoding") = utf8_escape_encoding;
    m.attr("mutf8_encoding") = mutf8_encoding;

    py::class_<Amulet::EncodingPreset> EncodingPreset(m, "EncodingPreset");
        EncodingPreset.def_readonly(
            "compressed",
            &Amulet::EncodingPreset::compressed
        );
        EncodingPreset.def_property_readonly(
            "little_endian",
            [](const Amulet::EncodingPreset& self) {
                return self.endianness == std::endian::little;
            }
        );
        EncodingPreset.def_readonly(
            "string_encoding",
            &Amulet::EncodingPreset::string_encoding
        );

    Amulet::EncodingPreset java_encoding = Amulet::EncodingPreset(true, std::endian::big, mutf8_encoding);
    Amulet::EncodingPreset bedrock_encoding = Amulet::EncodingPreset(false, std::endian::little, utf8_escape_encoding);

    m.attr("java_encoding") = java_encoding;
    m.attr("bedrock_encoding") = bedrock_encoding;
}
