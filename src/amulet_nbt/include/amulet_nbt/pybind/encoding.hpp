#pragma once

#include <bit>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>

namespace py = pybind11;


namespace AmuletNBT {
    class StringEncoding {
        public:
            AmuletNBT::StringEncode encode;
            AmuletNBT::StringDecode decode;
            StringEncoding(
                AmuletNBT::StringEncode encode,
                AmuletNBT::StringDecode decode
            ): encode(encode), decode(decode) {};
    };

    class EncodingPreset {
        public:
            bool compressed;
            std::endian endianness;
            AmuletNBT::StringEncoding string_encoding;
            EncodingPreset(
                bool compressed,
                std::endian endianness,
                AmuletNBT::StringEncoding string_encoding
            ): compressed(compressed), endianness(endianness), string_encoding(string_encoding) {};
    };
}
