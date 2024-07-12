#include <type_traits>
#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/wrapper.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>

namespace Amulet {
    size_t ListTag_size(const Amulet::ListTag& self){
        switch(self.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return get<LIST_TAG>(self).size();
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        return 0;
    };

    void ListTag_append(Amulet::ListTag& self, Amulet::TagNode tag){
        switch(tag.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                ListTag_append<TAG_STORAGE>(self, get<TAG_STORAGE>(tag));\
                break;
            case 0:
                throw AmuletNBT::type_error("Cannot append null TagNode");
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
    }

    ListTagIterator::ListTagIterator(Amulet::ListTagPtr tag, size_t start, std::ptrdiff_t step): tag(tag), index(start), step(step) {};
    Amulet::TagNode ListTagIterator::next() {
        auto node = Amulet::ListTag_get_node<size_t>(*tag, index);
        index += step;
        return node;
    }
    bool ListTagIterator::has_next(){
        return index >= 0 && index < ListTag_size(*tag);
    }
}
