#pragma once

#include <variant>
#include <unordered_map>
#include <memory>
#include <string>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/array.hpp>

namespace AmuletNBT {
    class ListTag;
    typedef std::shared_ptr<ListTag> ListTagPtr;
    class CompoundTag;
    typedef std::shared_ptr<CompoundTag> CompoundTagPtr;

    typedef std::variant<
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

    class CompoundTag: public std::unordered_map<std::string, TagNode>, public AbstractBaseMutableTag{
        using unordered_map::unordered_map;
    };

    static_assert(std::is_copy_constructible_v<CompoundTag>, "CompoundTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<CompoundTag>, "CompoundTag is not copy assignable");

    template<> struct tag_id<CompoundTag> { static constexpr std::uint8_t value = 10; };
    template<> struct tag_id<CompoundTagPtr> { static constexpr std::uint8_t value = 10; };

    class CompoundTagIterator {
        private:
            AmuletNBT::CompoundTagPtr tag;
            const AmuletNBT::CompoundTag::iterator begin;
            const AmuletNBT::CompoundTag::iterator end;
            AmuletNBT::CompoundTag::iterator pos;
            size_t size;
        public:
            CompoundTagIterator(
                AmuletNBT::CompoundTagPtr tag
            ) : tag(tag), begin(tag->begin()), end(tag->end()), pos(tag->begin()), size(tag->size()) {};
            std::string next() {
                if (!is_valid()) {
                    throw std::runtime_error("CompoundTag changed size during iteration.");
                }
                return (pos++)->first;
            };
            bool has_next() {
                return pos != end;
            };
            bool is_valid() {
                // This is not fool proof.
                // There are cases where this is true but the iterator is invalid.
                // The programmer should write good code and this will catch some of the bad cases.
                return size == tag->size() && begin == tag->begin() && end == tag->end();
            };
    };
}
