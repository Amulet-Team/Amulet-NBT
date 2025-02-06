#pragma once

#include <memory>
#include <type_traits>
#include <variant>
#include <set>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/export.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/tag/string.hpp>

namespace AmuletNBT {

template <typename T>
    requires std::is_same_v<T, AmuletNBT::ByteTag>
    || std::is_same_v<T, AmuletNBT::ShortTag>
    || std::is_same_v<T, AmuletNBT::IntTag>
    || std::is_same_v<T, AmuletNBT::LongTag>
    || std::is_same_v<T, AmuletNBT::FloatTag>
    || std::is_same_v<T, AmuletNBT::DoubleTag>
    || std::is_same_v<T, AmuletNBT::StringTag>
    || std::is_same_v<T, AmuletNBT::ListTag>
    || std::is_same_v<T, AmuletNBT::CompoundTag>
    || std::is_same_v<T, AmuletNBT::ByteArrayTag>
    || std::is_same_v<T, AmuletNBT::IntArrayTag>
    || std::is_same_v<T, AmuletNBT::LongArrayTag>
    || std::is_same_v<T, AmuletNBT::TagNode>
    || std::is_same_v<T, AmuletNBT::NamedTag>
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
    requires std::is_same_v<T, AmuletNBT::ByteTag>
    || std::is_same_v<T, AmuletNBT::ShortTag>
    || std::is_same_v<T, AmuletNBT::IntTag>
    || std::is_same_v<T, AmuletNBT::LongTag>
    || std::is_same_v<T, AmuletNBT::FloatTag>
    || std::is_same_v<T, AmuletNBT::DoubleTag>
    || std::is_same_v<T, AmuletNBT::StringTag>
    || std::is_same_v<T, AmuletNBT::ByteArrayTag>
    || std::is_same_v<T, AmuletNBT::IntArrayTag>
    || std::is_same_v<T, AmuletNBT::LongArrayTag>
T deep_copy_2(const T& tag, std::set<size_t>& memo)
{
    return tag;
}

AMULET_NBT_EXPORT AmuletNBT::ListTag deep_copy_2(const AmuletNBT::ListTag&, std::set<size_t>& memo);
AMULET_NBT_EXPORT AmuletNBT::CompoundTag deep_copy_2(const AmuletNBT::CompoundTag&, std::set<size_t>& memo);
AMULET_NBT_EXPORT AmuletNBT::TagNode deep_copy_2(const AmuletNBT::TagNode&, std::set<size_t>& memo);
AMULET_NBT_EXPORT AmuletNBT::NamedTag deep_copy_2(const AmuletNBT::NamedTag&, std::set<size_t>& memo);

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
auto deep_copy(const T& obj) {
    std::set<size_t> memo;
    return deep_copy_2(obj, memo);
}

} // namespace AmuletNBT
