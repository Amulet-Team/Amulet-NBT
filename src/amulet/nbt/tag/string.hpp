#pragma once

#include <cstdint>
#include <string>
#include <utility>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace Amulet {
namespace NBT {
    class StringTag : public std::string, public AbstractBaseImmutableTag {
    public:
        using std::string::string;
        using std::string::operator=;

        StringTag() = default;
        StringTag(const std::string& value)
            : std::string(value)
        {
        }

        StringTag(std::string&& value) noexcept
            : std::string(std::move(value))
        {
        }
    };

    template <>
    struct tag_id<StringTag> {
        static constexpr std::uint8_t value = 8;
    };
} // namespace NBT
} // namespace Amulet
