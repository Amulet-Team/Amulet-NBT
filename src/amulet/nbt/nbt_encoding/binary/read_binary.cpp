#include <bit>
#include <cstdint>
#include <memory>
#include <stdexcept>
#include <string>
#include <string_view>
#include <variant>
#include <vector>

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {

    template <typename T>
    inline T read_numeric_tag(BinaryReader& reader)
    {
        return T(reader.read_numeric<typename T::native_type>());
    }

    inline std::string read_string(BinaryReader& reader)
    {
        std::uint16_t length = reader.read_numeric<std::uint16_t>();
        return reader.read_string(length);
    };

    inline StringTag read_string_tag(BinaryReader& reader)
    {
        return StringTag(read_string(reader));
    };

    inline TagNode read_node(BinaryReader& reader, std::uint8_t tag_id);

    inline CompoundTagPtr read_compound_tag(BinaryReader& reader)
    {
        CompoundTagPtr tag_ptr = std::make_shared<CompoundTag>();
        CompoundTag& tag = *tag_ptr;
        while (true) {
            std::uint8_t tag_id = reader.read_numeric<std::uint8_t>();
            if (tag_id == 0) {
                break;
            }
            std::string name = read_string(reader);
            TagNode node = read_node(reader, tag_id);
            tag[name] = node;
        }
        return tag_ptr;
    };

    template <typename T>
    inline std::shared_ptr<T> read_array_tag(BinaryReader& reader)
    {
        std::int32_t length = reader.read_numeric<std::int32_t>();
        if (length < 0) {
            length = 0;
        }
        std::shared_ptr<T> tag = std::make_shared<T>(length);
        for (std::int32_t i = 0; i < length; i++) {
            reader.read_numeric_into((*tag)[i]);
        }
        return tag;
    }

    template <typename T>
    inline ListTagPtr read_numeric_list_tag(BinaryReader& reader)
    {
        std::int32_t length = reader.read_numeric<std::int32_t>();
        if (length < 0) {
            length = 0;
        }
        ListTagPtr tag = std::make_shared<ListTag>(std::vector<T>(length));
        std::vector<T>& list = std::get<std::vector<T>>(*tag);
        for (std::int32_t i = 0; i < length; i++) {
            list[i] = T(reader.read_numeric<typename T::native_type>());
        }
        return tag;
    }

    template <typename T, T (*readTag)(BinaryReader&)>
    inline ListTagPtr read_template_list_tag(BinaryReader& reader)
    {
        std::int32_t length = reader.read_numeric<std::int32_t>();
        if (length < 0) {
            length = 0;
        }
        ListTagPtr tag = std::make_shared<ListTag>(std::vector<T>(length));
        std::vector<T>& list = std::get<std::vector<T>>(*tag);
        for (std::int32_t i = 0; i < length; i++) {
            list[i] = readTag(reader);
        }
        return tag;
    }

    inline ListTagPtr read_void_list_tag(BinaryReader& reader)
    {
        std::int32_t length = reader.read_numeric<std::int32_t>();
        if (length < 0) {
            length = 0;
        }
        if (length != 0) {
            throw std::runtime_error("Void list tag must have a length of 0");
        }
        return std::make_shared<ListTag>();
    }

    inline ListTagPtr read_list_tag(BinaryReader& reader)
    {
        std::uint8_t tag_type = reader.read_numeric<std::uint8_t>();
        switch (tag_type) {
        case 0:
            return read_void_list_tag(reader);
        case tag_id_v<ByteTag>:
            return read_numeric_list_tag<ByteTag>(reader);
        case tag_id_v<ShortTag>:
            return read_numeric_list_tag<ShortTag>(reader);
        case tag_id_v<IntTag>:
            return read_numeric_list_tag<IntTag>(reader);
        case tag_id_v<LongTag>:
            return read_numeric_list_tag<LongTag>(reader);
        case tag_id_v<FloatTag>:
            return read_numeric_list_tag<FloatTag>(reader);
        case tag_id_v<DoubleTag>:
            return read_numeric_list_tag<DoubleTag>(reader);
        case tag_id_v<ByteArrayTag>:
            return read_template_list_tag<ByteArrayTagPtr, read_array_tag<ByteArrayTag>>(reader);
        case tag_id_v<StringTag>:
            return read_template_list_tag<StringTag, read_string_tag>(reader);
        case tag_id_v<ListTag>:
            return read_template_list_tag<ListTagPtr, read_list_tag>(reader);
        case tag_id_v<CompoundTag>:
            return read_template_list_tag<CompoundTagPtr, read_compound_tag>(reader);
        case tag_id_v<IntArrayTag>:
            return read_template_list_tag<IntArrayTagPtr, read_array_tag<IntArrayTag>>(reader);
        case tag_id_v<LongArrayTag>:
            return read_template_list_tag<LongArrayTagPtr, read_array_tag<LongArrayTag>>(reader);
        default:
            throw std::runtime_error("This shouldn't happen");
        }
    };

    inline TagNode read_node(BinaryReader& reader, std::uint8_t tag_id)
    {
        switch (tag_id) {
        case tag_id_v<ByteTag>:
            return read_numeric_tag<ByteTag>(reader);
        case tag_id_v<ShortTag>:
            return read_numeric_tag<ShortTag>(reader);
        case tag_id_v<IntTag>:
            return read_numeric_tag<IntTag>(reader);
        case tag_id_v<LongTag>:
            return read_numeric_tag<LongTag>(reader);
        case tag_id_v<FloatTag>:
            return read_numeric_tag<FloatTag>(reader);
        case tag_id_v<DoubleTag>:
            return read_numeric_tag<DoubleTag>(reader);
        case tag_id_v<ByteArrayTag>:
            return read_array_tag<ByteArrayTag>(reader);
        case tag_id_v<StringTag>:
            return read_string_tag(reader);
        case tag_id_v<ListTag>:
            return read_list_tag(reader);
        case tag_id_v<CompoundTag>:
            return read_compound_tag(reader);
        case tag_id_v<IntArrayTag>:
            return read_array_tag<IntArrayTag>(reader);
        case tag_id_v<LongArrayTag>:
            return read_array_tag<LongArrayTag>(reader);
        default:
            throw std::runtime_error("Unsupported tag type " + std::to_string(tag_id));
        }
    };

    NamedTag decode_nbt(BinaryReader& reader, bool named)
    {
        std::uint8_t tag_id = reader.read_numeric<std::uint8_t>();
        std::string name = named ? read_string_tag(reader) : "";
        TagNode node = read_node(reader, tag_id);
        return NamedTag(name, node);
    }

    // Read one (un)named tag from the string at position offset.
    NamedTag decode_nbt(std::string_view raw, std::endian endianness, Amulet::StringDecoder string_decode, size_t& offset, bool named)
    {
        BinaryReader reader(raw, offset, endianness, string_decode);
        return decode_nbt(reader, named);
    }

    // Read one (un)named tag from the string.
    NamedTag decode_nbt(std::string_view raw, std::endian endianness, Amulet::StringDecoder string_decode, bool named)
    {
        size_t offset = 0;
        return decode_nbt(raw, endianness, string_decode, offset, named);
    }

    // Read count (un)named tags from the string at position offset.
    std::vector<NamedTag> decode_nbt_array(std::string_view raw, std::endian endianness, Amulet::StringDecoder string_decode, size_t& offset, size_t count, bool named)
    {
        BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<NamedTag> out;
        for (size_t i = 0; i < count; i++) {
            out.push_back(decode_nbt(reader, named));
        }
        return out;
    }

    // Read all (un)named tags from the string at position offset.
    std::vector<NamedTag> decode_nbt_array(std::string_view raw, std::endian endianness, Amulet::StringDecoder string_decode, size_t& offset, bool named)
    {
        BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<NamedTag> out;
        while (reader.has_more_data()) {
            out.push_back(decode_nbt(reader, named));
        }
        return out;
    }
} // namespace NBT
} // namespace Amulet
