#pragma once

#include <utility>
#include <string>
#include <string_view>
#include <bit>
#include <vector>
#include <optional>

#include <amulet_nbt/dll.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    AMULET_NBT_DLLX NamedTag read_nbt(BinaryReader& reader, bool named = true);
    AMULET_NBT_DLLX NamedTag read_nbt(std::string_view, std::endian, StringDecode, size_t& offset, bool named = true);
    AMULET_NBT_DLLX NamedTag read_nbt(std::string_view, std::endian, StringDecode, bool named = true);
    AMULET_NBT_DLLX std::vector<NamedTag> read_nbt_array(std::string_view, std::endian, StringDecode, size_t& offset, bool named = true);
    AMULET_NBT_DLLX std::vector<NamedTag> read_nbt_array(std::string_view, std::endian, StringDecode, size_t& offset, size_t count, bool named);

    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const ByteTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const ShortTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const IntTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const LongTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const FloatTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const DoubleTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const ByteArrayTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const StringTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const ListTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const CompoundTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const IntArrayTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::optional<std::string>& name, const LongArrayTag&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const std::string& name, const TagNode&);
    AMULET_NBT_DLLX void write_nbt(BinaryWriter&, const NamedTag& tag);
    
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const ByteTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const ShortTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const IntTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const LongTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const FloatTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const DoubleTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const ByteArrayTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const StringTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const ListTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const CompoundTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const IntArrayTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::optional<std::string>& name, const LongArrayTag&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const std::string& name, const TagNode&, std::endian, StringEncode);
    AMULET_NBT_DLLX std::string write_nbt(const NamedTag& tag, std::endian, StringEncode);
}
