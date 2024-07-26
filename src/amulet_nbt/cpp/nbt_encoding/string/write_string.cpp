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
#include <ios>
#include <vector>
#include <cctype>
#include <utility>
#include <iterator>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>


namespace AmuletNBT {
    // Forward declarations
    void write_formatted_snbt(std::string& snbt, const AmuletNBT::TagNode& node, const std::string& indent, const size_t& indent_count);
    void write_formatted_snbt(std::string& snbt, const AmuletNBT::ListTag& tag, const std::string& indent, const size_t& indent_count);
    void write_formatted_snbt(std::string& snbt, const AmuletNBT::CompoundTag& tag, const std::string& indent, const size_t& indent_count);

    inline void write_indent(std::string& snbt, const std::string& indent, const size_t& indent_count){
        for (size_t i = 0; i < indent_count; i++){
            snbt.append(indent);
        }
    }

    inline void write_snbt(std::string& snbt, const TagNode& node){
        std::visit([&snbt](auto&& tag){
            using T = std::decay_t<decltype(tag)>;
            if constexpr (is_shared_ptr<T>()) {
                write_snbt(snbt, *tag);
            }
            else {
                write_snbt(snbt, tag);
            }
        }, node);
    }

    inline void write_formatted_snbt(std::string& snbt, const TagNode& node, const std::string& indent, const size_t& indent_count){
        std::visit([&snbt, &indent, &indent_count](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            if constexpr (std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr>) {
                write_formatted_snbt(snbt, *tag, indent, indent_count);
            }
            else if constexpr (is_shared_ptr<T>()) {
                write_snbt(snbt, *tag);
            }
            else {
                write_snbt(snbt, tag);
            }
        }, node);
    }

    inline void write_snbt(std::string& snbt, const ByteTag& tag){
        snbt.append(std::to_string(static_cast<ByteTagNative>(tag)));
        snbt.push_back('b');
    }

    inline void write_snbt(std::string& snbt, const ShortTag& tag){
        snbt.append(std::to_string(static_cast<ShortTagNative>(tag)));
        snbt.push_back('s');
    }

    inline void write_snbt(std::string& snbt, const IntTag& tag){
        snbt.append(std::to_string(static_cast<IntTagNative>(tag)));
    }

    inline void write_snbt(std::string& snbt, const LongTag& tag){
        snbt.append(std::to_string(static_cast<LongTagNative>(tag)));
        snbt.push_back('L');
    }

    template<typename T>
    inline std::string encode_float(const T& num){
        std::ostringstream oss;
        oss << std::setprecision(std::numeric_limits<T>::max_digits10) << std::noshowpoint << num;
        return oss.str();
    }

    inline void write_snbt(std::string& snbt, const FloatTag& tag){
        FloatTagNative native_tag = static_cast<FloatTagNative>(tag);
        if (std::isfinite(native_tag)){
            snbt.append(encode_float<FloatTagNative>(native_tag));
            snbt.push_back('f');
        } else if (native_tag == std::numeric_limits<FloatTagNative>::infinity()){
            snbt.append("Infinityf");
        } else if (native_tag == -std::numeric_limits<FloatTagNative>::infinity()){
            snbt.append("-Infinityf");
        } else {
            snbt.append("NaNf");
        }
    }

    inline void write_snbt(std::string& snbt, const DoubleTag& tag){
        DoubleTagNative native_tag = static_cast<DoubleTagNative>(tag);
        if (std::isfinite(native_tag)){
            snbt.append(encode_float<DoubleTagNative>(native_tag));
            snbt.push_back('d');
        } else if (native_tag == std::numeric_limits<DoubleTagNative>::infinity()){
            snbt.append("Infinityd");
        } else if (native_tag == -std::numeric_limits<DoubleTagNative>::infinity()){
            snbt.append("-Infinityd");
        } else {
            snbt.append("NaNd");
        }
    }


    inline void write_snbt(std::string& snbt, const StringTag& tag){
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
    inline void write_snbt_list(std::string& snbt, const ListTag& tag){
        const std::vector<T>& list = std::get<std::vector<T>>(tag);
        snbt.append("[");
        for (size_t i = 0; i < list.size(); i++){
            if (i != 0){
                snbt.append(", ");
            }
            if constexpr (is_shared_ptr<T>::value){
                write_snbt(snbt, *list[i]);
            } else {
                write_snbt(snbt, list[i]);
            }
        }
        snbt.append("]");
    }


    inline void write_snbt(std::string& snbt, const ListTag& tag){
        std::visit([&snbt](auto&& list_tag) {
            using T = std::decay_t<decltype(list_tag)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                snbt.append("[]");
            }
            else {
                write_snbt_list<typename T::value_type>(snbt, list_tag);
            }
        }, tag);
    }

    template <typename T>
    inline void write_formatted_snbt_list(std::string& snbt, const std::vector<T>& list, const std::string& indent, const size_t& indent_count){
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

    inline void write_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent, const size_t& indent_count){
        std::visit([&snbt, &indent, &indent_count](auto&& list_tag) {
            using T = std::decay_t<decltype(list_tag)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                snbt.append("[]");
            }
            else {
                write_formatted_snbt_list<typename T::value_type>(snbt, list_tag, indent, indent_count);
            }
        }, tag);
    }


    inline void write_key(std::string& snbt, const StringTag& key){
        if (std::all_of(key.begin(), key.end(), [](char c) {
            return std::isalnum(c) || c == '.' || c == '_' || c == '+' || c == '-';
        })){
            snbt.append(key);
        } else {
            write_snbt(snbt, key);
        }
    }


    inline std::vector<std::pair<std::string, TagNode>> sort_compound(const CompoundTag& tag){
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


    inline void write_snbt(std::string& snbt, const CompoundTag& tag){
        auto sorted = sort_compound(tag);
        snbt.append("{");
        for (size_t i = 0; i < sorted.size(); i++){
            if (i != 0){
                snbt.append(", ");
            }
            write_key(snbt, sorted[i].first);
            snbt.append(": ");
            write_snbt(snbt, sorted[i].second);
        }
        snbt.append("}");
    }


    inline void write_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent, const size_t& indent_count){
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


    inline void write_snbt(std::string& snbt, const ByteArrayTag& tag){
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


    inline void write_snbt(std::string& snbt, const IntArrayTag& tag){
        snbt.append("[I;");
        for (size_t i = 0; i < tag.size(); i++){
            snbt.append(std::to_string(tag[i]));
            if (i + 1 != tag.size()){
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }


    inline void write_snbt(std::string& snbt, const LongArrayTag& tag){
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
        return write_formatted_snbt(snbt, tag, indent, 0);
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
        return write_formatted_snbt(snbt, tag, indent, 0);
    }
    void write_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent){
        return write_formatted_snbt(snbt, tag, indent, 0);
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
