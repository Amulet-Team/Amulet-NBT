#include <cstdint>
#include <memory>
#include <vector>
#include <variant>
#include <stdexcept>
#include <string>
#include <bit>

#include <amulet_nbt/nbt_encoding/binary.hpp>

AmuletNBT::StringTag read_string_tag(AmuletNBT::BinaryReader& reader){
    std::uint16_t length = reader.readNumeric<std::uint16_t>();
    return reader.readString(length);
};


AmuletNBT::TagNode read_node(AmuletNBT::BinaryReader& reader, std::uint8_t tag_id);


AmuletNBT::CompoundTagPtr read_compound_tag(AmuletNBT::BinaryReader& reader){
    AmuletNBT::CompoundTagPtr tag = std::make_shared<AmuletNBT::CompoundTag>();
    while (true){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        if (tag_id == 0){
            break;
        }
        AmuletNBT::StringTag name = read_string_tag(reader);
        AmuletNBT::TagNode node = read_node(reader, tag_id);
        (*tag)[name] = node;
    }
    return tag;
};


template <typename T>
std::shared_ptr<AmuletNBT::ArrayTag<T>> read_array_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    std::shared_ptr<AmuletNBT::ArrayTag<T>> tag = std::make_shared<AmuletNBT::ArrayTag<T>>(length);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto((*tag)[i]);
    }
    return tag;
}


template <typename T>
AmuletNBT::ListTagPtr read_numeric_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto<T>(list[i]);
    }
    return tag;
}


template <typename T, T (*readTag)(AmuletNBT::BinaryReader&)>
AmuletNBT::ListTagPtr read_template_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        list[i] = readTag(reader);
    }
    return tag;
}


AmuletNBT::ListTagPtr read_void_list_tag(AmuletNBT::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    if (length != 0){throw std::runtime_error("Void list tag must have a length of 0");}
    return std::make_shared<AmuletNBT::ListTag>();
}


AmuletNBT::ListTagPtr read_list_tag(AmuletNBT::BinaryReader& reader){
    std::uint8_t tag_type = reader.readNumeric<std::uint8_t>();
    switch(tag_type){
        case 0:
            return read_void_list_tag(reader);
        case 1:
            return read_numeric_list_tag<AmuletNBT::ByteTag>(reader);
        case 2:
            return read_numeric_list_tag<AmuletNBT::ShortTag>(reader);
        case 3:
            return read_numeric_list_tag<AmuletNBT::IntTag>(reader);
        case 4:
            return read_numeric_list_tag<AmuletNBT::LongTag>(reader);
        case 5:
            return read_numeric_list_tag<AmuletNBT::FloatTag>(reader);
        case 6:
            return read_numeric_list_tag<AmuletNBT::DoubleTag>(reader);
        case 7:
            return read_template_list_tag<AmuletNBT::ByteArrayTagPtr, read_array_tag<AmuletNBT::ByteTag>>(reader);
        case 8:
            return read_template_list_tag<AmuletNBT::StringTag, read_string_tag>(reader);
        case 9:
            return read_template_list_tag<AmuletNBT::ListTagPtr, read_list_tag>(reader);
        case 10:
            return read_template_list_tag<AmuletNBT::CompoundTagPtr, read_compound_tag>(reader);
        case 11:
            return read_template_list_tag<AmuletNBT::IntArrayTagPtr, read_array_tag<AmuletNBT::IntTag>>(reader);
        case 12:
            return read_template_list_tag<AmuletNBT::LongArrayTagPtr, read_array_tag<AmuletNBT::LongTag>>(reader);
        default:
            throw std::runtime_error("This shouldn't happen");
    }
};


AmuletNBT::TagNode read_node(AmuletNBT::BinaryReader& reader, std::uint8_t tag_id){
    AmuletNBT::TagNode node;
    switch(tag_id){
        case 1:
            node = reader.readNumeric<AmuletNBT::ByteTag>();
            break;
        case 2:
            node = reader.readNumeric<AmuletNBT::ShortTag>();
            break;
        case 3:
            node = reader.readNumeric<AmuletNBT::IntTag>();
            break;
        case 4:
            node = reader.readNumeric<AmuletNBT::LongTag>();
            break;
        case 5:
            node = reader.readNumeric<AmuletNBT::FloatTag>();
            break;
        case 6:
            node = reader.readNumeric<AmuletNBT::DoubleTag>();
            break;
        case 8:
            node = read_string_tag(reader);
            break;
        case 9:
            node = read_list_tag(reader);
            break;
        case 10:
            node = read_compound_tag(reader);
            break;
        case 7:
            node = read_array_tag<AmuletNBT::ByteTag>(reader);
            break;
        case 11:
            node = read_array_tag<AmuletNBT::IntTag>(reader);
            break;
        case 12:
            node = read_array_tag<AmuletNBT::LongTag>(reader);
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
    return node;
};


namespace AmuletNBT {
    AmuletNBT::NamedTag read_nbt(AmuletNBT::BinaryReader& reader){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        std::string name = read_string_tag(reader);
        AmuletNBT::TagNode node = read_node(reader, tag_id);
        return AmuletNBT::NamedTag(name, node);
    }

    // Read one named tag from the string at position offset.
    AmuletNBT::NamedTag read_nbt(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        return read_nbt(reader);
    }

    // Read one named tag from the string.
    AmuletNBT::NamedTag read_nbt(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode){
        size_t offset = 0;
        return read_nbt(raw, endianness, string_decode, offset);
    }

    // Read count named tags from the string at position offset.
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset, size_t count){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<AmuletNBT::NamedTag> out;
        for (size_t i = 0; i < count; i++){
            out.push_back(read_nbt(reader));
        }
        return out;
    }

    // Read all named tags from the string at position offset.
    std::vector<AmuletNBT::NamedTag> read_nbt_array(const std::string& raw, std::endian endianness, AmuletNBT::StringDecode string_decode, size_t& offset){
        AmuletNBT::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<AmuletNBT::NamedTag> out;
        while (reader.has_more_data()){
            out.push_back(read_nbt(reader));
        }
        return out;
    }
}
