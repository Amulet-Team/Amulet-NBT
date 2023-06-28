#include "read.hpp"

void validate_stream(std::istream, stream){
    if (!stream){
        throw std::runtime_error("Error reading from the input stream.");
    }
}

template <typename T>
T read_number(std::istream stream, std::endian endianness){
    T tag;
    stream.read(reinterpret_cast<char*>(&tag), sizeof(tag));
    validate_stream(stream);
    swap_to_endian(tag, endianness);
    return tag;
}

ByteTag read_byte_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

ShortTag read_short_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

IntTag read_int_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

LongTag read_long_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

FloatTag read_float_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

DoubleTag read_double_tag(std::istream stream, std::endian endianness){
    return read_number(stream, endianness);
};

StringTag read_string_tag(std::istream stream, std::endian endianness){
    std::uint16_t length;
    stream.read(reinterpret_cast<char*>(&length), sizeof(length));
    validate_stream(stream);
    swap_to_endian(length, endianness);
    StringTag tag;
    tag.reserve(length);
    stream.read(reinterpret_cast<char*>(&tag[0]), length);
    validate_stream(stream);
    return tag;
};

ListTagPtr read_list_tag(std::istream stream, std::endian endianness){
    std::uint8_t tag_type;
    stream.read(reinterpret_cast<char*>(&tag_type), sizeof(tag_type));
    validate_stream(stream);

    std::int32_t length;
    stream.read(reinterpret_cast<char*>(&length), sizeof(length));
    validate_stream(stream);
    swap_to_endian(length, endianness);

    ListTagPtr tag;
    switch(tag_type){
        case 1:
            tag = std::make_shared<ListTag>(std::vector<ByteTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_byte_tag(stream, endianness);
            }
            break;
        case 2:
            tag = std::make_shared<ListTag>(std::vector<ShortTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_short_tag(stream, endianness);
            }
            break;
        case 3:
            tag = std::make_shared<ListTag>(std::vector<IntTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_int_tag(stream, endianness);
            }
            break;
        case 4:
            tag = std::make_shared<ListTag>(std::vector<LongTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_long_tag(stream, endianness);
            }
            break;
        case 5:
            tag = std::make_shared<ListTag>(std::vector<FloatTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_float_tag(stream, endianness);
            }
            break;
        case 6:
            tag = std::make_shared<ListTag>(std::vector<DoubleTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_double_tag(stream, endianness);
            }
            break;
        case 8:
            tag = std::make_shared<ListTag>(std::vector<StringTag>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_string_tag(stream, endianness);
            }
            break;
        case 9:
            tag = std::make_shared<ListTag>(std::vector<ListTagPtr>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_list_tag(stream, endianness);
            }
            break;
        case 10:
            tag = std::make_shared<ListTag>(std::vector<CompoundTagPtr>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_compound_tag(stream, endianness);
            }
            break;
        case 7:
            tag = std::make_shared<ListTag>(std::vector<ByteArrayTagPtr>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_byte_array_tag(stream, endianness);
            }
            break;
        case 11:
            tag = std::make_shared<ListTag>(std::vector<IntArrayTagPtr>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_int_array_tag(stream, endianness);
            }
            break;
        case 12:
            tag = std::make_shared<ListTag>(std::vector<LongArrayTagPtr>(length));
            for (std::int32_t i = 0; i < length; i++){
                (*tag)[i] = read_long_array_tag(stream, endianness);
            }
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
    return tag;
};

CompoundTagPtr read_compound_tag(std::istream stream, std::endian endianness){
    CompoundTagPtr tag = std::make_shared<CompoundTag>();
    std::uint8_t tag_type;
    do {
        stream.read(reinterpret_cast<char*>(&tag_type), sizeof(tag_type));
        validate_stream(stream);
        StringTag name = read_string_tag(stream, endianness);
        TagNode node = read_node(stream, endianness, tag_type);
        tag[name] = node;
    } while (tag_type);
    return tag;
};

template <typename T>
std::shared_ptr<Array<T>> read_array(std::istream stream, std::endian endianness){
    std::int32_t length;
    stream.read(reinterpret_cast<char*>(&length), sizeof(length));
    validate_stream(stream);
    swap_to_endian(length, endianness);

    std::shared_ptr<Array<T>> tag = std::make_shared<Array<T>>(length);
    if (length){
        stream.read(reinterpret_cast<char*>(tag->data()), sizeof(T) * length);
        validate_stream(stream);
        swap_array_to_endian(tag, endianness);
    }
    return tag;
}

ByteArrayTagPtr read_byte_array_tag(std::istream stream, std::endian endianness){
    return read_array<ByteTag>(stream, endianness);
};

IntArrayTagPtr read_int_array_tag(std::istream stream, std::endian endianness){
    return read_array<IntTag>(stream, endianness);
};

LongArrayTagPtr read_long_array_tag(std::istream stream, std::endian endianness){
    return read_array<LongTag>(stream, endianness);
};

TagNode read_node(std::istream stream, std::endian endianness, std::uint8_t tag_type){
    TagNode node;
    switch(tag_type){
        case 1:
            node = read_byte_tag(stream, endianness);
            break;
        case 2:
            node = read_short_tag(stream, endianness);
            break;
        case 3:
            node = read_int_tag(stream, endianness);
            break;
        case 4:
            node = read_long_tag(stream, endianness);
            break;
        case 5:
            node = read_float_tag(stream, endianness);
            break;
        case 6:
            node = read_double_tag(stream, endianness);
            break;
        case 8:
            node = read_string_tag(stream, endianness);
            break;
        case 9:
            node = read_list_tag(stream, endianness);
            break;
        case 10:
            node = read_compound_tag(stream, endianness);
            break;
        case 7:
            node = read_byte_array_tag(stream, endianness);
            break;
        case 11:
            node = read_int_array_tag(stream, endianness);
            break;
        case 12:
            node = read_long_array_tag(stream, endianness);
            break;
        default:
            throw std::runtime_error("Unsupported tag type");
    }
    return node;
};

// Read a type byte followed by a name followed by a payload of that type
std::pair<std::string, TagNode> read_named_tag(std::istream stream, std::endian endianness){
    std::uint8_t tag_type;
    stream.read(reinterpret_cast<char*>(&tag_type), sizeof(tag_type));
    validate_stream(stream);

    StringTag name = read_string_tag(stream, endianness);
    TagNode node = read_node(stream, endianness, tag_type);
    return std::make_pair(name, node);
};
