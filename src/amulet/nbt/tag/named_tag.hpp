#pragma once

#include <cstdint>
#include <string>

#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/compound.hpp>

namespace Amulet {
namespace NBT {
    class NamedTag {
    public:
        std::string name;
        TagNode tag_node;

        NamedTag(const std::string& name, const TagNode& tag_node)
            : name(name)
            , tag_node(tag_node)
        {
        }
    };
} // namespace NBT
} // namespace Amulet
