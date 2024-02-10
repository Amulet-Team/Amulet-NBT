#pragma once

#include <utility>
#include <string>
#include <bit>
#include <variant>

#include "_binary/reader.hpp"
#include "../../../_tag/_cpp/nbt.hpp"
#include "../../../_tag/_cpp/array.hpp"
#include "../../../_string_encoding/_cpp/utf8.hpp"
#include "../../../_string_encoding/_cpp/mutf8.hpp"

// Read a type byte followed by a name followed by a payload of that type
std::pair<std::string, TagNode> read_named_tag(BinaryReader&);
std::pair<std::string, TagNode> read_named_tag(const std::string&, std::endian, StringDecode, size_t&);
std::pair<std::string, TagNode> read_named_tag(const std::string&, std::endian, StringDecode);
