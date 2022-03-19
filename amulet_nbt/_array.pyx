import numpy
cimport numpy
from numpy import ndarray
from numpy cimport ndarray
from io import BytesIO
from copy import copy, deepcopy

from ._value cimport BaseMutableTag
from ._const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from ._util cimport write_array, BufferContext, read_int, read_data
from ._list cimport ListTag


cdef class BaseArrayTag(BaseMutableTag):
    data_type = big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    def __init__(BaseArrayTag self, object value = ()):
        self.value_ = numpy.array(value, self.data_type).ravel()

    @property
    def T(self):
        """
        The transposed array.
        
        Same as ``self.transpose()``.
        
        Examples
        --------
        >>> x = np.array([[1.,2.],[3.,4.]])
        >>> x
        array([[ 1.,  2.],
               [ 3.,  4.]])
        >>> x.T
        array([[ 1.,  3.],
               [ 2.,  4.]])
        >>> x = np.array([1.,2.,3.,4.])
        >>> x
        array([ 1.,  2.,  3.,  4.])
        >>> x.T
        array([ 1.,  2.,  3.,  4.])
        
        See Also
        --------
        transpose
        """
        return self.value_.T
    
    @property
    def dtype(self):
        """
        Data-type of the array's elements.
        
        Parameters
        ----------
        None
        
        Returns
        -------
        d : numpy dtype object
        
        See Also
        --------
        numpy.dtype
        
        Examples
        --------
        >>> x
        array([[0, 1],
               [2, 3]])
        >>> x.dtype
        dtype('int32')
        >>> type(x.dtype)
        <type 'numpy.dtype'>
        """
        return self.value_.dtype
    
    @property
    def flags(self):
        """
        Information about the memory layout of the array.
        
        Attributes
        ----------
        C_CONTIGUOUS (C)
            The data is in a single, C-style contiguous segment.
        F_CONTIGUOUS (F)
            The data is in a single, Fortran-style contiguous segment.
        OWNDATA (O)
            The array owns the memory it uses or borrows it from another object.
        WRITEABLE (W)
            The data area can be written to.  Setting this to False locks
            the data, making it read-only.  A view (slice, etc.) inherits WRITEABLE
            from its base array at creation time, but a view of a writeable
            array may be subsequently locked while the base array remains writeable.
            (The opposite is not true, in that a view of a locked array may not
            be made writeable.  However, currently, locking a base object does not
            lock any views that already reference it, so under that circumstance it
            is possible to alter the contents of a locked array via a previously
            created writeable view onto it.)  Attempting to change a non-writeable
            array raises a RuntimeError exception.
        ALIGNED (A)
            The data and all elements are aligned appropriately for the hardware.
        WRITEBACKIFCOPY (X)
            This array is a copy of some other array. The C-API function
            PyArray_ResolveWritebackIfCopy must be called before deallocating
            to the base array will be updated with the contents of this array.
        UPDATEIFCOPY (U)
            (Deprecated, use WRITEBACKIFCOPY) This array is a copy of some other array.
            When this array is
            deallocated, the base array will be updated with the contents of
            this array.
        FNC
            F_CONTIGUOUS and not C_CONTIGUOUS.
        FORC
            F_CONTIGUOUS or C_CONTIGUOUS (one-segment test).
        BEHAVED (B)
            ALIGNED and WRITEABLE.
        CARRAY (CA)
            BEHAVED and C_CONTIGUOUS.
        FARRAY (FA)
            BEHAVED and F_CONTIGUOUS and not C_CONTIGUOUS.
        
        Notes
        -----
        The `flags` object can be accessed dictionary-like (as in ``a.flags['WRITEABLE']``),
        or by using lowercased attribute names (as in ``a.flags.writeable``). Short flag
        names are only supported in dictionary access.
        
        Only the WRITEBACKIFCOPY, UPDATEIFCOPY, WRITEABLE, and ALIGNED flags can be
        changed by the user, via direct assignment to the attribute or dictionary
        entry, or by calling `ndarray.setflags`.
        
        The array flags cannot be set arbitrarily:
        
        - UPDATEIFCOPY can only be set ``False``.
        - WRITEBACKIFCOPY can only be set ``False``.
        - ALIGNED can only be set ``True`` if the data is truly aligned.
        - WRITEABLE can only be set ``True`` if the array owns its own memory
          or the ultimate owner of the memory exposes a writeable buffer
          interface or is a string.
        
        Arrays can be both C-style and Fortran-style contiguous simultaneously.
        This is clear for 1-dimensional arrays, but can also be true for higher
        dimensional arrays.
        
        Even for contiguous arrays a stride for a given dimension
        ``arr.strides[dim]`` may be *arbitrary* if ``arr.shape[dim] == 1``
        or the array has no elements.
        It does *not* generally hold that ``self.strides[-1] == self.itemsize``
        for C-style contiguous arrays or ``self.strides[0] == self.itemsize`` for
        Fortran-style contiguous arrays is true.
        """
        return self.value_.flags
    
    @property
    def flat(self):
        """
        A 1-D iterator over the array.
        
        This is a `numpy.flatiter` instance, which acts similarly to, but is not
        a subclass of, Python's built-in iterator object.
        
        See Also
        --------
        flatten : Return a copy of the array collapsed into one dimension.
        
        flatiter
        
        Examples
        --------
        >>> x = np.arange(1, 7).reshape(2, 3)
        >>> x
        array([[1, 2, 3],
               [4, 5, 6]])
        >>> x.flat[3]
        4
        >>> x.T
        array([[1, 4],
               [2, 5],
               [3, 6]])
        >>> x.T.flat[3]
        5
        >>> type(x.flat)
        <class 'numpy.flatiter'>
        
        An assignment example:
        
        >>> x.flat = 3; x
        array([[3, 3, 3],
               [3, 3, 3]])
        >>> x.flat[[1,4]] = 1; x
        array([[3, 1, 3],
               [3, 1, 3]])
        """
        return self.value_.flat
    
    @property
    def imag(self):
        """
        The imaginary part of the array.
        
        Examples
        --------
        >>> x = np.sqrt([1+0j, 0+1j])
        >>> x.imag
        array([ 0.        ,  0.70710678])
        >>> x.imag.dtype
        dtype('float64')
        """
        return self.value_.imag
    
    @property
    def itemsize(self):
        """
        Length of one array element in bytes.
        
        Examples
        --------
        >>> x = np.array([1,2,3], dtype=np.float64)
        >>> x.itemsize
        8
        >>> x = np.array([1,2,3], dtype=np.complex128)
        >>> x.itemsize
        16
        """
        return self.value_.itemsize
    
    @property
    def nbytes(self):
        """
        Total bytes consumed by the elements of the array.
        
        Notes
        -----
        Does not include memory consumed by non-element attributes of the
        array object.
        
        Examples
        --------
        >>> x = np.zeros((3,5,2), dtype=np.complex128)
        >>> x.nbytes
        480
        >>> np.prod(x.shape) * x.itemsize
        480
        """
        return self.value_.nbytes
    
    @property
    def ndim(self):
        """
        Number of array dimensions.
        
        Examples
        --------
        >>> x = np.array([1, 2, 3])
        >>> x.ndim
        1
        >>> y = np.zeros((2, 3, 4))
        >>> y.ndim
        3
        """
        return self.value_.ndim
    
    @property
    def real(self):
        """
        The real part of the array.
        
        Examples
        --------
        >>> x = np.sqrt([1+0j, 0+1j])
        >>> x.real
        array([ 1.        ,  0.70710678])
        >>> x.real.dtype
        dtype('float64')
        
        See Also
        --------
        numpy.real : equivalent function
        """
        return self.value_.real
    
    @property
    def size(self):
        """
        Number of elements in the array.
        
        Equal to ``np.prod(a.shape)``, i.e., the product of the array's
        dimensions.
        
        Notes
        -----
        `a.size` returns a standard arbitrary precision Python integer. This
        may not be the case with other methods of obtaining the same value
        (like the suggested ``np.prod(a.shape)``, which returns an instance
        of ``np.int_``), and may be relevant if the value is used further in
        calculations that may overflow a fixed size integer type.
        
        Examples
        --------
        >>> x = np.zeros((3, 5, 2), dtype=np.complex128)
        >>> x.size
        30
        >>> np.prod(x.shape)
        30
        """
        return self.value_.size
    
    def all(self, *args, **kwargs):
        return self.value_.all(*args, **kwargs)
    all.__doc__ = ndarray.all.__doc__
    
    def any(self, *args, **kwargs):
        return self.value_.any(*args, **kwargs)
    any.__doc__ = ndarray.any.__doc__
    
    def argmax(self, *args, **kwargs):
        return self.value_.argmax(*args, **kwargs)
    argmax.__doc__ = ndarray.argmax.__doc__
    
    def argmin(self, *args, **kwargs):
        return self.value_.argmin(*args, **kwargs)
    argmin.__doc__ = ndarray.argmin.__doc__
    
    def argpartition(self, *args, **kwargs):
        return self.value_.argpartition(*args, **kwargs)
    argpartition.__doc__ = ndarray.argpartition.__doc__
    
    def argsort(self, *args, **kwargs):
        return self.value_.argsort(*args, **kwargs)
    argsort.__doc__ = ndarray.argsort.__doc__
    
    def astype(self, *args, **kwargs):
        return self.value_.astype(*args, **kwargs)
    astype.__doc__ = ndarray.astype.__doc__
    
    def byteswap(self, *args, **kwargs):
        return self.value_.byteswap(*args, **kwargs)
    byteswap.__doc__ = ndarray.byteswap.__doc__
    
    def choose(self, *args, **kwargs):
        return self.value_.choose(*args, **kwargs)
    choose.__doc__ = ndarray.choose.__doc__
    
    def clip(self, *args, **kwargs):
        return self.value_.clip(*args, **kwargs)
    clip.__doc__ = ndarray.clip.__doc__
    
    def compress(self, *args, **kwargs):
        return self.value_.compress(*args, **kwargs)
    compress.__doc__ = ndarray.compress.__doc__
    
    def conj(self, *args, **kwargs):
        return self.value_.conj(*args, **kwargs)
    conj.__doc__ = ndarray.conj.__doc__
    
    def conjugate(self, *args, **kwargs):
        return self.value_.conjugate(*args, **kwargs)
    conjugate.__doc__ = ndarray.conjugate.__doc__
    
    def cumprod(self, *args, **kwargs):
        return self.value_.cumprod(*args, **kwargs)
    cumprod.__doc__ = ndarray.cumprod.__doc__
    
    def cumsum(self, *args, **kwargs):
        return self.value_.cumsum(*args, **kwargs)
    cumsum.__doc__ = ndarray.cumsum.__doc__
    
    def diagonal(self, *args, **kwargs):
        return self.value_.diagonal(*args, **kwargs)
    diagonal.__doc__ = ndarray.diagonal.__doc__
    
    def dot(self, *args, **kwargs):
        return self.value_.dot(*args, **kwargs)
    dot.__doc__ = ndarray.dot.__doc__
    
    def dump(self, *args, **kwargs):
        return self.value_.dump(*args, **kwargs)
    dump.__doc__ = ndarray.dump.__doc__
    
    def dumps(self, *args, **kwargs):
        return self.value_.dumps(*args, **kwargs)
    dumps.__doc__ = ndarray.dumps.__doc__
    
    def fill(self, *args, **kwargs):
        return self.value_.fill(*args, **kwargs)
    fill.__doc__ = ndarray.fill.__doc__
    
    def flatten(self, *args, **kwargs):
        return self.value_.flatten(*args, **kwargs)
    flatten.__doc__ = ndarray.flatten.__doc__
    
    def getfield(self, *args, **kwargs):
        return self.value_.getfield(*args, **kwargs)
    getfield.__doc__ = ndarray.getfield.__doc__
    
    def item(self, *args, **kwargs):
        return self.value_.item(*args, **kwargs)
    item.__doc__ = ndarray.item.__doc__
    
    def itemset(self, *args, **kwargs):
        return self.value_.itemset(*args, **kwargs)
    itemset.__doc__ = ndarray.itemset.__doc__
    
    def max(self, *args, **kwargs):
        return self.value_.max(*args, **kwargs)
    max.__doc__ = ndarray.max.__doc__
    
    def mean(self, *args, **kwargs):
        return self.value_.mean(*args, **kwargs)
    mean.__doc__ = ndarray.mean.__doc__
    
    def min(self, *args, **kwargs):
        return self.value_.min(*args, **kwargs)
    min.__doc__ = ndarray.min.__doc__
    
    def newbyteorder(self, *args, **kwargs):
        return self.value_.newbyteorder(*args, **kwargs)
    newbyteorder.__doc__ = ndarray.newbyteorder.__doc__
    
    def nonzero(self, *args, **kwargs):
        return self.value_.nonzero(*args, **kwargs)
    nonzero.__doc__ = ndarray.nonzero.__doc__
    
    def partition(self, *args, **kwargs):
        return self.value_.partition(*args, **kwargs)
    partition.__doc__ = ndarray.partition.__doc__
    
    def prod(self, *args, **kwargs):
        return self.value_.prod(*args, **kwargs)
    prod.__doc__ = ndarray.prod.__doc__
    
    def ptp(self, *args, **kwargs):
        return self.value_.ptp(*args, **kwargs)
    ptp.__doc__ = ndarray.ptp.__doc__
    
    def put(self, *args, **kwargs):
        return self.value_.put(*args, **kwargs)
    put.__doc__ = ndarray.put.__doc__
    
    def ravel(self, *args, **kwargs):
        return self.value_.ravel(*args, **kwargs)
    ravel.__doc__ = ndarray.ravel.__doc__
    
    def repeat(self, *args, **kwargs):
        return self.value_.repeat(*args, **kwargs)
    repeat.__doc__ = ndarray.repeat.__doc__
    
    def reshape(self, *args, **kwargs):
        return self.value_.reshape(*args, **kwargs)
    reshape.__doc__ = ndarray.reshape.__doc__
    
    def round(self, *args, **kwargs):
        return self.value_.round(*args, **kwargs)
    round.__doc__ = ndarray.round.__doc__
    
    def searchsorted(self, *args, **kwargs):
        return self.value_.searchsorted(*args, **kwargs)
    searchsorted.__doc__ = ndarray.searchsorted.__doc__
    
    def setfield(self, *args, **kwargs):
        return self.value_.setfield(*args, **kwargs)
    setfield.__doc__ = ndarray.setfield.__doc__
    
    def setflags(self, *args, **kwargs):
        return self.value_.setflags(*args, **kwargs)
    setflags.__doc__ = ndarray.setflags.__doc__
    
    def sort(self, *args, **kwargs):
        return self.value_.sort(*args, **kwargs)
    sort.__doc__ = ndarray.sort.__doc__
    
    def squeeze(self, *args, **kwargs):
        return self.value_.squeeze(*args, **kwargs)
    squeeze.__doc__ = ndarray.squeeze.__doc__
    
    def std(self, *args, **kwargs):
        return self.value_.std(*args, **kwargs)
    std.__doc__ = ndarray.std.__doc__
    
    def sum(self, *args, **kwargs):
        return self.value_.sum(*args, **kwargs)
    sum.__doc__ = ndarray.sum.__doc__
    
    def swapaxes(self, *args, **kwargs):
        return self.value_.swapaxes(*args, **kwargs)
    swapaxes.__doc__ = ndarray.swapaxes.__doc__
    
    def take(self, *args, **kwargs):
        return self.value_.take(*args, **kwargs)
    take.__doc__ = ndarray.take.__doc__
    
    def tobytes(self, *args, **kwargs):
        return self.value_.tobytes(*args, **kwargs)
    tobytes.__doc__ = ndarray.tobytes.__doc__
    
    def tofile(self, *args, **kwargs):
        return self.value_.tofile(*args, **kwargs)
    tofile.__doc__ = ndarray.tofile.__doc__
    
    def tolist(self, *args, **kwargs):
        return self.value_.tolist(*args, **kwargs)
    tolist.__doc__ = ndarray.tolist.__doc__
    
    def tostring(self, *args, **kwargs):
        return self.value_.tostring(*args, **kwargs)
    tostring.__doc__ = ndarray.tostring.__doc__
    
    def trace(self, *args, **kwargs):
        return self.value_.trace(*args, **kwargs)
    trace.__doc__ = ndarray.trace.__doc__
    
    def transpose(self, *args, **kwargs):
        return self.value_.transpose(*args, **kwargs)
    transpose.__doc__ = ndarray.transpose.__doc__
    
    def var(self, *args, **kwargs):
        return self.value_.var(*args, **kwargs)
    var.__doc__ = ndarray.var.__doc__
    
    def view(self, *args, **kwargs):
        return self.value_.view(*args, **kwargs)
    view.__doc__ = ndarray.view.__doc__
    
    def __str__(BaseArrayTag self):
        return str(self.value_)

    def __dir__(BaseArrayTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(BaseArrayTag self, other):
        return self.value_ == other

    def __ge__(BaseArrayTag self, other):
        return self.value_ >= other

    def __gt__(BaseArrayTag self, other):
        return self.value_ > other

    def __le__(BaseArrayTag self, other):
        return self.value_ <= other

    def __lt__(BaseArrayTag self, other):
        return self.value_ < other

    def __reduce__(BaseArrayTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(BaseArrayTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(BaseArrayTag self):
        return self.__class__(self.value_)

    @property
    def py_data(BaseArrayTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)

    __hash__ = None
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
        return tuple(self.value_.shape[i] for i in range(self.value_.ndim))
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
        return tuple(self.value_.strides[i] for i in range(self.value_.ndim))
    # strides.__doc__ = numpy.ndarray.strides.__doc__

    def resize(*args, **kwargs):
        raise Exception("The TAG_Array classes are 1D arrays and cannot be resized in place. Try reshape to get a copy.")

    cdef numpy.ndarray _as_endianness(BaseArrayTag self, bint little_endian = False):
        return self.value_.astype(self.little_endian_data_type if little_endian else self.big_endian_data_type)

    def __repr__(BaseArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(BaseArrayTag self, other):
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, ListTag)):
            return numpy.array_equal(self.value_, other)
        return NotImplemented

    def __getitem__(BaseArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__(BaseArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__(BaseArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__(BaseArrayTag self):
        return len(self.value_)

    def __add__(BaseArrayTag self, other):
        return (self.value_ + other).astype(self.data_type)

    def __radd__(BaseArrayTag self, other):
        return (other + self.value_).astype(self.data_type)

    def __iadd__(BaseArrayTag self, other):
        self.value_ += other
        return self

    def __sub__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rsub__(BaseArrayTag self, other):
        return (other - self.value_).astype(self.data_type)

    def __isub__(BaseArrayTag self, other):
        self.value_ -= other
        return self

    def __mul__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.data_type)

    def __rmul__(BaseArrayTag self, other):
        return (other * self.value_).astype(self.data_type)

    def __imul__(BaseArrayTag self, other):
        self.value_ *= other
        return self

    def __matmul__(BaseArrayTag self, other):
        return (self.value_ @ other).astype(self.data_type)

    def __rmatmul__(BaseArrayTag self, other):
        return (other @ self.value_).astype(self.data_type)

    def __imatmul__(BaseArrayTag self, other):
        self.value_ @= other
        return self

    def __truediv__(BaseArrayTag self, other):
        return (self.value_ / other).astype(self.data_type)

    def __rtruediv__(BaseArrayTag self, other):
        return (other / self.value_).astype(self.data_type)

    def __itruediv__(BaseArrayTag self, other):
        self.value_ /= other
        return self

    def __floordiv__(BaseArrayTag self, other):
        return (self.value_ // other).astype(self.data_type)

    def __rfloordiv__(BaseArrayTag self, other):
        return (other // self.value_).astype(self.data_type)

    def __ifloordiv__(BaseArrayTag self, other):
        self.value_ //= other
        return self

    def __mod__(BaseArrayTag self, other):
        return (self.value_ % other).astype(self.data_type)

    def __rmod__(BaseArrayTag self, other):
        return (other % self.value_).astype(self.data_type)

    def __imod__(BaseArrayTag self, other):
        self.value_ %= other
        return self

    def __divmod__(BaseArrayTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(BaseArrayTag self, other):
        return divmod(other, self.value_)

    def __pow__(BaseArrayTag self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.data_type)

    def __rpow__(BaseArrayTag self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.data_type)

    def __ipow__(BaseArrayTag self, other):
        self.value_ **= other
        return self

    def __lshift__(BaseArrayTag self, other):
        return (self.value_ << other).astype(self.data_type)

    def __rlshift__(BaseArrayTag self, other):
        return (other << self.value_).astype(self.data_type)

    def __ilshift__(BaseArrayTag self, other):
        self.value_ <<= other
        return self

    def __rshift__(BaseArrayTag self, other):
        return (self.value_ >> other).astype(self.data_type)

    def __rrshift__(BaseArrayTag self, other):
        return (other >> self.value_).astype(self.data_type)

    def __irshift__(BaseArrayTag self, other):
        self.value_ >>= other
        return self

    def __and__(BaseArrayTag self, other):
        return (self.value_ & other).astype(self.data_type)

    def __rand__(BaseArrayTag self, other):
        return (other & self.value_).astype(self.data_type)

    def __iand__(BaseArrayTag self, other):
        self.value_ &= other
        return self

    def __xor__(BaseArrayTag self, other):
        return (self.value_ ^ other).astype(self.data_type)

    def __rxor__(BaseArrayTag self, other):
        return (other ^ self.value_).astype(self.data_type)

    def __ixor__(BaseArrayTag self, other):
        self.value_ ^= other
        return self

    def __or__(BaseArrayTag self, other):
        return (self.value_ | other).astype(self.data_type)

    def __ror__(BaseArrayTag self, other):
        return (other | self.value_).astype(self.data_type)

    def __ior__(BaseArrayTag self, other):
        self.value_ |= other
        return self

    def __neg__(BaseArrayTag self):
        return self.value_.__neg__()

    def __pos__(BaseArrayTag self):
        return self.value_.__pos__()

    def __abs__(BaseArrayTag self):
        return self.value_.__abs__()


BaseArrayType = BaseArrayTag


cdef inline void _read_byte_array_tag_payload(ByteArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef char*arr = read_data(buffer, length)
    data_type = ByteArrayTag.little_endian_data_type if little_endian else ByteArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:length], dtype=data_type, count=length), ByteArrayTag.data_type).ravel()


cdef class ByteArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a byte."""
    tag_id = ID_BYTE_ARRAY
    data_type = big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(ByteArrayTag self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(ByteArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 1, little_endian)

    @staticmethod
    cdef ByteArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef ByteArrayTag tag = ByteArrayTag.__new__(ByteArrayTag)
        _read_byte_array_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_int_array_tag_payload(IntArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 4
    cdef char*arr = read_data(buffer, byte_length)
    cdef object data_type = IntArrayTag.little_endian_data_type if little_endian else IntArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), IntArrayTag.data_type).ravel()


cdef class IntArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 4 bytes."""
    tag_id = ID_INT_ARRAY
    data_type = numpy.int32
    big_endian_data_type = numpy.dtype(">i4")
    little_endian_data_type = numpy.dtype("<i4")

    cdef str _to_snbt(IntArrayTag self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(IntArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 4, little_endian)

    @staticmethod
    cdef IntArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef IntArrayTag tag = IntArrayTag.__new__(IntArrayTag)
        _read_int_array_tag_payload(tag, buffer, little_endian)
        return tag


cdef inline void _read_long_array_tag_payload(LongArrayTag tag, BufferContext buffer, bint little_endian):
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * 8
    cdef char*arr = read_data(buffer, byte_length)
    cdef object data_type = LongArrayTag.little_endian_data_type if little_endian else LongArrayTag.big_endian_data_type
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), LongArrayTag.data_type).ravel()


cdef class LongArrayTag(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 8 bytes."""
    tag_id = ID_LONG_ARRAY
    data_type = numpy.int64
    big_endian_data_type = numpy.dtype(">i8")
    little_endian_data_type = numpy.dtype("<i8")

    cdef str _to_snbt(LongArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(LongArrayTag self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 8, little_endian)

    @staticmethod
    cdef LongArrayTag read_payload(BufferContext buffer, bint little_endian):
        cdef LongArrayTag tag = LongArrayTag.__new__(LongArrayTag)
        _read_long_array_tag_payload(tag, buffer, little_endian)
        return tag
