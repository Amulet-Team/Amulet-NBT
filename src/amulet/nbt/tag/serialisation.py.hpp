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

using Writeable = Amulet::pybind11_extensions::PyObjectStr<"amulet.nbt.Writeable">;
using FilePathOrWriteable = std::variant<std::monostate, std::filesystem::path, Writeable>;
using Indent = std::variant<std::monostate, size_t, std::string>;

template <typename Tag>
std::string to_nbt(
    const Tag& tag,
    std::optional<std::string> name,
    bool compressed,
    std::endian endianness,
    const Amulet::StringEncoder& string_encoder)
{
    // Encode NBT
    std::string data = Amulet::NBT::encode_nbt(name, tag, endianness, string_encoder);

    if (compressed) {
        // Compress and return
        std::string compressed_data;
        Amulet::zlib::compress_gzip(data, compressed_data);
        return compressed_data;
    }
    return data;
};

template <typename Tag>
py::bytes to_nbt_bytes(
    const Tag& self,
    std::optional<std::string> name,
    bool compressed,
    std::endian endianness,
    const Amulet::StringEncoder& string_encoder)
{
    std::string data;
    {
        py::gil_scoped_release nogil;
        data = to_nbt(self, std::move(name), compressed, endianness, string_encoder);
    }
    return data;
};

template <typename Tag>
py::bytes save_to(
    const Tag& self,
    FilePathOrWriteable filepath_or_writeable,
    std::optional<std::string> name,
    bool compressed,
    std::endian endianness,
    const Amulet::StringEncoder& string_encoder)
{
    return std::visit(
        [&](auto&& arg) -> py::bytes {
            using T = std::decay_t<decltype(arg)>;
            std::string data;
            int err = 0;
            {
                // Release the GIL
                py::gil_scoped_release nogil;

                // Encode the data
                data = to_nbt(self, name, compressed, endianness, string_encoder);

                // Open the file and write the data if it is a path
                if constexpr (std::is_same_v<T, std::filesystem::path>) {
                    errno = 0;
                    std::ofstream file(arg, std::ios::out | std::ios::binary | std::ios::trunc);
                    if (file) {
                        file.write(data.data(), data.size());
                        file.close();
                        if (!file) {
                            err = errno ? errno : EIO;
                        }
                    } else {
                        err = errno ? errno : EIO;
                    }
                }
            }

            // Throw errors with the GIL
            if constexpr (std::is_same_v<T, std::filesystem::path>) {
                if (err) {
                    py::object filename = py::cast(arg);
                    errno = err;
                    PyErr_SetFromErrnoWithFilenameObject(PyExc_OSError, filename.ptr());
                    throw py::error_already_set();
                }
            }

            // Convert to python bytes
            py::bytes py_data = data;

            // Write to python writeable
            if constexpr (std::is_same_v<T, Writeable>) {
                arg.attr("write")(py_data);
            }

            // Return bytes
            return py_data;
        },
        filepath_or_writeable);
};

template <typename Tag>
std::string to_snbt(const Tag& tag, Indent indent_variant)
{
    return std::visit(
        [&tag](auto&& indent) {
            using T = std::decay_t<decltype(indent)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return Amulet::NBT::encode_snbt(tag);
            } else if constexpr (std::is_same_v<T, size_t>) {
                return Amulet::NBT::encode_formatted_snbt(tag, std::string(indent, ' '));
            } else {
                static_assert(std::is_same_v<T, std::string>);
                return Amulet::NBT::encode_formatted_snbt(tag, indent);
            }
        },
        indent_variant);
}

template <typename Tag, typename... Args>
void SerialiseTag(py::class_<Tag, Args...>& cls)
{
    py::object mutf8_encoding = py::module::import("amulet.nbt").attr("mutf8_encoding");
    py::object java_encoding = py::module::import("amulet.nbt").attr("java_encoding");

    cls.def(
        "to_nbt",
        [](
            const Tag& self,
            const Amulet::NBT::EncodingPreset& preset,
            std::optional<std::string> name) {
            return to_nbt_bytes(
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
            const Amulet::NBT::StringEncoding& string_encoding,
            std::optional<std::string> name) {
            return to_nbt_bytes(
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
            FilePathOrWriteable filepath_or_writeable,
            const Amulet::NBT::EncodingPreset& preset,
            std::optional<std::string> name) {
            return save_to(
                self,
                std::move(filepath_or_writeable),
                name,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.encode);
        },
        py::arg("filepath_or_writeable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("name") = "");
    cls.def(
        "save_to",
        [](
            const Tag& self,
            FilePathOrWriteable filepath_or_writeable,
            bool compressed,
            bool little_endian,
            const Amulet::NBT::StringEncoding& string_encoding,
            std::optional<std::string> name) {
            return save_to(
                self,
                std::move(filepath_or_writeable),
                name,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.encode);
        },
        py::arg("filepath_or_writeable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("name") = "");
    cls.def(
        "to_snbt",
        &to_snbt<Tag>,
        py::arg("indent") = py::none());
}
