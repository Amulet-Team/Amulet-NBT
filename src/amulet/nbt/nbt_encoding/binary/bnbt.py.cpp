#include <bit>
#include <filesystem>
#include <fstream>
#include <ios>
#include <stdexcept>
#include <string>
#include <string_view>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/stl/filesystem.h>

#include <amulet/pybind11_extensions/builtins.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/zlib/zlib.hpp>

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    class ReadOffset {
    public:
        size_t offset;
        ReadOffset()
            : offset(0) { };
        ReadOffset(size_t offset)
            : offset(offset) { };
    };
} // namespace NBT
} // namespace Amulet

using Writeable = Amulet::pybind11_extensions::PyObjectStr<"amulet.nbt.Writeable">;
using FilePathOrReadable = std::variant<std::filesystem::path, py::bytes, py::memoryview, Writeable>;

// Get a string_view from filepath_or_readable.
// The second argument may be a view to the first argument or memory in filepath_or_readable.
// The first argument may be empty.
std::pair<std::string, std::string_view> get_buffer(
    FilePathOrReadable& filepath_or_readable,
    bool compressed)
{
    return std::visit(
        [compressed](auto&& arg) -> std::pair<std::string, std::string_view> {
            using T = std::decay_t<decltype(arg)>;
            std::string data;
            std::string_view data_view;
            if constexpr (std::is_same_v<T, py::bytes>) {
                data_view = arg.cast<std::string_view>();
            } else if constexpr (std::is_same_v<T, py::memoryview>) {
                // TODO: Can this be done without a copy?
                data = arg.attr("tobytes")().cast<std::string>();
                data_view = data;
            } else if constexpr (std::is_same_v<T, Writeable>) {
                data = arg.attr("read")().cast<std::string>();
                data_view = data;
            }

            py::gil_scoped_release nogil;

            if constexpr (std::is_same_v<T, std::filesystem::path>) {
                std::ifstream file(arg, std::ios::binary);
                if (!file) {
                    auto path = arg.u8string();
                    throw std::invalid_argument("Could not open file: " + std::string(path.begin(), path.end()));
                }
                file.seekg(0, std::ios::end);
                std::streampos file_size = file.tellg();
                file.seekg(0, std::ios::beg);
                data.resize(file_size);
                file.read(&data[0], file_size);
                data_view = data;
            }

            if (compressed && data_view[0] == 0x1f) {
                py::gil_scoped_release nogil;
                std::string decompessed_data;
                Amulet::zlib::decompress_zlib_gzip(data_view, decompessed_data);
                data_view = decompessed_data;
                return { std::move(decompessed_data), data_view };
            }
            return { std::move(data), data_view };
        },
        filepath_or_readable);
}

Amulet::NBT::NamedTag read_nbt(
    FilePathOrReadable& filepath_or_readable,
    bool compressed,
    std::endian endianness,
    Amulet::StringDecoder string_decoder,
    bool named,
    Amulet::NBT::ReadOffset* read_offset)
{
    auto [buffer, buffer_view] = get_buffer(filepath_or_readable, compressed);
    if (read_offset) {
        return Amulet::NBT::decode_nbt(
            buffer_view,
            endianness,
            string_decoder,
            read_offset->offset,
            named);
    } else {
        return Amulet::NBT::decode_nbt(
            buffer_view,
            endianness,
            string_decoder,
            named);
    }
}

std::vector<Amulet::NBT::NamedTag> read_nbt_array(
    FilePathOrReadable& filepath_or_readable,
    Py_ssize_t count,
    bool compressed,
    std::endian endianness,
    Amulet::StringDecoder string_decoder,
    bool named,
    size_t& offset)
{
    if (count < -1) {
        throw std::invalid_argument("count must be -1 or higher");
    }
    auto [buffer, buffer_view] = get_buffer(filepath_or_readable, compressed);
    if (count == -1) {
        return Amulet::NBT::decode_nbt_array(
            buffer_view,
            endianness,
            string_decoder,
            offset,
            named);
    } else {
        return Amulet::NBT::decode_nbt_array(
            buffer_view,
            endianness,
            string_decoder,
            offset,
            count,
            named);
    }
}

std::vector<Amulet::NBT::NamedTag> read_nbt_array(
    FilePathOrReadable& filepath_or_readable,
    Py_ssize_t count,
    bool compressed,
    std::endian endianness,
    Amulet::StringDecoder string_decoder,
    bool named,
    Amulet::NBT::ReadOffset* read_offset)
{
    if (read_offset) {
        return read_nbt_array(filepath_or_readable, count, compressed, endianness, string_decoder, named, read_offset->offset);
    } else {
        size_t offset = 0;
        return read_nbt_array(filepath_or_readable, count, compressed, endianness, string_decoder, named, offset);
    }
}

void init_bnbt(py::module& m)
{
    py::classh<Amulet::NBT::ReadOffset> ReadOffset(m, "ReadOffset");
    ReadOffset.def(
        py::init<const size_t>(),
        py::arg("offset") = 0);
    ReadOffset.def_readonly("offset", &Amulet::NBT::ReadOffset::offset);
    ReadOffset.def(
        "__repr__",
        [](const Amulet::NBT::ReadOffset& self) {
            return "amulet.nbt.ReadOffset(" + std::to_string(self.offset) + ")";
        });

    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    m.def(
        "read_nbt",
        [](
            FilePathOrReadable filepath_or_readable,
            const Amulet::NBT::EncodingPreset& preset,
            bool named,
            Amulet::NBT::ReadOffset* read_offset) {
            return read_nbt(
                filepath_or_readable,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_readable"),
        py::pos_only(),
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load one binary NBT object.\n"
            "\n"
            ":param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.\n"
            ":param named: If the tag to read is named, if not, return NamedTag with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));
    m.def(
        "read_nbt",
        [](
            FilePathOrReadable filepath_or_readable,
            bool compressed,
            bool little_endian,
            const Amulet::NBT::StringEncoding& string_encoding,
            bool named,
            Amulet::NBT::ReadOffset* read_offset) {
            return read_nbt(
                filepath_or_readable,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_readable"),
        py::pos_only(),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load one binary NBT object.\n"
            "\n"
            ":param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param compressed: Is the binary data gzip compressed.\n"
            ":param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.\n"
            ":param string_encoding: The bytes decoder function to parse strings. mutf8_encoding for Java, utf8_escape_encoding for Bedrock.\n"
            ":param named: If the tag to read is named, if not, return NamedTag with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));

    m.def(
        "read_nbt_array",
        [](
            FilePathOrReadable filepath_or_readable,
            Py_ssize_t count,
            const Amulet::NBT::EncodingPreset& preset,
            bool named,
            Amulet::NBT::ReadOffset* read_offset) {
            return read_nbt_array(
                filepath_or_readable,
                count,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_readable"),
        py::pos_only(),
        py::kw_only(),
        py::arg("count") = 1,
        py::arg("preset") = java_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load an array of binary NBT objects from a contiguous buffer.\n"
            "\n"
            ":param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.\n"
            ":param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.\n"
            ":param named: If the tags to read are named, if not, return NamedTags with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));

    m.def(
        "read_nbt_array",
        [](
            FilePathOrReadable filepath_or_readable,
            Py_ssize_t count,
            bool compressed,
            bool little_endian,
            const Amulet::NBT::StringEncoding& string_encoding,
            bool named,
            Amulet::NBT::ReadOffset* read_offset) {
            return read_nbt_array(
                filepath_or_readable,
                count,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_readable"),
        py::pos_only(),
        py::kw_only(),
        py::arg("count") = 1,
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load an array of binary NBT objects from a contiguous buffer.\n"
            "\n"
            ":param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.\n"
            ":param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.\n"
            ":param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.\n"
            ":param string_encoding: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet.nbt.utf8_escape_decoder for Bedrock.\n"
            ":param named: If the tags to read are named, if not, return NamedTags with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));
}
