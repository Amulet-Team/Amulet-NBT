#pragma once

#include <memory>
#include <string>
#include <unordered_map>
#include <variant>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
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
        LongArrayTagPtr>
        TagNode;

    typedef std::unordered_map<std::string, TagNode> CompoundTagNative;

    class CompoundTag : public CompoundTagNative, public AbstractBaseMutableTag {
        using unordered_map::unordered_map;
    };

    static_assert(std::is_copy_constructible_v<CompoundTag>, "CompoundTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<CompoundTag>, "CompoundTag is not copy assignable");

    template <>
    struct tag_id<CompoundTag> {
        static constexpr std::uint8_t value = 10;
    };
    template <>
    struct tag_id<CompoundTagPtr> {
        static constexpr std::uint8_t value = 10;
    };
} // namespace NBT
} // namespace Amulet
