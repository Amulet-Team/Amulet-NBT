#pragma once

#include <bit>

#include <amulet/io/binary_reader.hpp>
#include <amulet/io/binary_writer.hpp>

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    class StringEncoding {
    public:
        Amulet::StringEncoder encode;
        Amulet::StringDecoder decode;
        StringEncoding(
            Amulet::StringEncoder encode,
            Amulet::StringDecoder decode)
            : encode(encode)
            , decode(decode) { };
    };

    class EncodingPreset {
    public:
        bool compressed;
        std::endian endianness;
        StringEncoding string_encoding;
        EncodingPreset(
            bool compressed,
            std::endian endianness,
            StringEncoding string_encoding)
            : compressed(compressed)
            , endianness(endianness)
            , string_encoding(string_encoding) { };
    };
} // namespace NBT
} // namespace Amulet
