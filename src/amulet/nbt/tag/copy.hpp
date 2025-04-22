#pragma once

#include <memory>
#include <set>
#include <type_traits>
#include <variant>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/export.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {

    template <typename T>
        requires std::is_same_v<T, ByteTag>
        || std::is_same_v<T, ShortTag>
        || std::is_same_v<T, IntTag>
        || std::is_same_v<T, LongTag>
        || std::is_same_v<T, FloatTag>
        || std::is_same_v<T, DoubleTag>
        || std::is_same_v<T, StringTag>
        || std::is_same_v<T, ListTag>
        || std::is_same_v<T, CompoundTag>
        || std::is_same_v<T, ByteArrayTag>
        || std::is_same_v<T, IntArrayTag>
        || std::is_same_v<T, LongArrayTag>
        || std::is_same_v<T, TagNode>
        || std::is_same_v<T, NamedTag>
    T shallow_copy(const T& tag)
    {
        return tag;
    }

    template <typename T>
    std::unique_ptr<T> shallow_copy(const std::unique_ptr<T>& tag)
    {
        return std::make_unique<T>(shallow_copy(*tag));
    }

    template <typename T>
    std::shared_ptr<T> shallow_copy(const std::shared_ptr<T>& tag)
    {
        return std::make_shared<T>(shallow_copy(*tag));
    }

    template <typename T>
        requires std::is_same_v<T, ByteTag>
        || std::is_same_v<T, ShortTag>
        || std::is_same_v<T, IntTag>
        || std::is_same_v<T, LongTag>
        || std::is_same_v<T, FloatTag>
        || std::is_same_v<T, DoubleTag>
        || std::is_same_v<T, StringTag>
        || std::is_same_v<T, ByteArrayTag>
        || std::is_same_v<T, IntArrayTag>
        || std::is_same_v<T, LongArrayTag>
    T deep_copy_2(const T& tag, std::set<size_t>& memo)
    {
        return tag;
    }

    AMULET_NBT_EXPORT ListTag deep_copy_2(const ListTag&, std::set<size_t>& memo);
    AMULET_NBT_EXPORT CompoundTag deep_copy_2(const CompoundTag&, std::set<size_t>& memo);
    AMULET_NBT_EXPORT TagNode deep_copy_2(const TagNode&, std::set<size_t>& memo);
    AMULET_NBT_EXPORT NamedTag deep_copy_2(const NamedTag&, std::set<size_t>& memo);

    template <typename T>
    std::unique_ptr<T> deep_copy_2(const std::unique_ptr<T>& tag, std::set<size_t>& memo)
    {
        return std::make_unique<T>(deep_copy_2(*tag, memo));
    }

    template <typename T>
    std::shared_ptr<T> deep_copy_2(const std::shared_ptr<T>& tag, std::set<size_t>& memo)
    {
        return std::make_shared<T>(deep_copy_2(*tag, memo));
    }

    template <typename T>
    auto deep_copy(const T& obj)
    {
        std::set<size_t> memo;
        return deep_copy_2(obj, memo);
    }

} // namespace NBT
} // namespace Amulet
