#include <fstream>
#include <bit>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;


void init_encoding(py::module& m) {
    py::class_<AmuletNBT::StringEncoding> StringEncoding(m, "StringEncoding");
        StringEncoding.def(
            "encode",
            [](const AmuletNBT::StringEncoding& self, py::bytes data) -> py::bytes {
                return self.encode(data);
            }
        );
        StringEncoding.def(
            "decode",
            [](const AmuletNBT::StringEncoding& self, py::bytes data) -> py::bytes {
                return self.decode(data);
            }
        );

    AmuletNBT::StringEncoding utf8_encoding = AmuletNBT::StringEncoding(AmuletNBT::utf8_to_utf8, AmuletNBT::utf8_to_utf8);
    AmuletNBT::StringEncoding utf8_escape_encoding = AmuletNBT::StringEncoding(AmuletNBT::utf8_to_utf8_escape, AmuletNBT::utf8_escape_to_utf8);
    AmuletNBT::StringEncoding mutf8_encoding = AmuletNBT::StringEncoding(AmuletNBT::utf8_to_mutf8, AmuletNBT::mutf8_to_utf8);

    m.attr("utf8_encoding") = utf8_encoding;
    m.attr("utf8_escape_encoding") = utf8_escape_encoding;
    m.attr("mutf8_encoding") = mutf8_encoding;

    py::class_<AmuletNBT::EncodingPreset> EncodingPreset(m, "EncodingPreset");
        EncodingPreset.def_readonly(
            "compressed",
            &AmuletNBT::EncodingPreset::compressed
        );
        EncodingPreset.def_property_readonly(
            "little_endian",
            [](const AmuletNBT::EncodingPreset& self) {
                return self.endianness == std::endian::little;
            }
        );
        EncodingPreset.def_readonly(
            "string_encoding",
            &AmuletNBT::EncodingPreset::string_encoding
        );

    AmuletNBT::EncodingPreset java_encoding = AmuletNBT::EncodingPreset(true, std::endian::big, mutf8_encoding);
    AmuletNBT::EncodingPreset bedrock_encoding = AmuletNBT::EncodingPreset(false, std::endian::little, utf8_escape_encoding);

    m.attr("java_encoding") = java_encoding;
    m.attr("bedrock_encoding") = bedrock_encoding;
}
