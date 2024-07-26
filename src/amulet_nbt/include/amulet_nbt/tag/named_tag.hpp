#pragma once

#include <cstdint>
#include <string>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/compound.hpp>

namespace AmuletNBT {
    class NamedTag {
        public:
            std::string name;
            TagNode tag_node;

            NamedTag(const std::string& name, const TagNode& tag_node): name(name), tag_node(tag_node) {}
    };
}
