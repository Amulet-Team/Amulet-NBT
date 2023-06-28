# distutils: language = c++

cdef extern from "<bit>" namespace "std" nogil:
    cdef enum endian "std::endian::type":
        little "std::endian::little"
        big "std::endian::big"
        native "std::endian::native"
