#pragma once

#include <type_traits>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace Amulet {
namespace NBT {
    typedef float FloatTagNative;
    typedef double DoubleTagNative;

    class FloatTag : public AbstractBaseFloatTag {
    public:
        FloatTagNative value;
        typedef FloatTagNative native_type;
        FloatTag()
            : value() { };
        FloatTag(const FloatTagNative& value)
            : value(value) { };
        FloatTag(const FloatTag& other)
            : value(other.value) { };
        FloatTag& operator=(const FloatTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        FloatTag& operator=(const FloatTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const FloatTagNative&() const { return value; };
        operator FloatTagNative&() { return value; };
        bool operator==(const FloatTag& rhs) { return value == rhs.value; }
        bool operator<(const FloatTag& rhs) { return value < rhs.value; }
    };

    class DoubleTag : public AbstractBaseFloatTag {
    public:
        DoubleTagNative value;
        typedef DoubleTagNative native_type;
        DoubleTag()
            : value() { };
        DoubleTag(const DoubleTagNative& value)
            : value(value) { };
        DoubleTag(const DoubleTag& other)
            : value(other.value) { };
        DoubleTag& operator=(const DoubleTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        DoubleTag& operator=(const DoubleTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const DoubleTagNative&() const { return value; };
        operator DoubleTagNative&() { return value; };
        bool operator==(const DoubleTag& rhs) { return value == rhs.value; }
        bool operator<(const DoubleTag& rhs) { return value < rhs.value; }
    };

    static_assert(std::is_copy_constructible_v<FloatTag>, "FloatTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<FloatTag>, "FloatTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<DoubleTag>, "DoubleTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<DoubleTag>, "DoubleTag is not copy assignable");

    template <>
    struct tag_id<FloatTag> {
        static constexpr std::uint8_t value = 5;
    };
    template <>
    struct tag_id<DoubleTag> {
        static constexpr std::uint8_t value = 6;
    };
} // namespace NBT
} // namespace Amulet
