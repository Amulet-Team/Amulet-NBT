#pragma once

#include <cstdint>
#include <memory>
#include <type_traits>
#include <vector>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/tag/abc.hpp>

namespace Amulet {
namespace NBT {
    template <typename T>
    class ArrayTagTemplate : private std::vector<T>, public AbstractBaseArrayTag {
        static_assert(
            std::is_same_v<T, std::int8_t> || std::is_same_v<T, std::int32_t> || std::is_same_v<T, std::int64_t>,
            "T must be int 8, 32 or 64");

    public:
        // only methods that do not change the buffer size should be exposed here
        using std::vector<T>::vector;

        // Member types
        using typename std::vector<T>::value_type;
        using typename std::vector<T>::size_type;
        using typename std::vector<T>::difference_type;
        using typename std::vector<T>::iterator;
        using typename std::vector<T>::const_iterator;
        using typename std::vector<T>::reverse_iterator;
        using typename std::vector<T>::const_reverse_iterator;

        // Element access
        using std::vector<T>::at;
        using std::vector<T>::operator[];
        using std::vector<T>::front;
        using std::vector<T>::back;
        using std::vector<T>::data;

        // Iterators
        using std::vector<T>::begin;
        using std::vector<T>::cbegin;
        using std::vector<T>::end;
        using std::vector<T>::cend;
        using std::vector<T>::rbegin;
        using std::vector<T>::crbegin;
        using std::vector<T>::rend;
        using std::vector<T>::crend;

        // Capacity
        using std::vector<T>::empty;
        using std::vector<T>::size;

        bool operator==(const ArrayTagTemplate<T>& other) const
        {
            return static_cast<const std::vector<T>&>(*this) == static_cast<const std::vector<T>&>(other);
        }

        // Cast
        explicit operator std::vector<T>() const
        {
            return static_cast<const std::vector<T>&>(*this);
        };
    };

    typedef ArrayTagTemplate<std::int8_t> ByteArrayTag;
    typedef ArrayTagTemplate<std::int32_t> IntArrayTag;
    typedef ArrayTagTemplate<std::int64_t> LongArrayTag;

    static_assert(std::is_copy_constructible_v<ByteArrayTag>, "ByteArrayTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<ByteArrayTag>, "ByteArrayTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<IntArrayTag>, "IntArrayTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<IntArrayTag>, "IntArrayTag is not copy assignable");
    static_assert(std::is_copy_constructible_v<LongArrayTag>, "LongArrayTag is not copy constructible");
    static_assert(std::is_copy_assignable_v<LongArrayTag>, "LongArrayTag is not copy assignable");

    typedef std::shared_ptr<ByteArrayTag> ByteArrayTagPtr;
    typedef std::shared_ptr<IntArrayTag> IntArrayTagPtr;
    typedef std::shared_ptr<LongArrayTag> LongArrayTagPtr;

    template <>
    struct tag_id<ByteArrayTag> {
        static constexpr std::uint8_t value = 7;
    };
    template <>
    struct tag_id<ByteArrayTagPtr> {
        static constexpr std::uint8_t value = 7;
    };
    template <>
    struct tag_id<IntArrayTag> {
        static constexpr std::uint8_t value = 11;
    };
    template <>
    struct tag_id<IntArrayTagPtr> {
        static constexpr std::uint8_t value = 11;
    };
    template <>
    struct tag_id<LongArrayTag> {
        static constexpr std::uint8_t value = 12;
    };
    template <>
    struct tag_id<LongArrayTagPtr> {
        static constexpr std::uint8_t value = 12;
    };
} // namespace NBT
} // namespace Amulet
