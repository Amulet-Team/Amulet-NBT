#include "write.hpp"


void write_string_tag(BinaryWriter& writer, const CStringTag& value){
    if (value.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())){
        throw std::overflow_error(std::format("String of length {} is too long.", value.size()));
    }
    std::uint16_t length = static_cast<std::uint16_t>(value.size());
    writer.writeNumeric<std::uint16_t>(length);
    writer.writeString(value);
}


void write_named_tag(BinaryWriter& writer, const std::string& name, const TagNode& node);


void write_compound_tag(BinaryWriter& writer, const CCompoundTagPtr& value){
    for (auto it = value->begin(); it != value->end(); it++){
        write_named_tag(writer, it->first, it->second);
    }
    writer.writeNumeric<std::uint8_t>(0);
};


template <typename T>
void write_array_tag(BinaryWriter& writer, const std::shared_ptr<Array<T>>& value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error(std::format("Array of length {} is too long.", value->size()));
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: *value){
        writer.writeNumeric<T>(element);
    }
}


template <typename T>
void write_numeric_list_tag(BinaryWriter& writer, const std::vector<T>& value){
    if (value.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error(std::format("List of length {} is too long.", value.size()));
    }
    std::int32_t length = static_cast<std::int32_t>(value.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: value){
        writer.writeNumeric<T>(element);
    }
}


template <typename T, void (*writeTag)(BinaryWriter&, const T&)>
void write_template_list_tag(BinaryWriter& writer, std::vector<T>& value){
    if (value.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error(std::format("List of length {} is too long.", value.size()));
    }
    std::int32_t length = static_cast<std::int32_t>(value.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: value){
        write_tag(writer, element);
    }
}


void write_list_tag(BinaryWriter& writer, const CListTagPtr& value){
    writer.writeNumeric<std::uint8_t>(value->index());
    switch(value->index()){
        case 1:
            write_numeric_list_tag<CByteTag>(writer, std::get<CByteList>(*value));
        case 2:
            write_numeric_list_tag<CShortTag>(writer, std::get<CShortList>(*value));
        case 3:
            write_numeric_list_tag<CIntTag>(writer, std::get<CIntList>(*value));
        case 4:
            write_numeric_list_tag<CLongTag>(writer, std::get<CLongList>(*value));
        case 5:
            write_numeric_list_tag<CFloatTag>(writer, std::get<CFloatList>(*value));
        case 6:
            write_numeric_list_tag<CDoubleTag>(writer, std::get<CDoubleList>(*value));
        case 7:
            write_template_list_tag<CByteArrayTagPtr, write_array_tag<CByteTag>>(writer, std::get<CByteArrayList>(*value));
//        case 8:
//            write_template_list_tag<CStringTag, write_string_tag>(writer, std::get<CStringList>(*value));
//        case 9:
//            write_template_list_tag<CListTagPtr, write_list_tag>(writer, std::get<CListList>(*value));
//        case 10:
//            write_template_list_tag<CCompoundTagPtr, write_compound_tag>(writer, std::get<CCompoundList>(*value));
//        case 11:
//            write_template_list_tag<CIntArrayTagPtr, write_array_tag<CIntTag>>(writer, std::get<CIntArrayList>(*value));
//        case 12:
//            write_template_list_tag<CLongArrayTagPtr, write_array_tag<CLongTag>>(writer, std::get<CLongArrayList>(*value));
        default:
            throw std::runtime_error("Unsupported tag type");
    }
}


void write_tag(BinaryWriter& writer, const TagNode& node){
    switch(node.index()){
        case 1:
            writer.writeNumeric<CByteTag>(std::get<CByteTag>(node));
            break;
        case 2:
            writer.writeNumeric<CShortTag>(std::get<CShortTag>(node));
            break;
        case 3:
            writer.writeNumeric<CIntTag>(std::get<CIntTag>(node));
            break;
        case 4:
            writer.writeNumeric<CLongTag>(std::get<CLongTag>(node));
            break;
        case 5:
            writer.writeNumeric<CFloatTag>(std::get<CFloatTag>(node));
            break;
        case 6:
            writer.writeNumeric<CDoubleTag>(std::get<CDoubleTag>(node));
            break;
        case 8:
            write_string_tag(writer, std::get<CStringTag>(node));
            break;
        case 9:
            write_list_tag(writer, std::get<CListTagPtr>(node));
            break;
        case 10:
            write_compound_tag(writer, std::get<CCompoundTagPtr>(node));
            break;
        case 7:
            write_array_tag<CByteTag>(writer, std::get<CByteArrayTagPtr>(node));
            break;
        case 11:
            write_array_tag<CIntTag>(writer, std::get<CIntArrayTagPtr>(node));
            break;
        case 12:
            write_array_tag<CLongTag>(writer, std::get<CLongArrayTagPtr>(node));
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
}


void write_named_tag(BinaryWriter& writer, const std::string& name, const TagNode& node){
    writer.writeNumeric<std::uint8_t>(node.index());
    write_string_tag(writer, name);
    write_tag(writer, node);
}


std::string write_named_tag(const std::string& name, const TagNode& node, std::endian endianness){
    BinaryWriter writer(endianness);
    write_named_tag(writer, name, node);
    return writer.getBuffer();
}
