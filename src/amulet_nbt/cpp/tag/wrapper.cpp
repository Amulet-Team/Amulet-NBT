#include <variant>

#include <amulet_nbt/tag/wrapper.hpp>

namespace AmuletNBT {
    AmuletNBT::WrapperNode wrap_node(AmuletNBT::TagNode node){
        switch(node.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return AmuletNBT::WrapperNode(TagWrapper<TAG_STORAGE>(std::get<TAG_STORAGE>(node)));
            FOR_EACH_LIST_TAG(CASE)
            default:
                return AmuletNBT::WrapperNode();
            #undef CASE
        }
    }
    AmuletNBT::TagNode unwrap_node(AmuletNBT::WrapperNode node){
        switch(node.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: return AmuletNBT::TagNode(std::get<TagWrapper<TAG_STORAGE>>(node).tag);
            FOR_EACH_LIST_TAG(CASE)
            default:
                return AmuletNBT::TagNode();
            #undef CASE
        }
    }
}
