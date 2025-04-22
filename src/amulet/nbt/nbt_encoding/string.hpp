#pragma once

#include <string>
#include <string_view>

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/string_encoding/string_encoding.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const TagNode&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const ByteTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const ShortTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const IntTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const LongTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const FloatTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const DoubleTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const ByteArrayTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const StringTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const ListTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const CompoundTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const IntArrayTag&);
    AMULET_NBT_EXPORT void encode_snbt(std::string&, const LongArrayTag&);

    AMULET_NBT_EXPORT std::string encode_snbt(const TagNode&);
    AMULET_NBT_EXPORT std::string encode_snbt(const ByteTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const ShortTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const IntTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const LongTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const FloatTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const DoubleTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const ByteArrayTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const StringTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const ListTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const CompoundTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const IntArrayTag&);
    AMULET_NBT_EXPORT std::string encode_snbt(const LongArrayTag&);

    // Multi-line variants
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const TagNode&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const ByteTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const ShortTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const IntTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const LongTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const FloatTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const DoubleTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const ByteArrayTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const StringTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const ListTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const CompoundTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const IntArrayTag&, const std::string& indent);
    AMULET_NBT_EXPORT void encode_formatted_snbt(std::string&, const LongArrayTag&, const std::string& indent);

    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const TagNode&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const ByteTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const ShortTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const IntTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const LongTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const FloatTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const DoubleTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const ByteArrayTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const StringTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const ListTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const CompoundTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const IntArrayTag&, const std::string& indent);
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const LongArrayTag&, const std::string& indent);

    AMULET_NBT_EXPORT TagNode decode_snbt(const CodePointVector& snbt);
    AMULET_NBT_EXPORT TagNode decode_snbt(std::string_view snbt);
} // namespace NBT
} // namespace Amulet
