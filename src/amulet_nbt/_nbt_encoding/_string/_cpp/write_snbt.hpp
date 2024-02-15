#pragma once

#include <variant>
#include <type_traits>
#include <format>
#include <cmath>
#include <limits>
#include <algorithm>

#include "../../../_string_encoding/_cpp/utf8.hpp"
#include "../../../_tag/_cpp/nbt.hpp"
#include "../../../_tag/_cpp/array.hpp"


inline void write_indent(std::string& snbt, const std::string& indent, size_t indent_count){
    for (size_t i = 0; i < indent_count; i++){
        snbt.append(indent);
    }
}


void write_snbt(std::string& snbt, const TagNode& tag);
void write_snbt(std::string& snbt, const CByteTag& tag);
void write_snbt(std::string& snbt, const CShortTag& tag);
void write_snbt(std::string& snbt, const CIntTag& tag);
void write_snbt(std::string& snbt, const CLongTag& tag);
void write_snbt(std::string& snbt, const CFloatTag& tag);
void write_snbt(std::string& snbt, const CDoubleTag& tag);
void write_snbt(std::string& snbt, const CByteArrayTagPtr& tag);
void write_snbt(std::string& snbt, const CStringTag& tag);
void write_snbt(std::string& snbt, const CListTagPtr& tag);
void write_snbt(std::string& snbt, const CCompoundTagPtr& tag);
void write_snbt(std::string& snbt, const CIntArrayTagPtr& tag);
void write_snbt(std::string& snbt, const CLongArrayTagPtr& tag);

void write_snbt(std::string& snbt, const TagNode& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CByteTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CShortTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CIntTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CLongTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CFloatTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CDoubleTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CByteArrayTagPtr& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CStringTag& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CListTagPtr& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CCompoundTagPtr& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CIntArrayTagPtr& tag, const std::string& indent, size_t indent_count);
void write_snbt(std::string& snbt, const CLongArrayTagPtr& tag, const std::string& indent, size_t indent_count);


template <
    typename T,
    typename... Args,
    std::enable_if_t<
        std::is_same_v<T, CByteTag> ||
        std::is_same_v<T, CShortTag> ||
        std::is_same_v<T, CIntTag> ||
        std::is_same_v<T, CLongTag> ||
        std::is_same_v<T, CFloatTag> ||
        std::is_same_v<T, CDoubleTag>,
        bool
    > = true
>
void write_snbt(std::string& snbt, const T& tag, Args... args){
    if constexpr (std::is_same_v<T, CByteTag>){
        snbt.append(std::format("{}b", tag));
    } else if constexpr (std::is_same_v<T, CShortTag>){
        snbt.append(std::format("{}s", tag));
    } else if constexpr (std::is_same_v<T, CIntTag>){
        snbt.append(std::format("{}", tag));
    } else if constexpr (std::is_same_v<T, CLongTag>){
        snbt.append(std::format("{}L", tag));
    } else if constexpr (std::is_same_v<T, CFloatTag>){
        if (std::isfinite(tag)){
            snbt.append(std::format("{}f", tag));
        } else if (tag == std::numeric_limits<CFloatTag>::infinity()){
            snbt.append("Infinityf");
        } else if (tag == -std::numeric_limits<CFloatTag>::infinity()){
            snbt.append("-Infinityf");
        } else {
            snbt.append("NaNf");
        }
    } else if constexpr (std::is_same_v<T, CDoubleTag>){
        if (std::isfinite(tag)){
            snbt.append(std::format("{}d", tag));
        } else if (tag == std::numeric_limits<CDoubleTag>::infinity()){
            snbt.append("Infinityd");
        } else if (tag == -std::numeric_limits<CDoubleTag>::infinity()){
            snbt.append("-Infinityd");
        } else {
            snbt.append("NaNd");
        }
    }
}


template <
    typename T,
    typename... Args,
    std::enable_if_t<std::is_same_v<T, CStringTag>, bool> = true
>
void write_snbt(std::string& snbt, const CStringTag& tag, Args... args){
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
        write_snbt<T>(snbt, list[i]);
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
        snbt.append("\r\n");
        write_indent(snbt, indent, indent_count + 1);
        write_snbt<T>(snbt, list[i], indent, indent_count + 1);
        if (i + 1 == list.size()){
            snbt.append("\r\n");
            write_indent(snbt, indent, indent_count);
        } else {
            snbt.append(",");
        }
    }
    snbt.append("]");
}


template <
    typename T,
    typename... Args,
    std::enable_if_t<std::is_same_v<T, CListTagPtr>, bool> = true
>
void write_snbt(std::string& snbt, const CListTagPtr& tag, Args... args){
    switch (tag->index()){
        case 0: snbt.append("[]"); break;
        case 1: write_snbt_list<CByteTag>(snbt, tag, args...); break;
        case 2: write_snbt_list<CShortTag>(snbt, tag, args...); break;
        case 3: write_snbt_list<CIntTag>(snbt, tag, args...); break;
        case 4: write_snbt_list<CLongTag>(snbt, tag, args...); break;
        case 5: write_snbt_list<CFloatTag>(snbt, tag, args...); break;
        case 6: write_snbt_list<CDoubleTag>(snbt, tag, args...); break;
        case 7: write_snbt_list<CByteArrayTagPtr>(snbt, tag, args...); break;
        case 8: write_snbt_list<CStringTag>(snbt, tag, args...); break;
        case 9: write_snbt_list<CListTagPtr>(snbt, tag, args...); break;
        case 10: write_snbt_list<CCompoundTagPtr>(snbt, tag, args...); break;
        case 11: write_snbt_list<CIntArrayTagPtr>(snbt, tag, args...); break;
        case 12: write_snbt_list<CLongArrayTagPtr>(snbt, tag, args...); break;
    }
}


void write_key(std::string& snbt, const CStringTag& key){
    if (std::all_of(key.begin(), key.end(), [](char c) {
        return std::isalnum(c) || c == '.' || c == '_' || c == '+' || c == '-';
    })){
        snbt.append(key);
    } else {
        write_snbt<CStringTag>(snbt, key);
    }
}


std::vector<std::pair<std::string, TagNode>> sort_compound(const CCompoundTagPtr& tag){
    std::vector<std::pair<std::string, TagNode>> keys(tag->begin(), tag->end());
    std::locale locale;
    try {
        locale = std::locale("en_US.UTF-8");
    } catch (const std::runtime_error& error) {
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


template <
    typename T,
    std::enable_if_t<std::is_same_v<T, CCompoundTagPtr>, bool> = true
>
void write_snbt(std::string& snbt, const CCompoundTagPtr& tag){
    auto sorted = sort_compound(tag);
    snbt.append("{");
    for (auto it = sorted.begin(); it != sorted.end(); it++){
        write_key(snbt, it->first);
        snbt.append(": ");
        write_snbt<TagNode>(snbt, it->second);
        if (std::next(it) != sorted.end()){
            snbt.append(", ");
        }
    }
    snbt.append("}");
}


template <
    typename T,
    typename... Args,
    std::enable_if_t<std::is_same_v<T, CCompoundTagPtr>, bool> = true
>
void write_snbt(std::string& snbt, const CCompoundTagPtr& tag, const std::string& indent, size_t indent_count){
    auto sorted = sort_compound(tag);
    snbt.append("{");
    for (auto it = sorted.begin(); it != sorted.end(); it++){
        snbt.append("\r\n");
        write_indent(snbt, indent, indent_count + 1);
        write_key(snbt, it->first);
        snbt.append(": ");
        write_snbt<TagNode, const std::string&, size_t>(snbt, it->second, indent, indent_count + 1);
        if (std::next(it) == sorted.end()){
            snbt.append("\r\n");
            write_indent(snbt, indent, indent_count);
        } else {
            snbt.append(",");
        }
    }
    snbt.append("}");
}


template <
    typename T,
    typename... Args,
    std::enable_if_t<
        std::is_same_v<T, CByteArrayTagPtr> ||
        std::is_same_v<T, CIntArrayTagPtr> ||
        std::is_same_v<T, CLongArrayTagPtr>,
        bool
    > = true
>
void write_snbt(std::string& snbt, const T& tag, Args... args){
    auto array = *tag;
    if constexpr (std::is_same_v<T, CByteArrayTagPtr>){
        snbt.append("[B;");
    } else if constexpr (std::is_same_v<T, CIntArrayTagPtr>){
        snbt.append("[I;");
    } else if constexpr (std::is_same_v<T, CLongArrayTagPtr>){
        snbt.append("[L;");
    }
    for (size_t i = 0; i < array.size(); i++){
        if constexpr (std::is_same_v<T, CByteArrayTagPtr>){
            snbt.append(std::format("{}B", array[i]));
        } else if constexpr (std::is_same_v<T, CIntArrayTagPtr>){
            snbt.append(std::format("{}", array[i]));
        } else if constexpr (std::is_same_v<T, CLongArrayTagPtr>){
            snbt.append(std::format("{}L", array[i]));
        }
        if (i + 1 != array.size()){
            snbt.append(", ");
        }
    }
    snbt.append("]");
}


template <
    typename T,
    typename... Args,
    std::enable_if_t<std::is_same_v<T, TagNode>, bool> = true
>
void write_snbt(std::string& snbt, const TagNode& tag, Args... args){
    switch (tag.index()){
        case 1: write_snbt<CByteTag, Args...>(snbt, std::get<CByteTag>(tag), args...); break;
        case 2: write_snbt<CShortTag, Args...>(snbt, std::get<CShortTag>(tag), args...); break;
        case 3: write_snbt<CIntTag, Args...>(snbt, std::get<CIntTag>(tag), args...); break;
        case 4: write_snbt<CLongTag, Args...>(snbt, std::get<CLongTag>(tag), args...); break;
        case 5: write_snbt<CFloatTag, Args...>(snbt, std::get<CFloatTag>(tag), args...); break;
        case 6: write_snbt<CDoubleTag, Args...>(snbt, std::get<CDoubleTag>(tag), args...); break;
        case 7: write_snbt<CByteArrayTagPtr, Args...>(snbt, std::get<CByteArrayTagPtr>(tag), args...); break;
        case 8: write_snbt<CStringTag, Args...>(snbt, std::get<CStringTag>(tag), args...); break;
        case 9: write_snbt<CListTagPtr, Args...>(snbt, std::get<CListTagPtr>(tag), args...); break;
        case 10: write_snbt<CCompoundTagPtr, Args...>(snbt, std::get<CCompoundTagPtr>(tag), args...); break;
        case 11: write_snbt<CIntArrayTagPtr, Args...>(snbt, std::get<CIntArrayTagPtr>(tag), args...); break;
        case 12: write_snbt<CLongArrayTagPtr, Args...>(snbt, std::get<CLongArrayTagPtr>(tag), args...); break;
        default: throw std::runtime_error("TagNode cannot be in null state when writing.");
    }
}
