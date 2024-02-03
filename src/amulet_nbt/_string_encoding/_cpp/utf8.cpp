// Partially based on the mutf8 python library by Tyler Kennedy <tk@tkte.ch> MIT
// Rewritten to stay within C++

#include <stdint.h>
#include <string>
#include <vector>
#include <stdexcept>


std::vector<size_t> read_utf8(std::string& src) {
    std::vector<size_t> dst;

    for (size_t index = 0; index < src.size(); index++) {
        uint8_t b1 = src[index];

        if (b1 < 0b10000000) {
            // ASCII/1 byte codepoint.
            dst.push_back(b1 & 0b01111111);
        }
        else if ((b1 & 0b11100000) == 0b11000000) {
            // 2 byte codepoint.
            if (index + 1 >= src.size()) {
                throw std::invalid_argument("2-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
            }
            uint8_t b2 = src[index + 1];
            if ((b2 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("2-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
            }
            size_t value = (0b00011111 & b1) << 6 | (0b00111111 & b2);
            if (0 < value && value < 0x80) {
                throw std::invalid_argument("2-byte codepoint at index " + std::to_string(index) + " has invalid value.");
            }
            dst.push_back(value);
            index++;
        }
        else if ((b1 & 0b11110000) == 0b11100000) {
            // 3 codepoint.
            if (index + 2 >= src.size()) {
                throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
            }
            uint8_t b2 = src[index + 1];
            uint8_t b3 = src[index + 2];

            if ((b2 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
            }
            if ((b3 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
            }
            size_t value = ((0b00001111 & b1) << 12) | ((0b00111111 & b2) << 6) | (0b00111111 & b3);
            if (value < 0x800 || (0xD800 <= value && value <= 0xDFFF)) {
                throw std::invalid_argument("3-byte codepoint at index " + std::to_string(index) + " has invalid value.");
            }
            dst.push_back(value);
            index += 2;
        }
        else if ((b1 & 0b11111000) == 0b11110000) {
            // 4 codepoint.
            if (index + 3 >= src.size()) {
                throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
            }
            uint8_t b2 = src[index + 1];
            uint8_t b3 = src[index + 2];
            uint8_t b4 = src[index + 3];

            if ((b2 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
            }
            if ((b3 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
            }
            if ((b4 & 0b11000000) != 0b10000000) {
                throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 4 are incorrect.");
            }
            size_t value = ((0b00000111 & b1) << 18) | ((0b00111111 & b2) << 12) | ((0b00111111 & b3) << 6) | (0b00111111 & b4);
            if (value < 0x10000) {
                throw std::invalid_argument("4-byte codepoint at index " + std::to_string(index) + " has invalid value.");
            }
            dst.push_back(value);
            index += 3;
        }
        else {
            throw std::invalid_argument("Invalid byte at index " + std::to_string(index));
        }
    }
    return dst;
}


void write_utf8(std::string &dst, std::vector<size_t> src) {
    for (size_t index = 0; index < src.size(); index++) {
        size_t& c = src[index];
        if (c <= 127) {
            dst.push_back(c & 0b01111111);
        }
        else if (c <= 2047) {
            dst.push_back(0b11000000 | 0b00011111 & (c >> 6));
            dst.push_back(0b10000000 | 0b00111111 & c);
        }
        else if (c <= 65535) {
            if ((c >= 0xD800) && (c <= 0xDFFF)){
                throw std::invalid_argument("code point at index " + std::to_string(index) + " cannot be encoded.");
            }
            dst.push_back(0b11100000 | 0b00001111 & (c >> 12));
            dst.push_back(0b10000000 | 0b00111111 & (c >> 6));
            dst.push_back(0b10000000 | 0b00111111 & c);
        }
        else if (c <= 1114111) {
            dst.push_back(0b11110000 | 0b00000111 & (c >> 18));
            dst.push_back(0b10000000 | 0b00111111 & (c >> 12));
            dst.push_back(0b10000000 | 0b00111111 & (c >> 6));
            dst.push_back(0b10000000 | 0b00111111 & c);
        }
        else {
            throw std::invalid_argument("Invalid code point at index " + std::to_string(index));
        }
    }
}


// Validate a utf-8 byte sequence and convert to itself.
std::string utf8_to_utf8(std::string& src) {
    std::string dst;
    write_utf8(dst, read_utf8(src));
    return dst;
}
