#include <utility>
#include <string>
#include <istream>

#include "nbt.hpp"
#include "endian.hpp"
#include "array.hpp"

// read a tag of a specific type
ByteTag read_byte_tag(std::istream stream, std::endian endianness);
ShortTag read_short_tag(std::istream stream, std::endian endianness);
IntTag read_int_tag(std::istream stream, std::endian endianness);
LongTag read_long_tag(std::istream stream, std::endian endianness);
FloatTag read_float_tag(std::istream stream, std::endian endianness);
DoubleTag read_double_tag(std::istream stream, std::endian endianness);
StringTag read_string_tag(std::istream stream, std::endian endianness);
ListTagPtr read_list_tag(std::istream stream, std::endian endianness);
CompoundTagPtr read_compound_tag(std::istream stream, std::endian endianness);
ByteArrayTagPtr read_byte_array_tag(std::istream stream, std::endian endianness);
IntArrayTagPtr read_int_array_tag(std::istream stream, std::endian endianness);
LongArrayTagPtr read_long_array_tag(std::istream stream, std::endian endianness);

// Read a tag knowing the tag type enum.
TagNode read_node(std::istream stream, std::endian endianness, std::uint8_t tag_type);

// Read a type byte followed by a name followed by a payload of that type
std::pair<std::string, TagNode> read_named_tag();
