#pragma once

#include <cstdint>

#include <amulet_nbt/tag2/abc.hpp>

namespace AmuletNBT {
    template <typename T>
    class ArrayTagTemplate: public AbstractBaseArrayTag {
        public:
            const std::string value;

            StringTag();
            StringTag(std::string&);
    };


}
