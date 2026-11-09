#pragma once

#include <bit>
#include <string>

#include <amulet/io/binary_reader.hpp>
#include <amulet/io/binary_writer.hpp>

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    class StringEncoding {
    public:
        std::string var_name;
        Amulet::StringEncoder encode;
        Amulet::StringDecoder decode;
        StringEncoding(
            std::string var_name,
            Amulet::StringEncoder encode,
            Amulet::StringDecoder decode)
            : var_name(var_name)
            , encode(encode)
            , decode(decode) { };
    };

    class EncodingPreset {
    public:
        std::string var_name;
        bool compressed;
        std::endian endianness;
        StringEncoding string_encoding;
        EncodingPreset(
            std::string var_name,
            bool compressed,
            std::endian endianness,
            StringEncoding string_encoding)
            : var_name(var_name)
            , compressed(compressed)
            , endianness(endianness)
            , string_encoding(string_encoding) { };
    };
} // namespace NBT
} // namespace Amulet
