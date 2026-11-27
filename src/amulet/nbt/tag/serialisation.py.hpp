#pragma once

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/stl/filesystem.h>

#include <amulet/pybind11_extensions/builtins.hpp>

#include <cerrno>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <variant>

template <typename Tag>
py::bytes to_nbt(
    const Tag& self,
    std::optional<std::string> name,
    bool compressed,
    std::endian endianness,
    Amulet::StringEncoder string_encoder)
{
    std::string data;
    {
        py::gil_scoped_release nogil;
        data = Amulet::NBT::encode_nbt(name, self, endianness, string_encoder);
        if (compressed) {
            std::string data2;
            Amulet::zlib::compress_gzip(data, data2);
            data = std::move(data2);
        }
    }
    return data;
};

template <typename Tag>
py::bytes save_to(
    const Tag& self,
    py::object filepath_or_writable,
    std::optional<std::string> name,
    bool compressed,
    std::endian endianness,
    Amulet::StringEncoder string_encoder)
{
    py::bytes py_data = to_nbt(self, name, compressed, endianness, string_encoder);
    if (!filepath_or_writable.is(py::none())) {
        if (py::isinstance<py::str>(filepath_or_writable)) {
            std::string data = py_data.cast<std::string>();
            std::ofstream file(filepath_or_writable.cast<std::string>(), std::ios::out | std::ios::binary | std::ios::trunc);
            file.write(data.c_str(), data.size());
        } else {
            filepath_or_writable.attr("write")(py_data);
        }
    }
    return py_data;
};

template <typename Tag, typename... Args>
void SerialiseTag(py::class_<Tag, Args...>& cls)
{
    py::object mutf8_encoding = py::module::import("amulet.nbt").attr("mutf8_encoding");
    py::object java_encoding = py::module::import("amulet.nbt").attr("java_encoding");

    cls.def(
        "to_nbt",
        [](
            const Tag& self,
            Amulet::NBT::EncodingPreset preset,
            std::optional<std::string> name) {
            return to_nbt(
                self,
                name,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.encode);
        },
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("name") = "");
    cls.def(
        "to_nbt",
        [](
            const Tag& self,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding,
            std::optional<std::string> name) {
            return to_nbt(
                self,
                name,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.encode);
        },
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("name") = "");
    cls.def(
        "save_to",
        [](
            const Tag& self,
            py::object filepath_or_writable,
            Amulet::NBT::EncodingPreset preset,
            std::optional<std::string> name) {
            return save_to(
                self,
                filepath_or_writable,
                name,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.encode);
        },
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("name") = "");
    cls.def(
        "save_to",
        [](
            const Tag& self,
            py::object filepath_or_writable,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding,
            std::optional<std::string> name) {
            return save_to(
                self,
                filepath_or_writable,
                name,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.encode);
        },
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("name") = "");
    cls.def(
        "to_snbt",
        [](
            const Tag& self,
            py::object indent) {
            if (indent.is(py::none())) {
                return Amulet::NBT::encode_snbt(self);
            } else if (py::isinstance<py::int_>(indent)) {
                return Amulet::NBT::encode_formatted_snbt(self, std::string(indent.cast<size_t>(), ' '));
            } else if (py::isinstance<py::str>(indent)) {
                return Amulet::NBT::encode_formatted_snbt(self, indent.cast<std::string>());
            } else {
                throw std::invalid_argument("indent must be None, int or str");
            }
        },
        py::arg("indent") = py::none());
}
