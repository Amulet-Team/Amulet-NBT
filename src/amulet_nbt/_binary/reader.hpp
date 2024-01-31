#pragma once

#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <algorithm>
#include <bit>
#include <format>


class BinaryReader {
private:
    const std::string& data;
    size_t position;
    std::endian endianness;

public:
    BinaryReader(const std::string& input, std::endian endianness)
        : data(input), position(0), endianness(endianness) {}

    /**
     * Read a numeric type from the buffer into the given value and fix its endianness.
     */
    template <typename T> inline void readNumericInto(T& value) {
        // Ensure the buffer is long enough
        if (position + sizeof(T) > data.size()) {
            throw std::out_of_range(std::format("Cannot read {} at position {}", typeid(T).name(), position));
        }

        // Create
        const char* src = &data[position];
        char* dst = (char*)&value;

        // Copy
        if (endianness == std::endian::native){
            for (size_t i = 0; i < sizeof(T); i++){
                dst[i] = src[i];
            }
        } else {
            for (size_t i = 0; i < sizeof(T); i++){
                dst[i] = src[sizeof(T) - i - 1];
            }
        }

        // Increment position
        position += sizeof(T);
    }

    /**
     * Read a numeric type from the buffer and fix its endianness.
     *
     * @return A value of the requested type.
     */
    template <typename T> inline T readNumeric() {
        T value;
        readNumericInto<T>(value);
        return value;
    }

    std::string readString(size_t length) {
        // Ensure the buffer is long enough
        if (position + length > data.size()) {
            throw std::out_of_range(std::format("Cannot read string at position {}", position));
        }

        std::string value = data.substr(position, length);
        position += length;
        return value;
    }
};