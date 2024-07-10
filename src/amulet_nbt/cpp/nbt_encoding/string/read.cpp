#include <set>
#include <stdexcept>
#include <algorithm>
#include <utility>
#include <type_traits>

#include <amulet_nbt/nbt_encoding/string.hpp>


const std::set<size_t> Whitespace{' ', '\t', '\r', '\n'};


inline bool in_range(const Amulet::CodePointVector& snbt, const size_t& index){
    return index < snbt.size();
}

inline bool in_range(const Amulet::CodePointVector& snbt, const size_t& index, const size_t count){
    return index + count - 1 < snbt.size();
}

inline bool bounds_check(const Amulet::CodePointVector& snbt, const size_t& index){
    if (in_range(snbt, index)){
        return true;
    }
    throw std::out_of_range("SNBT string is incomplete. Reached the end of the string.");
}

inline void read_whitespace(const Amulet::CodePointVector& snbt, size_t& index){
    while (in_range(snbt, index) && Whitespace.contains(snbt[index])){
        index++;
    }
}

inline size_t read_code_point(const Amulet::CodePointVector& snbt, const size_t& index){
    bounds_check(snbt, index);
    return snbt[index];
}

inline std::pair<std::string, bool> read_string(const Amulet::CodePointVector& snbt, size_t& index){
    throw std::exception("not implemented");
}

inline std::string read_error(const Amulet::CodePointVector& snbt, size_t& index){
    return Amulet::write_utf8(Amulet::CodePointVector(snbt.begin() + index, snbt.begin() + std::min(index + 10, snbt.size())));
}

inline void read_colon(const Amulet::CodePointVector& snbt, size_t& index){
    read_whitespace(snbt, index);
    if (read_code_point(snbt, index) != ':'){
        throw std::invalid_argument("Expected : at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
    }
    index++;
    read_whitespace(snbt, index);
}

inline void read_comma(const Amulet::CodePointVector& snbt, size_t& index, unsigned char end_chr){
    read_whitespace(snbt, index);
    size_t code = read_code_point(snbt, index);
    if (code == ','){
        index++;
        read_whitespace(snbt, index);
    } else if (code != end_chr){
        throw std::invalid_argument("Expected ',' or '" + std::string(1, end_chr) + "' at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
    }
}


inline std::pair<size_t, size_t> find_int(const Amulet::CodePointVector& snbt, const size_t& index){
    // Find an int at position index.
    // If an int is found the return value will be the start and end position of the int
    // If a valid int was not found the values will be equal.
    size_t start = index;
    size_t temp_index = index;
    if (in_range(snbt, temp_index) && (snbt[temp_index] == '+' || snbt[temp_index] == '-')){
        // read past the sign
        temp_index++;
    }
    size_t number_start = temp_index;
    while (in_range(snbt, temp_index) && '0' <= snbt[temp_index] && snbt[temp_index] <= '9'){
        temp_index++;
    }
    if (temp_index == number_start){
        // expected at least one number
        return std::make_pair(start, start);
    }
    return std::make_pair(start, temp_index);
}


template <typename T>
inline T read_int(const Amulet::CodePointVector& snbt, size_t start, size_t stop){
    std::string text;
    Amulet::write_utf8(text, Amulet::CodePointVector(snbt.begin() + start, snbt.begin() + stop));
    return static_cast<T>(std::stoll(text));
}


template <typename T>
inline Amulet::TagNode read_array(const Amulet::CodePointVector& snbt, size_t& index){
    //The caller must have read [ and validated B; but not read it (index must be after "[")

    // read past B;
    index += 2;
    read_whitespace(snbt, index);
    std::vector<T> arr;
    while (read_code_point(snbt, index) != ']'){
        // read the number
        auto [start, stop] = find_int(snbt, index);
        if (start == stop){
            throw std::invalid_argument("Expected a ] or int at position " + std::to_string(index) + " but got ->" + read_error(snbt, index) + " instead");
        }
        if constexpr (std::is_same_v<T, Amulet::ByteTag>){
            if ((read_code_point(snbt, stop) & ~32) != 'B'){
                throw std::invalid_argument("Expected 'B' position " + std::to_string(stop) + " but got ->" + read_error(snbt, index) + " instead");
            }
            index = stop + 1;
        } else if constexpr (std::is_same_v<T, Amulet::LongTag>){
            if ((read_code_point(snbt, stop) & ~32) != 'L'){
                throw std::invalid_argument("Expected 'L' position " + std::to_string(stop) + " but got ->" + read_error(snbt, index) + " instead");
            }
            index = stop + 1;
        } else {
            index = stop;
        }

        // read and append the value
        arr.push_back(read_int<T>(snbt, start, stop));

        // Read past the comma
        read_comma(snbt, index, ']');
    }
    return std::make_shared<Amulet::ArrayTag<T>>(arr.begin(), arr.end());
}


Amulet::TagNode _read_snbt(const Amulet::CodePointVector& snbt, size_t& index){
    read_whitespace(snbt, index);
    switch (read_code_point(snbt, index)){
        case '{':
            // CompoundTag
            {
                index++;
                read_whitespace(snbt, index);
                auto tag = std::make_shared<Amulet::CompoundTag>();
                while (read_code_point(snbt, index) != '}'){
                    // read the key
                    std::string key = read_string(snbt, index).first;

                    // Read past the colon
                    read_colon(snbt, index);

                    // Read the nested value
                    (*tag)[key] = _read_snbt(snbt, index);

                    // Read past the comma
                    read_comma(snbt, index, '}');
                }
                index++;  // seek past '{'
                return tag;
            }
        case '[':
            index++;
            read_whitespace(snbt, index);
            if (snbt.size() >= index + 2){
                if (snbt[index] == 'B' && snbt[index+1] == ';'){
                    // byte array
                    return read_array<Amulet::ByteTag>(snbt, index);
                } else if (snbt[index] == 'I' && snbt[index+1] == ';'){
                    // int array
                    return read_array<Amulet::IntTag>(snbt, index);
                } else if (snbt[index] == 'L' && snbt[index+1] == ';'){
                    // long array
                    return read_array<Amulet::LongTag>(snbt, index);
                } else {
                    // list
                    throw std::exception("not implemented");
                }
            } else if (read_code_point(snbt, index) == ']'){
                // empty list
                index++;
                return std::make_shared<Amulet::ListTag>();
            }
        default:
            throw std::exception("not implemented");
    }
}


Amulet::TagNode Amulet::read_snbt(const Amulet::CodePointVector& snbt){
    size_t index = 0;
    return _read_snbt(snbt, index);
}


Amulet::TagNode Amulet::read_snbt(const std::string& snbt){
    Amulet::CodePointVector code_points = Amulet::read_utf8_escape(snbt);
    return Amulet::read_snbt(code_points);
}
