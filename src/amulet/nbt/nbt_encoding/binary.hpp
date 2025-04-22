#pragma once

#include <bit>
#include <optional>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include <amulet/nbt/export.hpp>
#include <amulet/io/binary_reader.hpp>
#include <amulet/io/binary_writer.hpp>
#include <amulet/nbt/string_encoding/string_encoding.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
    AMULET_NBT_EXPORT NamedTag decode_nbt(BinaryReader& reader, bool named = true);
    AMULET_NBT_EXPORT NamedTag decode_nbt(std::string_view, std::endian, Amulet::StringDecoder, size_t& offset, bool named = true);
    AMULET_NBT_EXPORT NamedTag decode_nbt(std::string_view, std::endian, Amulet::StringDecoder, bool named = true);
    AMULET_NBT_EXPORT std::vector<NamedTag> decode_nbt_array(std::string_view, std::endian, Amulet::StringDecoder, size_t& offset, bool named = true);
    AMULET_NBT_EXPORT std::vector<NamedTag> decode_nbt_array(std::string_view, std::endian, Amulet::StringDecoder, size_t& offset, size_t count, bool named);

    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const ByteTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const ShortTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const IntTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const LongTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const FloatTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const DoubleTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const ByteArrayTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const StringTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const ListTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const CompoundTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const IntArrayTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::optional<std::string>& name, const LongArrayTag&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const std::string& name, const TagNode&);
    AMULET_NBT_EXPORT void encode_nbt(BinaryWriter&, const NamedTag& tag);

    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const ByteTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const ShortTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const IntTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const LongTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const FloatTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const DoubleTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const ByteArrayTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const StringTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const ListTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const CompoundTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const IntArrayTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::optional<std::string>& name, const LongArrayTag&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const std::string& name, const TagNode&, std::endian, Amulet::StringEncoder);
    AMULET_NBT_EXPORT std::string encode_nbt(const NamedTag& tag, std::endian, Amulet::StringEncoder);
} // namespace NBT
} // namespace Amulet
