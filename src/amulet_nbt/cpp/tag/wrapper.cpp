#include <amulet_nbt/tag/wrapper.hpp>

namespace Amulet {
    WrapperNode wrap_node(Amulet::TagNode node){
        switch(node.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return Amulet::WrapperNode(TagWrapper<TAG_STORAGE>(get<TAG_STORAGE>(node)));
            FOR_EACH_LIST_TAG(CASE)
            default:
                return Amulet::WrapperNode();
            #undef CASE
        }
    }
}
