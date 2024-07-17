#pragma once

#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>
#include <unordered_map>
#include <variant>
#include <memory>
#include "array.hpp"

namespace AmuletNBT {
    // Base types
    typedef std::int8_t ByteTag;
    typedef std::int16_t ShortTag;
    typedef std::int32_t IntTag;
    typedef std::int64_t LongTag;
    typedef float FloatTag;
    typedef double DoubleTag;
    typedef ArrayTag<ByteTag> ByteArrayTag;
    typedef std::string StringTag;
    class ListTag;
    class CompoundTag;
    typedef ArrayTag<IntTag> IntArrayTag;
    typedef ArrayTag<LongTag> LongArrayTag;

    // Pointer types
    typedef std::shared_ptr<ListTag> ListTagPtr;
    typedef std::shared_ptr<CompoundTag> CompoundTagPtr;
    typedef std::shared_ptr<ByteArrayTag> ByteArrayTagPtr;
    typedef std::shared_ptr<IntArrayTag> IntArrayTagPtr;
    typedef std::shared_ptr<LongArrayTag> LongArrayTagPtr;

    // List types
    typedef std::vector<ByteTag> ByteListTag;
    typedef std::vector<ShortTag> ShortListTag;
    typedef std::vector<IntTag> IntListTag;
    typedef std::vector<LongTag> LongListTag;
    typedef std::vector<FloatTag> FloatListTag;
    typedef std::vector<DoubleTag> DoubleListTag;
    typedef std::vector<ByteArrayTagPtr> ByteArrayListTag;
    typedef std::vector<StringTag> StringListTag;
    typedef std::vector<ListTagPtr> ListListTag;
    typedef std::vector<CompoundTagPtr> CompoundListTag;
    typedef std::vector<IntArrayTagPtr> IntArrayListTag;
    typedef std::vector<LongArrayTagPtr> LongArrayListTag;

    class ListTag : public std::variant<
        std::monostate,
        ByteListTag,
        ShortListTag,
        IntListTag,
        LongListTag,
        FloatListTag,
        DoubleListTag,
        ByteArrayListTag,
        StringListTag,
        ListListTag,
        CompoundListTag,
        IntArrayListTag,
        LongArrayListTag
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
        ByteArrayTagPtr,
        StringTag,
        ListTagPtr,
        CompoundTagPtr,
        IntArrayTagPtr,
        LongArrayTagPtr
    > TagNode;

    class CompoundTag : public std::unordered_map<std::string, TagNode> {
        using unordered_map::unordered_map;
    };

    class NamedTag {
        public:
            std::string name;
            TagNode tag_node;

            NamedTag(const std::string& name, const TagNode& tag_node): name(name), tag_node(tag_node) {}
    };

    #define FOR_EACH_LIST_TAG(MACRO)\
        MACRO(1,   "byte",        ByteTag,       AmuletNBT::ByteTag,          AmuletNBT::ByteListTag)\
        MACRO(2,   "short",       ShortTag,      AmuletNBT::ShortTag,         AmuletNBT::ShortListTag)\
        MACRO(3,   "int",         IntTag,        AmuletNBT::IntTag,           AmuletNBT::IntListTag)\
        MACRO(4,   "long",        LongTag,       AmuletNBT::LongTag,          AmuletNBT::LongListTag)\
        MACRO(5,   "float",       FloatTag,      AmuletNBT::FloatTag,         AmuletNBT::FloatListTag)\
        MACRO(6,   "double",      DoubleTag,     AmuletNBT::DoubleTag,        AmuletNBT::DoubleListTag)\
        MACRO(7,   "byte_array",  ByteArrayTag,  AmuletNBT::ByteArrayTagPtr,  AmuletNBT::ByteArrayListTag)\
        MACRO(8,   "string",      StringTag,     AmuletNBT::StringTag,        AmuletNBT::StringListTag)\
        MACRO(9,   "list",        ListTag,       AmuletNBT::ListTagPtr,       AmuletNBT::ListListTag)\
        MACRO(10,  "compound",    CompoundTag,   AmuletNBT::CompoundTagPtr,   AmuletNBT::CompoundListTag)\
        MACRO(11,  "int_array",   IntArrayTag,   AmuletNBT::IntArrayTagPtr,   AmuletNBT::IntArrayListTag)\
        MACRO(12,  "long_array",  LongArrayTag,  AmuletNBT::LongArrayTagPtr,  AmuletNBT::LongArrayListTag)

    #define FOR_EACH_LIST_TAG2(MACRO)\
        MACRO(0, "end", std::monostate, std::monostate, std::monostate)\
        FOR_EACH_LIST_TAG(MACRO)
}

namespace std {
    template <> struct variant_size<AmuletNBT::ListTag>: std::variant_size<AmuletNBT::ListTag::variant> {};
    template <std::size_t I> struct variant_alternative<I, AmuletNBT::ListTag> : variant_alternative<I, AmuletNBT::ListTag::variant> {};
}
