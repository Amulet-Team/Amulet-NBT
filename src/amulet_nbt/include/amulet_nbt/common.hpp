#pragma once

#include <type_traits>
#include <variant>
#include <memory>

template<typename V, typename T, size_t I = 0>
constexpr size_t variant_index() {
    static_assert(I < std::variant_size_v<V>, "Type T is not a member of variant V");
    if constexpr (std::is_same_v<std::variant_alternative_t<I, V>, T>) {
        return (I);
    } else {
        return (variant_index<V, T, I + 1>());
    }
}

template<class T>
struct is_shared_ptr : std::false_type {};

template<class T>
struct is_shared_ptr<std::shared_ptr<T>> : std::true_type {};
