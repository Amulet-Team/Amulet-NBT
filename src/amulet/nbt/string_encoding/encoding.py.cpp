#include <bit>
#include <fstream>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>

namespace py = pybind11;

void init_encoding(py::module& m)
{
    py::class_<Amulet::NBT::StringEncoding> StringEncoding(m, "StringEncoding");
    StringEncoding.def(
        "encode",
        [](const Amulet::NBT::StringEncoding& self, py::bytes data) -> py::bytes {
            return self.encode(data);
        });
    StringEncoding.def(
        "decode",
        [](const Amulet::NBT::StringEncoding& self, py::bytes data) -> py::bytes {
            return self.decode(data);
        });

    Amulet::NBT::StringEncoding utf8_encoding = Amulet::NBT::StringEncoding(Amulet::NBT::utf8_to_utf8, Amulet::NBT::utf8_to_utf8);
    Amulet::NBT::StringEncoding utf8_escape_encoding = Amulet::NBT::StringEncoding(Amulet::NBT::utf8_to_utf8_escape, Amulet::NBT::utf8_escape_to_utf8);
    Amulet::NBT::StringEncoding mutf8_encoding = Amulet::NBT::StringEncoding(Amulet::NBT::utf8_to_mutf8, Amulet::NBT::mutf8_to_utf8);

    m.attr("utf8_encoding") = utf8_encoding;
    m.attr("utf8_escape_encoding") = utf8_escape_encoding;
    m.attr("mutf8_encoding") = mutf8_encoding;

    py::class_<Amulet::NBT::EncodingPreset> EncodingPreset(m, "EncodingPreset");
    EncodingPreset.def_readonly(
        "compressed",
        &Amulet::NBT::EncodingPreset::compressed);
    EncodingPreset.def_property_readonly(
        "little_endian",
        [](const Amulet::NBT::EncodingPreset& self) {
            return self.endianness == std::endian::little;
        });
    EncodingPreset.def_readonly(
        "string_encoding",
        &Amulet::NBT::EncodingPreset::string_encoding);

    Amulet::NBT::EncodingPreset java_encoding = Amulet::NBT::EncodingPreset(true, std::endian::big, mutf8_encoding);
    Amulet::NBT::EncodingPreset bedrock_encoding = Amulet::NBT::EncodingPreset(false, std::endian::little, utf8_escape_encoding);

    m.attr("java_encoding") = java_encoding;
    m.attr("bedrock_encoding") = bedrock_encoding;
}
