#pragma once

#include <string>

#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    void write_snbt(std::string&, const AmuletNBT::TagNode&);
    void write_snbt(std::string&, const AmuletNBT::ByteTag&);
    void write_snbt(std::string&, const AmuletNBT::ShortTag&);
    void write_snbt(std::string&, const AmuletNBT::IntTag&);
    void write_snbt(std::string&, const AmuletNBT::LongTag&);
    void write_snbt(std::string&, const AmuletNBT::FloatTag&);
    void write_snbt(std::string&, const AmuletNBT::DoubleTag&);
    void write_snbt(std::string&, const AmuletNBT::ByteArrayTag&);
    void write_snbt(std::string&, const AmuletNBT::StringTag&);
    void write_snbt(std::string&, const AmuletNBT::ListTag&);
    void write_snbt(std::string&, const AmuletNBT::CompoundTag&);
    void write_snbt(std::string&, const AmuletNBT::IntArrayTag&);
    void write_snbt(std::string&, const AmuletNBT::LongArrayTag&);

    std::string write_snbt(const AmuletNBT::TagNode&);
    std::string write_snbt(const AmuletNBT::ByteTag&);
    std::string write_snbt(const AmuletNBT::ShortTag&);
    std::string write_snbt(const AmuletNBT::IntTag&);
    std::string write_snbt(const AmuletNBT::LongTag&);
    std::string write_snbt(const AmuletNBT::FloatTag&);
    std::string write_snbt(const AmuletNBT::DoubleTag&);
    std::string write_snbt(const AmuletNBT::ByteArrayTag&);
    std::string write_snbt(const AmuletNBT::StringTag&);
    std::string write_snbt(const AmuletNBT::ListTag&);
    std::string write_snbt(const AmuletNBT::CompoundTag&);
    std::string write_snbt(const AmuletNBT::IntArrayTag&);
    std::string write_snbt(const AmuletNBT::LongArrayTag&);

    // Multi-line variants
    void write_formatted_snbt(std::string&, const AmuletNBT::TagNode&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::ByteTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::ShortTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::IntTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::LongTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::FloatTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::DoubleTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::ByteArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::StringTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::ListTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::CompoundTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::IntArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const AmuletNBT::LongArrayTag&, const std::string& indent);

    std::string write_formatted_snbt(const AmuletNBT::TagNode&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::ByteTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::ShortTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::IntTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::LongTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::FloatTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::DoubleTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::ByteArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::StringTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::ListTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::CompoundTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::IntArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const AmuletNBT::LongArrayTag&, const std::string& indent);

    AmuletNBT::TagNode read_snbt(const AmuletNBT::CodePointVector& snbt);
    AmuletNBT::TagNode read_snbt(const std::string& snbt);
}
