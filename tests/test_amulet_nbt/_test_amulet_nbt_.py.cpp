#include <pybind11/pybind11.h>

#include <type_traits>

#include <amulet/nbt/tag/string.hpp>
#include <amulet/nbt/tag/string.py.hpp>

namespace detail {
template <typename To, typename From>
inline constexpr bool string_interop_v
    = std::is_constructible_v<To, const From&>
    && std::is_constructible_v<To, From&&>
    && std::is_assignable_v<To&, const From&>
    && std::is_assignable_v<To&, From&&>;

template <typename To>
inline constexpr bool string_interop_all_v
    = string_interop_v<To, std::string>
    && string_interop_v<To, Amulet::NBT::String>
    && string_interop_v<To, Amulet::NBT::StringTag>;
}

static_assert(detail::string_interop_all_v<std::string>, "std::string interop failed");
static_assert(detail::string_interop_all_v<Amulet::NBT::String>, "String interop failed");
static_assert(detail::string_interop_all_v<Amulet::NBT::StringTag>, "StringTag interop failed");

namespace py = pybind11;

void init_binary_nbt(py::module);

void init_test_amulet_nbt(py::module m)
{
    init_binary_nbt(m);
}
