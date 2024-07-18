#pragma once

#include <cstdint>

#include <amulet_nbt/tag2/abc.hpp>

namespace AmuletNBT {
    class StringTag: public AbstractBaseImmutableTag {
        public:
            const std::string value;

            StringTag();
            StringTag(std::string&);
    }
}
