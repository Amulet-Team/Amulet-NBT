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

template <typename Tag, typename... Args>
void SerialiseTag(py::class_<Tag, Args...>& cls)
{
    py::object mutf8_encoding = py::module::import("amulet.nbt").attr("mutf8_encoding");
    py::object java_encoding = py::module::import("amulet.nbt").attr("java_encoding");

    auto to_nbt = [](
                      const Tag& self,
                      std::optional<std::string> name,
                      bool compressed,
                      std::endian endianness,
                      Amulet::StringEncoder string_encoder) -> py::bytes {
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
    cls.def(
        "to_nbt",
        [to_nbt](
            const Tag& self,
            const Amulet::NBT::EncodingPreset& preset,
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
        [to_nbt](
            const Tag& self,
            bool compressed,
            bool little_endian,
            const Amulet::NBT::StringEncoding& string_encoding,
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
    auto save_to = [to_nbt](
                       const Tag& self,
                       std::variant<
                           std::monostate,
                           std::filesystem::path,
                           Amulet::pybind11_extensions::PyObjectStr<"amulet.nbt.Writeable">>
                           filepath_or_writeable,
                       std::optional<std::string> name,
                       bool compressed,
                       std::endian endianness,
                       const Amulet::StringEncoder& string_encoder) {
        py::bytes py_data = to_nbt(self, name, compressed, endianness, string_encoder);
        std::visit(
            [&py_data](auto&& arg) {
                using T = std::decay_t<decltype(arg)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // Do nothing
                } else if constexpr (std::is_same_v<T, std::filesystem::path>) {
                    const auto data = py_data.cast<std::string_view>();
                    int err = 0;
                    {
                        py::gil_scoped_release nogil;
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
                    if (err) {
                        py::object filename = py::cast(arg);
                        errno = err;
                        PyErr_SetFromErrnoWithFilenameObject(PyExc_OSError, filename.ptr());
                        throw py::error_already_set();
                    }
                } else {
                    arg.attr("write")(py_data);
                }
            },
            filepath_or_writeable);
        return py_data;
    };
    cls.def(
        "save_to",
        [save_to](
            const Tag& self,
            std::variant<
                std::monostate,
                std::filesystem::path,
                Amulet::pybind11_extensions::PyObjectStr<"amulet.nbt.Writeable">>
                filepath_or_writeable,
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
        [save_to](
            const Tag& self,
            std::variant<
                std::monostate,
                std::filesystem::path,
                Amulet::pybind11_extensions::PyObjectStr<"amulet.nbt.Writeable">>
                filepath_or_writeable,
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
        [](
            const Tag& self,
            std::variant<std::monostate, std::string, size_t> indent_variant) {
            return std::visit(
                [&self](auto&& indent) {
                    using IndentT = std::decay_t<decltype(indent)>;
                    if constexpr (std::is_same_v<IndentT, std::monostate>) {
                        return Amulet::NBT::encode_snbt(self);
                    } else if constexpr (std::is_same_v<IndentT, std::string>) {
                        return Amulet::NBT::encode_formatted_snbt(self, indent);
                    } else {
                        static_assert(std::is_same_v<IndentT, size_t>);
                        return Amulet::NBT::encode_formatted_snbt(self, std::string(indent, ' '));
                    }
                },
                indent_variant);
        },
        py::arg("indent") = py::none());
}
