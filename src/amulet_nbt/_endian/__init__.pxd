cdef extern from "endian.hpp" nogil:
    void swap_endian[T](T& val)
    void swap_to_endian[T](T& val, endian endianness)
    void swap_array_to_endian[Container, Element](Container& val, endian endianness)
