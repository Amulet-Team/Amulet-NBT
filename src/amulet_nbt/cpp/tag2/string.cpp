#include <amulet_nbt/tag2/string.hpp>

namespace AmuletNBT {
    StringTag::StringTag(): value(""){}
    StringTag::StringTag(std::string& value): value(value){}
}
