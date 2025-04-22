#include <memory>
#include <type_traits>
#include <variant>
#include <vector>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/export.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/eq.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/list_methods.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
    bool NBTTag_eq(const ByteTag& a, const ByteTag& b) { return a == b; };
    bool NBTTag_eq(const ShortTag& a, const ShortTag& b) { return a == b; };
    bool NBTTag_eq(const IntTag& a, const IntTag& b) { return a == b; };
    bool NBTTag_eq(const LongTag& a, const LongTag& b) { return a == b; };
    bool NBTTag_eq(const FloatTag& a, const FloatTag& b) { return a == b; };
    bool NBTTag_eq(const DoubleTag& a, const DoubleTag& b) { return a == b; };
    bool NBTTag_eq(const StringTag& a, const StringTag& b) { return a == b; };
    bool NBTTag_eq(const ByteArrayTag& a, const ByteArrayTag& b) { return a == b; };
    bool NBTTag_eq(const IntArrayTag& a, const IntArrayTag& b) { return a == b; };
    bool NBTTag_eq(const LongArrayTag& a, const LongArrayTag& b) { return a == b; };

    template <typename SelfT>
    inline bool ListTag_eq(const std::vector<SelfT>& a_vec, const ListTag& b)
    {
        if (!std::holds_alternative<std::vector<SelfT>>(b)) {
            return a_vec.size() == 0 && ListTag_size(b) == 0;
        }
        const std::vector<SelfT>& b_vec = std::get<std::vector<SelfT>>(b);

        if constexpr (is_shared_ptr<SelfT>::value) {
            // Values are shared pointers
            if (a_vec.size() != b_vec.size()) {
                return false;
            }
            for (size_t i = 0; i < a_vec.size(); i++) {
                if (!NBTTag_eq(a_vec[i], b_vec[i])) {
                    return false;
                };
            }
            return true;
        } else {
            // Vector of non-pointers
            return a_vec == b_vec;
        }
    }
    bool NBTTag_eq(const ListTag& a, const ListTag& b)
    {
        return std::visit([&b](auto&& list) -> bool {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return ListTag_size(b) == 0;
            } else {
                return ListTag_eq<typename T::value_type>(list, b);
            }
        },
            a);
    };
    bool NBTTag_eq(const CompoundTag& a, const CompoundTag& b)
    {
        if (a.size() != b.size()) {
            // Size does not match
            return false;
        }
        for (auto& [key, value] : a) {
            auto it = b.find(key);
            if (it == b.end()) {
                // Key not in b
                return false;
            }
            if (!NBTTag_eq(value, it->second)) {
                // Value does not match
                return false;
            }
        }
        return true;
    };
    bool NBTTag_eq(const TagNode& a, const TagNode& b)
    {
        return std::visit([&b](auto&& tag) -> bool {
            using T = std::decay_t<decltype(tag)>;
            if (!std::holds_alternative<T>(b)) {
                return false;
            }
            if constexpr (is_shared_ptr<T>::value) {
                return NBTTag_eq(*tag, *std::get<T>(b));
            } else {
                return NBTTag_eq(tag, std::get<T>(b));
            }
        },
            a);
    };
    bool NBTTag_eq(const NamedTag& a, const NamedTag& b)
    {
        return a.name == b.name && NBTTag_eq(a.tag_node, b.tag_node);
    };
} // namespace NBT
} // namespace Amulet
