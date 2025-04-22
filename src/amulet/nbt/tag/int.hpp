#pragma once

#include <cstdint>
#include <type_traits>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace Amulet {
namespace NBT {
    typedef std::int8_t ByteTagNative;
    typedef std::int16_t ShortTagNative;
    typedef std::int32_t IntTagNative;
    typedef std::int64_t LongTagNative;

    class ByteTag : public AbstractBaseIntTag {
    public:
        ByteTagNative value;
        typedef ByteTagNative native_type;
        ByteTag()
            : value() { };
        ByteTag(const ByteTagNative& value)
            : value(value) { };
        ByteTag(const ByteTag& other)
            : value(other.value) { };
        ByteTag& operator=(const ByteTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        ByteTag& operator=(const ByteTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const ByteTagNative&() const { return value; };
        operator ByteTagNative&() { return value; };
        bool operator==(const ByteTag& rhs) { return value == rhs.value; }
        bool operator<(const ByteTag& rhs) { return value < rhs.value; }
    };

    class ShortTag : public AbstractBaseIntTag {
    public:
        ShortTagNative value;
        typedef ShortTagNative native_type;
        ShortTag()
            : value() { };
        ShortTag(const ShortTagNative& value)
            : value(value) { };
        ShortTag(const ShortTag& other)
            : value(other.value) { };
        ShortTag& operator=(const ShortTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        ShortTag& operator=(const ShortTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const ShortTagNative&() const { return value; };
        operator ShortTagNative&() { return value; };
        bool operator==(const ShortTag& rhs) { return value == rhs.value; }
        bool operator<(const ShortTag& rhs) { return value < rhs.value; }
    };

    class IntTag : public AbstractBaseIntTag {
    public:
        IntTagNative value;
        typedef IntTagNative native_type;
        IntTag()
            : value() { };
        IntTag(const IntTagNative& value)
            : value(value) { };
        IntTag(const IntTag& other)
            : value(other.value) { };
        IntTag& operator=(const IntTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        IntTag& operator=(const IntTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const IntTagNative&() const { return value; };
        operator IntTagNative&() { return value; };
        bool operator==(const IntTag& rhs) { return value == rhs.value; }
        bool operator<(const IntTag& rhs) { return value < rhs.value; }
    };

    class LongTag : public AbstractBaseIntTag {
    public:
        LongTagNative value;
        typedef LongTagNative native_type;
        LongTag()
            : value() { };
        LongTag(const LongTagNative& value)
            : value(value) { };
        LongTag(const LongTag& other)
            : value(other.value) { };
        LongTag& operator=(const LongTag& rhs)
        {
            value = rhs.value;
            return *this;
        };
        LongTag& operator=(const LongTagNative& rhs)
        {
            value = rhs;
            return *this;
        };
        operator const LongTagNative&() const { return value; };
        operator LongTagNative&() { return value; };
        bool operator==(const LongTag& rhs) { return value == rhs.value; }
        bool operator<(const LongTag& rhs) { return value < rhs.value; }
    };

    static_assert(std::is_copy_constructible_v<ByteTag>, "ByteTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ByteTag>, "ByteTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<ShortTag>, "ShortTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ShortTag>, "ShortTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<IntTag>, "IntTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<IntTag>, "IntTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<LongTag>, "LongTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<LongTag>, "LongTag is not copy assignable");

    template <>
    struct tag_id<ByteTag> {
        static constexpr std::uint8_t value = 1;
    };
    template <>
    struct tag_id<ShortTag> {
        static constexpr std::uint8_t value = 2;
    };
    template <>
    struct tag_id<IntTag> {
        static constexpr std::uint8_t value = 3;
    };
    template <>
    struct tag_id<LongTag> {
        static constexpr std::uint8_t value = 4;
    };
} // namespace NBT
} // namespace Amulet
