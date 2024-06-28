#include "read_nbt.hpp"

CStringTag read_string_tag(BinaryReader& reader){
    std::uint16_t length = reader.readNumeric<std::uint16_t>();
    return reader.readString(length);
};


TagNode read_node(BinaryReader& reader, std::uint8_t tag_id);


CCompoundTagPtr read_compound_tag(BinaryReader& reader){
    CCompoundTagPtr tag = std::make_shared<CCompoundTag>();
    while (true){
        std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
        if (tag_id == 0){
            break;
        }
        CStringTag name = read_string_tag(reader);
        TagNode node = read_node(reader, tag_id);
        (*tag)[name] = node;
    }
    return tag;
};


template <typename T>
std::shared_ptr<Array<T>> read_array_tag(BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    std::shared_ptr<Array<T>> tag = std::make_shared<Array<T>>(length);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto((*tag)[i]);
    }
    return tag;
}


template <typename T>
CListTagPtr read_numeric_list_tag(BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    CListTagPtr tag = std::make_shared<CListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        reader.readNumericInto<T>(list[i]);
    }
    return tag;
}


template <typename T, T (*readTag)(BinaryReader&)>
CListTagPtr read_template_list_tag(BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    CListTagPtr tag = std::make_shared<CListTag>(std::vector<T>(length));
    std::vector<T>& list = std::get<std::vector<T>>(*tag);
    for (std::int32_t i = 0; i < length; i++){
        list[i] = readTag(reader);
    }
    return tag;
}


CListTagPtr read_void_list_tag(BinaryReader& reader){
    std::int32_t length = reader.readNumeric<std::int32_t>();
    if (length < 0){length = 0;}
    if (length != 0){throw std::runtime_error("Void list tag must have a length of 0");}
    return std::make_shared<CListTag>();
}


CListTagPtr read_list_tag(BinaryReader& reader){
    std::uint8_t tag_type = reader.readNumeric<std::uint8_t>();
    switch(tag_type){
        case 0:
            return read_void_list_tag(reader);
        case 1:
            return read_numeric_list_tag<CByteTag>(reader);
        case 2:
            return read_numeric_list_tag<CShortTag>(reader);
        case 3:
            return read_numeric_list_tag<CIntTag>(reader);
        case 4:
            return read_numeric_list_tag<CLongTag>(reader);
        case 5:
            return read_numeric_list_tag<CFloatTag>(reader);
        case 6:
            return read_numeric_list_tag<CDoubleTag>(reader);
        case 7:
            return read_template_list_tag<CByteArrayTagPtr, read_array_tag<CByteTag>>(reader);
        case 8:
            return read_template_list_tag<CStringTag, read_string_tag>(reader);
        case 9:
            return read_template_list_tag<CListTagPtr, read_list_tag>(reader);
        case 10:
            return read_template_list_tag<CCompoundTagPtr, read_compound_tag>(reader);
        case 11:
            return read_template_list_tag<CIntArrayTagPtr, read_array_tag<CIntTag>>(reader);
        case 12:
            return read_template_list_tag<CLongArrayTagPtr, read_array_tag<CLongTag>>(reader);
        default:
            throw std::runtime_error("This shouldn't happen");
    }
};


TagNode read_node(BinaryReader& reader, std::uint8_t tag_id){
    TagNode node;
    switch(tag_id){
        case 1:
            node = reader.readNumeric<CByteTag>();
            break;
        case 2:
            node = reader.readNumeric<CShortTag>();
            break;
        case 3:
            node = reader.readNumeric<CIntTag>();
            break;
        case 4:
            node = reader.readNumeric<CLongTag>();
            break;
        case 5:
            node = reader.readNumeric<CFloatTag>();
            break;
        case 6:
            node = reader.readNumeric<CDoubleTag>();
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
            node = read_array_tag<CByteTag>(reader);
            break;
        case 11:
            node = read_array_tag<CIntTag>(reader);
            break;
        case 12:
            node = read_array_tag<CLongTag>(reader);
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
    return node;
};


std::pair<std::string, TagNode> read_named_tag(BinaryReader& reader){
    std::uint8_t tag_id = reader.readNumeric<std::uint8_t>();
    std::string name = read_string_tag(reader);
    TagNode node = read_node(reader, tag_id);
    return std::make_pair(name, node);
}


std::pair<std::string, TagNode> read_named_tag(const std::string& raw, std::endian endianness, StringDecode stringDecode, size_t& offset){
    BinaryReader reader(raw, offset, endianness, stringDecode);
    return read_named_tag(reader);
}


std::pair<std::string, TagNode> read_named_tag(const std::string& raw, std::endian endianness, StringDecode stringDecode){
    size_t offset = 0;
    return read_named_tag(raw, endianness, stringDecode, offset);
}
