#pragma once

#include <string>
#include <string_view>
#include <vector>

#include <amulet/nbt/export.hpp>

namespace Amulet {
namespace NBT {
    typedef std::vector<size_t> CodePointVector;

    // Functions to convert between code point vector and encoded formats
    AMULET_NBT_EXPORT CodePointVector read_utf8(std::string_view src);
    AMULET_NBT_EXPORT CodePointVector read_utf8_escape(std::string_view src);
    AMULET_NBT_EXPORT CodePointVector read_mutf8(std::string_view src);

    AMULET_NBT_EXPORT void write_utf8(std::string& dst, const CodePointVector& src);
    AMULET_NBT_EXPORT void write_utf8_escape(std::string& dst, const CodePointVector& src);
    AMULET_NBT_EXPORT void write_mutf8(std::string& dst, const CodePointVector& src);

    AMULET_NBT_EXPORT std::string write_utf8(const CodePointVector& src);
    AMULET_NBT_EXPORT std::string write_utf8_escape(const CodePointVector& src);
    AMULET_NBT_EXPORT std::string write_mutf8(const CodePointVector& src);

    // Functions to convert between the encoded formats.
    AMULET_NBT_EXPORT std::string utf8_to_utf8(std::string_view src);
    AMULET_NBT_EXPORT std::string utf8_escape_to_utf8(std::string_view src);
    AMULET_NBT_EXPORT std::string utf8_to_utf8_escape(std::string_view src);
    AMULET_NBT_EXPORT std::string mutf8_to_utf8(std::string_view src);
    AMULET_NBT_EXPORT std::string utf8_to_mutf8(std::string_view src);
} // namespace NBT
} // namespace Amulet
