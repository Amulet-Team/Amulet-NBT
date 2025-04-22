#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/list.hpp>

namespace Amulet {
namespace NBT {
    inline size_t ListTag_size(const ListTag& self)
    {
        return std::visit([](auto&& list) -> size_t {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return 0;
            } else {
                return list.size();
            }
        },
            self);
    };

    template <
        typename tagT,
        std::enable_if_t<
            std::is_same_v<tagT, ByteTag> || std::is_same_v<tagT, ShortTag> || std::is_same_v<tagT, IntTag> || std::is_same_v<tagT, LongTag> || std::is_same_v<tagT, FloatTag> || std::is_same_v<tagT, DoubleTag> || std::is_same_v<tagT, ByteArrayTagPtr> || std::is_same_v<tagT, StringTag> || std::is_same_v<tagT, ListTagPtr> || std::is_same_v<tagT, CompoundTagPtr> || std::is_same_v<tagT, IntArrayTagPtr> || std::is_same_v<tagT, LongArrayTagPtr>,
            bool>
        = true>
    inline void ListTag_append(ListTag& self, const tagT& tag)
    {
        if (std::holds_alternative<std::vector<tagT>>(self)) {
            std::get<std::vector<tagT>>(self).push_back(tag);
        } else if (ListTag_size(self) == 0) {
            self.emplace<std::vector<tagT>>().push_back(tag);
        } else {
            throw type_error(
                "ListTag has element type " + std::to_string(self.index()) + " but the tag has type " + std::to_string(variant_index<ListTag, std::vector<tagT>>()));
        }
    };

    template <
        typename tagT,
        std::enable_if_t<
            std::is_same_v<tagT, TagNode>,
            bool>
        = true>
    inline void ListTag_append(ListTag& self, const TagNode& node)
    {
        std::visit([&self](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            ListTag_append<T>(self, tag);
        },
            node);
    }

    template <typename indexT, bool clamp = false>
    size_t ListTag_bounds_check(size_t size, indexT index)
    {
        if constexpr (std::is_signed_v<indexT>) {
            if (index < 0) {
                index += size;
            }
            if constexpr (clamp) {
                if (index < 0) {
                    index = 0;
                }
            } else {
                if (index < 0) {
                    throw std::out_of_range("ListTag index is out of range.");
                }
            }
        }
        size_t abs_index = index;
        if constexpr (clamp) {
            if (size < abs_index) {
                abs_index = size;
            }
        } else {
            if (size <= abs_index) {
                throw std::out_of_range("ListTag index is out of range.");
            }
        }
        return abs_index;
    };

    template <
        typename tagT,
        typename indexT,
        std::enable_if_t<
            std::is_same_v<tagT, ByteTag> || std::is_same_v<tagT, ShortTag> || std::is_same_v<tagT, IntTag> || std::is_same_v<tagT, LongTag> || std::is_same_v<tagT, FloatTag> || std::is_same_v<tagT, DoubleTag> || std::is_same_v<tagT, ByteArrayTagPtr> || std::is_same_v<tagT, StringTag> || std::is_same_v<tagT, ListTagPtr> || std::is_same_v<tagT, CompoundTagPtr> || std::is_same_v<tagT, IntArrayTagPtr> || std::is_same_v<tagT, LongArrayTagPtr>,
            bool>
        = true>
    tagT ListTag_get(const ListTag& self, indexT index)
    {
        auto& list_tag = std::get<std::vector<tagT>>(self);
        return list_tag[ListTag_bounds_check<indexT>(list_tag.size(), index)];
    }

    template <typename indexT>
    TagNode ListTag_get_node(const ListTag& self, indexT index)
    {
        return std::visit([&self, &index](auto&& list) -> TagNode {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                throw type_error("Cannot get from null ListTag.");
            } else {
                return list[ListTag_bounds_check<indexT>(list.size(), index)];
            }
        },
            self);
    }

    template <typename tagT, typename indexT>
    void ListTag_set(ListTag& self, indexT index, tagT tag)
    {
        // Get the unsigned index. Also do bounds checking.
        size_t abs_index = ListTag_bounds_check<indexT>(ListTag_size(self), index);
        if (std::holds_alternative<std::vector<tagT>>(self)) {
            // If the list type is the same as the tag
            auto& list_tag = std::get<std::vector<tagT>>(self);
            list_tag[abs_index] = tag;
        } else if (ListTag_size(self) == 1 && abs_index == 0) {
            // Overwriting the only value
            self.emplace<std::vector<tagT>>({ tag });
        } else {
            throw type_error("NBT ListTag item mismatch.");
        }
    }

    template <typename indexT>
    void ListTag_del(ListTag& self, indexT index)
    {
        std::visit([&index](auto&& list) {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                // do nothing
            } else {
                size_t abs_index = ListTag_bounds_check<indexT>(list.size(), index);
                list.erase(list.begin() + abs_index);
            }
        },
            self);
    }

    template <typename indexT>
    inline TagNode ListTag_pop(ListTag& self, const indexT& index)
    {
        return std::visit([&index](auto&& list) -> TagNode {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                throw std::out_of_range("ListTag index is out of range.");
            } else {
                size_t abs_index = ListTag_bounds_check<indexT>(list.size(), index);
                typename T::value_type tag = list[abs_index];
                list.erase(list.begin() + abs_index);
                return tag;
            }
        },
            self);
    }

    template <typename tagT, typename indexT>
    void ListTag_insert(ListTag& self, indexT index, const tagT& tag)
    {
        if (!std::holds_alternative<std::vector<tagT>>(self)) {
            if (ListTag_size(self) == 0) {
                self.emplace<std::vector<tagT>>();
            } else {
                throw type_error(
                    "ListTag has element type " + std::to_string(self.index()) + " but the tag has type " + std::to_string(variant_index<ListTag, std::vector<tagT>>()));
            }
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t abs_index = ListTag_bounds_check<indexT, true>(list_tag.size(), index);
        list_tag.insert(list_tag.begin() + abs_index, tag);
    }

    template <typename indexT>
    void ListTag_insert(ListTag& self, indexT index, const TagNode& node)
    {
        std::visit([&self, &index](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            ListTag_insert<T, indexT>(self, index, tag);
        },
            node);
    }

    template <typename tagT, typename indexT>
    size_t ListTag_index(const ListTag& self, tagT tag, indexT start = 0, indexT stop = std::numeric_limits<indexT>::max())
    {
        if (!std::holds_alternative<std::vector<tagT>>(self)) {
            throw std::invalid_argument("item is not in the ListTag");
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t abs_start = ListTag_bounds_check<indexT, true>(list_tag.size(), start);
        size_t abs_stop = ListTag_bounds_check<indexT, true>(list_tag.size(), stop);
        for (size_t i = abs_start; i < abs_stop; i++) {
            tagT tag_i = list_tag[i];
            if (NBTTag_eq(tag, tag_i)) {
                return i;
            }
        }
        throw std::invalid_argument("item is not in the ListTag");
    }

    template <typename tagT>
    size_t ListTag_count(const ListTag& self, tagT tag)
    {
        if (!std::holds_alternative<std::vector<tagT>>(self)) {
            return 0;
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t count = 0;
        for (tagT tag_i : list_tag) {
            if (NBTTag_eq(tag, tag_i)) {
                count++;
            }
        }
        return count;
    }
} // namespace NBT
} // namespace Amulet
