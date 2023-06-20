cdef extern from "array.hpp" nogil:
    cdef cppclass Array[T]:
        ctypedef T value_type

        ctypedef size_t size_type
        ctypedef ptrdiff_t difference_type

        cppclass iterator:
            T& operator *()
            iterator operator++()
            iterator operator--()
            iterator operator+(size_type)
            iterator operator-(size_type)
            difference_type operator-(iterator)
            bint operator ==(iterator)
            bint operator !=(iterator)
            bint operator <(iterator)
            bint operator >(iterator)
            bint operator <=(iterator)
            bint operator >=(iterator)
        cppclass const_iterator(iterator):
            pass
        cppclass reverse_iterator:
            T& operator *()
            reverse_iterator operator++()
            reverse_iterator operator--()
            reverse_iterator operator+(size_type)
            reverse_iterator operator-(size_type)
            difference_type operator-(reverse_iterator)
            bint operator ==(reverse_iterator)
            bint operator !=(reverse_iterator)
            bint operator <(reverse_iterator)
            bint operator >(reverse_iterator)
            bint operator <=(reverse_iterator)
            bint operator >=(reverse_iterator)
        cppclass const_reverse_iterator(reverse_iterator):
            pass
        Array() except +
        Array(Array &) except +
        Array(size_type) except +
        Array(size_type, T &) except +
        #Array[InputIt](InputIt, InputIt)
        T& operator[](size_type)
        #Array& operator=(Array&)
        bint operator ==(Array &, Array &)
        bint operator !=(Array &, Array &)
        bint operator <(Array &, Array &)
        bint operator >(Array &, Array &)
        bint operator <=(Array &, Array &)
        bint operator >=(Array &, Array &)
        # void assign(size_type, const T&)
        # void assign[InputIt](InputIt, InputIt) except +
        T& at(size_type) except +
        T& back()
        iterator begin()
        const_iterator const_begin "begin"()
        # size_type capacity()
        # void clear()
        bint empty()
        iterator end()
        const_iterator const_end "end"()
        # iterator erase(iterator)
        # iterator erase(iterator, iterator)
        T& front()
        # iterator insert(iterator, const T&) except +
        # iterator insert(iterator, size_type, const T&) except +
        # iterator insert[InputIt](iterator, InputIt, InputIt) except +
        size_type max_size()
        # void pop_back()
        # void push_back(T&) except +
        # reverse_iterator rbegin()
        # const_reverse_iterator const_rbegin "crbegin"()
        # reverse_iterator rend()
        # const_reverse_iterator const_rend "crend"()
        # void reserve(size_type) except +
        # void resize(size_type) except +
        # void resize(size_type, T&) except +
        size_type size()
        # void swap(Array&)

        # C++11 methods
        T * data()
        const T * const_data "data"()
        # void shrink_to_fit() except +
        # iterator emplace(const_iterator, ...) except +
        # T& emplace_back(...) except +
