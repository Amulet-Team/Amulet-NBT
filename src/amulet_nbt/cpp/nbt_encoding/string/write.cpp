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

#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>


namespace Amulet {
    // Forward declarations

    inline void write_indent(std::string& snbt, const std::string& indent, size_t indent_count){
        for (size_t i = 0; i < indent_count; i++){
            snbt.append(indent);
        }
    }

    void write_snbt(std::string& snbt, const TagNode& tag){
        switch (tag.index()){
            case 1: write_snbt(snbt, std::get<ByteTag>(tag)); break;
            case 2: write_snbt(snbt, std::get<ShortTag>(tag)); break;
            case 3: write_snbt(snbt, std::get<IntTag>(tag)); break;
            case 4: write_snbt(snbt, std::get<LongTag>(tag)); break;
            case 5: write_snbt(snbt, std::get<FloatTag>(tag)); break;
            case 6: write_snbt(snbt, std::get<DoubleTag>(tag)); break;
            case 7: write_snbt(snbt, std::get<ByteArrayTagPtr>(tag)); break;
            case 8: write_snbt(snbt, std::get<StringTag>(tag)); break;
            case 9: write_snbt(snbt, std::get<ListTagPtr>(tag)); break;
            case 10: write_snbt(snbt, std::get<CompoundTagPtr>(tag)); break;
            case 11: write_snbt(snbt, std::get<IntArrayTagPtr>(tag)); break;
            case 12: write_snbt(snbt, std::get<LongArrayTagPtr>(tag)); break;
            default: throw std::runtime_error("TagNode cannot be in null state when writing.");
        }
    }

    void write_formatted_snbt(std::string& snbt, const TagNode& tag, const std::string& indent, size_t indent_count){
        switch (tag.index()){
            case 1: write_snbt(snbt, std::get<ByteTag>(tag)); break;
            case 2: write_snbt(snbt, std::get<ShortTag>(tag)); break;
            case 3: write_snbt(snbt, std::get<IntTag>(tag)); break;
            case 4: write_snbt(snbt, std::get<LongTag>(tag)); break;
            case 5: write_snbt(snbt, std::get<FloatTag>(tag)); break;
            case 6: write_snbt(snbt, std::get<DoubleTag>(tag)); break;
            case 7: write_snbt(snbt, std::get<ByteArrayTagPtr>(tag)); break;
            case 8: write_snbt(snbt, std::get<StringTag>(tag)); break;
            case 9: write_formatted_snbt(snbt, std::get<ListTagPtr>(tag), indent, indent_count); break;
            case 10: write_formatted_snbt(snbt, std::get<CompoundTagPtr>(tag), indent, indent_count); break;
            case 11: write_snbt(snbt, std::get<IntArrayTagPtr>(tag)); break;
            case 12: write_snbt(snbt, std::get<LongArrayTagPtr>(tag)); break;
            default: throw std::runtime_error("TagNode cannot be in null state when writing.");
        }
    }

    void write_snbt(std::string& snbt, const ByteTag& tag){
        snbt.append(std::to_string(tag));
        snbt.push_back('b');
    }

    void write_snbt(std::string& snbt, const ShortTag& tag){
        snbt.append(std::to_string(tag));
        snbt.push_back('s');
    }

    void write_snbt(std::string& snbt, const IntTag& tag){
        snbt.append(std::to_string(tag));
    }

    void write_snbt(std::string& snbt, const LongTag& tag){
        snbt.append(std::to_string(tag));
        snbt.push_back('L');
    }

    template<typename T>
    inline std::string encode_float(const T& num){
        std::ostringstream oss;
        oss << std::setprecision(std::numeric_limits<T>::max_digits10) << std::noshowpoint << num;
        return oss.str();
    }

    void write_snbt(std::string& snbt, const FloatTag& tag){
        if (std::isfinite(tag)){
            snbt.append(encode_float<FloatTag>(tag));
            snbt.push_back('f');
        } else if (tag == std::numeric_limits<FloatTag>::infinity()){
            snbt.append("Infinityf");
        } else if (tag == -std::numeric_limits<FloatTag>::infinity()){
            snbt.append("-Infinityf");
        } else {
            snbt.append("NaNf");
        }
    }

    void write_snbt(std::string& snbt, const DoubleTag& tag){
        if (std::isfinite(tag)){
            snbt.append(encode_float<DoubleTag>(tag));
            snbt.push_back('d');
        } else if (tag == std::numeric_limits<DoubleTag>::infinity()){
            snbt.append("Infinityd");
        } else if (tag == -std::numeric_limits<DoubleTag>::infinity()){
            snbt.append("-Infinityd");
        } else {
            snbt.append("NaNd");
        }
    }


    void write_snbt(std::string& snbt, const StringTag& tag){
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


    template <typename T>
    void write_snbt_list(std::string& snbt, const ListTag& tag){
        const std::vector<T>& list = std::get<std::vector<T>>(tag);
        snbt.append("[");
        for (size_t i = 0; i < list.size(); i++){
            if (i != 0){
                snbt.append(", ");
            }
            write_snbt(snbt, list[i]);
        }
        snbt.append("]");
    }


    void write_snbt(std::string& snbt, const ListTag& tag){
        switch (tag.index()){
            case 0: snbt.append("[]"); break;
            case 1: write_snbt_list<ByteTag>(snbt, tag); break;
            case 2: write_snbt_list<ShortTag>(snbt, tag); break;
            case 3: write_snbt_list<IntTag>(snbt, tag); break;
            case 4: write_snbt_list<LongTag>(snbt, tag); break;
            case 5: write_snbt_list<FloatTag>(snbt, tag); break;
            case 6: write_snbt_list<DoubleTag>(snbt, tag); break;
            case 7: write_snbt_list<ByteArrayTagPtr>(snbt, tag); break;
            case 8: write_snbt_list<StringTag>(snbt, tag); break;
            case 9: write_snbt_list<ListTagPtr>(snbt, tag); break;
            case 10: write_snbt_list<CompoundTagPtr>(snbt, tag); break;
            case 11: write_snbt_list<IntArrayTagPtr>(snbt, tag); break;
            case 12: write_snbt_list<LongArrayTagPtr>(snbt, tag); break;
        }
    }

    template <typename T>
    void write_formatted_snbt_list(std::string& snbt, const ListTag& tag, const std::string& indent, size_t indent_count){
        const std::vector<T>& list = std::get<std::vector<T>>(tag);
        snbt.append("[");
        for (size_t i = 0; i < list.size(); i++){
            snbt.append("\n");
            write_indent(snbt, indent, indent_count + 1);
            if constexpr (
                std::is_same_v<T, ListTagPtr> ||
                std::is_same_v<T, CompoundTagPtr>
            ){
                write_formatted_snbt(snbt, list[i], indent, indent_count + 1);
            } else {
                write_snbt(snbt, list[i]);
            }
            if (i + 1 == list.size()){
                snbt.append("\n");
                write_indent(snbt, indent, indent_count);
            } else {
                snbt.append(",");
            }
        }
        snbt.append("]");
    }

    void write_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent, size_t indent_count){
        switch (tag.index()){
            case 0: snbt.append("[]"); break;
            case 1: write_formatted_snbt_list<ByteTag>(snbt, tag, indent, indent_count); break;
            case 2: write_formatted_snbt_list<ShortTag>(snbt, tag, indent, indent_count); break;
            case 3: write_formatted_snbt_list<IntTag>(snbt, tag, indent, indent_count); break;
            case 4: write_formatted_snbt_list<LongTag>(snbt, tag, indent, indent_count); break;
            case 5: write_formatted_snbt_list<FloatTag>(snbt, tag, indent, indent_count); break;
            case 6: write_formatted_snbt_list<DoubleTag>(snbt, tag, indent, indent_count); break;
            case 7: write_formatted_snbt_list<ByteArrayTagPtr>(snbt, tag, indent, indent_count); break;
            case 8: write_formatted_snbt_list<StringTag>(snbt, tag, indent, indent_count); break;
            case 9: write_formatted_snbt_list<ListTagPtr>(snbt, tag, indent, indent_count); break;
            case 10: write_formatted_snbt_list<CompoundTagPtr>(snbt, tag, indent, indent_count); break;
            case 11: write_formatted_snbt_list<IntArrayTagPtr>(snbt, tag, indent, indent_count); break;
            case 12: write_formatted_snbt_list<LongArrayTagPtr>(snbt, tag, indent, indent_count); break;
        }
    }


    void write_key(std::string& snbt, const StringTag& key){
        if (std::all_of(key.begin(), key.end(), [](char c) {
            return std::isalnum(c) || c == '.' || c == '_' || c == '+' || c == '-';
        })){
            snbt.append(key);
        } else {
            write_snbt(snbt, key);
        }
    }


    std::vector<std::pair<std::string, TagNode>> sort_compound(const CompoundTag& tag){
        std::vector<std::pair<std::string, TagNode>> keys(tag.begin(), tag.end());
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


    void write_snbt(std::string& snbt, const CompoundTag& tag){
        auto sorted = sort_compound(tag);
        snbt.append("{");
        for (auto it = sorted.begin(); it != sorted.end(); it++){
            write_key(snbt, it->first);
            snbt.append(": ");
            write_snbt(snbt, it->second);
            if (std::next(it) != sorted.end()){
                snbt.append(", ");
            }
        }
        snbt.append("}");
    }


    void write_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent, size_t indent_count){
        auto sorted = sort_compound(tag);
        snbt.append("{");
        for (auto it = sorted.begin(); it != sorted.end(); it++){
            snbt.append("\n");
            write_indent(snbt, indent, indent_count + 1);
            write_key(snbt, it->first);
            snbt.append(": ");
            write_formatted_snbt(snbt, it->second, indent, indent_count + 1);
            if (std::next(it) == sorted.end()){
                snbt.append("\n");
                write_indent(snbt, indent, indent_count);
            } else {
                snbt.append(",");
            }
        }
        snbt.append("}");
    }


    void write_snbt(std::string& snbt, const ByteArrayTag& tag){
        snbt.append("[B;");
        for (size_t i = 0; i < tag.size(); i++){
            snbt.append(std::to_string(tag[i]));
            snbt.push_back('B');
            if (i + 1 != tag.size()){
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }


    void write_snbt(std::string& snbt, const IntArrayTag& tag){
        snbt.append("[I;");
        for (size_t i = 0; i < tag.size(); i++){
            snbt.append(std::to_string(tag[i]));
            if (i + 1 != tag.size()){
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }


    void write_snbt(std::string& snbt, const LongArrayTag& tag){
        snbt.append("[L;");
        for (size_t i = 0; i < tag.size(); i++){
            snbt.append(std::to_string(tag[i]));
            snbt.push_back('L');
            if (i + 1 != tag.size()){
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }


    std::string write_snbt(const TagNode& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const ByteTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const ShortTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const IntTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const LongTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const FloatTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const DoubleTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const ByteArrayTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const StringTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const ListTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const CompoundTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const IntArrayTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }
    std::string write_snbt(const LongArrayTag& tag){
        std::string snbt;
        write_snbt(snbt, tag);
        return snbt;
    }

    void write_formatted_snbt(std::string& snbt, const TagNode& tag, const std::string& indent){
        size_t indent_count = 0;
        return write_formatted_snbt(snbt, tag, indent, indent_count);
    }
    void write_formatted_snbt(std::string& snbt, const ByteTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const ShortTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const IntTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const LongTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const FloatTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const DoubleTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const ByteArrayTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const StringTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent){
        size_t indent_count = 0;
        return write_formatted_snbt(snbt, tag, indent, indent_count);
    }
    void write_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent){
        size_t indent_count = 0;
        return write_formatted_snbt(snbt, tag, indent, indent_count);
    }
    void write_formatted_snbt(std::string& snbt, const IntArrayTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }
    void write_formatted_snbt(std::string& snbt, const LongArrayTag& tag, const std::string& indent){
        write_snbt(snbt, tag);
    }

    std::string write_formatted_snbt(const TagNode& tag, const std::string& indent){
        std::string snbt;
        write_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    std::string write_formatted_snbt(const ByteTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const ShortTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const IntTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const LongTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const FloatTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const DoubleTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const ByteArrayTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const StringTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const ListTag& tag, const std::string& indent){
        std::string snbt;
        write_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    std::string write_formatted_snbt(const CompoundTag& tag, const std::string& indent){
        std::string snbt;
        write_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    std::string write_formatted_snbt(const IntArrayTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
    std::string write_formatted_snbt(const LongArrayTag& tag, const std::string& indent){
        return write_snbt(tag);
    }
}
