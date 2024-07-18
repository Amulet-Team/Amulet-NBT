#pragma once

#include <cstdint>

#include <amulet_nbt/tag2/abc.hpp>

namespace AmuletNBT {
    class NamedTag {
        public:
            std::string name;
            TagNode tag_node;

            NamedTag(const std::string& name, const TagNode& tag_node): name(name), tag_node(tag_node) {}
    }
}
