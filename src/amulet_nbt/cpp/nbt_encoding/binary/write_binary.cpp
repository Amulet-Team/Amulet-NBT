#include <string>
#include <bit>
#include <variant>
#include <stdexcept>
#include <type_traits>
#include <limits>
#include <cstdint>
#include <memory>
#include <vector>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>

#include <amulet_nbt/io/binary_writer.hpp>

// I wanted to use templates to reduce code duplication but I can't get this to work
// The template version compiled and passed all tests on my computer but it just wasn't working on the remote servers


template <typename T>
void write_numeric_payload(AmuletNBT::BinaryWriter& writer, const T& value){
    writer.writeNumeric<T>(value);
};

void write_string_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::StringTag& value){
    std::string encoded_string = writer.encodeString(value);
    if (encoded_string.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())){
        throw std::overflow_error("String of length " + std::to_string(encoded_string.size()) + " is too long.");
    }
    std::uint16_t length = static_cast<std::uint16_t>(encoded_string.size());
    writer.writeNumeric<std::uint16_t>(length);
    writer.writeString(encoded_string);
}


template <typename T>
void write_array_payload(AmuletNBT::BinaryWriter& writer, const std::shared_ptr<AmuletNBT::ArrayTag<T>> value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value->size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: *value){
        writer.writeNumeric<T>(element);
    }
}


void write_list_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::ListTagPtr& value);
void write_compound_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::CompoundTagPtr& value);


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::StringTag> ||
        std::is_same_v<T, AmuletNBT::ListTagPtr> ||
        std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
        std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
        bool
    > = true
>
void write_list_tag_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::ListTagPtr& value){
    const std::vector<T>& list = std::get<std::vector<T>>(*value);
    if (list.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("List of length " + std::to_string(list.size()) + " is too long.");
    }
    writer.writeNumeric<std::uint8_t>(variant_index<AmuletNBT::TagNode, T>());
    std::int32_t length = static_cast<std::int32_t>(list.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: list){
        if constexpr (std::is_same_v<T, AmuletNBT::ByteTag>){write_numeric_payload<AmuletNBT::ByteTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::ShortTag>){write_numeric_payload<AmuletNBT::ShortTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::IntTag>){write_numeric_payload<AmuletNBT::IntTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::LongTag>){write_numeric_payload<AmuletNBT::LongTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::FloatTag>){write_numeric_payload<AmuletNBT::FloatTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::DoubleTag>){write_numeric_payload<AmuletNBT::DoubleTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::ByteArrayTagPtr>){write_array_payload<AmuletNBT::ByteTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::StringTag>){write_string_payload(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::ListTagPtr>){write_list_payload(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::CompoundTagPtr>){write_compound_payload(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::IntArrayTagPtr>){write_array_payload<AmuletNBT::IntTag>(writer, element);} else
        if constexpr (std::is_same_v<T, AmuletNBT::LongArrayTagPtr>){write_array_payload<AmuletNBT::LongTag>(writer, element);}
    }
}


void write_list_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::ListTagPtr& value){
    switch (value->index()){
        case 0:
            writer.writeNumeric<std::uint8_t>(0);
            writer.writeNumeric<std::int32_t>(0);
            break;
        case 1: write_list_tag_payload<AmuletNBT::ByteTag>(writer, value); break;
        case 2: write_list_tag_payload<AmuletNBT::ShortTag>(writer, value); break;
        case 3: write_list_tag_payload<AmuletNBT::IntTag>(writer, value); break;
        case 4: write_list_tag_payload<AmuletNBT::LongTag>(writer, value); break;
        case 5: write_list_tag_payload<AmuletNBT::FloatTag>(writer, value); break;
        case 6: write_list_tag_payload<AmuletNBT::DoubleTag>(writer, value); break;
        case 7: write_list_tag_payload<AmuletNBT::ByteArrayTagPtr>(writer, value); break;
        case 8: write_list_tag_payload<AmuletNBT::StringTag>(writer, value); break;
        case 9: write_list_tag_payload<AmuletNBT::ListTagPtr>(writer, value); break;
        case 10: write_list_tag_payload<AmuletNBT::CompoundTagPtr>(writer, value); break;
        case 11: write_list_tag_payload<AmuletNBT::IntArrayTagPtr>(writer, value); break;
        case 12: write_list_tag_payload<AmuletNBT::LongArrayTagPtr>(writer, value); break;
    }
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::StringTag> ||
        std::is_same_v<T, AmuletNBT::ListTagPtr> ||
        std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
        std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
        bool
    > = true
>
void write_name_and_tag(AmuletNBT::BinaryWriter& writer, const std::string& name, const T& tag){
    writer.writeNumeric<std::uint8_t>(variant_index<AmuletNBT::TagNode, T>());
    write_string_payload(writer, name);
    if constexpr (std::is_same_v<T, AmuletNBT::ByteTag>){write_numeric_payload<AmuletNBT::ByteTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::ShortTag>){write_numeric_payload<AmuletNBT::ShortTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::IntTag>){write_numeric_payload<AmuletNBT::IntTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::LongTag>){write_numeric_payload<AmuletNBT::LongTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::FloatTag>){write_numeric_payload<AmuletNBT::FloatTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::DoubleTag>){write_numeric_payload<AmuletNBT::DoubleTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::ByteArrayTagPtr>){write_array_payload<AmuletNBT::ByteTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::StringTag>){write_string_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::ListTagPtr>){write_list_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::CompoundTagPtr>){write_compound_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::IntArrayTagPtr>){write_array_payload<AmuletNBT::IntTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, AmuletNBT::LongArrayTagPtr>){write_array_payload<AmuletNBT::LongTag>(writer, tag);}
}


template <
    typename T,
    std::enable_if_t<std::is_same_v<T, AmuletNBT::TagNode>, bool> = true
>
void write_name_and_tag(AmuletNBT::BinaryWriter& writer, const std::string& name, const AmuletNBT::TagNode& node){
    switch (node.index()){
        case 1: write_name_and_tag<AmuletNBT::ByteTag>(writer, name, std::get<AmuletNBT::ByteTag>(node)); break;
        case 2: write_name_and_tag<AmuletNBT::ShortTag>(writer, name, std::get<AmuletNBT::ShortTag>(node)); break;
        case 3: write_name_and_tag<AmuletNBT::IntTag>(writer, name, std::get<AmuletNBT::IntTag>(node)); break;
        case 4: write_name_and_tag<AmuletNBT::LongTag>(writer, name, std::get<AmuletNBT::LongTag>(node)); break;
        case 5: write_name_and_tag<AmuletNBT::FloatTag>(writer, name, std::get<AmuletNBT::FloatTag>(node)); break;
        case 6: write_name_and_tag<AmuletNBT::DoubleTag>(writer, name, std::get<AmuletNBT::DoubleTag>(node)); break;
        case 7: write_name_and_tag<AmuletNBT::ByteArrayTagPtr>(writer, name, std::get<AmuletNBT::ByteArrayTagPtr>(node)); break;
        case 8: write_name_and_tag<AmuletNBT::StringTag>(writer, name, std::get<AmuletNBT::StringTag>(node)); break;
        case 9: write_name_and_tag<AmuletNBT::ListTagPtr>(writer, name, std::get<AmuletNBT::ListTagPtr>(node)); break;
        case 10: write_name_and_tag<AmuletNBT::CompoundTagPtr>(writer, name, std::get<AmuletNBT::CompoundTagPtr>(node)); break;
        case 11: write_name_and_tag<AmuletNBT::IntArrayTagPtr>(writer, name, std::get<AmuletNBT::IntArrayTagPtr>(node)); break;
        case 12: write_name_and_tag<AmuletNBT::LongArrayTagPtr>(writer, name, std::get<AmuletNBT::LongArrayTagPtr>(node)); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}


void write_compound_payload(AmuletNBT::BinaryWriter& writer, const AmuletNBT::CompoundTagPtr& value){
    for (auto it = value->begin(); it != value->end(); it++){
        write_name_and_tag<AmuletNBT::TagNode>(writer, it->first, it->second);
    }
    writer.writeNumeric<std::uint8_t>(0);
};


template <typename T>
    std::string _write_nbt(const std::string& name, const T& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        AmuletNBT::BinaryWriter writer(endianness, string_encode);
        write_name_and_tag<T>(writer, name, tag);
        return writer.getBuffer();
    }

namespace AmuletNBT {
    std::string write_nbt(const std::string& name, const AmuletNBT::ByteTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ShortTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::IntTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::LongTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::FloatTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::DoubleTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ByteArrayTagPtr& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::StringTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ListTagPtr& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::CompoundTagPtr& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::IntArrayTagPtr& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::LongArrayTagPtr& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::TagNode& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const AmuletNBT::NamedTag& named_tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return write_nbt(named_tag.name, named_tag.tag_node, endianness, string_encode);
    }
}
