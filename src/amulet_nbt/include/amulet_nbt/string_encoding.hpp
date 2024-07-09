#pragma once

#include <string>
#include <vector>

namespace Amulet {
    // Functions to convert between code point vector and encoded formats
    typedef std::vector<size_t> CodePointVector;
    CodePointVector read_utf8(const std::string& src);
    void write_utf8(std::string &dst, const CodePointVector& src);
    CodePointVector read_utf8_escape(const std::string& src);
    void write_utf8_escape(std::string &dst, const CodePointVector& src);
    CodePointVector read_mutf8(const std::string &src);
    void write_mutf8(std::string& dst, const CodePointVector& src);

    // Functions to convert between the encoded formats.
    std::string utf8_to_utf8(const std::string& src);
    std::string utf8_escape_to_utf8(const std::string& src);
    std::string utf8_to_utf8_escape(const std::string& src);
    std::string mutf8_to_utf8(const std::string& src);
    std::string utf8_to_mutf8(const std::string& src);
}
