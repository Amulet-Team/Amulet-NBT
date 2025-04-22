#include <algorithm>
#include <memory>
#include <stdexcept>
#include <string>
#include <tuple>
#include <type_traits>
#include <unordered_set>
#include <utility>
#include <vector>

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/list_methods.hpp>

namespace Amulet {
namespace NBT {

    const std::unordered_set<size_t> Whitespace { ' ', '\t', '\r', '\n' };
    const std::unordered_set<size_t> AlphaNumPlus { '+', '-', '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '_', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
    const ByteTag byte_false = 0;
    const ByteTag byte_true = 1;

    inline bool in_range(const CodePointVector& snbt, const size_t& index)
    {
        return index < snbt.size();
    }

    inline bool in_range(const CodePointVector& snbt, const size_t& index, const size_t count)
    {
        return index + count - 1 < snbt.size();
    }

    inline bool bounds_check(const CodePointVector& snbt, const size_t& index)
    {
        if (in_range(snbt, index)) {
            return true;
        }
        throw std::out_of_range("SNBT string is incomplete. Reached the end of the string.");
    }

    inline void read_whitespace(const CodePointVector& snbt, size_t& index)
    {
        while (in_range(snbt, index) && Whitespace.contains(snbt[index])) {
            index++;
        }
    }

    inline size_t read_code_point(const CodePointVector& snbt, const size_t& index)
    {
        bounds_check(snbt, index);
        return snbt[index];
    }

    inline std::string read_error(const CodePointVector& snbt, const size_t& index)
    {
        return write_utf8(CodePointVector(snbt.begin() + index, snbt.begin() + std::min(index + 10, snbt.size())));
    }

    inline std::pair<CodePointVector, bool> read_string(const CodePointVector& snbt, size_t& index)
    {
        size_t quote_code = read_code_point(snbt, index);
        if (quote_code == '"' || quote_code == '\'') {
            // quoted string
            index++;
            CodePointVector string;
            bool escaped = false;
            while (true) {
                size_t code = read_code_point(snbt, index);
                if (code == '\\') {
                    if (escaped) {
                        string.push_back('\\');
                        escaped = false;
                    } else {
                        escaped = true;
                    }
                } else if (code == quote_code) {
                    if (escaped) {
                        // found an escaped quote
                        string.push_back(quote_code);
                        escaped = false;
                    } else {
                        // found the closing quote
                        index++;
                        break;
                    }
                } else if (escaped) {
                    throw std::invalid_argument("Invalid escape sequence " + read_error(snbt, index - 1) + " at position " + std::to_string(index));
                } else {
                    string.push_back(code);
                }
                index++;
            }
            return std::make_pair(string, true);
        } else {
            // unquoted string
            size_t start = index;
            while (in_range(snbt, index) && AlphaNumPlus.contains(snbt[index])) {
                index++;
            }
            return std::make_pair(
                CodePointVector(snbt.begin() + start, snbt.begin() + index),
                false);
        }
    }

    inline void read_colon(const CodePointVector& snbt, size_t& index)
    {
        read_whitespace(snbt, index);
        if (read_code_point(snbt, index) != ':') {
            throw std::invalid_argument("Expected : at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
        }
        index++;
        read_whitespace(snbt, index);
    }

    inline void read_comma(const CodePointVector& snbt, size_t& index, unsigned char end_chr)
    {
        read_whitespace(snbt, index);
        size_t code = read_code_point(snbt, index);
        if (code == ',') {
            index++;
            read_whitespace(snbt, index);
        } else if (code != end_chr) {
            throw std::invalid_argument("Expected ',' or '" + std::string(1, end_chr) + "' at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
        }
    }

    inline std::pair<size_t, size_t> find_int(const CodePointVector& snbt, const size_t& index)
    {
        // Find an int at position index.
        // If an int is found, the return value will be the start and end position of the int
        // If a valid int was not found, the values will be equal.
        size_t start = index;
        size_t temp_index = index;
        if (in_range(snbt, temp_index) && (snbt[temp_index] == '+' || snbt[temp_index] == '-')) {
            // read past the sign
            temp_index++;
        }
        size_t number_start = temp_index;
        while (in_range(snbt, temp_index) && '0' <= snbt[temp_index] && snbt[temp_index] <= '9') {
            temp_index++;
        }
        if (temp_index == number_start) {
            // expected at least one number
            return std::make_pair(start, start);
        }
        return std::make_pair(start, temp_index);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteTagNative> || std::is_same_v<T, ShortTagNative> || std::is_same_v<T, IntTagNative> || std::is_same_v<T, LongTagNative>,
            bool>
        = true>
    inline T read_int(const CodePointVector& snbt, const size_t& start, const size_t& stop)
    {
        std::string text;
        write_utf8(text, CodePointVector(snbt.begin() + start, snbt.begin() + stop));
        return static_cast<T>(std::stoll(text));
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteTag> || std::is_same_v<T, ShortTag> || std::is_same_v<T, IntTag> || std::is_same_v<T, LongTag>,
            bool>
        = true>
    inline T read_int_tag(const CodePointVector& snbt, const size_t& start, const size_t& stop)
    {
        return T(read_int<typename T::native_type>(snbt, start, stop));
    }

    inline std::tuple<size_t, size_t, bool> find_float(const CodePointVector& snbt, const size_t& index)
    {
        // Find a float at position index.
        // If an float is found, the return value will be the start and end position of the float
        // If a valid float was not found, the values will be equal.
        size_t start = index;
        size_t temp_index = index;
        // read optional sign
        if (in_range(snbt, temp_index) && (snbt[temp_index] == '+' || snbt[temp_index] == '-')) {
            temp_index++;
        }
        size_t whole_start = temp_index;
        // read leading numbers
        while (in_range(snbt, temp_index) && '0' <= snbt[temp_index] && snbt[temp_index] <= '9') {
            temp_index++;
        }
        size_t whole_end = temp_index;
        // read decimal
        bool needs_code = true;
        if (in_range(snbt, temp_index) && snbt[temp_index] == '.') {
            needs_code = false;
            temp_index++;
            size_t decimal_start = temp_index;
            while (in_range(snbt, temp_index) && '0' <= snbt[temp_index] && snbt[temp_index] <= '9') {
                temp_index++;
            }
            if (decimal_start == temp_index && whole_start == whole_end) {
                // no whole or decimal numbers
                return std::make_tuple(start, start, false);
            }
        } else if (whole_start == whole_end) {
            // no decimal so there must be at least one whole number
            return std::make_tuple(start, start, false);
        }
        // read optional exponent
        if (in_range(snbt, temp_index) && (snbt[temp_index] | 32) == 'e') {
            temp_index++;
            // read optional sign
            if (in_range(snbt, temp_index) && (snbt[temp_index] == '+' || snbt[temp_index] == '-')) {
                temp_index++;
            }
            size_t exp_start = temp_index;
            while (in_range(snbt, temp_index) && '0' <= snbt[temp_index] && snbt[temp_index] <= '9') {
                temp_index++;
            }
            if (exp_start == temp_index) {
                // if exponent is defined there must be a number.
                return std::make_tuple(start, start, false);
            }
        }
        return std::make_tuple(start, temp_index, needs_code);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, FloatTag> || std::is_same_v<T, DoubleTag>,
            bool>
        = true>
    inline T read_float(const CodePointVector& snbt, size_t start, size_t stop)
    {
        std::string text;
        write_utf8(text, CodePointVector(snbt.begin() + start, snbt.begin() + stop));
        if constexpr (std::is_same_v<T, DoubleTag>) {
            return std::stod(text);
        } else {
            return std::stof(text);
        }
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteArrayTag> || std::is_same_v<T, IntArrayTag> || std::is_same_v<T, LongArrayTag>,
            bool>
        = true>
    inline TagNode read_array(const CodePointVector& snbt, size_t& index)
    {
        // The caller must have read [ and validated B; but not read it (index must be after "[")

        // read past B;
        index += 2;
        read_whitespace(snbt, index);
        std::vector<typename T::value_type> arr;
        while (read_code_point(snbt, index) != ']') {
            // read the number
            auto [start, stop] = find_int(snbt, index);
            if (start == stop) {
                throw std::invalid_argument("Expected a ] or int at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
            }
            if constexpr (std::is_same_v<T, ByteArrayTag>) {
                if ((read_code_point(snbt, stop) | 32) != 'b') {
                    throw std::invalid_argument("Expected 'B' position " + std::to_string(stop) + " but got ->" + read_error(snbt, stop) + " instead");
                }
                index = stop + 1;
            } else if constexpr (std::is_same_v<T, LongArrayTag>) {
                if ((read_code_point(snbt, stop) | 32) != 'l') {
                    throw std::invalid_argument("Expected 'L' position " + std::to_string(stop) + " but got ->" + read_error(snbt, stop) + " instead");
                }
                index = stop + 1;
            } else {
                index = stop;
            }

            // read and append the value
            arr.push_back(read_int<typename T::value_type>(snbt, start, stop));

            // Read past the comma
            read_comma(snbt, index, ']');
        }
        index++; // seek past ']'
        return std::make_shared<T>(arr.begin(), arr.end());
    }

    TagNode _decode_snbt(const CodePointVector& snbt, size_t& index)
    {
        read_whitespace(snbt, index);
        switch (read_code_point(snbt, index)) {
        case '{':
            // CompoundTag
            {
                index++;
                read_whitespace(snbt, index);
                CompoundTagPtr tag_ptr = std::make_shared<CompoundTag>();
                CompoundTag& tag = *tag_ptr;
                while (read_code_point(snbt, index) != '}') {
                    // read the key
                    std::string key = write_utf8(read_string(snbt, index).first);

                    // Read past the colon
                    read_colon(snbt, index);

                    // Read the nested value
                    TagNode node = _decode_snbt(snbt, index);

                    // Write to the map
                    tag[key] = node;

                    // Read past the comma
                    read_comma(snbt, index, '}');
                }
                index++; // seek past '}'
                return tag_ptr;
            }
        case '[':
            index++;
            read_whitespace(snbt, index);
            if (snbt.size() >= index + 2) {
                if (snbt[index] == 'B' && snbt[index + 1] == ';') {
                    // byte array
                    return read_array<ByteArrayTag>(snbt, index);
                } else if (snbt[index] == 'I' && snbt[index + 1] == ';') {
                    // int array
                    return read_array<IntArrayTag>(snbt, index);
                } else if (snbt[index] == 'L' && snbt[index + 1] == ';') {
                    // long array
                    return read_array<LongArrayTag>(snbt, index);
                } else {
                    // list
                    auto tag = std::make_shared<ListTag>();
                    while (read_code_point(snbt, index) != ']') {
                        // read the value
                        auto value = _decode_snbt(snbt, index);

                        if (tag->index() != 0 && tag->index() != value.index() + 1) {
                            throw std::invalid_argument("All elements of a list tag must have the same type.");
                        }

                        ListTag_append<TagNode>(*tag, value);

                        // Read past the comma
                        read_comma(snbt, index, ']');
                    }
                    index++; // seek past ']'
                    return tag;
                }
            } else if (read_code_point(snbt, index) == ']') {
                // empty list
                index++;
                return std::make_shared<ListTag>();
            }
        default: {
            auto [string, is_quoted] = read_string(snbt, index);
            if (is_quoted) {
                return write_utf8(string);
            }
            if (string.empty()) {
                throw std::invalid_argument("Expected data matching [A-Za-z0-9._+-]+ at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
            }
            if (
                string.size() == 4 && (string[0] | 32) == 't' && (string[1] | 32) == 'r' && (string[2] | 32) == 'u' && (string[3] | 32) == 'e') {
                return byte_true;
            }
            if (
                string.size() == 5 && (string[0] | 32) == 'f' && (string[1] | 32) == 'a' && (string[2] | 32) == 'l' && (string[3] | 32) == 's' && (string[4] | 32) == 'e') {
                return byte_false;
            }

            // try matching an int
            auto [int_start, int_stop] = find_int(string, 0);
            if (int_stop == string.size()) {
                // found an int that takes the whole string
                return read_int_tag<IntTag>(string, int_start, int_stop);
            } else if (int_start != int_stop && int_stop == string.size() - 1) {
                switch (string[string.size() - 1] | 32) {
                case 'b':
                    return read_int_tag<ByteTag>(string, int_start, int_stop);
                case 's':
                    return read_int_tag<ShortTag>(string, int_start, int_stop);
                case 'l':
                    return read_int_tag<LongTag>(string, int_start, int_stop);
                }
            }

            // if not an int, try matching a float
            auto [float_start, float_stop, needs_code] = find_float(string, 0);
            if (float_stop == string.size()) {
                // found a float that takes the whole string
                if (!needs_code) {
                    return read_float<DoubleTag>(string, float_start, float_stop);
                }
            } else if (float_start != float_stop && float_stop == string.size() - 1) {
                switch (string[string.size() - 1] | 32) {
                case 'f':
                    return read_float<FloatTag>(string, float_start, float_stop);
                case 'd':
                    return read_float<DoubleTag>(string, float_start, float_stop);
                }
            }

            // if none of the above, return as string
            return write_utf8(string);
        }
        }
#if defined(_MSC_VER) && !defined(__clang__) // MSVC
        __assume(false);
#else // GCC, Clang
        __builtin_unreachable();
#endif
    }

    TagNode decode_snbt(const CodePointVector& snbt)
    {
        size_t index = 0;
        return _decode_snbt(snbt, index);
    }

    TagNode decode_snbt(std::string_view snbt)
    {
        CodePointVector code_points = read_utf8_escape(snbt);
        return decode_snbt(code_points);
    }
} // namespace NBT
} // namespace Amulet
