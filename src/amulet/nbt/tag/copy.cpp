#include <memory>
#include <set>
#include <stdexcept>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/string.hpp>

#include <amulet/nbt/tag/copy.hpp>

namespace Amulet {
namespace NBT {

    template <typename T>
    ListTag deep_copy_list_vector(const std::vector<T>& vec, std::set<size_t>& memo)
    {
        std::vector<T> new_vector;
        new_vector.reserve(vec.size());
        for (const T& value : vec) {
            new_vector.push_back(deep_copy_2(value, memo));
        }
        return new_vector;
    }

    ListTag deep_copy_2(const ListTag& tag, std::set<size_t>& memo)
    {
        auto ptr = reinterpret_cast<size_t>(&tag);
        if (memo.contains(ptr)) {
            throw std::runtime_error("ListTag cannot contain itself.");
        }
        memo.insert(ptr);
        auto new_tag = std::visit(
            [&memo](auto&& list) -> ListTag {
                using T = std::decay_t<decltype(list)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    return ListTag();
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

    CompoundTag deep_copy_2(const CompoundTag& tag, std::set<size_t>& memo)
    {
        auto ptr = reinterpret_cast<size_t>(&tag);
        if (memo.contains(ptr)) {
            throw std::runtime_error("CompoundTag cannot contain itself.");
        }
        memo.insert(ptr);
        CompoundTag new_tag;
        for (auto& [key, value] : tag) {
            new_tag.emplace(key, deep_copy_2(value, memo));
        }
        memo.erase(ptr);
        return new_tag;
    }

    TagNode deep_copy_2(const TagNode& node, std::set<size_t>& memo)
    {
        return std::visit(
            [&memo](auto&& tag) -> TagNode {
                return deep_copy_2(tag, memo);
            },
            node);
    }

    NamedTag deep_copy_2(const NamedTag& named_tag, std::set<size_t>& memo)
    {
        return { named_tag.name, deep_copy_2(named_tag.tag_node, memo) };
    }

} // namespace NBT
} // namespace Amulet
