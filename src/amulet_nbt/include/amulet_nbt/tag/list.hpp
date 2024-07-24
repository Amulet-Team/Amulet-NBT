#pragma once

#include <cstdint>
#include <memory>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>

namespace AmuletNBT {
    class ListTag;
    typedef std::shared_ptr<ListTag> ListTagPtr;
    class CompoundTag;
    typedef std::shared_ptr<CompoundTag> CompoundTagPtr;

    // List types
    typedef std::vector<ByteTag> ByteListTag;
    typedef std::vector<ShortTag> ShortListTag;
    typedef std::vector<IntTag> IntListTag;
    typedef std::vector<LongTag> LongListTag;
    typedef std::vector<FloatTag> FloatListTag;
    typedef std::vector<DoubleTag> DoubleListTag;
    typedef std::vector<ByteArrayTagPtr> ByteArrayListTag;
    typedef std::vector<StringTag> StringListTag;
    typedef std::vector<ListTagPtr> ListListTag;
    typedef std::vector<CompoundTagPtr> CompoundListTag;
    typedef std::vector<IntArrayTagPtr> IntArrayListTag;
    typedef std::vector<LongArrayTagPtr> LongArrayListTag;

    typedef std::variant<
        std::monostate,
        ByteListTag,
        ShortListTag,
        IntListTag,
        LongListTag,
        FloatListTag,
        DoubleListTag,
        ByteArrayListTag,
        StringListTag,
        ListListTag,
        CompoundListTag,
        IntArrayListTag,
        LongArrayListTag
    > ListTagNative;

    class ListTag: public ListTagNative, public AbstractBaseImmutableTag{
        using variant::variant;
    };

    static_assert(std::is_copy_constructible_v<ListTag>, "ListTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ListTag>, "ListTag is not copy assignable");

    inline size_t ListTag_size(const ListTag& self) {
        return std::visit([](auto&& list) -> size_t {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                return 0;
            }
            else {
                return list.size();
            }
        }, self);
    };

    template <
        typename tagT,
        std::enable_if_t<
            std::is_same_v<tagT, AmuletNBT::ByteTag> ||
            std::is_same_v<tagT, AmuletNBT::ShortTag> ||
            std::is_same_v<tagT, AmuletNBT::IntTag> ||
            std::is_same_v<tagT, AmuletNBT::LongTag> ||
            std::is_same_v<tagT, AmuletNBT::FloatTag> ||
            std::is_same_v<tagT, AmuletNBT::DoubleTag> ||
            std::is_same_v<tagT, AmuletNBT::ByteArrayTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::StringTag> ||
            std::is_same_v<tagT, AmuletNBT::ListTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::CompoundTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::IntArrayTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::LongArrayTagPtr>,
            bool
        > = true
    >
    inline void ListTag_append(ListTag& self, const tagT& tag) {
        if (self.index() == variant_index<ListTag, std::vector<tagT>>()) {
            std::get<std::vector<tagT>>(self).push_back(tag);
        } else if (ListTag_size(self) == 0) {
            self.emplace<std::vector<tagT>>().push_back(tag);
        } else {
            throw type_error(
                "ListTag has element type " +
                std::to_string(self.index()) +
                " but the tag has type " +
                std::to_string(variant_index<ListTag, std::vector<tagT>>())
            );
        }
    };

    template <
        typename tagT,
        std::enable_if_t<
        std::is_same_v<tagT, AmuletNBT::TagNode>,
        bool
        > = true
    >
    inline void ListTag_append(ListTag& self, const TagNode& node) {
        std::visit([&self](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            ListTag_append<T>(self, tag);
        }, node);
    }

    template <typename indexT, bool clamp = false>
    size_t ListTag_bounds_check(size_t size, indexT index){
        if constexpr (std::is_signed_v<indexT>){
            if (index < 0){
                index += size;
            }
            if constexpr (clamp){
                if (index < 0){
                    index = 0;
                }
            } else {
                if (index < 0){
                    throw std::out_of_range("ListTag index is out of range.");
                }
            }
        }
        size_t abs_index = index;
        if constexpr (clamp){
            if (size < abs_index){
                abs_index = size;
            }
        } else {
            if (size <= abs_index){
                throw std::out_of_range("ListTag index is out of range.");
            }
        }
        return abs_index;
    };

    template <
        typename tagT,
        typename indexT,
        std::enable_if_t<
            std::is_same_v<tagT, AmuletNBT::ByteTag> ||
            std::is_same_v<tagT, AmuletNBT::ShortTag> ||
            std::is_same_v<tagT, AmuletNBT::IntTag> ||
            std::is_same_v<tagT, AmuletNBT::LongTag> ||
            std::is_same_v<tagT, AmuletNBT::FloatTag> ||
            std::is_same_v<tagT, AmuletNBT::DoubleTag> ||
            std::is_same_v<tagT, AmuletNBT::ByteArrayTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::StringTag> ||
            std::is_same_v<tagT, AmuletNBT::ListTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::CompoundTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::IntArrayTagPtr> ||
            std::is_same_v<tagT, AmuletNBT::LongArrayTagPtr>,
            bool
        > = true
    >
    tagT ListTag_get(const ListTag& self, indexT index){
        auto& list_tag = std::get<std::vector<tagT>>(self);
        return list_tag[ListTag_bounds_check<indexT>(list_tag.size(), index)];
    }

    template <typename indexT>
    TagNode ListTag_get_node(const ListTag& self, indexT index){
        return std::visit([&self, &index](auto&& list) -> TagNode {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                throw type_error("Cannot get from null ListTag.");
            }
            else {
                return list[ListTag_bounds_check<indexT>(list.size(), index)];
            }
        }, self);
    }

    template <typename tagT, typename indexT>
    void ListTag_set(ListTag& self, indexT index, tagT tag){
        // Get the unsigned index. Also do bounds checking.
        size_t abs_index = ListTag_bounds_check<indexT>(ListTag_size(self), index);
        if (self.index() == variant_index<ListTag, std::vector<tagT>>()){
            // If the list type is the same as the tag
            auto& list_tag = std::get<std::vector<tagT>>(self);
            list_tag[abs_index] = tag;
        } else if (ListTag_size(self) == 1 && abs_index == 0){
            // Overwriting the only value
            self.emplace<std::vector<tagT>>({tag});
        } else {
            throw type_error("NBT ListTag item mismatch.");
        }
    }

    template <typename indexT>
    void ListTag_del(ListTag& self, indexT index){
        std::visit([&index](auto&& list) {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                // do nothing
            } else {
                size_t abs_index = ListTag_bounds_check<indexT>(list.size(), index);
                list.erase(list.begin() + abs_index);
            }
        }, self);
    }
    
    template <typename indexT>
    inline TagNode ListTag_pop(ListTag& self, const indexT& index){
        return std::visit([&index](auto&& list) {
            using T = std::decay_t<decltype(list)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                throw std::out_of_range("ListTag index is out of range.");
            } else {
                size_t abs_index = ListTag_bounds_check<indexT>(list.size(), index);
                typename T::value_type tag = list[abs_index];
                list.erase(list.begin() + abs_index);
                return tag;
            }
        }, self);
    }

    template <typename tagT, typename indexT>
    void ListTag_insert(ListTag& self, indexT index, const tagT& tag){
        if (self.index() != variant_index<ListTag, std::vector<tagT>>()){
            if (ListTag_size(self) == 0) {
                self.emplace<std::vector<tagT>>();
            } else {
                throw type_error(
                    "ListTag has element type " +
                    std::to_string(self.index()) +
                    " but the tag has type " +
                    std::to_string(variant_index<ListTag, std::vector<tagT>>())
                );
            }
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t abs_index = ListTag_bounds_check<indexT, true>(list_tag.size(), index);
        list_tag.insert(list_tag.begin() + abs_index, tag);
    }

    template <typename indexT>
    void ListTag_insert(ListTag& self, indexT index, const TagNode& node){
        std::visit([&self, &index](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            ListTag_insert<T, indexT>(self, index, tag);
        }, node);
    }

    template <typename tagT, typename indexT>
    size_t ListTag_index(ListTag& self, tagT tag, indexT start=0, indexT stop=std::numeric_limits<indexT>::max()){
        if (self.index() != variant_index<ListTag, std::vector<tagT>>()){
            throw std::invalid_argument("item is not in the ListTag");
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t abs_start = ListTag_bounds_check<indexT, true>(list_tag.size(), start);
        size_t abs_stop = ListTag_bounds_check<indexT, true>(list_tag.size(), stop);
        for (size_t i = abs_start; i < abs_stop; i++){
            tagT tag_i = list_tag[i];
            if (NBTTag_eq(tag, tag_i)){
                return i;
            }
        }
        throw std::invalid_argument("item is not in the ListTag");
    }

    template <typename tagT>
    size_t ListTag_count(ListTag& self, tagT tag){
        if (self.index() != variant_index<ListTag, std::vector<tagT>>()){
            return 0;
        }
        auto& list_tag = std::get<std::vector<tagT>>(self);
        size_t count = 0;
        for (tagT tag_i: list_tag){
            if (NBTTag_eq(tag, tag_i)){
                count++;
            }
        }
        return count;
    }

    template<> struct tag_id<ListTag> { static constexpr std::uint8_t value = 9; };
    template<> struct tag_id<ListTagPtr> { static constexpr std::uint8_t value = 9; };

    // A class to emulate python's iteration mechanic
    class ListTagIterator {
        private:
            ListTagPtr tag;
            size_t index;
            std::ptrdiff_t step;
        public:
            ListTagIterator(ListTagPtr tag, size_t start, std::ptrdiff_t step) : tag(tag), index(start), step(step) {};
            TagNode next() {
                auto node = ListTag_get_node<size_t>(*tag, index);
                index += step;
                return node;
            }
            bool has_next() {
                return index >= 0 && index < ListTag_size(*tag);
            }
    };
}

namespace std {
    template <> struct variant_size<AmuletNBT::ListTag> : std::variant_size<AmuletNBT::ListTagNative> {};
    template <std::size_t I> struct variant_alternative<I, AmuletNBT::ListTag> : variant_alternative<I, AmuletNBT::ListTagNative> {};
}
