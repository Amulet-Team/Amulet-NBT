#pragma once

#include <variant>
#include <type_traits>
#include <cmath>
#include <limits>
#include <algorithm>
#include <string>
#include <locale>
#include <sstream>
#include <iomanip>
#include <stdexcept>

#include "../../../_string_encoding/_cpp/utf8.hpp"
#include "../../../_tag/_cpp/nbt.hpp"
#include "../../../_tag/_cpp/array.hpp"

// I wanted to use templates to reduce code duplication but I can't get this to work
// The template version compiled and passed all tests on my computer but it just wasn't working on the remote servers


inline void write_indent(std::string& snbt, const std::string& indent, size_t indent_count){
    for (size_t i = 0; i < indent_count; i++){
        snbt.append(indent);
    }
}

// Forward declarations
void write_byte_snbt(std::string& snbt, const CByteTag& tag);
void write_short_snbt(std::string& snbt, const CShortTag& tag);
void write_int_snbt(std::string& snbt, const CIntTag& tag);
void write_long_snbt(std::string& snbt, const CLongTag& tag);
void write_float_snbt(std::string& snbt, const CFloatTag& tag);
void write_double_snbt(std::string& snbt, const CDoubleTag& tag);
void write_byte_array_snbt(std::string& snbt, const CByteArrayTagPtr& tag);
void write_string_snbt(std::string& snbt, const CStringTag& tag);
void write_list_snbt(std::string& snbt, const CListTagPtr& tag);
void write_compound_snbt(std::string& snbt, const CCompoundTagPtr& tag);
void write_int_array_snbt(std::string& snbt, const CIntArrayTagPtr& tag);
void write_long_array_snbt(std::string& snbt, const CLongArrayTagPtr& tag);

// Multi-line variants
void write_list_snbt(std::string& snbt, const CListTagPtr& tag, const std::string& indent, size_t indent_count);
void write_compound_snbt(std::string& snbt, const CCompoundTagPtr& tag, const std::string& indent, size_t indent_count);


void write_node_snbt(std::string& snbt, const TagNode& tag){
    switch (tag.index()){
        case 1: write_byte_snbt(snbt, std::get<CByteTag>(tag)); break;
        case 2: write_short_snbt(snbt, std::get<CShortTag>(tag)); break;
        case 3: write_int_snbt(snbt, std::get<CIntTag>(tag)); break;
        case 4: write_long_snbt(snbt, std::get<CLongTag>(tag)); break;
        case 5: write_float_snbt(snbt, std::get<CFloatTag>(tag)); break;
        case 6: write_double_snbt(snbt, std::get<CDoubleTag>(tag)); break;
        case 7: write_byte_array_snbt(snbt, std::get<CByteArrayTagPtr>(tag)); break;
        case 8: write_string_snbt(snbt, std::get<CStringTag>(tag)); break;
        case 9: write_list_snbt(snbt, std::get<CListTagPtr>(tag)); break;
        case 10: write_compound_snbt(snbt, std::get<CCompoundTagPtr>(tag)); break;
        case 11: write_int_array_snbt(snbt, std::get<CIntArrayTagPtr>(tag)); break;
        case 12: write_long_array_snbt(snbt, std::get<CLongArrayTagPtr>(tag)); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}


void write_node_snbt(std::string& snbt, const TagNode& tag, const std::string& indent, size_t indent_count){
    switch (tag.index()){
        case 1: write_byte_snbt(snbt, std::get<CByteTag>(tag)); break;
        case 2: write_short_snbt(snbt, std::get<CShortTag>(tag)); break;
        case 3: write_int_snbt(snbt, std::get<CIntTag>(tag)); break;
        case 4: write_long_snbt(snbt, std::get<CLongTag>(tag)); break;
        case 5: write_float_snbt(snbt, std::get<CFloatTag>(tag)); break;
        case 6: write_double_snbt(snbt, std::get<CDoubleTag>(tag)); break;
        case 7: write_byte_array_snbt(snbt, std::get<CByteArrayTagPtr>(tag)); break;
        case 8: write_string_snbt(snbt, std::get<CStringTag>(tag)); break;
        case 9: write_list_snbt(snbt, std::get<CListTagPtr>(tag), indent, indent_count); break;
        case 10: write_compound_snbt(snbt, std::get<CCompoundTagPtr>(tag), indent, indent_count); break;
        case 11: write_int_array_snbt(snbt, std::get<CIntArrayTagPtr>(tag)); break;
        case 12: write_long_array_snbt(snbt, std::get<CLongArrayTagPtr>(tag)); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}


void write_byte_snbt(std::string& snbt, const CByteTag& tag){
    snbt.append(std::to_string(tag));
    snbt.push_back('b');
}

void write_short_snbt(std::string& snbt, const CShortTag& tag){
    snbt.append(std::to_string(tag));
    snbt.push_back('s');
}

void write_int_snbt(std::string& snbt, const CIntTag& tag){
    snbt.append(std::to_string(tag));
}

void write_long_snbt(std::string& snbt, const CLongTag& tag){
    snbt.append(std::to_string(tag));
    snbt.push_back('L');
}

template<typename T>
inline std::string encode_float(const T& num){
    std::ostringstream oss;
    oss << std::setprecision(std::numeric_limits<T>::max_digits10) << std::noshowpoint << num;
    return oss.str();
}

void write_float_snbt(std::string& snbt, const CFloatTag& tag){
    if (std::isfinite(tag)){
        snbt.append(encode_float<CFloatTag>(tag));
        snbt.push_back('f');
    } else if (tag == std::numeric_limits<CFloatTag>::infinity()){
        snbt.append("Infinityf");
    } else if (tag == -std::numeric_limits<CFloatTag>::infinity()){
        snbt.append("-Infinityf");
    } else {
        snbt.append("NaNf");
    }
}

void write_double_snbt(std::string& snbt, const CDoubleTag& tag){
    if (std::isfinite(tag)){
        snbt.append(encode_float<CDoubleTag>(tag));
        snbt.push_back('d');
    } else if (tag == std::numeric_limits<CDoubleTag>::infinity()){
        snbt.append("Infinityd");
    } else if (tag == -std::numeric_limits<CDoubleTag>::infinity()){
        snbt.append("-Infinityd");
    } else {
        snbt.append("NaNd");
    }
}


void write_string_snbt(std::string& snbt, const CStringTag& tag){
    std::string result = tag;

    size_t pos = 0;
    while ((pos = result.find('\\', pos)) != std::string::npos) {
        result.replace(pos, 1, "\\\\");
        pos += 2;
    }

    pos = 0;
    while ((pos = result.find('"', pos)) != std::string::npos) {
        result.replace(pos, 1, "\\\"");
        pos += 2;
    }

    snbt.append("\"");
    snbt.append(result);
    snbt.append("\"");
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
void write_snbt_list(std::string& snbt, const CListTagPtr& tag){
    const std::vector<T>& list = std::get<std::vector<T>>(*tag);
    snbt.append("[");
    for (size_t i = 0; i < list.size(); i++){
        if constexpr (std::is_same_v<T, CByteTag>){write_byte_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CShortTag>){write_short_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CIntTag>){write_int_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CLongTag>){write_long_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CFloatTag>){write_float_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CDoubleTag>){write_double_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CByteArrayTagPtr>){write_byte_array_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CStringTag>){write_string_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CListTagPtr>){write_list_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CCompoundTagPtr>){write_compound_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CIntArrayTagPtr>){write_int_array_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CLongArrayTagPtr>){write_long_array_snbt(snbt, list[i]);}
        if (i + 1 != list.size()){
            snbt.append(", ");
        }
    }
    snbt.append("]");
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
void write_snbt_list(std::string& snbt, const CListTagPtr& tag, const std::string& indent, size_t indent_count){
    const std::vector<T>& list = std::get<std::vector<T>>(*tag);
    snbt.append("[");
    for (size_t i = 0; i < list.size(); i++){
        snbt.append("\n");
        write_indent(snbt, indent, indent_count + 1);
        if constexpr (std::is_same_v<T, CByteTag>){write_byte_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CShortTag>){write_short_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CIntTag>){write_int_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CLongTag>){write_long_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CFloatTag>){write_float_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CDoubleTag>){write_double_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CByteArrayTagPtr>){write_byte_array_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CStringTag>){write_string_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CListTagPtr>){write_list_snbt(snbt, list[i], indent, indent_count + 1);} else
        if constexpr (std::is_same_v<T, CCompoundTagPtr>){write_compound_snbt(snbt, list[i], indent, indent_count + 1);} else
        if constexpr (std::is_same_v<T, CIntArrayTagPtr>){write_int_array_snbt(snbt, list[i]);} else
        if constexpr (std::is_same_v<T, CLongArrayTagPtr>){write_long_array_snbt(snbt, list[i]);}
        if (i + 1 == list.size()){
            snbt.append("\n");
            write_indent(snbt, indent, indent_count);
        } else {
            snbt.append(",");
        }
    }
    snbt.append("]");
}


void write_list_snbt(std::string& snbt, const CListTagPtr& tag){
    switch (tag->index()){
        case 0: snbt.append("[]"); break;
        case 1: write_snbt_list<CByteTag>(snbt, tag); break;
        case 2: write_snbt_list<CShortTag>(snbt, tag); break;
        case 3: write_snbt_list<CIntTag>(snbt, tag); break;
        case 4: write_snbt_list<CLongTag>(snbt, tag); break;
        case 5: write_snbt_list<CFloatTag>(snbt, tag); break;
        case 6: write_snbt_list<CDoubleTag>(snbt, tag); break;
        case 7: write_snbt_list<CByteArrayTagPtr>(snbt, tag); break;
        case 8: write_snbt_list<CStringTag>(snbt, tag); break;
        case 9: write_snbt_list<CListTagPtr>(snbt, tag); break;
        case 10: write_snbt_list<CCompoundTagPtr>(snbt, tag); break;
        case 11: write_snbt_list<CIntArrayTagPtr>(snbt, tag); break;
        case 12: write_snbt_list<CLongArrayTagPtr>(snbt, tag); break;
    }
}


void write_list_snbt(std::string& snbt, const CListTagPtr& tag, const std::string& indent, size_t indent_count){
    switch (tag->index()){
        case 0: snbt.append("[]"); break;
        case 1: write_snbt_list<CByteTag>(snbt, tag, indent, indent_count); break;
        case 2: write_snbt_list<CShortTag>(snbt, tag, indent, indent_count); break;
        case 3: write_snbt_list<CIntTag>(snbt, tag, indent, indent_count); break;
        case 4: write_snbt_list<CLongTag>(snbt, tag, indent, indent_count); break;
        case 5: write_snbt_list<CFloatTag>(snbt, tag, indent, indent_count); break;
        case 6: write_snbt_list<CDoubleTag>(snbt, tag, indent, indent_count); break;
        case 7: write_snbt_list<CByteArrayTagPtr>(snbt, tag, indent, indent_count); break;
        case 8: write_snbt_list<CStringTag>(snbt, tag, indent, indent_count); break;
        case 9: write_snbt_list<CListTagPtr>(snbt, tag, indent, indent_count); break;
        case 10: write_snbt_list<CCompoundTagPtr>(snbt, tag, indent, indent_count); break;
        case 11: write_snbt_list<CIntArrayTagPtr>(snbt, tag, indent, indent_count); break;
        case 12: write_snbt_list<CLongArrayTagPtr>(snbt, tag, indent, indent_count); break;
    }
}


void write_key(std::string& snbt, const CStringTag& key){
    if (std::all_of(key.begin(), key.end(), [](char c) {
        return std::isalnum(c) || c == '.' || c == '_' || c == '+' || c == '-';
    })){
        snbt.append(key);
    } else {
        write_string_snbt(snbt, key);
    }
}


std::vector<std::pair<std::string, TagNode>> sort_compound(const CCompoundTagPtr& tag){
    std::vector<std::pair<std::string, TagNode>> keys(tag->begin(), tag->end());
    std::locale locale;
    try {
        locale = std::locale("en_US.UTF-8");
    } catch (const std::runtime_error&) {
        locale = std::locale("");
    }
    std::sort(keys.begin(), keys.end(), [&locale](
        const std::pair<std::string, TagNode>& a,
        const std::pair<std::string, TagNode>& b
    ){
        return locale(a.first, b.first);
    });
    return keys;
}


void write_compound_snbt(std::string& snbt, const CCompoundTagPtr& tag){
    auto sorted = sort_compound(tag);
    snbt.append("{");
    for (auto it = sorted.begin(); it != sorted.end(); it++){
        write_key(snbt, it->first);
        snbt.append(": ");
        write_node_snbt(snbt, it->second);
        if (std::next(it) != sorted.end()){
            snbt.append(", ");
        }
    }
    snbt.append("}");
}


void write_compound_snbt(std::string& snbt, const CCompoundTagPtr& tag, const std::string& indent, size_t indent_count){
    auto sorted = sort_compound(tag);
    snbt.append("{");
    for (auto it = sorted.begin(); it != sorted.end(); it++){
        snbt.append("\n");
        write_indent(snbt, indent, indent_count + 1);
        write_key(snbt, it->first);
        snbt.append(": ");
        write_node_snbt(snbt, it->second, indent, indent_count + 1);
        if (std::next(it) == sorted.end()){
            snbt.append("\n");
            write_indent(snbt, indent, indent_count);
        } else {
            snbt.append(",");
        }
    }
    snbt.append("}");
}


void write_byte_array_snbt(std::string& snbt, const CByteArrayTagPtr& tag){
    auto array = *tag;
    snbt.append("[B;");
    for (size_t i = 0; i < array.size(); i++){
        snbt.append(std::to_string(array[i]));
        snbt.push_back('B');
        if (i + 1 != array.size()){
            snbt.append(", ");
        }
    }
    snbt.append("]");
}


void write_int_array_snbt(std::string& snbt, const CIntArrayTagPtr& tag){
    auto array = *tag;
    snbt.append("[I;");
    for (size_t i = 0; i < array.size(); i++){
        snbt.append(std::to_string(array[i]));
        if (i + 1 != array.size()){
            snbt.append(", ");
        }
    }
    snbt.append("]");
}


void write_long_array_snbt(std::string& snbt, const CLongArrayTagPtr& tag){
    auto array = *tag;
    snbt.append("[L;");
    for (size_t i = 0; i < array.size(); i++){
        snbt.append(std::to_string(array[i]));
        snbt.push_back('L');
        if (i + 1 != array.size()){
            snbt.append(", ");
        }
    }
    snbt.append("]");
}
