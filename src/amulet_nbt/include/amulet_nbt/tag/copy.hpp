#pragma once

#include <memory>
#include <type_traits>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>

namespace AmuletNBT {
    template <
        typename T,
        std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag> ||
        std::is_same_v<T, AmuletNBT::StringTag>,
        bool
        > = true
    >
    inline T NBTTag_copy(const T & tag) {
        return tag;
    }
    
    template <
        typename T,
        std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ListTag> ||
        std::is_same_v<T, AmuletNBT::CompoundTag> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTag> ||
        std::is_same_v<T, AmuletNBT::IntArrayTag> ||
        std::is_same_v<T, AmuletNBT::LongArrayTag>,
        bool
        > = true
    >
    inline std::shared_ptr<T> NBTTag_copy(const T& tag){
        return std::make_shared<T>(tag);
    }

    AmuletNBT::ListTagPtr NBTTag_deep_copy_list(const AmuletNBT::ListTag& tag);
    AmuletNBT::TagNode NBTTag_deep_copy_node(const AmuletNBT::TagNode& tag);
    AmuletNBT::CompoundTagPtr NBTTag_deep_copy_compound(const AmuletNBT::CompoundTag& tag);
}
