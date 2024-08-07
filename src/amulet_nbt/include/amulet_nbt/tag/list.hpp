#pragma once

#include <cstdint>
#include <memory>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>

namespace AmuletNBT {
    class ListTag;
    typedef std::shared_ptr<ListTag> ListTagPtr;
    class CompoundTag;
    typedef std::shared_ptr<CompoundTag> CompoundTagPtr;

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

    typedef std::variant<
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
    > ListTagNative;

    class ListTag: public ListTagNative, public AbstractBaseImmutableTag{
        using variant::variant;
    };

    static_assert(std::is_copy_constructible_v<ListTag>, "ListTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ListTag>, "ListTag is not copy assignable");

    template<> struct tag_id<ListTag> { static constexpr std::uint8_t value = 9; };
    template<> struct tag_id<ListTagPtr> { static constexpr std::uint8_t value = 9; };
}

namespace std {
    template <> struct variant_size<AmuletNBT::ListTag> : std::variant_size<AmuletNBT::ListTagNative> {};
    template <std::size_t I> struct variant_alternative<I, AmuletNBT::ListTag> : variant_alternative<I, AmuletNBT::ListTagNative> {};
}
