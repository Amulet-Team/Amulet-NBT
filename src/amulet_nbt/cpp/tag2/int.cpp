#include <cstdint>
#include <amulet_nbt/tag2/int.hpp>

namespace AmuletNBT {
    template <typename T>
    IntTagTemplate<T>::IntTagTemplate(): value(0){}

    template <typename T>
    IntTagTemplate<T>::IntTagTemplate(T& value): value(value){}

    template class IntTagTemplate<std::int8_t>;
    template class IntTagTemplate<std::int16_t>;
    template class IntTagTemplate<std::int32_t>;
    template class IntTagTemplate<std::int64_t>;
}
