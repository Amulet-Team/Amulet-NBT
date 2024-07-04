#pragma once

#include <utility>
#include <string>
#include <bit>
#include <vector>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace Amulet {
    Amulet::NamedTag read_named_tag(const std::string&, std::endian, Amulet::StringDecode, size_t& offset);
    std::vector<Amulet::NamedTag> read_named_tags(const std::string&, std::endian, Amulet::StringDecode, size_t& offset);
    std::vector<Amulet::NamedTag> read_named_tags(const std::string&, std::endian, Amulet::StringDecode, size_t& offset, size_t count);

    template <typename T>
    std::string write_named_tag(const std::string&, const T&, std::endian, Amulet::StringEncode);

    std::string write_named_tag(const Amulet::NamedTag&, std::endian, Amulet::StringEncode);
}
