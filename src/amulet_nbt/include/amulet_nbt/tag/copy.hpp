#pragma once

#include <memory>
#include <type_traits>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/list.hpp>

namespace Amulet {
    template <typename T>
    std::shared_ptr<T> NBTTag_copy(const T& tag){
        return std::make_shared<T>(tag);
    }

    Amulet::ListTagPtr NBTTag_deep_copy_list(const Amulet::ListTag& tag);
    Amulet::TagNode NBTTag_deep_copy_node(const Amulet::TagNode& tag);
    Amulet::CompoundTagPtr NBTTag_deep_copy_compound(const Amulet::CompoundTag& tag);
}
