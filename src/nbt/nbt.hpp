#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <unordered_map>
#include <variant>
#include <memory>
#include "array.hpp"


typedef std::int8_t ByteTag;
typedef std::int16_t ShortTag;
typedef std::int32_t IntTag;
typedef std::int64_t LongTag;
typedef float FloatTag;
typedef double DoubleTag;
typedef std::string StringTag;
class ListTag;
class CompoundTag;
typedef Array<ByteTag> ByteArrayTag;
typedef Array<IntTag> IntArrayTag;
typedef Array<LongTag> LongArrayTag;

typedef std::shared_ptr<ListTag> ListTagPtr;
typedef std::shared_ptr<CompoundTag> CompoundTagPtr;
typedef std::shared_ptr<ByteArrayTag> ByteArrayTagPtr;
typedef std::shared_ptr<IntArrayTag> IntArrayTagPtr;
typedef std::shared_ptr<LongArrayTag> LongArrayTagPtr;

class ListTag : public std::variant<
    std::monostate,
    std::vector<ByteTag>,
    std::vector<ShortTag>,
    std::vector<IntTag>,
    std::vector<LongTag>,
    std::vector<FloatTag>,
    std::vector<DoubleTag>,
    std::vector<StringTag>,
    std::vector<ListTagPtr>,
    std::vector<CompoundTagPtr>,
    std::vector<ByteArrayTagPtr>,
    std::vector<IntArrayTagPtr>,
    std::vector<LongArrayTagPtr>
> {
    using variant::variant;
};

typedef std::variant<
    std::monostate,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTagPtr,
    CompoundTagPtr,
    ByteArrayTagPtr,
    IntArrayTagPtr,
    LongArrayTagPtr
> TagNode;

class CompoundTag : public std::unordered_map<std::string, TagNode> {
    using unordered_map::unordered_map;
};
