## This file is generated from a template.
## Do not modify this file directly or your changes will get overwritten.
## Edit the accompanying .pyx.tp file instead.
# cython: language_level=3, boundscheck=False, wraparound=False
# distutils: language = c++
# distutils: extra_compile_args = CPPCARGS
# cython: c_string_type=str, c_string_encoding=utf8

import numpy
cimport numpy
numpy.import_array()
from numpy.typing import NDArray, ArrayLike
from typing import Any, overload, SupportsInt
from collections.abc import Iterable, Iterator

from cython.operator cimport dereference
from cpython cimport Py_INCREF
from libcpp.memory cimport make_shared
from libcpp.string cimport string
from amulet_nbt._libcpp.endian cimport endian
from amulet_nbt._string_encoding._cpp cimport CStringEncode
from amulet_nbt._nbt_encoding._binary cimport write_named_tag
from amulet_nbt._nbt_encoding._string cimport write_byte_array_snbt, write_int_array_snbt, write_long_array_snbt
from amulet_nbt._tag._cpp cimport TagNode, CByteArrayTag, CIntArrayTag, CLongArrayTag
from .abc cimport AbstractBaseMutableTag


cdef class AbstractBaseArrayTag(AbstractBaseMutableTag):
    @property
    def np_array(self) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        """A numpy array holding the same internal data.

        Changes to the array will also modify the internal state.
        """
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        return self.np_array

    # Sized
    def __len__(self) -> int:
        """The length of the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """
        raise NotImplementedError

    # Sequence
    @overload
    def __getitem__(self, item: int) -> numpy.int8 | numpy.int32 | numpy.int64:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        ...

    @overload
    def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        ...

    def __getitem__(self, item):
        """Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """
        raise NotImplementedError

    def __iter__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
        """Iterate through the items in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """
        raise NotImplementedError

    def __reversed__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
        """Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass

        :return: A reversed iterator.
        """
        raise NotImplementedError

    def __contains__(self, item: Any) -> bool:
        """Check if an item is in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """
        raise NotImplementedError

    # MutableSequence
    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: ArrayLike[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: ArrayLike[numpy.integer]) -> None:
        ...

    def __setitem__(self, key, value):
        """Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """
        raise NotImplementedError

    # Array interface
    def __array__(self, dtype: Any = None) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        """Get a numpy array representation of the stored data.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)

        :param dtype: This is ignored but is part of the array interace
        :return: A numpy array that shares the memory with this instance.
        """
        raise NotImplementedError


cdef class ByteArrayTag(AbstractBaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a byte."""
    tag_id: int = 7

    def __init__(self, object value: Iterable[SupportsInt] = ()) -> None:
        """Construct a new ByteArrayTag object from an array-like object."""
        cdef numpy.ndarray arr = numpy.asarray(value, numpy.dtype("int8")).ravel()
        self.cpp = make_shared[CByteArrayTag](arr.size)
        cdef size_t i
        for i in range(arr.size):
            dereference(self.cpp)[i] = arr[i]

    @staticmethod
    cdef ByteArrayTag wrap(CByteArrayTagPtr cpp):
        cdef ByteArrayTag tag = ByteArrayTag.__new__(ByteArrayTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CByteArrayTagPtr](self.cpp)
        return node

    @property
    def np_array(self) -> NDArray[numpy.int8]:
        return numpy.asarray(self)

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CByteArrayTagPtr](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_byte_array_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, ByteArrayTag):
            return False
        cdef ByteArrayTag tag = other
        return dereference(self.cpp) == dereference(tag.cpp)

    def __repr__(self) -> str:
        return f"ByteArrayTag({list(self)})"

    def __str__(self) -> str:
        return str(list(self))

    def __reduce__(self):
        return ByteArrayTag, (list(self),)

    def __copy__(self) -> ByteArrayTag:
        return ByteArrayTag.wrap(
            make_shared[CByteArrayTag](dereference(self.cpp))
        )

    def __deepcopy__(self, memo=None) -> ByteArrayTag:
        return ByteArrayTag.wrap(
            make_shared[CByteArrayTag](dereference(self.cpp))
        )

    # Sized
    def __len__(self) -> int:
        """The length of the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """
        return dereference(self.cpp).size()

    # Sequence
    @overload
    def __getitem__(self, item: int) -> numpy.int8:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int8]:
        ...

    @overload
    def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int8]:
        ...

    def __getitem__(self, object item):
        """Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """
        return numpy.asarray(self)[item]

    def __iter__(self) -> Iterator[numpy.int8]:
        """Iterate through the items in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """
        return iter(numpy.asarray(self))

    def __reversed__(self) -> Iterator[numpy.int8]:
        """Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass

        :return: A reversed iterator.
        """
        return reversed(numpy.asarray(self))

    def __contains__(self, value: int) -> bool:
        """Check if an item is in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """
        return value in numpy.asarray(self)

    # MutableSequence
    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: NDArray[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: NDArray[numpy.integer]) -> None:
        ...

    def __setitem__(self, object item, object value):
        """Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """
        numpy.asarray(self)[item] = value

    # Array interface
    def __array__(self, dtype: Any = None) -> NDArray[numpy.int8]:
        """Get a numpy array representation of the stored data.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)

        :param dtype: This is ignored but is part of the array interace
        :return: A numpy array that shares the memory with this instance.
        """
        cdef numpy.npy_intp shape[1]
        shape[0] = <numpy.npy_intp> dereference(self.cpp).size()
        cdef numpy.ndarray ndarray = numpy.PyArray_SimpleNewFromData(1, shape, numpy.NPY_INT8, dereference(self.cpp).data())
        Py_INCREF(self)
        numpy.PyArray_SetBaseObject(ndarray, self)
        return ndarray



cdef class IntArrayTag(AbstractBaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a int."""
    tag_id: int = 11

    def __init__(self, object value: Iterable[SupportsInt] = ()) -> None:
        """Construct a new IntArrayTag object from an array-like object."""
        cdef numpy.ndarray arr = numpy.asarray(value, numpy.int32).ravel()
        self.cpp = make_shared[CIntArrayTag](arr.size)
        cdef size_t i
        for i in range(arr.size):
            dereference(self.cpp)[i] = arr[i]

    @staticmethod
    cdef IntArrayTag wrap(CIntArrayTagPtr cpp):
        cdef IntArrayTag tag = IntArrayTag.__new__(IntArrayTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CIntArrayTagPtr](self.cpp)
        return node

    @property
    def np_array(self) -> NDArray[numpy.int32]:
        return numpy.asarray(self)

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CIntArrayTagPtr](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_int_array_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, IntArrayTag):
            return False
        cdef IntArrayTag tag = other
        return dereference(self.cpp) == dereference(tag.cpp)

    def __repr__(self) -> str:
        return f"IntArrayTag({list(self)})"

    def __str__(self) -> str:
        return str(list(self))

    def __reduce__(self):
        return IntArrayTag, (list(self),)

    def __copy__(self) -> IntArrayTag:
        return IntArrayTag.wrap(
            make_shared[CIntArrayTag](dereference(self.cpp))
        )

    def __deepcopy__(self, memo=None) -> IntArrayTag:
        return IntArrayTag.wrap(
            make_shared[CIntArrayTag](dereference(self.cpp))
        )

    # Sized
    def __len__(self) -> int:
        """The length of the array.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """
        return dereference(self.cpp).size()

    # Sequence
    @overload
    def __getitem__(self, item: int) -> numpy.int32:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int32]:
        ...

    @overload
    def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int32]:
        ...

    def __getitem__(self, object item):
        """Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """
        return numpy.asarray(self)[item]

    def __iter__(self) -> Iterator[numpy.int32]:
        """Iterate through the items in the array.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """
        return iter(numpy.asarray(self))

    def __reversed__(self) -> Iterator[numpy.int32]:
        """Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass

        :return: A reversed iterator.
        """
        return reversed(numpy.asarray(self))

    def __contains__(self, value: int) -> bool:
        """Check if an item is in the array.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """
        return value in numpy.asarray(self)

    # MutableSequence
    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: NDArray[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: NDArray[numpy.integer]) -> None:
        ...

    def __setitem__(self, object item, object value):
        """Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """
        numpy.asarray(self)[item] = value

    # Array interface
    def __array__(self, dtype: Any = None) -> NDArray[numpy.int32]:
        """Get a numpy array representation of the stored data.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)

        :param dtype: This is ignored but is part of the array interace
        :return: A numpy array that shares the memory with this instance.
        """
        cdef numpy.npy_intp shape[1]
        shape[0] = <numpy.npy_intp> dereference(self.cpp).size()
        cdef numpy.ndarray ndarray = numpy.PyArray_SimpleNewFromData(1, shape, numpy.NPY_INT32, dereference(self.cpp).data())
        Py_INCREF(self)
        numpy.PyArray_SetBaseObject(ndarray, self)
        return ndarray



cdef class LongArrayTag(AbstractBaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a long."""
    tag_id: int = 12

    def __init__(self, object value: Iterable[SupportsInt] = ()) -> None:
        """Construct a new LongArrayTag object from an array-like object."""
        cdef numpy.ndarray arr = numpy.asarray(value, numpy.int64).ravel()
        self.cpp = make_shared[CLongArrayTag](arr.size)
        cdef size_t i
        for i in range(arr.size):
            dereference(self.cpp)[i] = arr[i]

    @staticmethod
    cdef LongArrayTag wrap(CLongArrayTagPtr cpp):
        cdef LongArrayTag tag = LongArrayTag.__new__(LongArrayTag)
        tag.cpp = cpp
        return tag

    cdef TagNode to_node(self):
        cdef TagNode node
        node.emplace[CLongArrayTagPtr](self.cpp)
        return node

    @property
    def np_array(self) -> NDArray[numpy.int64]:
        return numpy.asarray(self)

    cdef string write_nbt(self, string name, endian endianness, CStringEncode string_encode):
        return write_named_tag[CLongArrayTagPtr](name, self.cpp, endianness, string_encode)

    def to_snbt(self, object indent: None | str | int = None) -> str:
        cdef string snbt
        write_long_array_snbt(snbt, self.cpp)
        return snbt

    def __eq__(self, object other: Any) -> bool:
        if not isinstance(other, LongArrayTag):
            return False
        cdef LongArrayTag tag = other
        return dereference(self.cpp) == dereference(tag.cpp)

    def __repr__(self) -> str:
        return f"LongArrayTag({list(self)})"

    def __str__(self) -> str:
        return str(list(self))

    def __reduce__(self):
        return LongArrayTag, (list(self),)

    def __copy__(self) -> LongArrayTag:
        return LongArrayTag.wrap(
            make_shared[CLongArrayTag](dereference(self.cpp))
        )

    def __deepcopy__(self, memo=None) -> LongArrayTag:
        return LongArrayTag.wrap(
            make_shared[CLongArrayTag](dereference(self.cpp))
        )

    # Sized
    def __len__(self) -> int:
        """The length of the array.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """
        return dereference(self.cpp).size()

    # Sequence
    @overload
    def __getitem__(self, item: int) -> numpy.int64:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int64]:
        ...

    @overload
    def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int64]:
        ...

    def __getitem__(self, object item):
        """Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """
        return numpy.asarray(self)[item]

    def __iter__(self) -> Iterator[numpy.int64]:
        """Iterate through the items in the array.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """
        return iter(numpy.asarray(self))

    def __reversed__(self) -> Iterator[numpy.int64]:
        """Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass

        :return: A reversed iterator.
        """
        return reversed(numpy.asarray(self))

    def __contains__(self, value: int) -> bool:
        """Check if an item is in the array.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """
        return value in numpy.asarray(self)

    # MutableSequence
    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: NDArray[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: NDArray[numpy.integer]) -> None:
        ...

    def __setitem__(self, object item, object value):
        """Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """
        numpy.asarray(self)[item] = value

    # Array interface
    def __array__(self, dtype: Any = None) -> NDArray[numpy.int64]:
        """Get a numpy array representation of the stored data.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)

        :param dtype: This is ignored but is part of the array interace
        :return: A numpy array that shares the memory with this instance.
        """
        cdef numpy.npy_intp shape[1]
        shape[0] = <numpy.npy_intp> dereference(self.cpp).size()
        cdef numpy.ndarray ndarray = numpy.PyArray_SimpleNewFromData(1, shape, numpy.NPY_INT64, dereference(self.cpp).data())
        Py_INCREF(self)
        numpy.PyArray_SetBaseObject(ndarray, self)
        return ndarray

