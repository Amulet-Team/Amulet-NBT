#include <memory>
#include <type_traits>
#include <vector>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/eq.hpp>


namespace AmuletNBT{
    bool NBTTag_eq(const AmuletNBT::ByteTag a, const AmuletNBT::ByteTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::ShortTag a, const AmuletNBT::ShortTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::IntTag a, const AmuletNBT::IntTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::LongTag a, const AmuletNBT::LongTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::FloatTag a, const AmuletNBT::FloatTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::DoubleTag a, const AmuletNBT::DoubleTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::StringTag a, const AmuletNBT::StringTag b){return a == b;};
    bool NBTTag_eq(const AmuletNBT::ByteArrayTagPtr a, const AmuletNBT::ByteArrayTagPtr b){return *a == *b;};
    bool NBTTag_eq(const AmuletNBT::IntArrayTagPtr a, const AmuletNBT::IntArrayTagPtr b){return *a == *b;};
    bool NBTTag_eq(const AmuletNBT::LongArrayTagPtr a, const AmuletNBT::LongArrayTagPtr b){return *a == *b;};

    template <typename SelfT>
    inline bool ListTag_eq(const AmuletNBT::ListTagPtr a, const AmuletNBT::ListTagPtr b){
        const std::vector<SelfT>& a_vec = std::get<std::vector<SelfT>>(*a);
        if (b->index() != variant_index<AmuletNBT::ListTag, std::vector<SelfT>>()){
            return a_vec.size() == 0 && ListTag_size(*b) == 0;
        }
        const std::vector<SelfT>& b_vec = std::get<std::vector<SelfT>>(*b);

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
    bool NBTTag_eq(const AmuletNBT::ListTagPtr a, const AmuletNBT::ListTagPtr b){
        switch(a->index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return ListTag_eq<TAG_STORAGE>(a, b);
            case 0:
                return ListTag_size(*b) == 0;
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        return false;
    };
    bool NBTTag_eq(const AmuletNBT::CompoundTagPtr a, const AmuletNBT::CompoundTagPtr b){
        if (a->size() != b->size()){
            // Size does not match
            return false;
        }
        for (auto& [key, value]: *a){
            AmuletNBT::CompoundTag::iterator it = b->find(key);
            if (it == b->end()){
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
    bool NBTTag_eq(const AmuletNBT::TagNode a, const AmuletNBT::TagNode b){
        switch(a.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return b.index() == ID && NBTTag_eq(std::get<TAG_STORAGE>(a), std::get<TAG_STORAGE>(b));
            case 0:
                return b.index() == 0;
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        return false;
    };
}
