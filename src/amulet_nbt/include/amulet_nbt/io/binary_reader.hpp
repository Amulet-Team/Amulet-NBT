#pragma once

#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <algorithm>
#include <bit>
#include <functional>
#include <stdexcept>


namespace AmuletNBT {
    typedef std::function<std::string(const std::string&)> StringDecode;


    class BinaryReader {
    protected:
        const std::string& data;
        size_t& position;
        std::endian endianness;
        StringDecode string_decode;

    public:
        BinaryReader(
            const std::string& input,
            size_t& position,
            std::endian endianness,
            StringDecode string_decode
        )
            : data(input), position(position), endianness(endianness), string_decode(string_decode) {}

        /**
         * Read a numeric type from the buffer into the given value and fix its endianness.
         */
        template <typename T> inline void readNumericInto(T& value) {
            // Ensure the buffer is long enough
            if (position + sizeof(T) > data.size()) {
                throw std::out_of_range(std::string("Cannot read ") + typeid(T).name() + " at position " + std::to_string(position));
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

        // Read length bytes, decode and return.
        std::string readString(size_t length) {
            // Ensure the buffer is long enough
            if (position + length > data.size()) {
                throw std::out_of_range("Cannot read string at position " + std::to_string(position));
            }

            std::string value = data.substr(position, length);
            position += length;
            return string_decode(value);
        }

        // Get the current read position.
        size_t getPosition(){
            return position;
        }

        // Is there more unread data.
        bool has_more_data(){
            return position < data.size();
        }
    };
}
