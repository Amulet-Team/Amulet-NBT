#pragma once

#include <vector>

namespace AmuletNBT {
    // The standard vector class can be resized.
    // To make wrapping in numpy easier we will make the size fixed at runtime.
    template<class T>
    class ArrayTag : private std::vector<T>
    {
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

            bool operator==(const ArrayTag<T>& other) const
            {
                return static_cast<const std::vector<T>&>(*this) == static_cast<const std::vector<T>&>(other);
            }
    };
}
