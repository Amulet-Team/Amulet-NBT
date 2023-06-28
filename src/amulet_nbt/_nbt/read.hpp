#include <utility>
#include <string>
#include <istream>

#include "nbt.hpp"
#include "../_endian/endian.hpp"
#include "array.hpp"

// Read a type byte followed by a name followed by a payload of that type
std::pair<std::string, TagNode> read_named_tag(std::istream stream, std::endian endianness);
