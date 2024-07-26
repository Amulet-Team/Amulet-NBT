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
        private:
            T value;
        public:
            typedef T native_type;
            FloatTagTemplate() : value(0.0) {};
            FloatTagTemplate(const T& value) : value(value) {};
            operator const T&() const {
                return value;
            };
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
