#include <amulet_nbt/tag2/float.hpp>

namespace AmuletNBT {
    template <typename T>
    FloatTagTemplate<T>::FloatTagTemplate(): value(0.0){}

    template <typename T>
    FloatTagTemplate<T>::FloatTagTemplate(T& value): value(value){}

    template class FloatTagTemplate<float>;
    template class FloatTagTemplate<double>;
}
