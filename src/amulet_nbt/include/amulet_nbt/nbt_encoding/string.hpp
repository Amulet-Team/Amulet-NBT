#pragma once

#include <string>

#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    void write_snbt(std::string&, const TagNode&);
    void write_snbt(std::string&, const ByteTag&);
    void write_snbt(std::string&, const ShortTag&);
    void write_snbt(std::string&, const IntTag&);
    void write_snbt(std::string&, const LongTag&);
    void write_snbt(std::string&, const FloatTag&);
    void write_snbt(std::string&, const DoubleTag&);
    void write_snbt(std::string&, const ByteArrayTag&);
    void write_snbt(std::string&, const StringTag&);
    void write_snbt(std::string&, const ListTag&);
    void write_snbt(std::string&, const CompoundTag&);
    void write_snbt(std::string&, const IntArrayTag&);
    void write_snbt(std::string&, const LongArrayTag&);

    std::string write_snbt(const TagNode&);
    std::string write_snbt(const ByteTag&);
    std::string write_snbt(const ShortTag&);
    std::string write_snbt(const IntTag&);
    std::string write_snbt(const LongTag&);
    std::string write_snbt(const FloatTag&);
    std::string write_snbt(const DoubleTag&);
    std::string write_snbt(const ByteArrayTag&);
    std::string write_snbt(const StringTag&);
    std::string write_snbt(const ListTag&);
    std::string write_snbt(const CompoundTag&);
    std::string write_snbt(const IntArrayTag&);
    std::string write_snbt(const LongArrayTag&);

    // Multi-line variants
    void write_formatted_snbt(std::string&, const TagNode&, const std::string& indent);
    void write_formatted_snbt(std::string&, const ByteTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const ShortTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const IntTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const LongTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const FloatTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const DoubleTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const ByteArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const StringTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const ListTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const CompoundTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const IntArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const LongArrayTag&, const std::string& indent);

    std::string write_formatted_snbt(const TagNode&, const std::string& indent);
    std::string write_formatted_snbt(const ByteTag&, const std::string& indent);
    std::string write_formatted_snbt(const ShortTag&, const std::string& indent);
    std::string write_formatted_snbt(const IntTag&, const std::string& indent);
    std::string write_formatted_snbt(const LongTag&, const std::string& indent);
    std::string write_formatted_snbt(const FloatTag&, const std::string& indent);
    std::string write_formatted_snbt(const DoubleTag&, const std::string& indent);
    std::string write_formatted_snbt(const ByteArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const StringTag&, const std::string& indent);
    std::string write_formatted_snbt(const ListTag&, const std::string& indent);
    std::string write_formatted_snbt(const CompoundTag&, const std::string& indent);
    std::string write_formatted_snbt(const IntArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const LongArrayTag&, const std::string& indent);

    TagNode read_snbt(const CodePointVector& snbt);
    TagNode read_snbt(const std::string& snbt);
}
