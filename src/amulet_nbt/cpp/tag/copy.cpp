#include <vector>
#include <memory>
#include <utility>
#include <variant>
#include <type_traits>
#include <stdexcept>
#include <vector>

#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>

#include <amulet_nbt/tag/copy.hpp>


namespace AmuletNBT {
    template <
        typename T,
        std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ListTagPtr> ||
        std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
        bool
        > = true
    >
    AmuletNBT::ListTagPtr NBTTag_deep_copy_list_vector(const std::vector<T>&tag) {
        AmuletNBT::ListTagPtr new_tag = std::make_shared<AmuletNBT::ListTag>(std::in_place_type<std::vector<T>>);
        std::vector<T>& new_vector = std::get<std::vector<T>>(*new_tag);
        for (T value : tag) {
            if constexpr (std::is_same_v<T, AmuletNBT::ListTagPtr>) {
                new_vector.push_back(NBTTag_deep_copy_list(*value));
            }
            else if constexpr (std::is_same_v<T, AmuletNBT::CompoundTagPtr>) {
                new_vector.push_back(NBTTag_deep_copy_compound(*value));
            }
            else {
                new_vector.push_back(NBTTag_copy<typename T::element_type>(*value));
            }
        }
        return new_tag;
    }

    AmuletNBT::ListTagPtr NBTTag_deep_copy_list(const AmuletNBT::ListTag& tag) {
        return std::visit([](auto&& list) {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return std::make_shared<AmuletNBT::ListTag>();
            }
            else if constexpr (is_shared_ptr<typename T::value_type>::value) {
                return NBTTag_deep_copy_list_vector(list);
            }
            else {
                return std::make_shared<AmuletNBT::ListTag>(list);
            }
        }, tag);
    }

    AmuletNBT::TagNode NBTTag_deep_copy_node(const AmuletNBT::TagNode& node) {
        return std::visit([](auto&& tag) -> AmuletNBT::TagNode {
            using T = std::decay_t<decltype(tag)>;
            if constexpr (std::is_same_v<T, AmuletNBT::ListTagPtr>) {
                return NBTTag_deep_copy_list(*tag);
            }
            else if constexpr (std::is_same_v<T, AmuletNBT::CompoundTagPtr>) {
                return NBTTag_deep_copy_compound(*tag);
            }
            else if constexpr (
                std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
                std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
                std::is_same_v<T, AmuletNBT::LongArrayTagPtr>
            ) {
                return NBTTag_copy(*tag);
            }
            else {
                return tag;
            }
        }, node);
    }

    AmuletNBT::CompoundTagPtr NBTTag_deep_copy_compound(const AmuletNBT::CompoundTag& tag) {
        auto new_tag = std::make_shared<AmuletNBT::CompoundTag>();
        for (auto& [key, value] : tag) {
            (*new_tag)[key] = NBTTag_deep_copy_node(value);
        }
        return new_tag;
    }
}
