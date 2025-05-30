#include <bit>
#include <fstream>
#include <ios>
#include <stdexcept>
#include <string>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

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

void init_bnbt(py::module& m)
{
    py::class_<Amulet::NBT::ReadOffset> ReadOffset(m, "ReadOffset");
    ReadOffset.def(
        py::init<const size_t>(),
        py::arg("offset") = 0);
    ReadOffset.def_readonly("offset", &Amulet::NBT::ReadOffset::offset);

    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    auto get_buffer = [](
                          py::object filepath_or_buffer,
                          bool compressed) -> std::string {
        std::string data;

        if (py::isinstance<py::str>(filepath_or_buffer)) {
            std::string file_path = filepath_or_buffer.cast<std::string>();
            std::ifstream file(file_path, std::ios::binary);
            if (!file) {
                throw std::invalid_argument("Could not open file: " + file_path);
            }
            file.seekg(0, std::ios::end);
            std::streampos file_size = file.tellg();
            file.seekg(0, std::ios::beg);
            data.resize(file_size);
            file.read(&data[0], file_size);
        } else if (py::isinstance<py::bytes>(filepath_or_buffer)) {
            data = filepath_or_buffer.cast<std::string>();
        } else if (py::isinstance<py::memoryview>(filepath_or_buffer)) {
            data = filepath_or_buffer.attr("tobytes")().cast<std::string>();
        } else if (py::hasattr(filepath_or_buffer, "read")) {
            data = filepath_or_buffer.attr("read")().cast<std::string>();
        } else {
            throw std::invalid_argument("filepath_or_buffer must be a path string, bytes, memory view or an object with a read method.");
        }

        if (compressed && data[0] == 0x1f) {
            py::gil_scoped_release nogil;
            std::string data2;
            Amulet::zlib::decompress_zlib_gzip(data, data2);
            return data2;
        }
        return data;
    };

    auto read_nbt = [get_buffer](
                        py::object filepath_or_buffer,
                        bool compressed,
                        std::endian endianness,
                        Amulet::StringDecoder string_decoder,
                        bool named,
                        py::object read_offset_py) {
        std::string buffer = get_buffer(filepath_or_buffer, compressed);
        if (py::isinstance<Amulet::NBT::ReadOffset>(read_offset_py)) {
            Amulet::NBT::ReadOffset& read_offset = read_offset_py.cast<Amulet::NBT::ReadOffset&>();
            return Amulet::NBT::decode_nbt(
                buffer,
                endianness,
                string_decoder,
                read_offset.offset,
                named);
        } else if (read_offset_py.is(py::none())) {
            return Amulet::NBT::decode_nbt(
                buffer,
                endianness,
                string_decoder,
                named);
        } else {
            throw std::invalid_argument("read_offset must be ReadOffset or None");
        }
    };

    m.def(
        "read_nbt",
        [read_nbt](
            py::object filepath_or_buffer,
            Amulet::NBT::EncodingPreset preset,
            bool named,
            py::object read_offset) {
            return read_nbt(
                filepath_or_buffer,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_buffer"),
        py::kw_only(),
        py::arg("preset") = java_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load one binary NBT object.\n"
            "\n"
            ":param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.\n"
            ":param named: If the tag to read is named, if not, return NamedTag with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));
    m.def(
        "read_nbt",
        [read_nbt](
            py::object filepath_or_buffer,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding,
            bool named,
            py::object read_offset) {
            return read_nbt(
                filepath_or_buffer,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_buffer"),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load one binary NBT object.\n"
            "\n"
            ":param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param compressed: Is the binary data gzip compressed.\n"
            ":param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.\n"
            ":param string_encoding: The bytes decoder function to parse strings. mutf8_encoding for Java, utf8_escape_encoding for Bedrock.\n"
            ":param named: If the tag to read is named, if not, return NamedTag with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));

    auto read_nbt_array = [get_buffer](
                              py::object filepath_or_buffer,
                              Py_ssize_t count,
                              bool compressed,
                              std::endian endianness,
                              Amulet::StringDecoder string_decoder,
                              bool named,
                              py::object read_offset_py) {
        if (count < -1) {
            throw std::invalid_argument("count must be -1 or higher");
        }
        std::string buffer = get_buffer(filepath_or_buffer, compressed);
        if (py::isinstance<Amulet::NBT::ReadOffset>(read_offset_py)) {
            Amulet::NBT::ReadOffset& read_offset = read_offset_py.cast<Amulet::NBT::ReadOffset&>();
            if (count == -1) {
                return Amulet::NBT::decode_nbt_array(
                    buffer,
                    endianness,
                    string_decoder,
                    read_offset.offset,
                    named);
            } else {
                return Amulet::NBT::decode_nbt_array(
                    buffer,
                    endianness,
                    string_decoder,
                    read_offset.offset,
                    count,
                    named);
            }
        } else if (read_offset_py.is(py::none())) {
            size_t offset = 0;
            if (count == -1) {
                return Amulet::NBT::decode_nbt_array(
                    buffer,
                    endianness,
                    string_decoder,
                    offset,
                    named);
            } else {
                return Amulet::NBT::decode_nbt_array(
                    buffer,
                    endianness,
                    string_decoder,
                    offset,
                    count,
                    named);
            }
        } else {
            throw std::invalid_argument("read_offset must be ReadOffset or None");
        }
    };
    m.def(
        "read_nbt_array",
        [read_nbt_array](
            py::object filepath_or_buffer,
            Py_ssize_t count,
            Amulet::NBT::EncodingPreset preset,
            bool named,
            py::object read_offset) {
            return read_nbt_array(
                filepath_or_buffer,
                count,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_buffer"),
        py::kw_only(),
        py::arg("count") = 1,
        py::arg("preset") = java_encoding,
        py::arg("named") = true,
        py::arg("read_offset") = py::none(),
        py::doc(
            "Load an array of binary NBT objects from a contiguous buffer.\n"
            "\n"
            ":param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.\n"
            ":param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.\n"
            ":param named: If the tags to read are named, if not, return NamedTags with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));

    m.def(
        "read_nbt_array",
        [read_nbt_array](
            py::object filepath_or_buffer,
            Py_ssize_t count,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding,
            bool named,
            py::object read_offset) {
            return read_nbt_array(
                filepath_or_buffer,
                count,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.decode,
                named,
                read_offset);
        },
        py::arg("filepath_or_buffer"),
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
            ":param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.\n"
            ":param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.\n"
            ":param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.\n"
            ":param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.\n"
            ":param string_encoding: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet.nbt.utf8_escape_decoder for Bedrock.\n"
            ":param named: If the tags to read are named, if not, return NamedTags with empty name.\n"
            ":param read_offset: Optional ReadOffset object to get read end offset.\n"
            ":raises: IndexError if the data is not long enough."));
}
