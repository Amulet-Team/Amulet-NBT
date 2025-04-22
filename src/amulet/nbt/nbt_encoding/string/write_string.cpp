#include <algorithm>
#include <cctype>
#include <cmath>
#include <iomanip>
#include <ios>
#include <iterator>
#include <limits>
#include <locale>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/export.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
    // Forward declarations
    void encode_formatted_snbt(std::string& snbt, const TagNode& node, const std::string& indent, const size_t& indent_count);
    void encode_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent, const size_t& indent_count);
    void encode_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent, const size_t& indent_count);

    inline void write_indent(std::string& snbt, const std::string& indent, const size_t& indent_count)
    {
        for (size_t i = 0; i < indent_count; i++) {
            snbt.append(indent);
        }
    }

    inline void encode_snbt(std::string& snbt, const TagNode& node)
    {
        std::visit([&snbt](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            if constexpr (is_shared_ptr<T>()) {
                encode_snbt(snbt, *tag);
            } else {
                encode_snbt(snbt, tag);
            }
        },
            node);
    }

    inline void encode_formatted_snbt(std::string& snbt, const TagNode& node, const std::string& indent, const size_t& indent_count)
    {
        std::visit([&snbt, &indent, &indent_count](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            if constexpr (std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr>) {
                encode_formatted_snbt(snbt, *tag, indent, indent_count);
            } else if constexpr (is_shared_ptr<T>()) {
                encode_snbt(snbt, *tag);
            } else {
                encode_snbt(snbt, tag);
            }
        },
            node);
    }

    inline void encode_snbt(std::string& snbt, const ByteTag& tag)
    {
        snbt.append(std::to_string(static_cast<ByteTagNative>(tag)));
        snbt.push_back('b');
    }

    inline void encode_snbt(std::string& snbt, const ShortTag& tag)
    {
        snbt.append(std::to_string(static_cast<ShortTagNative>(tag)));
        snbt.push_back('s');
    }

    inline void encode_snbt(std::string& snbt, const IntTag& tag)
    {
        snbt.append(std::to_string(static_cast<IntTagNative>(tag)));
    }

    inline void encode_snbt(std::string& snbt, const LongTag& tag)
    {
        snbt.append(std::to_string(static_cast<LongTagNative>(tag)));
        snbt.push_back('L');
    }

    template <typename T>
    inline std::string encode_float(const T& num)
    {
        std::ostringstream oss;
        oss << std::setprecision(std::numeric_limits<T>::max_digits10) << std::noshowpoint << num;
        return oss.str();
    }

    inline void encode_snbt(std::string& snbt, const FloatTag& tag)
    {
        FloatTagNative native_tag = static_cast<FloatTagNative>(tag);
        if (std::isfinite(native_tag)) {
            snbt.append(encode_float<FloatTagNative>(native_tag));
            snbt.push_back('f');
        } else if (native_tag == std::numeric_limits<FloatTagNative>::infinity()) {
            snbt.append("Infinityf");
        } else if (native_tag == -std::numeric_limits<FloatTagNative>::infinity()) {
            snbt.append("-Infinityf");
        } else {
            snbt.append("NaNf");
        }
    }

    inline void encode_snbt(std::string& snbt, const DoubleTag& tag)
    {
        DoubleTagNative native_tag = static_cast<DoubleTagNative>(tag);
        if (std::isfinite(native_tag)) {
            snbt.append(encode_float<DoubleTagNative>(native_tag));
            snbt.push_back('d');
        } else if (native_tag == std::numeric_limits<DoubleTagNative>::infinity()) {
            snbt.append("Infinityd");
        } else if (native_tag == -std::numeric_limits<DoubleTagNative>::infinity()) {
            snbt.append("-Infinityd");
        } else {
            snbt.append("NaNd");
        }
    }

    inline void encode_snbt(std::string& snbt, const StringTag& tag)
    {
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
            std::is_same_v<T, ByteTag> || std::is_same_v<T, ShortTag> || std::is_same_v<T, IntTag> || std::is_same_v<T, LongTag> || std::is_same_v<T, FloatTag> || std::is_same_v<T, DoubleTag> || std::is_same_v<T, ByteArrayTagPtr> || std::is_same_v<T, StringTag> || std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr> || std::is_same_v<T, IntArrayTagPtr> || std::is_same_v<T, LongArrayTagPtr>,
            bool>
        = true>
    inline void encode_snbt_list(std::string& snbt, const ListTag& tag)
    {
        const std::vector<T>& list = std::get<std::vector<T>>(tag);
        snbt.append("[");
        for (size_t i = 0; i < list.size(); i++) {
            if (i != 0) {
                snbt.append(", ");
            }
            if constexpr (is_shared_ptr<T>::value) {
                encode_snbt(snbt, *list[i]);
            } else {
                encode_snbt(snbt, list[i]);
            }
        }
        snbt.append("]");
    }

    inline void encode_snbt(std::string& snbt, const ListTag& tag)
    {
        std::visit([&snbt](auto&& list_tag) {
            using T = std::decay_t<decltype(list_tag)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                snbt.append("[]");
            } else {
                encode_snbt_list<typename T::value_type>(snbt, list_tag);
            }
        },
            tag);
    }

    template <typename T>
    inline void encode_formatted_snbt_list(std::string& snbt, const std::vector<T>& list, const std::string& indent, const size_t& indent_count)
    {
        snbt.append("[");
        for (size_t i = 0; i < list.size(); i++) {
            snbt.append("\n");
            write_indent(snbt, indent, indent_count + 1);
            if constexpr (
                std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr>) {
                encode_formatted_snbt(snbt, list[i], indent, indent_count + 1);
            } else {
                encode_snbt(snbt, list[i]);
            }
            if (i + 1 == list.size()) {
                snbt.append("\n");
                write_indent(snbt, indent, indent_count);
            } else {
                snbt.append(",");
            }
        }
        snbt.append("]");
    }

    inline void encode_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent, const size_t& indent_count)
    {
        std::visit([&snbt, &indent, &indent_count](auto&& list_tag) {
            using T = std::decay_t<decltype(list_tag)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                snbt.append("[]");
            } else {
                encode_formatted_snbt_list<typename T::value_type>(snbt, list_tag, indent, indent_count);
            }
        },
            tag);
    }

    inline void write_key(std::string& snbt, const StringTag& key)
    {
        if (std::all_of(key.begin(), key.end(), [](char c) {
                return std::isalnum(c) || c == '.' || c == '_' || c == '+' || c == '-';
            })) {
            snbt.append(key);
        } else {
            encode_snbt(snbt, key);
        }
    }

    inline std::vector<std::pair<std::string, TagNode>> sort_compound(const CompoundTag& tag)
    {
        std::vector<std::pair<std::string, TagNode>> keys(tag.begin(), tag.end());
        std::locale locale;
        try {
            locale = std::locale("en_US.UTF-8");
        } catch (const std::runtime_error&) {
            locale = std::locale("");
        }
        std::sort(keys.begin(), keys.end(), [&locale](const std::pair<std::string, TagNode>& a, const std::pair<std::string, TagNode>& b) {
            return locale(a.first, b.first);
        });
        return keys;
    }

    inline void encode_snbt(std::string& snbt, const CompoundTag& tag)
    {
        auto sorted = sort_compound(tag);
        snbt.append("{");
        for (size_t i = 0; i < sorted.size(); i++) {
            if (i != 0) {
                snbt.append(", ");
            }
            write_key(snbt, sorted[i].first);
            snbt.append(": ");
            encode_snbt(snbt, sorted[i].second);
        }
        snbt.append("}");
    }

    inline void encode_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent, const size_t& indent_count)
    {
        auto sorted = sort_compound(tag);
        snbt.append("{");
        for (auto it = sorted.begin(); it != sorted.end(); it++) {
            snbt.append("\n");
            write_indent(snbt, indent, indent_count + 1);
            write_key(snbt, it->first);
            snbt.append(": ");
            encode_formatted_snbt(snbt, it->second, indent, indent_count + 1);
            if (std::next(it) == sorted.end()) {
                snbt.append("\n");
                write_indent(snbt, indent, indent_count);
            } else {
                snbt.append(",");
            }
        }
        snbt.append("}");
    }

    inline void encode_snbt(std::string& snbt, const ByteArrayTag& tag)
    {
        snbt.append("[B;");
        for (size_t i = 0; i < tag.size(); i++) {
            snbt.append(std::to_string(tag[i]));
            snbt.push_back('B');
            if (i + 1 != tag.size()) {
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }

    inline void encode_snbt(std::string& snbt, const IntArrayTag& tag)
    {
        snbt.append("[I;");
        for (size_t i = 0; i < tag.size(); i++) {
            snbt.append(std::to_string(tag[i]));
            if (i + 1 != tag.size()) {
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }

    inline void encode_snbt(std::string& snbt, const LongArrayTag& tag)
    {
        snbt.append("[L;");
        for (size_t i = 0; i < tag.size(); i++) {
            snbt.append(std::to_string(tag[i]));
            snbt.push_back('L');
            if (i + 1 != tag.size()) {
                snbt.append(", ");
            }
        }
        snbt.append("]");
    }

    std::string encode_snbt(const TagNode& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const ByteTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const ShortTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const IntTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const LongTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const FloatTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const DoubleTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const ByteArrayTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const StringTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const ListTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const CompoundTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const IntArrayTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }
    std::string encode_snbt(const LongArrayTag& tag)
    {
        std::string snbt;
        encode_snbt(snbt, tag);
        return snbt;
    }

    void encode_formatted_snbt(std::string& snbt, const TagNode& tag, const std::string& indent)
    {
        return encode_formatted_snbt(snbt, tag, indent, 0);
    }
    void encode_formatted_snbt(std::string& snbt, const ByteTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const ShortTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const IntTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const LongTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const FloatTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const DoubleTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const ByteArrayTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const StringTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const ListTag& tag, const std::string& indent)
    {
        return encode_formatted_snbt(snbt, tag, indent, 0);
    }
    void encode_formatted_snbt(std::string& snbt, const CompoundTag& tag, const std::string& indent)
    {
        return encode_formatted_snbt(snbt, tag, indent, 0);
    }
    void encode_formatted_snbt(std::string& snbt, const IntArrayTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }
    void encode_formatted_snbt(std::string& snbt, const LongArrayTag& tag, const std::string& indent)
    {
        encode_snbt(snbt, tag);
    }

    std::string encode_formatted_snbt(const TagNode& tag, const std::string& indent)
    {
        std::string snbt;
        encode_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    std::string encode_formatted_snbt(const ByteTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const ShortTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const IntTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const LongTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const FloatTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const DoubleTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const ByteArrayTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const StringTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    std::string encode_formatted_snbt(const ListTag& tag, const std::string& indent)
    {
        std::string snbt;
        encode_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const CompoundTag& tag, const std::string& indent)
    {
        std::string snbt;
        encode_formatted_snbt(snbt, tag, indent);
        return snbt;
    }
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const IntArrayTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
    AMULET_NBT_EXPORT std::string encode_formatted_snbt(const LongArrayTag& tag, const std::string& indent)
    {
        return encode_snbt(tag);
    }
} // namespace NBT
} // namespace Amulet
