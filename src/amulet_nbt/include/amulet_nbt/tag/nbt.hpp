#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <unordered_map>
#include <variant>
#include <memory>
#include "array.hpp"

namespace Amulet {
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
    typedef std::vector<ByteTag> ByteList;
    typedef std::vector<ShortTag> ShortList;
    typedef std::vector<IntTag> IntList;
    typedef std::vector<LongTag> LongList;
    typedef std::vector<FloatTag> FloatList;
    typedef std::vector<DoubleTag> DoubleList;
    typedef std::vector<ByteArrayTagPtr> ByteArrayList;
    typedef std::vector<StringTag> StringList;
    typedef std::vector<ListTagPtr> ListList;
    typedef std::vector<CompoundTagPtr> CompoundList;
    typedef std::vector<IntArrayTagPtr> IntArrayList;
    typedef std::vector<LongArrayTagPtr> LongArrayList;

    class ListTag : public std::variant<
        std::monostate,
        ByteList,
        ShortList,
        IntList,
        LongList,
        FloatList,
        DoubleList,
        ByteArrayList,
        StringList,
        ListList,
        CompoundList,
        IntArrayList,
        LongArrayList
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
}
