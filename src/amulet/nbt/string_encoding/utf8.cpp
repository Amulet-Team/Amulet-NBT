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

    const size_t HexChars[16] = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102 };

    inline void push_escape(CodePointVector& dst, const uint8_t& b)
    {
        dst.push_back(9243); // ␛
        dst.push_back(120); // x
        dst.push_back(HexChars[b >> 4]);
        dst.push_back(HexChars[b & 15]);
    }

    template <bool escapeErrors>
    CodePointVector _read_utf8(std::string_view src)
    {
        CodePointVector dst;

        for (size_t index = 0; index < src.size(); index++) {
            uint8_t b1 = src[index];

            if (b1 < 0b10000000) {
                // ASCII/1 byte codepoint.
                dst.push_back(b1 & 0b01111111);
            } else if ((b1 & 0b11100000) == 0b11000000) {
                // 2 byte codepoint.
                if (index + 1 >= src.size()) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("2-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
                    }
                }
                uint8_t b2 = src[index + 1];
                if ((b2 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("2-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
                    }
                }
                size_t value = (0b00011111 & b1) << 6 | (0b00111111 & b2);
                if (value < 0x80) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("2-byte codepoint at index " + std::to_string(index) + " has invalid value.");
                    }
                }
                dst.push_back(value);
                index++;
            } else if ((b1 & 0b11110000) == 0b11100000) {
                // 3 codepoint.
                if (index + 2 >= src.size()) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
                    }
                }
                uint8_t b2 = src[index + 1];
                if ((b2 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
                    }
                }
                uint8_t b3 = src[index + 2];
                if ((b3 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("3-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
                    }
                }
                size_t value = ((0b00001111 & b1) << 12) | ((0b00111111 & b2) << 6) | (0b00111111 & b3);
                if (value < 0x800 || (0xD800 <= value && value <= 0xDFFF)) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("3-byte codepoint at index " + std::to_string(index) + " has invalid value.");
                    }
                }
                dst.push_back(value);
                index += 2;
            } else if ((b1 & 0b11111000) == 0b11110000) {
                // 4 codepoint.
                if (index + 3 >= src.size()) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but input too short to finish.");
                    }
                }
                uint8_t b2 = src[index + 1];
                if ((b2 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 2 are incorrect.");
                    }
                }
                uint8_t b3 = src[index + 2];
                if ((b3 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 3 are incorrect.");
                    }
                }
                uint8_t b4 = src[index + 3];
                if ((b4 & 0b11000000) != 0b10000000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("4-byte codepoint started at index " + std::to_string(index) + ", but format bits of byte 4 are incorrect.");
                    }
                }
                size_t value = ((0b00000111 & b1) << 18) | ((0b00111111 & b2) << 12) | ((0b00111111 & b3) << 6) | (0b00111111 & b4);
                if (value < 0x10000) {
                    if constexpr (escapeErrors) {
                        push_escape(dst, b1);
                        continue;
                    } else {
                        throw std::invalid_argument("4-byte codepoint at index " + std::to_string(index) + " has invalid value.");
                    }
                }
                dst.push_back(value);
                index += 3;
            } else {
                if constexpr (escapeErrors) {
                    push_escape(dst, b1);
                    continue;
                } else {
                    throw std::invalid_argument("Invalid byte at index " + std::to_string(index));
                }
            }
        }
        return dst;
    }

    inline char char_to_hex(const size_t& c)
    {
        char index = -1;
        if (48 <= c && c <= 57) {
            index = c - 48;
        } else if (65 <= (c & ~0b0100000) && (c & ~0b0100000) <= 70) {
            index = (c & ~0b0100000) - 65 + 10;
        }
        return index;
    }

    template <bool escapeErrors>
    constexpr void _write_utf8(std::string& dst, const CodePointVector& src)
    {
        for (size_t index = 0; index < src.size(); index++) {
            const size_t& c = src[index];
            if (c <= 127) {
                dst.push_back(c & 0b01111111);
            } else if (c <= 2047) {
                dst.push_back(0b11000000 | (0b00011111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else if (c <= 65535) {
                if constexpr (escapeErrors) {
                    if (c == 9243 && src.size() >= index + 4 && src[index + 1] == 120) {
                        // If the array is long enough and contains the characters ␛x
                        char upper = char_to_hex(src[index + 2]);
                        if (upper >= 0) {
                            char lower = char_to_hex(src[index + 3]);
                            if (lower >= 0) {
                                // followed by two hex characters
                                dst.push_back((upper << 4) + lower);
                                index += 3;
                                continue;
                            }
                        }
                    }
                }
                if ((c >= 0xD800) && (c <= 0xDFFF)) {
                    throw std::invalid_argument("code point at index " + std::to_string(index) + " cannot be encoded.");
                }
                dst.push_back(0b11100000 | (0b00001111 & (c >> 12)));
                dst.push_back(0b10000000 | (0b00111111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else if (c <= 1114111) {
                dst.push_back(0b11110000 | (0b00000111 & (c >> 18)));
                dst.push_back(0b10000000 | (0b00111111 & (c >> 12)));
                dst.push_back(0b10000000 | (0b00111111 & (c >> 6)));
                dst.push_back(0b10000000 | (0b00111111 & c));
            } else {
                throw std::invalid_argument("Invalid code point at index " + std::to_string(index));
            }
        }
    }

    CodePointVector read_utf8(std::string_view src)
    {
        return _read_utf8<false>(src);
    }

    void write_utf8(std::string& dst, const CodePointVector& src)
    {
        _write_utf8<false>(dst, src);
    }

    std::string write_utf8(const CodePointVector& src)
    {
        std::string dst;
        _write_utf8<false>(dst, src);
        return dst;
    }

    CodePointVector read_utf8_escape(std::string_view src)
    {
        return _read_utf8<true>(src);
    }

    void write_utf8_escape(std::string& dst, const CodePointVector& src)
    {
        _write_utf8<true>(dst, src);
    }

    std::string write_utf8_escape(const CodePointVector& src)
    {
        std::string dst;
        _write_utf8<true>(dst, src);
        return dst;
    }

    // Validate a utf-8 byte sequence and convert to itself.
    std::string utf8_to_utf8(std::string_view src)
    {
        std::string dst;
        write_utf8(dst, read_utf8(src));
        return dst;
    }

    // Decode a utf-8 escape byte sequence to a regular utf-8 byte sequence
    std::string utf8_escape_to_utf8(std::string_view src)
    {
        std::string dst;
        write_utf8(dst, read_utf8_escape(src));
        return dst;
    }

    // Encode a regular utf-8 byte sequence to a utf-8 escape byte sequence
    std::string utf8_to_utf8_escape(std::string_view src)
    {
        std::string dst;
        write_utf8_escape(dst, read_utf8(src));
        return dst;
    }
} // namespace NBT
} // namespace Amulet
