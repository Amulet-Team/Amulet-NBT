#include <vector>
#include <memory>
#include <utility>
#include <variant>
#include <type_traits>
#include <stdexcept>

#include <amulet_nbt/tag/copy.hpp>

namespace Amulet {
    template <typename T>
    Amulet::ListTagPtr NBTTag_deep_copy_list_vector(const std::vector<T>& tag){
        Amulet::ListTagPtr new_tag = std::make_shared<Amulet::ListTag>(std::in_place_type<std::vector<T>>);
        std::vector<T>& new_vector = std::get<std::vector<T>>(*new_tag);
        for (T value: tag){
            if constexpr (std::is_same_v<T, Amulet::ListTagPtr>){
                new_vector.push_back(NBTTag_deep_copy_list(*value));
            } else if constexpr (std::is_same_v<T, Amulet::CompoundTagPtr>){
                new_vector.push_back(NBTTag_deep_copy_compound(*value));
            } else if constexpr (std::is_same_v<T, Amulet::ByteArrayTagPtr>){
                new_vector.push_back(NBTTag_copy<Amulet::ByteArrayTag>(*value));
            } else if constexpr (std::is_same_v<T, Amulet::IntArrayTagPtr>){
                new_vector.push_back(NBTTag_copy<Amulet::IntArrayTag>(*value));
            } else {
                static_assert(std::is_same_v<T, Amulet::LongArrayTagPtr>);
                new_vector.push_back(NBTTag_copy<Amulet::LongArrayTag>(*value));
            }
        }
        return new_tag;
    }

    Amulet::ListTagPtr NBTTag_deep_copy_list(const Amulet::ListTag& tag){
        switch (tag.index()){
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 8:
                return std::make_shared<Amulet::ListTag>(tag);
            case 7:
                return NBTTag_deep_copy_list_vector<Amulet::ByteArrayTagPtr>(std::get<Amulet::ByteArrayListTag>(tag));
            case 9:
                return NBTTag_deep_copy_list_vector<Amulet::ListTagPtr>(std::get<Amulet::ListListTag>(tag));
            case 10:
                return NBTTag_deep_copy_list_vector<Amulet::CompoundTagPtr>(std::get<Amulet::CompoundListTag>(tag));
            case 11:
                return NBTTag_deep_copy_list_vector<Amulet::IntArrayTagPtr>(std::get<Amulet::IntArrayListTag>(tag));
            case 12:
                return NBTTag_deep_copy_list_vector<Amulet::LongArrayTagPtr>(std::get<Amulet::LongArrayListTag>(tag));
            default:
                throw std::runtime_error("");
        }
    }

    Amulet::TagNode NBTTag_deep_copy_node(const Amulet::TagNode& tag) {
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
                return NBTTag_copy<Amulet::ByteArrayTag>(*std::get<Amulet::ByteArrayTagPtr>(tag));
            case 9:
                return NBTTag_deep_copy_list(*std::get<Amulet::ListTagPtr>(tag));
            case 10:
                return NBTTag_deep_copy_compound(*std::get<Amulet::CompoundTagPtr>(tag));
            case 11:
                return NBTTag_copy<Amulet::IntArrayTag>(*std::get<Amulet::IntArrayTagPtr>(tag));
            case 12:
                return NBTTag_copy<Amulet::LongArrayTag>(*std::get<Amulet::LongArrayTagPtr>(tag));
            default:
                throw std::runtime_error("");
        }
    }

    Amulet::CompoundTagPtr NBTTag_deep_copy_compound(const Amulet::CompoundTag& tag){
        auto new_tag = std::make_shared<Amulet::CompoundTag>();
        for (auto& [key, value]: tag){
            (*new_tag)[key] = NBTTag_deep_copy_node(value);
        }
        return new_tag;
    }
}
