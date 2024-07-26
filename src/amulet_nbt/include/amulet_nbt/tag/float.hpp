#pragma once

#include <type_traits>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/abc.hpp>

namespace AmuletNBT {
    template <typename T>
    class FloatTagTemplate: public AbstractBaseFloatTag {
        static_assert(
            std::is_same_v<T, float> ||
            std::is_same_v<T, double>,
            "T must be float or double"
        );
        public:
            T value;
            typedef T native_type;
            FloatTagTemplate() : value() {};
            FloatTagTemplate(const T& value) : value(value) {};
            FloatTagTemplate(const FloatTagTemplate<T>& other) : value(other.value) {};
            FloatTagTemplate<T>& operator=(const FloatTagTemplate<T>& rhs) { value = rhs.value; return *this; };
            FloatTagTemplate<T>& operator=(const T& rhs) { value = rhs; return *this; };
            operator const T&() const { return value; };
            operator T& () { return value; };
            bool operator==(const FloatTagTemplate<T>& rhs) { return value == rhs.value; }
            bool operator<(const FloatTagTemplate<T>& rhs) { return value < rhs.value; }
    };

    typedef float FloatTagNative;
    typedef double DoubleTagNative;

    typedef FloatTagTemplate<FloatTagNative> FloatTag;
    typedef FloatTagTemplate<DoubleTagNative> DoubleTag;

    static_assert(std::is_copy_constructible_v<FloatTag>, "FloatTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<FloatTag>, "FloatTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<DoubleTag>, "DoubleTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<DoubleTag>, "DoubleTag is not copy assignable");

    template<> struct tag_id<FloatTag> { static constexpr std::uint8_t value = 5; };
    template<> struct tag_id<DoubleTag> { static constexpr std::uint8_t value = 6; };
}
