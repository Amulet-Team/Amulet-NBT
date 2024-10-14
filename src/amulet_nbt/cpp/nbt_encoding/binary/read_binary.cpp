#include <cstdint>
#include <memory>
#include <vector>
#include <variant>
#include <stdexcept>
#include <string>
#include <bit>

#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>

template <typename T>
inline T read_numeric_tag(AmuletNBT::BinaryReader& reader) {
    return T(reader.readNumeric<typename T::native_type>());
}

inline std::string read_string(AmuletNBT::BinaryReader& reader) {
    std::uint16_t length = reader.readNumeric<std::uint16_t>();
    return reader.readString(length);
};

inline AmuletNBT::StringTag read_string_tag(AmuletNBT::BinaryReader& reader){
    return AmuletNBT::StringTag(read_string(reader));
};


inline AmuletNBT::TagNode read_node(AmuletNBT::BinaryReader& reader, std::uint8_t tag_id);


inline AmuletNBT::CompoundTagPtr read_compound_tag(AmuletNBT::BinaryReader& reader){
    AmuletNBT::CompoundTagPtr tag_ptr = std::make_shared<AmuletNBT::CompoundTag>();
    AmuletNBT::CompoundTag& tag = *tag_ptr;
    while (true){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        if (tag_id == 0){
            break;
        }
        std::string name = read_string(reader);
        AmuletNBT::TagNode node = read_node(reader, tag_id);
        tag[name] = node;
    }
    return tag_ptr;
};


template <typename T>
inline std::shared_ptr<T> read_array_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    std::shared_ptr<T> tag = std::make_shared<T>(length);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto((*tag)[i]);
    }
    return tag;
}


template <typename T>
inline AmuletNBT::ListTagPtr read_numeric_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        list[i] = T(reader.readNumeric<typename T::native_type>());
    }
    return tag;
}


template <typename T, T (*readTag)(AmuletNBT::BinaryReader&)>
inline AmuletNBT::ListTagPtr read_template_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        list[i] = readTag(reader);
    }
    return tag;
}


inline AmuletNBT::ListTagPtr read_void_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    if (length != 0){throw std::runtime_error("Void list tag must have a length of 0");}
    return std::make_shared<AmuletNBT::ListTag>();
}


inline AmuletNBT::ListTagPtr read_list_tag(AmuletNBT::BinaryReader& reader){
    std::uint8_t tag_type = reader.readNumeric<std::uint8_t>();
    switch(tag_type){
        case 0:
            return read_void_list_tag(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ByteTag>:
            return read_numeric_list_tag<AmuletNBT::ByteTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ShortTag>:
            return read_numeric_list_tag<AmuletNBT::ShortTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::IntTag>:
            return read_numeric_list_tag<AmuletNBT::IntTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::LongTag>:
            return read_numeric_list_tag<AmuletNBT::LongTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::FloatTag>:
            return read_numeric_list_tag<AmuletNBT::FloatTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::DoubleTag>:
            return read_numeric_list_tag<AmuletNBT::DoubleTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ByteArrayTag>:
            return read_template_list_tag<AmuletNBT::ByteArrayTagPtr, read_array_tag<AmuletNBT::ByteArrayTag>>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::StringTag>:
            return read_template_list_tag<AmuletNBT::StringTag, read_string_tag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ListTag>:
            return read_template_list_tag<AmuletNBT::ListTagPtr, read_list_tag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::CompoundTag>:
            return read_template_list_tag<AmuletNBT::CompoundTagPtr, read_compound_tag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::IntArrayTag>:
            return read_template_list_tag<AmuletNBT::IntArrayTagPtr, read_array_tag<AmuletNBT::IntArrayTag>>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::LongArrayTag>:
            return read_template_list_tag<AmuletNBT::LongArrayTagPtr, read_array_tag<AmuletNBT::LongArrayTag>>(reader);
        default:
            throw std::runtime_error("This shouldn't happen");
    }
};


inline AmuletNBT::TagNode read_node(AmuletNBT::BinaryReader& reader, std::uint8_t tag_id){
    switch(tag_id){
        case AmuletNBT::tag_id_v<AmuletNBT::ByteTag>:
            return read_numeric_tag<AmuletNBT::ByteTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ShortTag>:
            return read_numeric_tag<AmuletNBT::ShortTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::IntTag>:
            return read_numeric_tag<AmuletNBT::IntTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::LongTag>:
            return read_numeric_tag<AmuletNBT::LongTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::FloatTag>:
            return read_numeric_tag<AmuletNBT::FloatTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::DoubleTag>:
            return read_numeric_tag<AmuletNBT::DoubleTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ByteArrayTag>:
            return read_array_tag<AmuletNBT::ByteArrayTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::StringTag>:
            return read_string_tag(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::ListTag>:
            return read_list_tag(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::CompoundTag>:
            return read_compound_tag(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::IntArrayTag>:
            return read_array_tag<AmuletNBT::IntArrayTag>(reader);
        case AmuletNBT::tag_id_v<AmuletNBT::LongArrayTag>:
            return read_array_tag<AmuletNBT::LongArrayTag>(reader);
        default:
            throw std::runtime_error("Unsupported tag type " + std::to_string(tag_id));
    }
};


namespace AmuletNBT {
    AmuletNBT::NamedTag read_nbt(AmuletNBT::BinaryReader& reader, bool named){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        std::string name = named ? read_string_tag(reader) : "";
        AmuletNBT::TagNode node = read_node(reader, tag_id);
        return AmuletNBT::NamedTag(name, node);
    }

    // Read one (un)named tag from the string at position offset.
    AmuletNBT::NamedTag read_nbt(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset, bool named){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        return read_nbt(reader, named);
    }

    // Read one (un)named tag from the string.
    AmuletNBT::NamedTag read_nbt(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, bool named){
        size_t offset = 0;
        return read_nbt(raw, endianness, string_decode, offset, named);
    }

    // Read count (un)named tags from the string at position offset.
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset, size_t count, bool named){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<AmuletNBT::NamedTag> out;
        for (size_t i = 0; i < count; i++){
            out.push_back(read_nbt(reader, named));
        }
        return out;
    }

    // Read all (un)named tags from the string at position offset.
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset, bool named){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<AmuletNBT::NamedTag> out;
        while (reader.has_more_data()){
            out.push_back(read_nbt(reader, named));
        }
        return out;
    }
}
