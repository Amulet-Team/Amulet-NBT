// Partially based on the mutf8 python library by Tyler Kennedy <tk@tkte.ch> MIT
// Rewritten to stay within C++

#include <cstdint>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/string_encoding/string_encoding.hpp>

namespace Amulet {
namespace NBT {
    CodePointVector read_mutf8(std::string_view src)
    {
        CodePointVector dst;

        for (size_t index = 0; index < src.size(); index++) {
            uint8_t b1 = src[index];

            if (b1 == 0) {
                throw std::invalid_argument("Embedded NULL byte at index " + std::to_string(index));
            } else if (b1 < 0b10000000) {
                // ASCII/1 byte codepoint.
                dst.push_back(b1 & 0b01111111);
            } else if ((b1 & 0b11100000) == 0b11000000) {
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
            } else if ((b1 & 0b11110000) == 0b11100000) {
                // 3 or 6 byte codepoint.
                if (index + 2 >= src.size()) {
                    throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
                }
                uint8_t b2 = src[index + 1];
                uint8_t b3 = src[index + 2];

                if (b1 == 0b11101101 && (b2 & 0b11100000) == 0b10100000) {
                    if (index + 5 >= src.size()) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
                    }

                    uint8_t b4 = src[index + 3];
                    uint8_t b5 = src[index + 4];
                    uint8_t b6 = src[index + 5];
                    if ((b2 & 0b11110000) != 0b10100000) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
                    }
                    if ((b3 & 0b11000000) != 0b10000000) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
                    }
                    if (b4 != 0b11101101) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 4 are incorrect.");
                    }
                    if ((b5 & 0b11110000) != 0b10110000) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 5 are incorrect.");
                    }
                    if ((b6 & 0b11000000) != 0b10000000) {
                        throw std::invalid_argument("6-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 6 are incorrect.");
                    }
                    size_t value = 0x10000 + ((0b00001111 & b2) << 16 | (0b00111111 & b3) << 10 | (0b00001111 & b5) << 6 | (0b00111111 & b6));
                    if (value < 0x10000) {
                        throw std::invalid_argument("6-byte codepoint at index " + std::to_string(index) + " has invalid value.");
                    }
                    dst.push_back(value);
                    index += 5;
                } else {
                    if ((b2 & 0b11000000) != 0b10000000) {
                        throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
                    }
                    if ((b3 & 0b11000000) != 0b10000000) {
                        throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
                    }
                    size_t value = ((0b00001111 & b1) << 12) | ((0b00111111 & b2) << 6) | (0b00111111 & b3);
                    if (value < 0x800) {
                        throw std::invalid_argument("3-byte codepoint at index " + std::to_string(index) + " has invalid value.");
                    }
                    dst.push_back(value);
                    index += 2;
                }
            } else {
                throw std::invalid_argument("Invalid byte at index " + std::to_string(index));
            }
        }
        return dst;
    }

    void write_mutf8(std::string& dst, const CodePointVector& src)
    {
        for (size_t index = 0; index < src.size(); index++) {
            const size_t& c = src[index];
            if (c == 0) {
                dst.push_back(0xC0);
                dst.push_back(0x80);
            } else if (c <= 127) {
                dst.push_back(c & 0b01111111);
            } else if (c <= 2047) {
                dst.push_back(0b11000000 | (0b00011111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else if (c <= 65535) {
                if ((c >= 0xD800) && (c <= 0xDFFF)) {
                    throw std::invalid_argument("code point at index " + std::to_string(index) + " cannot be encoded.");
                }
                dst.push_back(0b11100000 | (0b00001111 & (c >> 12)));
                dst.push_back(0b10000000 | (0b00111111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else if (c <= 1114111) {
                dst.push_back(0b11101101);
                dst.push_back(0b10100000 | (0b00001111 & ((c >> 16) - 1)));
                dst.push_back(0b10000000 | (0b00111111 & (c >> 10)));
                dst.push_back(0b11101101);
                dst.push_back(0b10110000 | (0b00001111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else {
                throw std::invalid_argument("Invalid code point at index " + std::to_string(index));
            }
        }
    }

    std::string write_mutf8(const CodePointVector& src)
    {
        std::string dst;
        write_mutf8(dst, src);
        return dst;
    }

    // Decode a modified utf-8 byte sequence to a regular utf-8 byte sequence
    std::string mutf8_to_utf8(std::string_view src)
    {
        std::string dst;
        write_utf8(dst, read_mutf8(src));
        return dst;
    }

    // Encode a regular utf-8 byte sequence to a modified utf-8 byte sequence
    std::string utf8_to_mutf8(std::string_view src)
    {
        std::string dst;
        write_mutf8(dst, read_utf8(src));
        return dst;
    }
} // namespace NBT
} // namespace Amulet
