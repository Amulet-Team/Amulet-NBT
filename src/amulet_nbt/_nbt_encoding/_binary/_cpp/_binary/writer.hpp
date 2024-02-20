#pragma once

#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <algorithm>
#include <bit>
#include <functional>


typedef std::function<std::string(const std::string&)> StringEncode;


class BinaryWriter {
private:
    std::string data;
    std::endian endianness;
    StringEncode stringEncode;

public:
    BinaryWriter(
        std::endian endianness,
        StringEncode stringEncode
    ) : endianness(endianness), stringEncode(stringEncode) {}

    /**
     * Fix the endianness of the numeric value and write it to the buffer.
     */
    template <typename T> inline void writeNumeric(const T& value) {
        // Create
        char* src = (char*)&value;

        // Copy
        if (endianness == std::endian::native){
            data.append(src, sizeof(T));
        } else {
            for (size_t i = 0; i < sizeof(T); i++){
                data.push_back(src[sizeof(T) - i - 1]);
            }
        }
    }

    std::string encodeString(const std::string& value) {
        return stringEncode(value);
    }

    void writeString(const std::string& value) {
        data.append(value);
    }

    std::string getBuffer(){
        return data;
    }
};
