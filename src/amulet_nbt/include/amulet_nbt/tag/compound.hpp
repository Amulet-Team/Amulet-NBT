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

    typedef std::unordered_map<std::string, TagNode> CompoundTagNative;

    class CompoundTag: public CompoundTagNative, public AbstractBaseMutableTag{
        using unordered_map::unordered_map;
    };

    static_assert(std::is_copy_constructible_v<CompoundTag>, "CompoundTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<CompoundTag>, "CompoundTag is not copy assignable");

    template<> struct tag_id<CompoundTag> { static constexpr std::uint8_t value = 10; };
    template<> struct tag_id<CompoundTagPtr> { static constexpr std::uint8_t value = 10; };
}
