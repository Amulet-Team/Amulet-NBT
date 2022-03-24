import numpy
cimport numpy
from io import BytesIO
from copy import copy, deepcopy
import warnings

from ._value cimport BaseMutableTag
from ._const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from ._util cimport write_array, BufferContext, read_int, read_data
from ._list cimport ListTag


cdef class BaseArrayTag(BaseMutableTag):
    @property
    def shape(self):
        """
        Tuple of array dimensions.
        
        The shape property is usually used to get the current shape of an array,
        but may also be used to reshape the array in-place by assigning a tuple of
        array dimensions to it.  As with `numpy.reshape`, one of the new shape
        dimensions can be -1, in which case its value is inferred from the size of
        the array and the remaining dimensions. Reshaping an array in-place will
        fail if a copy is required.
        
        Examples
        --------
        >>> x = np.array([1, 2, 3, 4])
        >>> x.shape
        (4,)
        >>> y = np.zeros((2, 3, 4))
        >>> y.shape
        (2, 3, 4)
        >>> y.shape = (3, 8)
        >>> y
        array([[ 0.,  0.,  0.,  0.,  0.,  0.,  0.,  0.],
               [ 0.,  0.,  0.,  0.,  0.,  0.,  0.,  0.],
               [ 0.,  0.,  0.,  0.,  0.,  0.,  0.,  0.]])
        >>> y.shape = (3, 6)
        Traceback (most recent call last):
          File "<stdin>", line 1, in <module>
        ValueError: total size of new array must be unchanged
        >>> np.zeros((4,2))[::2].shape = (-1,)
        Traceback (most recent call last):
          File "<stdin>", line 1, in <module>
        AttributeError: Incompatible shape for in-place modification. Use
        `.reshape()` to make a copy with the desired shape.
        
        See Also
        --------
        numpy.reshape : similar function
        ndarray.reshape : similar method
        """
        raise NotImplementedError
    # shape.__doc__ = numpy.ndarray.shape.__doc__

    @property
    def strides(self):
        """
        Tuple of bytes to step in each dimension when traversing an array.
        
        The byte offset of element ``(i[0], i[1], ..., i[n])`` in an array `a`
        is::
        
            offset = sum(np.array(i) * a.strides)
        
        A more detailed explanation of strides can be found in the
        "ndarray.rst" file in the NumPy reference guide.
        
        Notes
        -----
        Imagine an array of 32-bit integers (each 4 bytes)::
        
          x = np.array([[0, 1, 2, 3, 4],
                        [5, 6, 7, 8, 9]], dtype=np.int32)
        
        This array is stored in memory as 40 bytes, one after the other
        (known as a contiguous block of memory).  The strides of an array tell
        us how many bytes we have to skip in memory to move to the next position
        along a certain axis.  For example, we have to skip 4 bytes (1 value) to
        move to the next column, but 20 bytes (5 values) to get to the same
        position in the next row.  As such, the strides for the array `x` will be
        ``(20, 4)``.
        
        See Also
        --------
        numpy.lib.stride_tricks.as_strided
        
        Examples
        --------
        >>> y = np.reshape(np.arange(2*3*4), (2,3,4))
        >>> y
        array([[[ 0,  1,  2,  3],
                [ 4,  5,  6,  7],
                [ 8,  9, 10, 11]],
               [[12, 13, 14, 15],
                [16, 17, 18, 19],
                [20, 21, 22, 23]]])
        >>> y.strides
        (48, 16, 4)
        >>> y[1,1,1]
        17
        >>> offset=sum(y.strides * np.array((1,1,1)))
        >>> offset/y.itemsize
        17
        
        >>> x = np.reshape(np.arange(5*6*7*8), (5,6,7,8)).transpose(2,3,1,0)
        >>> x.strides
        (32, 4, 224, 1344)
        >>> i = np.array([3,5,2,2])
        >>> offset = sum(i * x.strides)
        >>> x[3,5,2,2]
        813
        >>> offset / x.itemsize
        813
        """
        raise NotImplementedError
    # strides.__doc__ = numpy.ndarray.strides.__doc__

    def __repr__(BaseArrayTag self):
        raise NotImplementedError

    def __eq__(BaseArrayTag self, other):
        raise NotImplementedError

    def __getitem__(BaseArrayTag self, item):
        raise NotImplementedError

    def __setitem__(BaseArrayTag self, key, value):
        raise NotImplementedError

    def __array__(BaseArrayTag self, dtype=None):
        raise NotImplementedError

    def __len__(BaseArrayTag self):
        raise NotImplementedError

    def __add__(BaseArrayTag self, other):
        raise NotImplementedError

    def __radd__(BaseArrayTag self, other):
        raise NotImplementedError

    def __iadd__(BaseArrayTag self, other):
        raise NotImplementedError

    def __sub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rsub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __isub__(BaseArrayTag self, other):
        raise NotImplementedError

    def __mul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __matmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmatmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imatmul__(BaseArrayTag self, other):
        raise NotImplementedError

    def __truediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rtruediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __itruediv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __floordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rfloordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ifloordiv__(BaseArrayTag self, other):
        raise NotImplementedError

    def __mod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __imod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __divmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rdivmod__(BaseArrayTag self, other):
        raise NotImplementedError

    def __pow__(BaseArrayTag self, power, modulo):
        raise NotImplementedError

    def __rpow__(BaseArrayTag self, other, modulo):
        raise NotImplementedError

    def __ipow__(BaseArrayTag self, other):
        raise NotImplementedError

    def __lshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rlshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ilshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rrshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __irshift__(BaseArrayTag self, other):
        raise NotImplementedError

    def __and__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rand__(BaseArrayTag self, other):
        raise NotImplementedError

    def __iand__(BaseArrayTag self, other):
        raise NotImplementedError

    def __xor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __rxor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ixor__(BaseArrayTag self, other):
        raise NotImplementedError

    def __or__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ror__(BaseArrayTag self, other):
        raise NotImplementedError

    def __ior__(BaseArrayTag self, other):
        raise NotImplementedError

    def __neg__(BaseArrayTag self):
        raise NotImplementedError

    def __pos__(BaseArrayTag self):
        raise NotImplementedError

    def __abs__(BaseArrayTag self):
        raise NotImplementedError


BaseArrayType = BaseArrayTag


cdef inline void _read_byte_array_tag_payload(ByteArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 1
    cdef char*arr = read_data(buffer, byte_length)
    data_type = numpy.dtype("int8") if little_endian else numpy.dtype("int8")
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), numpy.dtype("int8")).ravel()


cdef class ByteArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a byte."""
    tag_id = ID_BYTE_ARRAY

    def __init__(ByteArrayTag self, object value = ()):
        self.value_ = numpy.array(value, numpy.dtype("int8")).ravel()

    cdef str _to_snbt(ByteArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(ByteArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(
            numpy.asarray(self.value_, numpy.dtype("int8") if little_endian else numpy.dtype("int8")),
            buffer,
            1,
            little_endian
        )

    @staticmethod
    cdef ByteArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef ByteArrayTag tag = ByteArrayTag.__new__(ByteArrayTag)
        _read_byte_array_tag_payload(tag, buffer, little_endian)
        return tag

    def __str__(ByteArrayTag self):
        return str(self.value_)

    def __eq__(ByteArrayTag self, other):
        cdef ByteArrayTag other_
        if isinstance(other, ByteArrayTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(ByteArrayTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(ByteArrayTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(ByteArrayTag self):
        return self.__class__(self.value_)

    @property
    def py_data(ByteArrayTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)
    def __repr__(ByteArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(ByteArrayTag self, other):
        warnings.warn("The behaviour of __eq__ on arrays will change in the future. You should use eq_other to ensure the return is always a bool.", FutureWarning)
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def eq_other(self, other):
        return numpy.array_equal(self.value_, other)

    def __getitem__(ByteArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(ByteArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(ByteArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(ByteArrayTag self):
        return len(self.value_)



cdef inline void _read_int_array_tag_payload(IntArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 4
    cdef char*arr = read_data(buffer, byte_length)
    data_type = numpy.dtype("<i4") if little_endian else numpy.dtype(">i4")
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), numpy.int32).ravel()


cdef class IntArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a int."""
    tag_id = ID_INT_ARRAY

    def __init__(IntArrayTag self, object value = ()):
        self.value_ = numpy.array(value, numpy.int32).ravel()

    cdef str _to_snbt(IntArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}")
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(IntArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(
            numpy.asarray(self.value_, numpy.dtype("<i4") if little_endian else numpy.dtype(">i4")),
            buffer,
            4,
            little_endian
        )

    @staticmethod
    cdef IntArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef IntArrayTag tag = IntArrayTag.__new__(IntArrayTag)
        _read_int_array_tag_payload(tag, buffer, little_endian)
        return tag

    def __str__(IntArrayTag self):
        return str(self.value_)

    def __eq__(IntArrayTag self, other):
        cdef IntArrayTag other_
        if isinstance(other, IntArrayTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(IntArrayTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(IntArrayTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(IntArrayTag self):
        return self.__class__(self.value_)

    @property
    def py_data(IntArrayTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)
    def __repr__(IntArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(IntArrayTag self, other):
        warnings.warn("The behaviour of __eq__ on arrays will change in the future. You should use eq_other to ensure the return is always a bool.", FutureWarning)
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def eq_other(self, other):
        return numpy.array_equal(self.value_, other)

    def __getitem__(IntArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(IntArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(IntArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(IntArrayTag self):
        return len(self.value_)



cdef inline void _read_long_array_tag_payload(LongArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 8
    cdef char*arr = read_data(buffer, byte_length)
    data_type = numpy.dtype("<i8") if little_endian else numpy.dtype(">i8")
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), numpy.int64).ravel()


cdef class LongArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a long."""
    tag_id = ID_LONG_ARRAY

    def __init__(LongArrayTag self, object value = ()):
        self.value_ = numpy.array(value, numpy.int64).ravel()

    cdef str _to_snbt(LongArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(LongArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(
            numpy.asarray(self.value_, numpy.dtype("<i8") if little_endian else numpy.dtype(">i8")),
            buffer,
            8,
            little_endian
        )

    @staticmethod
    cdef LongArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef LongArrayTag tag = LongArrayTag.__new__(LongArrayTag)
        _read_long_array_tag_payload(tag, buffer, little_endian)
        return tag

    def __str__(LongArrayTag self):
        return str(self.value_)

    def __eq__(LongArrayTag self, other):
        cdef LongArrayTag other_
        if isinstance(other, LongArrayTag):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__(LongArrayTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(LongArrayTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(LongArrayTag self):
        return self.__class__(self.value_)

    @property
    def py_data(LongArrayTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)
    def __repr__(LongArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(LongArrayTag self, other):
        warnings.warn("The behaviour of __eq__ on arrays will change in the future. You should use eq_other to ensure the return is always a bool.", FutureWarning)
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def eq_other(self, other):
        return numpy.array_equal(self.value_, other)

    def __getitem__(LongArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(LongArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(LongArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(LongArrayTag self):
        return len(self.value_)

