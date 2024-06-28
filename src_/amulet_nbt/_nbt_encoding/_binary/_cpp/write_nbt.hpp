#pragma once

#include <string>
#include <bit>
#include <variant>
#include <stdexcept>
#include <type_traits>

#include "_binary/writer.hpp"
#include "../../../_tag/_cpp/nbt.hpp"
#include "../../../_tag/_cpp/array.hpp"

// I wanted to use templates to reduce code duplication but I can't get this to work
// The template version compiled and passed all tests on my computer but it just wasn't working on the remote servers


void write_byte_payload(BinaryWriter& writer, const CByteTag& value);
void write_short_payload(BinaryWriter& writer, const CShortTag& value);
void write_int_payload(BinaryWriter& writer, const CIntTag& value);
void write_long_payload(BinaryWriter& writer, const CLongTag& value);
void write_float_payload(BinaryWriter& writer, const CFloatTag& value);
void write_double_payload(BinaryWriter& writer, const CDoubleTag& value);
void write_byte_array_payload(BinaryWriter& writer, const CByteArrayTagPtr& value);
void write_string_payload(BinaryWriter& writer, const CStringTag& value);
void write_list_payload(BinaryWriter& writer, const CListTagPtr& value);
void write_compound_payload(BinaryWriter& writer, const CCompoundTagPtr& value);
void write_int_array_payload(BinaryWriter& writer, const CIntArrayTagPtr& value);
void write_long_array_payload(BinaryWriter& writer, const CLongArrayTagPtr& value);


template<typename V, typename T, size_t I = 0>
constexpr size_t variant_index() {
    static_assert(I < std::variant_size_v<V>, "Type T is not a member of variant V");
    if constexpr (std::is_same_v<std::variant_alternative_t<I, V>, T>) {
        return (I);
    } else {
        return (variant_index<V, T, I + 1>());
    }
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, CByteTag> ||
        std::is_same_v<T, CShortTag> ||
        std::is_same_v<T, CIntTag> ||
        std::is_same_v<T, CLongTag> ||
        std::is_same_v<T, CFloatTag> ||
        std::is_same_v<T, CDoubleTag> ||
        std::is_same_v<T, CByteArrayTagPtr> ||
        std::is_same_v<T, CStringTag> ||
        std::is_same_v<T, CListTagPtr> ||
        std::is_same_v<T, CCompoundTagPtr> ||
        std::is_same_v<T, CIntArrayTagPtr> ||
        std::is_same_v<T, CLongArrayTagPtr>,
        bool
    > = true
>
void write_named_tag(BinaryWriter& writer, const std::string& name, const T& tag){
    writer.writeNumeric<std::uint8_t>(variant_index<TagNode, T>());
    write_string_payload(writer, name);
    if constexpr (std::is_same_v<T, CByteTag>){write_byte_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CShortTag>){write_short_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CIntTag>){write_int_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CLongTag>){write_long_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CFloatTag>){write_float_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CDoubleTag>){write_double_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CByteArrayTagPtr>){write_byte_array_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CStringTag>){write_string_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CListTagPtr>){write_list_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CCompoundTagPtr>){write_compound_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CIntArrayTagPtr>){write_int_array_payload(writer, tag);} else
    if constexpr (std::is_same_v<T, CLongArrayTagPtr>){write_long_array_payload(writer, tag);}
}


template <
    typename T,
    std::enable_if_t<std::is_same_v<T, TagNode>, bool> = true
>
void write_named_tag(BinaryWriter& writer, const std::string& name, const TagNode& node){
    switch (node.index()){
        case 1: write_named_tag<CByteTag>(writer, name, std::get<CByteTag>(node)); break;
        case 2: write_named_tag<CShortTag>(writer, name, std::get<CShortTag>(node)); break;
        case 3: write_named_tag<CIntTag>(writer, name, std::get<CIntTag>(node)); break;
        case 4: write_named_tag<CLongTag>(writer, name, std::get<CLongTag>(node)); break;
        case 5: write_named_tag<CFloatTag>(writer, name, std::get<CFloatTag>(node)); break;
        case 6: write_named_tag<CDoubleTag>(writer, name, std::get<CDoubleTag>(node)); break;
        case 7: write_named_tag<CByteArrayTagPtr>(writer, name, std::get<CByteArrayTagPtr>(node)); break;
        case 8: write_named_tag<CStringTag>(writer, name, std::get<CStringTag>(node)); break;
        case 9: write_named_tag<CListTagPtr>(writer, name, std::get<CListTagPtr>(node)); break;
        case 10: write_named_tag<CCompoundTagPtr>(writer, name, std::get<CCompoundTagPtr>(node)); break;
        case 11: write_named_tag<CIntArrayTagPtr>(writer, name, std::get<CIntArrayTagPtr>(node)); break;
        case 12: write_named_tag<CLongArrayTagPtr>(writer, name, std::get<CLongArrayTagPtr>(node)); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, TagNode> ||
        std::is_same_v<T, CByteTag> ||
        std::is_same_v<T, CShortTag> ||
        std::is_same_v<T, CIntTag> ||
        std::is_same_v<T, CLongTag> ||
        std::is_same_v<T, CFloatTag> ||
        std::is_same_v<T, CDoubleTag> ||
        std::is_same_v<T, CByteArrayTagPtr> ||
        std::is_same_v<T, CStringTag> ||
        std::is_same_v<T, CListTagPtr> ||
        std::is_same_v<T, CCompoundTagPtr> ||
        std::is_same_v<T, CIntArrayTagPtr> ||
        std::is_same_v<T, CLongArrayTagPtr>,
        bool
    > = true
>
std::string write_named_tag(const std::string& name, const T& tag, std::endian endianness, StringEncode stringEncode){
    BinaryWriter writer(endianness, stringEncode);
    write_named_tag<T>(writer, name, tag);
    return writer.getBuffer();
}


void write_byte_payload(BinaryWriter& writer, const CByteTag& value){
    writer.writeNumeric<CByteTag>(value);
}

void write_short_payload(BinaryWriter& writer, const CShortTag& value){
    writer.writeNumeric<CShortTag>(value);
}

void write_int_payload(BinaryWriter& writer, const CIntTag& value){
    writer.writeNumeric<CIntTag>(value);
}

void write_long_payload(BinaryWriter& writer, const CLongTag& value){
    writer.writeNumeric<CLongTag>(value);
}

void write_float_payload(BinaryWriter& writer, const CFloatTag& value){
    writer.writeNumeric<CFloatTag>(value);
}

void write_double_payload(BinaryWriter& writer, const CDoubleTag& value){
    writer.writeNumeric<CDoubleTag>(value);
}

void write_string_payload(BinaryWriter& writer, const CStringTag& value){
    std::string encoded_string = writer.encodeString(value);
    if (encoded_string.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())){
        throw std::overflow_error("String of length " + std::to_string(encoded_string.size()) + " is too long.");
    }
    std::uint16_t length = static_cast<std::uint16_t>(encoded_string.size());
    writer.writeNumeric<std::uint16_t>(length);
    writer.writeString(encoded_string);
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, CByteTag> ||
        std::is_same_v<T, CShortTag> ||
        std::is_same_v<T, CIntTag> ||
        std::is_same_v<T, CLongTag> ||
        std::is_same_v<T, CFloatTag> ||
        std::is_same_v<T, CDoubleTag> ||
        std::is_same_v<T, CByteArrayTagPtr> ||
        std::is_same_v<T, CStringTag> ||
        std::is_same_v<T, CListTagPtr> ||
        std::is_same_v<T, CCompoundTagPtr> ||
        std::is_same_v<T, CIntArrayTagPtr> ||
        std::is_same_v<T, CLongArrayTagPtr>,
        bool
    > = true
>
void write_list_tag_payload(BinaryWriter& writer, const CListTagPtr& value){
    const std::vector<T>& list = std::get<std::vector<T>>(*value);
    if (list.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("List of length " + std::to_string(list.size()) + " is too long.");
    }
    writer.writeNumeric<std::uint8_t>(variant_index<TagNode, T>());
    std::int32_t length = static_cast<std::int32_t>(list.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const T& element: list){
        if constexpr (std::is_same_v<T, CByteTag>){write_byte_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CShortTag>){write_short_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CIntTag>){write_int_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CLongTag>){write_long_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CFloatTag>){write_float_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CDoubleTag>){write_double_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CByteArrayTagPtr>){write_byte_array_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CStringTag>){write_string_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CListTagPtr>){write_list_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CCompoundTagPtr>){write_compound_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CIntArrayTagPtr>){write_int_array_payload(writer, element);} else
        if constexpr (std::is_same_v<T, CLongArrayTagPtr>){write_long_array_payload(writer, element);}
    }
}


void write_list_payload(BinaryWriter& writer, const CListTagPtr& value){
    switch (value->index()){
        case 0:
            writer.writeNumeric<std::uint8_t>(0);
            writer.writeNumeric<std::int32_t>(0);
            break;
        case 1: write_list_tag_payload<CByteTag>(writer, value); break;
        case 2: write_list_tag_payload<CShortTag>(writer, value); break;
        case 3: write_list_tag_payload<CIntTag>(writer, value); break;
        case 4: write_list_tag_payload<CLongTag>(writer, value); break;
        case 5: write_list_tag_payload<CFloatTag>(writer, value); break;
        case 6: write_list_tag_payload<CDoubleTag>(writer, value); break;
        case 7: write_list_tag_payload<CByteArrayTagPtr>(writer, value); break;
        case 8: write_list_tag_payload<CStringTag>(writer, value); break;
        case 9: write_list_tag_payload<CListTagPtr>(writer, value); break;
        case 10: write_list_tag_payload<CCompoundTagPtr>(writer, value); break;
        case 11: write_list_tag_payload<CIntArrayTagPtr>(writer, value); break;
        case 12: write_list_tag_payload<CLongArrayTagPtr>(writer, value); break;
    }
}


void write_compound_payload(BinaryWriter& writer, const CCompoundTagPtr& value){
    for (auto it = value->begin(); it != value->end(); it++){
        write_named_tag<TagNode>(writer, it->first, it->second);
    }
    writer.writeNumeric<std::uint8_t>(0);
};


void write_byte_array_payload(BinaryWriter& writer, const CByteArrayTagPtr& value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value->size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const CByteTag& element: *value){
        writer.writeNumeric<CByteTag>(element);
    }
}

void write_int_array_payload(BinaryWriter& writer, const CIntArrayTagPtr& value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value->size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const CIntTag& element: *value){
        writer.writeNumeric<CIntTag>(element);
    }
}

void write_long_array_payload(BinaryWriter& writer, const CLongArrayTagPtr& value){
    if (value->size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value->size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value->size());
    writer.writeNumeric<std::int32_t>(length);
    for (const CLongTag& element: *value){
        writer.writeNumeric<CLongTag>(element);
    }
}
