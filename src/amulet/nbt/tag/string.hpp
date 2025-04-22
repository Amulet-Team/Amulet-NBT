#pragma once

#include <cstdint>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace Amulet {
namespace NBT {
    class StringTag : public std::string, public AbstractBaseImmutableTag {
    public:
        using std::string::string;
        StringTag(const std::string& value)
            : std::string(value.begin(), value.end()) { };
    };

    static_assert(std::is_copy_constructible_v<StringTag>, "StringTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<StringTag>, "StringTag is not copy assignable");

    template <>
    struct tag_id<StringTag> {
        static constexpr std::uint8_t value = 8;
    };
} // namespace NBT
} // namespace Amulet
