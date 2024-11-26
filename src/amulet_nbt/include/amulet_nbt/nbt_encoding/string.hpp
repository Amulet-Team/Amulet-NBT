#pragma once

#include <string>
#include <string_view>

#include <amulet_nbt/dll.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    AMULET_NBT_DLLX void write_snbt(std::string&, const TagNode&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const ByteTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const ShortTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const IntTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const LongTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const FloatTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const DoubleTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const ByteArrayTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const StringTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const ListTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const CompoundTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const IntArrayTag&);
    AMULET_NBT_DLLX void write_snbt(std::string&, const LongArrayTag&);

    AMULET_NBT_DLLX std::string write_snbt(const TagNode&);
    AMULET_NBT_DLLX std::string write_snbt(const ByteTag&);
    AMULET_NBT_DLLX std::string write_snbt(const ShortTag&);
    AMULET_NBT_DLLX std::string write_snbt(const IntTag&);
    AMULET_NBT_DLLX std::string write_snbt(const LongTag&);
    AMULET_NBT_DLLX std::string write_snbt(const FloatTag&);
    AMULET_NBT_DLLX std::string write_snbt(const DoubleTag&);
    AMULET_NBT_DLLX std::string write_snbt(const ByteArrayTag&);
    AMULET_NBT_DLLX std::string write_snbt(const StringTag&);
    AMULET_NBT_DLLX std::string write_snbt(const ListTag&);
    AMULET_NBT_DLLX std::string write_snbt(const CompoundTag&);
    AMULET_NBT_DLLX std::string write_snbt(const IntArrayTag&);
    AMULET_NBT_DLLX std::string write_snbt(const LongArrayTag&);

    // Multi-line variants
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const TagNode&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const ByteTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const ShortTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const IntTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const LongTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const FloatTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const DoubleTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const ByteArrayTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const StringTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const ListTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const CompoundTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const IntArrayTag&, const std::string& indent);
    AMULET_NBT_DLLX void write_formatted_snbt(std::string&, const LongArrayTag&, const std::string& indent);

    AMULET_NBT_DLLX std::string write_formatted_snbt(const TagNode&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const ByteTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const ShortTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const IntTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const LongTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const FloatTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const DoubleTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const ByteArrayTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const StringTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const ListTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const CompoundTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const IntArrayTag&, const std::string& indent);
    AMULET_NBT_DLLX std::string write_formatted_snbt(const LongArrayTag&, const std::string& indent);

    AMULET_NBT_DLLX TagNode read_snbt(const CodePointVector& snbt);
    AMULET_NBT_DLLX TagNode read_snbt(std::string_view snbt);
    }
