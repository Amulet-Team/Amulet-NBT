#pragma once

#include <utility>
#include <string>
#include <bit>
#include <vector>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace Amulet {
    Amulet::NamedTag read_nbt(const std::string&, std::endian, Amulet::StringDecode, size_t& offset);
    Amulet::NamedTag read_nbt(const std::string&, std::endian, Amulet::StringDecode);
    std::vector<Amulet::NamedTag> read_nbt_array(const std::string&, std::endian, Amulet::StringDecode, size_t& offset);
    std::vector<Amulet::NamedTag> read_nbt_array(const std::string&, std::endian, Amulet::StringDecode, size_t& offset, size_t count);

    std::string write_nbt(const std::string& name, const Amulet::ByteTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::ShortTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::IntTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::LongTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::FloatTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::DoubleTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::ByteArrayTagPtr&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::StringTag&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::ListTagPtr&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::CompoundTagPtr&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::IntArrayTagPtr&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::LongArrayTagPtr&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const std::string& name, const Amulet::TagNode&, std::endian, Amulet::StringEncode);
    std::string write_nbt(const Amulet::NamedTag& tag, std::endian, Amulet::StringEncode);
}
