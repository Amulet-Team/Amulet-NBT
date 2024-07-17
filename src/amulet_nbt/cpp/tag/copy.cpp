#include <vector>
#include <memory>
#include <utility>
#include <variant>
#include <type_traits>
#include <stdexcept>

#include <amulet_nbt/tag/copy.hpp>

namespace AmuletNBT {
    template <typename T>
    AmuletNBT::ListTagPtr NBTTag_deep_copy_list_vector(const std::vector<T>& tag){
        AmuletNBT::ListTagPtr new_tag = std::make_shared<AmuletNBT::ListTag>(std::in_place_type<std::vector<T>>);
        std::vector<T>& new_vector = std::get<std::vector<T>>(*new_tag);
        for (T value: tag){
            if constexpr (std::is_same_v<T, AmuletNBT::ListTagPtr>){
                new_vector.push_back(NBTTag_deep_copy_list(*value));
            } else if constexpr (std::is_same_v<T, AmuletNBT::CompoundTagPtr>){
                new_vector.push_back(NBTTag_deep_copy_compound(*value));
            } else if constexpr (std::is_same_v<T, AmuletNBT::ByteArrayTagPtr>){
                new_vector.push_back(NBTTag_copy<AmuletNBT::ByteArrayTag>(*value));
            } else if constexpr (std::is_same_v<T, AmuletNBT::IntArrayTagPtr>){
                new_vector.push_back(NBTTag_copy<AmuletNBT::IntArrayTag>(*value));
            } else {
                static_assert(std::is_same_v<T, AmuletNBT::LongArrayTagPtr>);
                new_vector.push_back(NBTTag_copy<AmuletNBT::LongArrayTag>(*value));
            }
        }
        return new_tag;
    }

    AmuletNBT::ListTagPtr NBTTag_deep_copy_list(const AmuletNBT::ListTag& tag){
        switch (tag.index()){
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 8:
                return std::make_shared<AmuletNBT::ListTag>(tag);
            case 7:
                return NBTTag_deep_copy_list_vector<AmuletNBT::ByteArrayTagPtr>(std::get<AmuletNBT::ByteArrayListTag>(tag));
            case 9:
                return NBTTag_deep_copy_list_vector<AmuletNBT::ListTagPtr>(std::get<AmuletNBT::ListListTag>(tag));
            case 10:
                return NBTTag_deep_copy_list_vector<AmuletNBT::CompoundTagPtr>(std::get<AmuletNBT::CompoundListTag>(tag));
            case 11:
                return NBTTag_deep_copy_list_vector<AmuletNBT::IntArrayTagPtr>(std::get<AmuletNBT::IntArrayListTag>(tag));
            case 12:
                return NBTTag_deep_copy_list_vector<AmuletNBT::LongArrayTagPtr>(std::get<AmuletNBT::LongArrayListTag>(tag));
            default:
                throw std::runtime_error("");
        }
    }

    AmuletNBT::TagNode NBTTag_deep_copy_node(const AmuletNBT::TagNode& tag) {
        switch (tag.index()){
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 8:
                return tag;
            case 7:
                return NBTTag_copy<AmuletNBT::ByteArrayTag>(*std::get<AmuletNBT::ByteArrayTagPtr>(tag));
            case 9:
                return NBTTag_deep_copy_list(*std::get<AmuletNBT::ListTagPtr>(tag));
            case 10:
                return NBTTag_deep_copy_compound(*std::get<AmuletNBT::CompoundTagPtr>(tag));
            case 11:
                return NBTTag_copy<AmuletNBT::IntArrayTag>(*std::get<AmuletNBT::IntArrayTagPtr>(tag));
            case 12:
                return NBTTag_copy<AmuletNBT::LongArrayTag>(*std::get<AmuletNBT::LongArrayTagPtr>(tag));
            default:
                throw std::runtime_error("");
        }
    }

    AmuletNBT::CompoundTagPtr NBTTag_deep_copy_compound(const AmuletNBT::CompoundTag& tag){
        auto new_tag = std::make_shared<AmuletNBT::CompoundTag>();
        for (auto& [key, value]: tag){
            (*new_tag)[key] = NBTTag_deep_copy_node(value);
        }
        return new_tag;
    }
}
