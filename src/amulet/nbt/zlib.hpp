#pragma once

#include <string>
#include <string_view>

#include <amulet/nbt/export.hpp>

namespace Amulet {
namespace NBT {

    // Decompress zlib or gzip compressed data from src into dst.
    AMULET_NBT_EXPORT void decompress_zlib_gzip(const std::string_view src, std::string& dst);

    // Compress the data in src in zlib format and append to dst.
    AMULET_NBT_EXPORT void compress_zlib(const std::string_view src, std::string& dst);

    // Compress the data in src in gzip format and append to dst.
    AMULET_NBT_EXPORT void compress_gzip(const std::string_view src, std::string& dst);

} // namespace NBT
} // namespace Amulet
