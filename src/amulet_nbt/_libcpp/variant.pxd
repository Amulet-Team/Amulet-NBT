# distutils: language = c++

cdef extern from "<variant>" namespace "std" nogil:
    cdef cppclass variant:
        variant& operator=(variant&)

        # value status
        bint valueless_by_exception()
        size_t index()

    cdef struct monostate

    T* get_if[T](...)
    T& get[T](...)
