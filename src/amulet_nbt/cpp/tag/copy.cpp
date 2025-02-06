#include <memory>
#include <stdexcept>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#include <amulet_nbt/export.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/string.hpp>

#include <amulet_nbt/tag/copy.hpp>

namespace AmuletNBT {

template <typename T>
AmuletNBT::ListTag deep_copy_list_vector(const std::vector<T>& vec)
{
    std::vector<T> new_vector;
    new_vector.reserve(vec.size());
    for (const T& value : vec) {
        new_vector.push_back(deep_copy(value));
    }
    return new_vector;
}

AmuletNBT::ListTag deep_copy(const AmuletNBT::ListTag& tag)
{
    return std::visit(
        [](auto&& list) -> AmuletNBT::ListTag {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return AmuletNBT::ListTag();
            } else if constexpr (is_shared_ptr<typename T::value_type>::value) {
                return deep_copy_list_vector(list);
            } else {
                return list;
            }
        },
        tag);
}

AmuletNBT::CompoundTag deep_copy(const AmuletNBT::CompoundTag& tag)
{
    AmuletNBT::CompoundTag new_tag;
    for (auto& [key, value] : tag) {
        new_tag.emplace(key, deep_copy(value));
    }
    return new_tag;
}

AmuletNBT::TagNode deep_copy(const AmuletNBT::TagNode& node)
{
    return std::visit(
        [](auto&& tag) -> AmuletNBT::TagNode {
            return deep_copy(tag);
        },
        node);
}

AmuletNBT::NamedTag deep_copy(const AmuletNBT::NamedTag& named_tag)
{
    return { named_tag.name, deep_copy(named_tag.tag_node) };
}

} // namespace AmuletNBT
