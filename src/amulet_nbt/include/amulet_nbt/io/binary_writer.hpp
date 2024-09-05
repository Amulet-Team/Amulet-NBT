#pragma once

#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <algorithm>
#include <bit>
#include <functional>


namespace AmuletNBT {
    typedef std::function<std::string(const std::string&)> StringEncode;


    class BinaryWriter {
    protected:
        std::string data;
        std::endian endianness;
        StringEncode string_encode;

    public:
        BinaryWriter(
            std::endian endianness,
            StringEncode string_encode
        ) : endianness(endianness), string_encode(string_encode) {}

        /**
         * Fix the endianness of the numeric value and write it to the buffer.
         */
        template <typename T> void writeNumeric(const T& value) {
            if (endianness == std::endian::native) {
                data.append((char*)&value, sizeof(T));
            }
            else {
                T value_reverse;
                char* src = (char*)&value;
                char* dst = (char*)&value_reverse;
                for (size_t i = 0; i < sizeof(T); i++) {
                    dst[i] = src[sizeof(T) - i - 1];
                }
                data.append(dst, sizeof(T));
            }
        }

        // Encode and return a string.
        std::string encodeString(const std::string& value) {
            return string_encode(value);
        }

        // Write a string without encoding or prefixed size.
        void writeBytes(const std::string& value) {
            data.append(value);
        }

        const std::string& getBuffer(){
            return data;
        }
    };
}
