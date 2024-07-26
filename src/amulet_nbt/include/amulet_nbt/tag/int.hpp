#pragma once

#include <cstdint>
#include <type_traits>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/abc.hpp>

namespace AmuletNBT {
    template <typename T>
    class IntTagTemplate: public AbstractBaseIntTag {
        static_assert(
            std::is_same_v<T, std::int8_t> || 
            std::is_same_v<T, std::int16_t> || 
            std::is_same_v<T, std::int32_t> || 
            std::is_same_v<T, std::int64_t>, 
            "T must be int 8, 16, 32 or 64"
        );
        private:
            T value;
        public:
            typedef T native_type;
            IntTagTemplate() : value(0) {};
            IntTagTemplate(const T& value) : value(value) {};
            operator const T&() const {
                return value;
            };
    };

    typedef std::int8_t ByteTagNative;
    typedef std::int16_t ShortTagNative;
    typedef std::int32_t IntTagNative;
    typedef std::int64_t LongTagNative;

    typedef IntTagTemplate<ByteTagNative> ByteTag;
    typedef IntTagTemplate<ShortTagNative> ShortTag;
    typedef IntTagTemplate<IntTagNative> IntTag;
    typedef IntTagTemplate<LongTagNative> LongTag;

    static_assert(std::is_copy_constructible_v<ByteTag>, "ByteTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ByteTag>, "ByteTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<ShortTag>, "ShortTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ShortTag>, "ShortTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<IntTag>, "IntTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<IntTag>, "IntTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<LongTag>, "LongTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<LongTag>, "LongTag is not copy assignable");

    template<> struct tag_id<ByteTag> {static constexpr std::uint8_t value = 1;};
    template<> struct tag_id<ShortTag> {static constexpr std::uint8_t value = 2;};
    template<> struct tag_id<IntTag> {static constexpr std::uint8_t value = 3;};
    template<> struct tag_id<LongTag> {static constexpr std::uint8_t value = 4;};
}
