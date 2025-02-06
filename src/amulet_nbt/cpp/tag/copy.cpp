#include <memory>
#include <set>
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
AmuletNBT::ListTag deep_copy_list_vector(const std::vector<T>& vec, std::set<size_t>& memo)
{
    std::vector<T> new_vector;
    new_vector.reserve(vec.size());
    for (const T& value : vec) {
        new_vector.push_back(deep_copy_2(value, memo));
    }
    return new_vector;
}

AmuletNBT::ListTag deep_copy_2(const AmuletNBT::ListTag& tag, std::set<size_t>& memo)
{
    auto ptr = reinterpret_cast<size_t>(&tag);
    if (memo.contains(ptr)) {
        throw std::runtime_error("ListTag cannot contain itself.");
    }
    memo.insert(ptr);
    auto new_tag = std::visit(
        [&memo](auto&& list) -> AmuletNBT::ListTag {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return AmuletNBT::ListTag();
            } else if constexpr (is_shared_ptr<typename T::value_type>::value) {
                return deep_copy_list_vector(list, memo);
            } else {
                return list;
            }
        },
        tag);
    memo.erase(ptr);
    return new_tag;
}

AmuletNBT::CompoundTag deep_copy_2(const AmuletNBT::CompoundTag& tag, std::set<size_t>& memo)
{
    auto ptr = reinterpret_cast<size_t>(&tag);
    if (memo.contains(ptr)) {
        throw std::runtime_error("CompoundTag cannot contain itself.");
    }
    memo.insert(ptr);
    AmuletNBT::CompoundTag new_tag;
    for (auto& [key, value] : tag) {
        new_tag.emplace(key, deep_copy_2(value, memo));
    }
    memo.erase(ptr);
    return new_tag;
}

AmuletNBT::TagNode deep_copy_2(const AmuletNBT::TagNode& node, std::set<size_t>& memo)
{
    return std::visit(
        [&memo](auto&& tag) -> AmuletNBT::TagNode {
            return deep_copy_2(tag, memo);
        },
        node);
}

AmuletNBT::NamedTag deep_copy_2(const AmuletNBT::NamedTag& named_tag, std::set<size_t>& memo)
{
    return { named_tag.name, deep_copy_2(named_tag.tag_node, memo) };
}

} // namespace AmuletNBT
