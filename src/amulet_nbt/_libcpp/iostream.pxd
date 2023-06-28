# distutils: language = c++

cdef extern from "<iostream>" namespace "std":
    cdef cppclass istream:
        pass
