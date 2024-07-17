#pragma once

#include <memory>
#include <type_traits>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/list.hpp>

namespace AmuletNBT {
    template <typename T>
    std::shared_ptr<T> NBTTag_copy(const T& tag){
        return std::make_shared<T>(tag);
    }

    AmuletNBT::ListTagPtr NBTTag_deep_copy_list(const AmuletNBT::ListTag& tag);
    AmuletNBT::TagNode NBTTag_deep_copy_node(const AmuletNBT::TagNode& tag);
    AmuletNBT::CompoundTagPtr NBTTag_deep_copy_compound(const AmuletNBT::CompoundTag& tag);
}
