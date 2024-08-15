#include <memory>
#include <type_traits>
#include <vector>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/list_methods.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/tag/eq.hpp>


namespace AmuletNBT{
    bool NBTTag_eq(const AmuletNBT::ByteTag& a, const AmuletNBT::ByteTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::ShortTag& a, const AmuletNBT::ShortTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::IntTag& a, const AmuletNBT::IntTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::LongTag& a, const AmuletNBT::LongTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::FloatTag& a, const AmuletNBT::FloatTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::DoubleTag& a, const AmuletNBT::DoubleTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::StringTag& a, const AmuletNBT::StringTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::ByteArrayTag& a, const AmuletNBT::ByteArrayTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::IntArrayTag& a, const AmuletNBT::IntArrayTag& b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::LongArrayTag& a, const AmuletNBT::LongArrayTag& b){return a == b;};

    template <typename SelfT>
    inline bool ListTag_eq(const std::vector<SelfT>& a_vec, const AmuletNBT::ListTag& b){
        if (!std::holds_alternative<std::vector<SelfT>>(b)){
            return a_vec.size() == 0 && ListTag_size(b) == 0;
        }
        const std::vector<SelfT>& b_vec = std::get<std::vector<SelfT>>(b);

        if constexpr (is_shared_ptr<SelfT>::value){
            // Values are shared pointers
            if (a_vec.size() != b_vec.size()){
                return false;
            }
            for (size_t i = 0; i<a_vec.size(); i++){
                if (!NBTTag_eq(a_vec[i], b_vec[i])){
                    return false;
                };
            }
            return true;
        } else {
            // Vector of non-pointers
            return a_vec == b_vec;
        }
    }
    bool NBTTag_eq(const AmuletNBT::ListTag& a, const AmuletNBT::ListTag& b){
        return std::visit([&b](auto&& list) -> bool {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return ListTag_size(b) == 0;
            }
            else {
                return ListTag_eq<typename T::value_type>(list, b);
            }
        }, a);
    };
    bool NBTTag_eq(const AmuletNBT::CompoundTag& a, const AmuletNBT::CompoundTag& b){
        if (a.size() != b.size()){
            // Size does not match
            return false;
        }
        for (auto& [key, value]: a){
            auto it = b.find(key);
            if (it == b.end()){
                // Key not in b
                return false;
            }
            if (!NBTTag_eq(value, it->second)){
                // Value does not match
                return false;
            }
        }
        return true;
    };
    bool NBTTag_eq(const AmuletNBT::TagNode& a, const AmuletNBT::TagNode& b){
        return std::visit([&b](auto&& tag) -> bool {
            using T = std::decay_t<decltype(tag)>;
            if (!std::holds_alternative<T>(b)) {
                return false;
            }
            if constexpr (is_shared_ptr<T>::value) {
                return NBTTag_eq(*tag, *std::get<T>(b));
            }
            else {
                return NBTTag_eq(tag, std::get<T>(b));
            }
        }, a);
    };
    bool NBTTag_eq(const AmuletNBT::NamedTag& a, const AmuletNBT::NamedTag& b) {
        return a.name == b.name && NBTTag_eq(a.tag_node, b.tag_node);
    };
}
