// Utility functions for the ListTag

#pragma once

#include <stdexcept>
#include <iostream>
#include <algorithm>
#include <limits>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/eq.hpp>

namespace Amulet {
    size_t ListTag_size(const Amulet::ListTag&);

    template <typename tagT>
    void ListTag_append(Amulet::ListTag& self, tagT tag){
        if (self.index() == variant_index<Amulet::ListTag, std::vector<tagT>>()){
            get<std::vector<tagT>>(self).push_back(tag);
        } else if (ListTag_size(self) == 0){
            self.emplace<std::vector<tagT>>().push_back(tag);
        } else {
            throw std::invalid_argument(
                "ListTag has element type " +
                std::to_string(self.index()) +
                " but the tag has type " +
                std::to_string(variant_index<Amulet::ListTag, std::vector<tagT>>())
            );
        }
    };

    void ListTag_append(Amulet::ListTag& self, Amulet::TagNode tag);

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

    template <typename tagT, typename indexT>
    tagT ListTag_get(const Amulet::ListTag& self, indexT index){
        auto& list_tag = get<std::vector<tagT>>(self);
        return list_tag[Amulet::ListTag_bounds_check<indexT>(list_tag.size(), index)];
    }

    template <typename indexT>
    Amulet::TagNode ListTag_get_node(const Amulet::ListTag& self, indexT index){
        switch(self.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                return Amulet::TagNode(ListTag_get<TAG_STORAGE, indexT>(self, index));
            FOR_EACH_LIST_TAG(CASE)
            default:
                throw std::invalid_argument("Cannot get from null ListTag.");
            #undef CASE
        }
    }

    template <typename tagT, typename indexT>
    void ListTag_set(Amulet::ListTag& self, indexT index, tagT tag){
        // Get the unsigned index. Also do bounds checking.
        size_t abs_index = ListTag_bounds_check<indexT>(ListTag_size(self), index);
        if (self.index() == variant_index<Amulet::ListTag, std::vector<tagT>>()){
            // If the list type is the same as the tag
            auto& list_tag = get<std::vector<tagT>>(self);
            list_tag[abs_index] = tag;
        } else if (ListTag_size(self) == 1 && abs_index == 0){
            // Overwriting the only value
            self.emplace<std::vector<tagT>>({tag});
        } else {
            throw std::invalid_argument("NBT ListTag item mismatch.");
        }
    }

    template <typename indexT>
    void ListTag_remove(Amulet::ListTag& self, indexT index){
        switch(self.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                {\
                    LIST_TAG& list_tag = get<LIST_TAG>(self);\
                    size_t abs_index = Amulet::ListTag_bounds_check<indexT>(list_tag.size(), index);\
                    list_tag.erase(list_tag.begin() + abs_index);\
                    break;\
                }
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
    }

    template <typename indexT>
    Amulet::TagNode ListTag_pop(Amulet::ListTag& self, indexT index){
        switch(self.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                {\
                    LIST_TAG& list_tag = get<LIST_TAG>(self);\
                    size_t abs_index = Amulet::ListTag_bounds_check<indexT>(list_tag.size(), index);\
                    TAG_STORAGE tag = list_tag[abs_index];\
                    list_tag.erase(list_tag.begin() + abs_index);\
                    return tag;\
                }
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        throw std::out_of_range("ListTag index is out of range.");
    }

    template <typename tagT, typename indexT>
    void ListTag_insert(Amulet::ListTag& self, indexT index, tagT tag){
        if (self.index() != variant_index<Amulet::ListTag, std::vector<tagT>>()){
            if (ListTag_size(self) == 0) {
                self.emplace<std::vector<tagT>>();
            } else {
                throw std::invalid_argument(
                    "ListTag has element type " +
                    std::to_string(self.index()) +
                    " but the tag has type " +
                    std::to_string(variant_index<Amulet::ListTag, std::vector<tagT>>())
                );
            }
        }
        auto& list_tag = get<std::vector<tagT>>(self);
        size_t abs_index = ListTag_bounds_check<indexT, true>(list_tag.size(), index);
        list_tag.insert(list_tag.begin() + abs_index, tag);
    }

    template <typename indexT>
    void ListTag_insert(Amulet::ListTag& self, indexT index, Amulet::TagNode node){
        switch(self.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                ListTag_insert<TAG_STORAGE, indexT>(self, index, get<TAG_STORAGE>(node));\
                break;
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
    }

    template <typename tagT, typename indexT>
    size_t ListTag_index(Amulet::ListTag& self, tagT tag, indexT start=0, indexT stop=std::numeric_limits<indexT>::max()){
        if (self.index() != variant_index<Amulet::ListTag, std::vector<tagT>>()){
            throw std::invalid_argument("item is not in the ListTag");
        }
        auto& list_tag = get<std::vector<tagT>>(self);
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
    size_t ListTag_count(Amulet::ListTag& self, tagT tag){
        if (self.index() != variant_index<Amulet::ListTag, std::vector<tagT>>()){
            return 0;
        }
        auto& list_tag = get<std::vector<tagT>>(self);
        size_t count = 0;
        for (tagT tag_i: list_tag){
            if (NBTTag_eq(tag, tag_i)){
                count++;
            }
        }
        return count;
    }

    // A class to emulate python's iteration mechanic
    class ListTagIterator {
        private:
            Amulet::ListTagPtr tag;
            size_t index;
            std::ptrdiff_t step;
        public:
            ListTagIterator(Amulet::ListTagPtr, size_t start, std::ptrdiff_t step);
            Amulet::TagNode next();
            bool has_next();
    };
}
