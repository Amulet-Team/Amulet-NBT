#include <string>
#include <bit>
#include <variant>
#include <stdexcept>
#include <type_traits>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>

#include <amulet_nbt/io/binary_writer.hpp>

// I wanted to use templates to reduce code duplication but I can't get this to work
// The template version compiled and passed all tests on my computer but it just wasn't working on the remote servers


template <typename T>
void write_numeric_payload(Amulet::BinaryWriter& writer, const T& value){
    writer.writeNumeric<T>(value);
};

void write_string_payload(Amulet::BinaryWriter& writer, const Amulet::StringTag& value){
    std::string encoded_string = writer.encodeString(value);
    if (encoded_string.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())){
        throw std::overflow_error("String of length " + std::to_string(encoded_string.size()) + " is too long.");
    }
    std::uint16_t length = static_cast<std::uint16_t>(encoded_string.size());
    writer.writeNumeric<std::uint16_t>(length);
    writer.writeString(encoded_string);
}


template <typename T>
void write_array_payload(Amulet::BinaryWriter& writer, const std::shared_ptr<Amulet::ArrayTag<T>> value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value->size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: *value){
        writer.writeNumeric<T>(element);
    }
}


void write_list_payload(Amulet::BinaryWriter& writer, const Amulet::ListTagPtr& value);
void write_compound_payload(Amulet::BinaryWriter& writer, const Amulet::CompoundTagPtr& value);


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, Amulet::ByteTag> ||
        std::is_same_v<T, Amulet::ShortTag> ||
        std::is_same_v<T, Amulet::IntTag> ||
        std::is_same_v<T, Amulet::LongTag> ||
        std::is_same_v<T, Amulet::FloatTag> ||
        std::is_same_v<T, Amulet::DoubleTag> ||
        std::is_same_v<T, Amulet::ByteArrayTagPtr> ||
        std::is_same_v<T, Amulet::StringTag> ||
        std::is_same_v<T, Amulet::ListTagPtr> ||
        std::is_same_v<T, Amulet::CompoundTagPtr> ||
        std::is_same_v<T, Amulet::IntArrayTagPtr> ||
        std::is_same_v<T, Amulet::LongArrayTagPtr>,
        bool
    > = true
>
void write_list_tag_payload(Amulet::BinaryWriter& writer, const Amulet::ListTagPtr& value){
    const std::vector<T>& list = std::get<std::vector<T>>(*value);
    if (list.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("List of length " + std::to_string(list.size()) + " is too long.");
    }
    writer.writeNumeric<std::uint8_t>(variant_index<Amulet::TagNode, T>());
    std::int32_t length = static_cast<std::int32_t>(list.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: list){
        if constexpr (std::is_same_v<T, Amulet::ByteTag>){write_numeric_payload<Amulet::ByteTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::ShortTag>){write_numeric_payload<Amulet::ShortTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::IntTag>){write_numeric_payload<Amulet::IntTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::LongTag>){write_numeric_payload<Amulet::LongTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::FloatTag>){write_numeric_payload<Amulet::FloatTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::DoubleTag>){write_numeric_payload<Amulet::DoubleTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::ByteArrayTagPtr>){write_array_payload<Amulet::ByteTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::StringTag>){write_string_payload(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::ListTagPtr>){write_list_payload(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::CompoundTagPtr>){write_compound_payload(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::IntArrayTagPtr>){write_array_payload<Amulet::IntTag>(writer, element);} else
        if constexpr (std::is_same_v<T, Amulet::LongArrayTagPtr>){write_array_payload<Amulet::LongTag>(writer, element);}
    }
}


void write_list_payload(Amulet::BinaryWriter& writer, const Amulet::ListTagPtr& value){
    switch (value->index()){
        case 0:
            writer.writeNumeric<std::uint8_t>(0);
            writer.writeNumeric<std::int32_t>(0);
            break;
        case 1: write_list_tag_payload<Amulet::ByteTag>(writer, value); break;
        case 2: write_list_tag_payload<Amulet::ShortTag>(writer, value); break;
        case 3: write_list_tag_payload<Amulet::IntTag>(writer, value); break;
        case 4: write_list_tag_payload<Amulet::LongTag>(writer, value); break;
        case 5: write_list_tag_payload<Amulet::FloatTag>(writer, value); break;
        case 6: write_list_tag_payload<Amulet::DoubleTag>(writer, value); break;
        case 7: write_list_tag_payload<Amulet::ByteArrayTagPtr>(writer, value); break;
        case 8: write_list_tag_payload<Amulet::StringTag>(writer, value); break;
        case 9: write_list_tag_payload<Amulet::ListTagPtr>(writer, value); break;
        case 10: write_list_tag_payload<Amulet::CompoundTagPtr>(writer, value); break;
        case 11: write_list_tag_payload<Amulet::IntArrayTagPtr>(writer, value); break;
        case 12: write_list_tag_payload<Amulet::LongArrayTagPtr>(writer, value); break;
    }
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, Amulet::ByteTag> ||
        std::is_same_v<T, Amulet::ShortTag> ||
        std::is_same_v<T, Amulet::IntTag> ||
        std::is_same_v<T, Amulet::LongTag> ||
        std::is_same_v<T, Amulet::FloatTag> ||
        std::is_same_v<T, Amulet::DoubleTag> ||
        std::is_same_v<T, Amulet::ByteArrayTagPtr> ||
        std::is_same_v<T, Amulet::StringTag> ||
        std::is_same_v<T, Amulet::ListTagPtr> ||
        std::is_same_v<T, Amulet::CompoundTagPtr> ||
        std::is_same_v<T, Amulet::IntArrayTagPtr> ||
        std::is_same_v<T, Amulet::LongArrayTagPtr>,
        bool
    > = true
>
void write_name_and_tag(Amulet::BinaryWriter& writer, const std::string& name, const T& tag){
    writer.writeNumeric<std::uint8_t>(variant_index<Amulet::TagNode, T>());
    write_string_payload(writer, name);
    if constexpr (std::is_same_v<T, Amulet::ByteTag>){write_numeric_payload<Amulet::ByteTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::ShortTag>){write_numeric_payload<Amulet::ShortTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::IntTag>){write_numeric_payload<Amulet::IntTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::LongTag>){write_numeric_payload<Amulet::LongTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::FloatTag>){write_numeric_payload<Amulet::FloatTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::DoubleTag>){write_numeric_payload<Amulet::DoubleTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::ByteArrayTagPtr>){write_array_payload<Amulet::ByteTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::StringTag>){write_string_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::ListTagPtr>){write_list_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::CompoundTagPtr>){write_compound_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::IntArrayTagPtr>){write_array_payload<Amulet::IntTag>(writer, tag);} else
    if constexpr (std::is_same_v<T, Amulet::LongArrayTagPtr>){write_array_payload<Amulet::LongTag>(writer, tag);}
}


template <
    typename T,
    std::enable_if_t<std::is_same_v<T, Amulet::TagNode>, bool> = true
>
void write_name_and_tag(Amulet::BinaryWriter& writer, const std::string& name, const Amulet::TagNode& node){
    switch (node.index()){
        case 1: write_name_and_tag<Amulet::ByteTag>(writer, name, std::get<Amulet::ByteTag>(node)); break;
        case 2: write_name_and_tag<Amulet::ShortTag>(writer, name, std::get<Amulet::ShortTag>(node)); break;
        case 3: write_name_and_tag<Amulet::IntTag>(writer, name, std::get<Amulet::IntTag>(node)); break;
        case 4: write_name_and_tag<Amulet::LongTag>(writer, name, std::get<Amulet::LongTag>(node)); break;
        case 5: write_name_and_tag<Amulet::FloatTag>(writer, name, std::get<Amulet::FloatTag>(node)); break;
        case 6: write_name_and_tag<Amulet::DoubleTag>(writer, name, std::get<Amulet::DoubleTag>(node)); break;
        case 7: write_name_and_tag<Amulet::ByteArrayTagPtr>(writer, name, std::get<Amulet::ByteArrayTagPtr>(node)); break;
        case 8: write_name_and_tag<Amulet::StringTag>(writer, name, std::get<Amulet::StringTag>(node)); break;
        case 9: write_name_and_tag<Amulet::ListTagPtr>(writer, name, std::get<Amulet::ListTagPtr>(node)); break;
        case 10: write_name_and_tag<Amulet::CompoundTagPtr>(writer, name, std::get<Amulet::CompoundTagPtr>(node)); break;
        case 11: write_name_and_tag<Amulet::IntArrayTagPtr>(writer, name, std::get<Amulet::IntArrayTagPtr>(node)); break;
        case 12: write_name_and_tag<Amulet::LongArrayTagPtr>(writer, name, std::get<Amulet::LongArrayTagPtr>(node)); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}


void write_compound_payload(Amulet::BinaryWriter& writer, const Amulet::CompoundTagPtr& value){
    for (auto it = value->begin(); it != value->end(); it++){
        write_name_and_tag<Amulet::TagNode>(writer, it->first, it->second);
    }
    writer.writeNumeric<std::uint8_t>(0);
};


template <typename T>
    std::string _write_nbt(const std::string& name, const T& tag, std::endian endianness, Amulet::StringEncode string_encode){
        Amulet::BinaryWriter writer(endianness, string_encode);
        write_name_and_tag<T>(writer, name, tag);
        return writer.getBuffer();
    }

namespace Amulet {
    std::string write_nbt(const std::string& name, const Amulet::ByteTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::ShortTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::IntTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::LongTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::FloatTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::DoubleTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::ByteArrayTagPtr& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::StringTag& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::ListTagPtr& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::CompoundTagPtr& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::IntArrayTagPtr& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::LongArrayTagPtr& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const Amulet::TagNode& tag, std::endian endianness, Amulet::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const Amulet::NamedTag& named_tag, std::endian endianness, Amulet::StringEncode string_encode){
        return write_nbt(named_tag.name, named_tag.tag_node, endianness, string_encode);
    }
}
