#pragma once

#include <vector>

// The standard vector class can be resized.
// To make wrapping in numpy easier we will make the size fixed at runtime.
template<class T>
class Array : private std::vector<T>
{
    public:
        // only methods that do not change the buffer size should be exposed here
        using std::vector<T>::value_type;
        using std::vector<T>::size_type;
        using std::vector<T>::difference_type;
        using std::vector<T>::iterator;
        using std::vector<T>::const_iterator;
        using std::vector<T>::reverse_iterator;
        using std::vector<T>::const_reverse_iterator;

        using std::vector<T>::vector;

        using std::vector<T>::operator[];
        using std::vector<T>::at;
        using std::vector<T>::back;
        using std::vector<T>::begin;
        using std::vector<T>::empty;
        using std::vector<T>::end;
        using std::vector<T>::front;
        using std::vector<T>::max_size;
        using std::vector<T>::size;
        using std::vector<T>::data;
};
