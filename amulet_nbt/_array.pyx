import numpy
cimport numpy
from io import BytesIO
from copy import copy, deepcopy

from ._value cimport BaseMutableTag
from ._const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from ._util cimport write_array, BufferContext, read_int, read_data


cdef class BaseArrayTag(BaseMutableTag):
    def __getitem__(BaseArrayTag self, item):
        raise NotImplementedError

    def __setitem__(BaseArrayTag self, key, value):
        raise NotImplementedError

    def __array__(BaseArrayTag self, dtype=None):
        raise NotImplementedError

    def __len__(BaseArrayTag self):
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
        A numpy array holding the same internal data.
        Changes to the array will also modify the internal state.
        """
        return self.value_

    def __repr__(ByteArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(ByteArrayTag self, other):
        cdef ByteArrayTag other_
        if isinstance(other, ByteArrayTag):
            other_ = other
            return numpy.array_equal(self.value_, other_.value_)
        return False

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
        A numpy array holding the same internal data.
        Changes to the array will also modify the internal state.
        """
        return self.value_

    def __repr__(IntArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(IntArrayTag self, other):
        cdef IntArrayTag other_
        if isinstance(other, IntArrayTag):
            other_ = other
            return numpy.array_equal(self.value_, other_.value_)
        return False

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
        A numpy array holding the same internal data.
        Changes to the array will also modify the internal state.
        """
        return self.value_

    def __repr__(LongArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(LongArrayTag self, other):
        cdef LongArrayTag other_
        if isinstance(other, LongArrayTag):
            other_ = other
            return numpy.array_equal(self.value_, other_.value_)
        return False

    def __getitem__(LongArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(LongArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(LongArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(LongArrayTag self):
        return len(self.value_)
