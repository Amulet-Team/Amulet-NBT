#pragma once

#include <cstdint>

#include <amulet_nbt/tag2/abc.hpp>

namespace AmuletNBT {
    template <typename T>
    class IntTagTemplate: public AbstractBaseIntTag {
        public:
            const T value;

            IntTagTemplate();
            IntTagTemplate(T&);
    };

    typedef IntTagTemplate<std::int8_t> ByteTag;
    typedef IntTagTemplate<std::int16_t> ShortTag;
    typedef IntTagTemplate<std::int32_t> IntTag;
    typedef IntTagTemplate<std::int64_t> LongTag;
}
