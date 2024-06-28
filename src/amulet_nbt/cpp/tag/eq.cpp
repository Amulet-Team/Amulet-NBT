#include <memory>
#include <type_traits>

#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/eq.hpp>

template<class T>
struct is_shared_ptr : std::false_type {};

template<class T>
struct is_shared_ptr<std::shared_ptr<T>> : std::true_type {};

namespace Amulet{
    bool NBTTag_eq(const Amulet::ByteTag a, const Amulet::ByteTag b){return a == b;};
    bool NBTTag_eq(const Amulet::ShortTag a, const Amulet::ShortTag b){return a == b;};
    bool NBTTag_eq(const Amulet::IntTag a, const Amulet::IntTag b){return a == b;};
    bool NBTTag_eq(const Amulet::LongTag a, const Amulet::LongTag b){return a == b;};
    bool NBTTag_eq(const Amulet::FloatTag a, const Amulet::FloatTag b){return a == b;};
    bool NBTTag_eq(const Amulet::DoubleTag a, const Amulet::DoubleTag b){return a == b;};
    bool NBTTag_eq(const Amulet::StringTag a, const Amulet::StringTag b){return a == b;};
    bool NBTTag_eq(const Amulet::ByteArrayTagPtr a, const Amulet::ByteArrayTagPtr b){return *a == *b;};
    bool NBTTag_eq(const Amulet::IntArrayTagPtr a, const Amulet::IntArrayTagPtr b){return *a == *b;};
    bool NBTTag_eq(const Amulet::LongArrayTagPtr a, const Amulet::LongArrayTagPtr b){return *a == *b;};

    template <typename SelfT>
    inline bool ListTag_eq(const Amulet::ListTagPtr a, const Amulet::ListTagPtr b){
        const SelfT& a_vec = get<SelfT>(*a);
        if (b->index() != variant_index<Amulet::ListTag, SelfT>()){
            return a_vec.size() == 0 && ListTag_size(*b) == 0;
        }
        const SelfT& b_vec = get<SelfT>(*b);

        if constexpr (is_shared_ptr<SelfT>::value){
            // Values are shared pointers
            if (a_vec.size() != b_vec.size()){
                return false;
            }
            for (size_t i = 0; i<a_vec.size(); i++){
                if (NBTTag_eq(a_vec[i], b_vec[i])){
                    return false;
                };
            }
            return true;
        } else {
            // Vector of non-pointers
            return a_vec == b_vec;
        }
    }
    bool NBTTag_eq(const Amulet::ListTagPtr a, const Amulet::ListTagPtr b){
        switch(a->index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return ListTag_eq<LIST_TAG>(a, b);
            case 0:
                return ListTag_size(*b) == 0;
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        return false;
    };
    bool NBTTag_eq(const Amulet::CompoundTagPtr a, const Amulet::CompoundTagPtr b){
        if (a->size() != b->size()){
            // Size does not match
            return false;
        }
        for (auto& [key, value]: *a){
            Amulet::CompoundTag::iterator it = b->find(key);
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
    bool NBTTag_eq(const Amulet::TagNode a, const Amulet::TagNode b){
        switch(a.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return b.index() == ID && NBTTag_eq(get<TAG_STORAGE>(a), get<TAG_STORAGE>(b));
            case 0:
                return b.index() == 0;
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        return false;
    };
}
