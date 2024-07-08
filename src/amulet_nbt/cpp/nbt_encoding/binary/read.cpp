#include <amulet_nbt/nbt_encoding/binary.hpp>

Amulet::StringTag read_string_tag(Amulet::BinaryReader& reader){
    std::uint16_t length = reader.readNumeric<std::uint16_t>();
    return reader.readString(length);
};


Amulet::TagNode read_node(Amulet::BinaryReader& reader, std::uint8_t tag_id);


Amulet::CompoundTagPtr read_compound_tag(Amulet::BinaryReader& reader){
    Amulet::CompoundTagPtr tag = std::make_shared<Amulet::CompoundTag>();
    while (true){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        if (tag_id == 0){
            break;
        }
        Amulet::StringTag name = read_string_tag(reader);
        Amulet::TagNode node = read_node(reader, tag_id);
        (*tag)[name] = node;
    }
    return tag;
};


template <typename T>
std::shared_ptr<Amulet::ArrayTag<T>> read_array_tag(Amulet::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    std::shared_ptr<Amulet::ArrayTag<T>> tag = std::make_shared<Amulet::ArrayTag<T>>(length);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto((*tag)[i]);
    }
    return tag;
}


template <typename T>
Amulet::ListTagPtr read_numeric_list_tag(Amulet::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    Amulet::ListTagPtr tag = std::make_shared<Amulet::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto<T>(list[i]);
    }
    return tag;
}


template <typename T, T (*readTag)(Amulet::BinaryReader&)>
Amulet::ListTagPtr read_template_list_tag(Amulet::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    Amulet::ListTagPtr tag = std::make_shared<Amulet::ListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        list[i] = readTag(reader);
    }
    return tag;
}


Amulet::ListTagPtr read_void_list_tag(Amulet::BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    if (length != 0){throw std::runtime_error("Void list tag must have a length of 0");}
    return std::make_shared<Amulet::ListTag>();
}


Amulet::ListTagPtr read_list_tag(Amulet::BinaryReader& reader){
    std::uint8_t tag_type = reader.readNumeric<std::uint8_t>();
    switch(tag_type){
        case 0:
            return read_void_list_tag(reader);
        case 1:
            return read_numeric_list_tag<Amulet::ByteTag>(reader);
        case 2:
            return read_numeric_list_tag<Amulet::ShortTag>(reader);
        case 3:
            return read_numeric_list_tag<Amulet::IntTag>(reader);
        case 4:
            return read_numeric_list_tag<Amulet::LongTag>(reader);
        case 5:
            return read_numeric_list_tag<Amulet::FloatTag>(reader);
        case 6:
            return read_numeric_list_tag<Amulet::DoubleTag>(reader);
        case 7:
            return read_template_list_tag<Amulet::ByteArrayTagPtr, read_array_tag<Amulet::ByteTag>>(reader);
        case 8:
            return read_template_list_tag<Amulet::StringTag, read_string_tag>(reader);
        case 9:
            return read_template_list_tag<Amulet::ListTagPtr, read_list_tag>(reader);
        case 10:
            return read_template_list_tag<Amulet::CompoundTagPtr, read_compound_tag>(reader);
        case 11:
            return read_template_list_tag<Amulet::IntArrayTagPtr, read_array_tag<Amulet::IntTag>>(reader);
        case 12:
            return read_template_list_tag<Amulet::LongArrayTagPtr, read_array_tag<Amulet::LongTag>>(reader);
        default:
            throw std::runtime_error("This shouldn't happen");
    }
};


Amulet::TagNode read_node(Amulet::BinaryReader& reader, std::uint8_t tag_id){
    Amulet::TagNode node;
    switch(tag_id){
        case 1:
            node = reader.readNumeric<Amulet::ByteTag>();
            break;
        case 2:
            node = reader.readNumeric<Amulet::ShortTag>();
            break;
        case 3:
            node = reader.readNumeric<Amulet::IntTag>();
            break;
        case 4:
            node = reader.readNumeric<Amulet::LongTag>();
            break;
        case 5:
            node = reader.readNumeric<Amulet::FloatTag>();
            break;
        case 6:
            node = reader.readNumeric<Amulet::DoubleTag>();
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
            node = read_array_tag<Amulet::ByteTag>(reader);
            break;
        case 11:
            node = read_array_tag<Amulet::IntTag>(reader);
            break;
        case 12:
            node = read_array_tag<Amulet::LongTag>(reader);
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
    return node;
};


namespace Amulet {
    Amulet::NamedTag read_named_tag(Amulet::BinaryReader& reader){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        std::string name = read_string_tag(reader);
        Amulet::TagNode node = read_node(reader, tag_id);
        return Amulet::NamedTag(name, node);
    }

    // Read one named tag from the string at position offset.
    Amulet::NamedTag read_named_tag(const std::string& raw, std::endian endianness, Amulet::StringDecode string_decode, size_t& offset){
        Amulet::BinaryReader reader(raw, offset, endianness, string_decode);
        return read_named_tag(reader);
    }

    // Read one named tag from the string.
    Amulet::NamedTag read_named_tag(const std::string& raw, std::endian endianness, Amulet::StringDecode string_decode){
        size_t offset = 0;
        return read_named_tag(raw, endianness, string_decode, offset);
    }

    // Read count named tags from the string at position offset.
    std::vector<Amulet::NamedTag> read_named_tags(const std::string& raw, std::endian endianness, Amulet::StringDecode string_decode, size_t& offset, size_t count){
        Amulet::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<Amulet::NamedTag> out;
        for (size_t i = 0; i < count; i++){
            out.push_back(read_named_tag(reader));
        }
        return out;
    }

    // Read all named tags from the string at position offset.
    std::vector<Amulet::NamedTag> read_named_tags(const std::string& raw, std::endian endianness, Amulet::StringDecode string_decode, size_t& offset){
        Amulet::BinaryReader reader(raw, offset, endianness, string_decode);
        std::vector<Amulet::NamedTag> out;
        while (reader.has_more_data()){
            out.push_back(read_named_tag(reader));
        }
        return out;
    }
}
