#pragma once

#include <type_traits>
#include <variant>

template<typename V, typename T, size_t I = 0>
constexpr size_t variant_index() {
    static_assert(I < std::variant_size_v<V>, "Type T is not a member of variant V");
    if constexpr (std::is_same_v<std::variant_alternative_t<I, V>, T>) {
        return (I);
    } else {
        return (variant_index<V, T, I + 1>());
    }
}
