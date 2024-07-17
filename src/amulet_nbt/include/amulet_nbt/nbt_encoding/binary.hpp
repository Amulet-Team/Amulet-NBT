#pragma once

#include <utility>
#include <string>
#include <bit>
#include <vector>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    AmuletNBT::NamedTag read_nbt(const std::string&, std::endian, AmuletNBT::StringDecode, size_t& offset);
    AmuletNBT::NamedTag read_nbt(const std::string&, std::endian, AmuletNBT::StringDecode);
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string&, std::endian, AmuletNBT::StringDecode, size_t& offset);
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string&, std::endian, AmuletNBT::StringDecode, size_t& offset, size_t count);

    std::string write_nbt(const std::string& name, const AmuletNBT::ByteTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::ShortTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::IntTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::LongTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::FloatTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::DoubleTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::ByteArrayTagPtr&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::StringTag&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::ListTagPtr&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::CompoundTagPtr&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::IntArrayTagPtr&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::LongArrayTagPtr&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const std::string& name, const AmuletNBT::TagNode&, std::endian, AmuletNBT::StringEncode);
    std::string write_nbt(const AmuletNBT::NamedTag& tag, std::endian, AmuletNBT::StringEncode);
}
