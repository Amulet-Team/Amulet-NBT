#pragma once

#include <cstdint>
#include <variant>
#include <unordered_map>

#include <amulet_nbt/tag2/abc.hpp>
#include <amulet_nbt/tag2/int.hpp>
#include <amulet_nbt/tag2/float.hpp>
#include <amulet_nbt/tag2/string.hpp>

namespace AmuletNBT {
    class CompoundTag;

    typedef std::variant<
        ByteTag,
        ShortTag,
        IntTag,
        LongTag,
        FloatTag,
        DoubleTag,
        ByteArrayTagPtr,
        StringTag,
        ListTagPtr,
        CompoundTagPtr,
        IntArrayTagPtr,
        LongArrayTagPtr
    > TagNode;

    class CompoundTag: public AbstractBaseMutableTag {
        public:
            const std::string value;

            StringTag();
            StringTag(std::string&);
    }
}
