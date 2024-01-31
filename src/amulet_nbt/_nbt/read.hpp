#pragma once

#include <utility>
#include <string>
#include <bit>
#include <variant>

#include "../_binary/reader.hpp"
#include "nbt.hpp"
#include "array.hpp"

// Read a type byte followed by a name followed by a payload of that type
std::pair<std::string, TagNode> read_named_tag(BinaryReader&);
std::pair<std::string, TagNode> read_named_tag(const std::string&, std::endian);
