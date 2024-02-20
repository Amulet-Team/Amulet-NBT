# distutils: language = c++

cdef extern from "<variant>" namespace "std" nogil:
    cdef cppclass variant:
        variant& operator=(variant&)

        # Observers
        size_t index()
        bint valueless_by_exception()

        # Modifiers
        T& emplace[T](...)
        void swap(...)

    cdef struct monostate

    T* get_if[T](...)
    T& get[T](...)
