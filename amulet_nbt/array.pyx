import numpy
cimport numpy
from io import BytesIO
from copy import copy, deepcopy

from .value cimport BaseMutableTag
from .const cimport CommaSpace, ID_BYTE_ARRAY, ID_INT_ARRAY, ID_LONG_ARRAY
from .util cimport write_array, BufferContext, read_int, read_data
from .list cimport TAG_List


cdef class BaseArrayTag(BaseMutableTag):
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    def __init__(BaseArrayTag self, object value = ()):
        self.value_ = numpy.array(value, self.big_endian_data_type).ravel()

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
        """
        a.all(axis=None, out=None, keepdims=False, *, where=True)
        
        Returns True if all elements evaluate to True.
        
        Refer to `numpy.all` for full documentation.
        
        See Also
        --------
        numpy.all : equivalent function
        """
        return self.value_.all(*args, **kwargs)
    
    def any(self, *args, **kwargs):
        """
        a.any(axis=None, out=None, keepdims=False, *, where=True)
        
        Returns True if any of the elements of `a` evaluate to True.
        
        Refer to `numpy.any` for full documentation.
        
        See Also
        --------
        numpy.any : equivalent function
        """
        return self.value_.any(*args, **kwargs)
    
    def argmax(self, *args, **kwargs):
        """
        a.argmax(axis=None, out=None)
        
        Return indices of the maximum values along the given axis.
        
        Refer to `numpy.argmax` for full documentation.
        
        See Also
        --------
        numpy.argmax : equivalent function
        """
        return self.value_.argmax(*args, **kwargs)
    
    def argmin(self, *args, **kwargs):
        """
        a.argmin(axis=None, out=None)
        
        Return indices of the minimum values along the given axis.
        
        Refer to `numpy.argmin` for detailed documentation.
        
        See Also
        --------
        numpy.argmin : equivalent function
        """
        return self.value_.argmin(*args, **kwargs)
    
    def argpartition(self, *args, **kwargs):
        """
        a.argpartition(kth, axis=-1, kind='introselect', order=None)
        
        Returns the indices that would partition this array.
        
        Refer to `numpy.argpartition` for full documentation.
        
        .. versionadded:: 1.8.0
        
        See Also
        --------
        numpy.argpartition : equivalent function
        """
        return self.value_.argpartition(*args, **kwargs)
    
    def argsort(self, *args, **kwargs):
        """
        a.argsort(axis=-1, kind=None, order=None)
        
        Returns the indices that would sort this array.
        
        Refer to `numpy.argsort` for full documentation.
        
        See Also
        --------
        numpy.argsort : equivalent function
        """
        return self.value_.argsort(*args, **kwargs)
    
    def astype(self, *args, **kwargs):
        """
        a.astype(dtype, order='K', casting='unsafe', subok=True, copy=True)
        
        Copy of the array, cast to a specified type.
        
        Parameters
        ----------
        dtype : str or dtype
            Typecode or data-type to which the array is cast.
        order : {'C', 'F', 'A', 'K'}, optional
            Controls the memory layout order of the result.
            'C' means C order, 'F' means Fortran order, 'A'
            means 'F' order if all the arrays are Fortran contiguous,
            'C' order otherwise, and 'K' means as close to the
            order the array elements appear in memory as possible.
            Default is 'K'.
        casting : {'no', 'equiv', 'safe', 'same_kind', 'unsafe'}, optional
            Controls what kind of data casting may occur. Defaults to 'unsafe'
            for backwards compatibility.
        
              * 'no' means the data types should not be cast at all.
              * 'equiv' means only byte-order changes are allowed.
              * 'safe' means only casts which can preserve values are allowed.
              * 'same_kind' means only safe casts or casts within a kind,
                like float64 to float32, are allowed.
              * 'unsafe' means any data conversions may be done.
        subok : bool, optional
            If True, then sub-classes will be passed-through (default), otherwise
            the returned array will be forced to be a base-class array.
        copy : bool, optional
            By default, astype always returns a newly allocated array. If this
            is set to false, and the `dtype`, `order`, and `subok`
            requirements are satisfied, the input array is returned instead
            of a copy.
        
        Returns
        -------
        arr_t : ndarray
            Unless `copy` is False and the other conditions for returning the input
            array are satisfied (see description for `copy` input parameter), `arr_t`
            is a new array of the same shape as the input array, with dtype, order
            given by `dtype`, `order`.
        
        Notes
        -----
        .. versionchanged:: 1.17.0
           Casting between a simple data type and a structured one is possible only
           for "unsafe" casting.  Casting to multiple fields is allowed, but
           casting from multiple fields is not.
        
        .. versionchanged:: 1.9.0
           Casting from numeric to string types in 'safe' casting mode requires
           that the string dtype length is long enough to store the max
           integer/float value converted.
        
        Raises
        ------
        ComplexWarning
            When casting from complex to float or int. To avoid this,
            one should use ``a.real.astype(t)``.
        
        Examples
        --------
        >>> x = np.array([1, 2, 2.5])
        >>> x
        array([1. ,  2. ,  2.5])
        
        >>> x.astype(int)
        array([1, 2, 2])
        """
        return self.value_.astype(*args, **kwargs)
    
    def byteswap(self, *args, **kwargs):
        """
        a.byteswap(inplace=False)
        
        Swap the bytes of the array elements
        
        Toggle between low-endian and big-endian data representation by
        returning a byteswapped array, optionally swapped in-place.
        Arrays of byte-strings are not swapped. The real and imaginary
        parts of a complex number are swapped individually.
        
        Parameters
        ----------
        inplace : bool, optional
            If ``True``, swap bytes in-place, default is ``False``.
        
        Returns
        -------
        out : ndarray
            The byteswapped array. If `inplace` is ``True``, this is
            a view to self.
        
        Examples
        --------
        >>> A = np.array([1, 256, 8755], dtype=np.int16)
        >>> list(map(hex, A))
        ['0x1', '0x100', '0x2233']
        >>> A.byteswap(inplace=True)
        array([  256,     1, 13090], dtype=int16)
        >>> list(map(hex, A))
        ['0x100', '0x1', '0x3322']
        
        Arrays of byte-strings are not swapped
        
        >>> A = np.array([b'ceg', b'fac'])
        >>> A.byteswap()
        array([b'ceg', b'fac'], dtype='|S3')
        
        ``A.newbyteorder().byteswap()`` produces an array with the same values
          but different representation in memory
        
        >>> A = np.array([1, 2, 3])
        >>> A.view(np.uint8)
        array([1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0,
               0, 0], dtype=uint8)
        >>> A.newbyteorder().byteswap(inplace=True)
        array([1, 2, 3])
        >>> A.view(np.uint8)
        array([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
               0, 3], dtype=uint8)
        """
        return self.value_.byteswap(*args, **kwargs)
    
    def choose(self, *args, **kwargs):
        """
        a.choose(choices, out=None, mode='raise')
        
        Use an index array to construct a new array from a set of choices.
        
        Refer to `numpy.choose` for full documentation.
        
        See Also
        --------
        numpy.choose : equivalent function
        """
        return self.value_.choose(*args, **kwargs)
    
    def clip(self, *args, **kwargs):
        """
        a.clip(min=None, max=None, out=None, **kwargs)
        
        Return an array whose values are limited to ``[min, max]``.
        One of max or min must be given.
        
        Refer to `numpy.clip` for full documentation.
        
        See Also
        --------
        numpy.clip : equivalent function
        """
        return self.value_.clip(*args, **kwargs)
    
    def compress(self, *args, **kwargs):
        """
        a.compress(condition, axis=None, out=None)
        
        Return selected slices of this array along given axis.
        
        Refer to `numpy.compress` for full documentation.
        
        See Also
        --------
        numpy.compress : equivalent function
        """
        return self.value_.compress(*args, **kwargs)
    
    def conj(self, *args, **kwargs):
        """
        a.conj()
        
        Complex-conjugate all elements.
        
        Refer to `numpy.conjugate` for full documentation.
        
        See Also
        --------
        numpy.conjugate : equivalent function
        """
        return self.value_.conj(*args, **kwargs)
    
    def conjugate(self, *args, **kwargs):
        """
        a.conjugate()
        
        Return the complex conjugate, element-wise.
        
        Refer to `numpy.conjugate` for full documentation.
        
        See Also
        --------
        numpy.conjugate : equivalent function
        """
        return self.value_.conjugate(*args, **kwargs)
    
    def cumprod(self, *args, **kwargs):
        """
        a.cumprod(axis=None, dtype=None, out=None)
        
        Return the cumulative product of the elements along the given axis.
        
        Refer to `numpy.cumprod` for full documentation.
        
        See Also
        --------
        numpy.cumprod : equivalent function
        """
        return self.value_.cumprod(*args, **kwargs)
    
    def cumsum(self, *args, **kwargs):
        """
        a.cumsum(axis=None, dtype=None, out=None)
        
        Return the cumulative sum of the elements along the given axis.
        
        Refer to `numpy.cumsum` for full documentation.
        
        See Also
        --------
        numpy.cumsum : equivalent function
        """
        return self.value_.cumsum(*args, **kwargs)
    
    def diagonal(self, *args, **kwargs):
        """
        a.diagonal(offset=0, axis1=0, axis2=1)
        
        Return specified diagonals. In NumPy 1.9 the returned array is a
        read-only view instead of a copy as in previous NumPy versions.  In
        a future version the read-only restriction will be removed.
        
        Refer to :func:`numpy.diagonal` for full documentation.
        
        See Also
        --------
        numpy.diagonal : equivalent function
        """
        return self.value_.diagonal(*args, **kwargs)
    
    def dot(self, *args, **kwargs):
        """
        a.dot(b, out=None)
        
        Dot product of two arrays.
        
        Refer to `numpy.dot` for full documentation.
        
        See Also
        --------
        numpy.dot : equivalent function
        
        Examples
        --------
        >>> a = np.eye(2)
        >>> b = np.ones((2, 2)) * 2
        >>> a.dot(b)
        array([[2.,  2.],
               [2.,  2.]])
        
        This array method can be conveniently chained:
        
        >>> a.dot(b).dot(b)
        array([[8.,  8.],
               [8.,  8.]])
        """
        return self.value_.dot(*args, **kwargs)
    
    def dump(self, *args, **kwargs):
        """
        a.dump(file)
        
        Dump a pickle of the array to the specified file.
        The array can be read back with pickle.load or numpy.load.
        
        Parameters
        ----------
        file : str or Path
            A string naming the dump file.
        
            .. versionchanged:: 1.17.0
                `pathlib.Path` objects are now accepted.
        """
        return self.value_.dump(*args, **kwargs)
    
    def dumps(self, *args, **kwargs):
        """
        a.dumps()
        
        Returns the pickle of the array as a string.
        pickle.loads or numpy.loads will convert the string back to an array.
        
        Parameters
        ----------
        None
        """
        return self.value_.dumps(*args, **kwargs)
    
    def fill(self, *args, **kwargs):
        """
        a.fill(value)
        
        Fill the array with a scalar value.
        
        Parameters
        ----------
        value : scalar
            All elements of `a` will be assigned this value.
        
        Examples
        --------
        >>> a = np.array([1, 2])
        >>> a.fill(0)
        >>> a
        array([0, 0])
        >>> a = np.empty(2)
        >>> a.fill(1)
        >>> a
        array([1.,  1.])
        """
        return self.value_.fill(*args, **kwargs)
    
    def flatten(self, *args, **kwargs):
        """
        a.flatten(order='C')
        
        Return a copy of the array collapsed into one dimension.
        
        Parameters
        ----------
        order : {'C', 'F', 'A', 'K'}, optional
            'C' means to flatten in row-major (C-style) order.
            'F' means to flatten in column-major (Fortran-
            style) order. 'A' means to flatten in column-major
            order if `a` is Fortran *contiguous* in memory,
            row-major order otherwise. 'K' means to flatten
            `a` in the order the elements occur in memory.
            The default is 'C'.
        
        Returns
        -------
        y : ndarray
            A copy of the input array, flattened to one dimension.
        
        See Also
        --------
        ravel : Return a flattened array.
        flat : A 1-D flat iterator over the array.
        
        Examples
        --------
        >>> a = np.array([[1,2], [3,4]])
        >>> a.flatten()
        array([1, 2, 3, 4])
        >>> a.flatten('F')
        array([1, 3, 2, 4])
        """
        return self.value_.flatten(*args, **kwargs)
    
    def getfield(self, *args, **kwargs):
        """
        a.getfield(dtype, offset=0)
        
        Returns a field of the given array as a certain type.
        
        A field is a view of the array data with a given data-type. The values in
        the view are determined by the given type and the offset into the current
        array in bytes. The offset needs to be such that the view dtype fits in the
        array dtype; for example an array of dtype complex128 has 16-byte elements.
        If taking a view with a 32-bit integer (4 bytes), the offset needs to be
        between 0 and 12 bytes.
        
        Parameters
        ----------
        dtype : str or dtype
            The data type of the view. The dtype size of the view can not be larger
            than that of the array itself.
        offset : int
            Number of bytes to skip before beginning the element view.
        
        Examples
        --------
        >>> x = np.diag([1.+1.j]*2)
        >>> x[1, 1] = 2 + 4.j
        >>> x
        array([[1.+1.j,  0.+0.j],
               [0.+0.j,  2.+4.j]])
        >>> x.getfield(np.float64)
        array([[1.,  0.],
               [0.,  2.]])
        
        By choosing an offset of 8 bytes we can select the complex part of the
        array for our view:
        
        >>> x.getfield(np.float64, offset=8)
        array([[1.,  0.],
               [0.,  4.]])
        """
        return self.value_.getfield(*args, **kwargs)
    
    def item(self, *args, **kwargs):
        """
        a.item(*args)
        
        Copy an element of an array to a standard Python scalar and return it.
        
        Parameters
        ----------
        \*args : Arguments (variable number and type)
        
            * none: in this case, the method only works for arrays
              with one element (`a.size == 1`), which element is
              copied into a standard Python scalar object and returned.
        
            * int_type: this argument is interpreted as a flat index into
              the array, specifying which element to copy and return.
        
            * tuple of int_types: functions as does a single int_type argument,
              except that the argument is interpreted as an nd-index into the
              array.
        
        Returns
        -------
        z : Standard Python scalar object
            A copy of the specified element of the array as a suitable
            Python scalar
        
        Notes
        -----
        When the data type of `a` is longdouble or clongdouble, item() returns
        a scalar array object because there is no available Python scalar that
        would not lose information. Void arrays return a buffer object for item(),
        unless fields are defined, in which case a tuple is returned.
        
        `item` is very similar to a[args], except, instead of an array scalar,
        a standard Python scalar is returned. This can be useful for speeding up
        access to elements of the array and doing arithmetic on elements of the
        array using Python's optimized math.
        
        Examples
        --------
        >>> np.random.seed(123)
        >>> x = np.random.randint(9, size=(3, 3))
        >>> x
        array([[2, 2, 6],
               [1, 3, 6],
               [1, 0, 1]])
        >>> x.item(3)
        1
        >>> x.item(7)
        0
        >>> x.item((0, 1))
        2
        >>> x.item((2, 2))
        1
        """
        return self.value_.item(*args, **kwargs)
    
    def itemset(self, *args, **kwargs):
        """
        a.itemset(*args)
        
        Insert scalar into an array (scalar is cast to array's dtype, if possible)
        
        There must be at least 1 argument, and define the last argument
        as *item*.  Then, ``a.itemset(*args)`` is equivalent to but faster
        than ``a[args] = item``.  The item should be a scalar value and `args`
        must select a single item in the array `a`.
        
        Parameters
        ----------
        \*args : Arguments
            If one argument: a scalar, only used in case `a` is of size 1.
            If two arguments: the last argument is the value to be set
            and must be a scalar, the first argument specifies a single array
            element location. It is either an int or a tuple.
        
        Notes
        -----
        Compared to indexing syntax, `itemset` provides some speed increase
        for placing a scalar into a particular location in an `ndarray`,
        if you must do this.  However, generally this is discouraged:
        among other problems, it complicates the appearance of the code.
        Also, when using `itemset` (and `item`) inside a loop, be sure
        to assign the methods to a local variable to avoid the attribute
        look-up at each loop iteration.
        
        Examples
        --------
        >>> np.random.seed(123)
        >>> x = np.random.randint(9, size=(3, 3))
        >>> x
        array([[2, 2, 6],
               [1, 3, 6],
               [1, 0, 1]])
        >>> x.itemset(4, 0)
        >>> x.itemset((2, 2), 9)
        >>> x
        array([[2, 2, 6],
               [1, 0, 6],
               [1, 0, 9]])
        """
        return self.value_.itemset(*args, **kwargs)
    
    def max(self, *args, **kwargs):
        """
        a.max(axis=None, out=None, keepdims=False, initial=<no value>, where=True)
        
        Return the maximum along a given axis.
        
        Refer to `numpy.amax` for full documentation.
        
        See Also
        --------
        numpy.amax : equivalent function
        """
        return self.value_.max(*args, **kwargs)
    
    def mean(self, *args, **kwargs):
        """
        a.mean(axis=None, dtype=None, out=None, keepdims=False, *, where=True)
        
        Returns the average of the array elements along given axis.
        
        Refer to `numpy.mean` for full documentation.
        
        See Also
        --------
        numpy.mean : equivalent function
        """
        return self.value_.mean(*args, **kwargs)
    
    def min(self, *args, **kwargs):
        """
        a.min(axis=None, out=None, keepdims=False, initial=<no value>, where=True)
        
        Return the minimum along a given axis.
        
        Refer to `numpy.amin` for full documentation.
        
        See Also
        --------
        numpy.amin : equivalent function
        """
        return self.value_.min(*args, **kwargs)
    
    def newbyteorder(self, *args, **kwargs):
        """
        arr.newbyteorder(new_order='S', /)
        
        Return the array with the same data viewed with a different byte order.
        
        Equivalent to::
        
            arr.view(arr.dtype.newbytorder(new_order))
        
        Changes are also made in all fields and sub-arrays of the array data
        type.
        
        
        
        Parameters
        ----------
        new_order : string, optional
            Byte order to force; a value from the byte order specifications
            below. `new_order` codes can be any of:
        
            * 'S' - swap dtype from current to opposite endian
            * {'<', 'little'} - little endian
            * {'>', 'big'} - big endian
            * '=' - native order, equivalent to `sys.byteorder`
            * {'|', 'I'} - ignore (no change to byte order)
        
            The default value ('S') results in swapping the current
            byte order.
        
        
        Returns
        -------
        new_arr : array
            New array object with the dtype reflecting given change to the
            byte order.
        """
        return self.value_.newbyteorder(*args, **kwargs)
    
    def nonzero(self, *args, **kwargs):
        """
        a.nonzero()
        
        Return the indices of the elements that are non-zero.
        
        Refer to `numpy.nonzero` for full documentation.
        
        See Also
        --------
        numpy.nonzero : equivalent function
        """
        return self.value_.nonzero(*args, **kwargs)
    
    def partition(self, *args, **kwargs):
        """
        a.partition(kth, axis=-1, kind='introselect', order=None)
        
        Rearranges the elements in the array in such a way that the value of the
        element in kth position is in the position it would be in a sorted array.
        All elements smaller than the kth element are moved before this element and
        all equal or greater are moved behind it. The ordering of the elements in
        the two partitions is undefined.
        
        .. versionadded:: 1.8.0
        
        Parameters
        ----------
        kth : int or sequence of ints
            Element index to partition by. The kth element value will be in its
            final sorted position and all smaller elements will be moved before it
            and all equal or greater elements behind it.
            The order of all elements in the partitions is undefined.
            If provided with a sequence of kth it will partition all elements
            indexed by kth of them into their sorted position at once.
        axis : int, optional
            Axis along which to sort. Default is -1, which means sort along the
            last axis.
        kind : {'introselect'}, optional
            Selection algorithm. Default is 'introselect'.
        order : str or list of str, optional
            When `a` is an array with fields defined, this argument specifies
            which fields to compare first, second, etc. A single field can
            be specified as a string, and not all fields need to be specified,
            but unspecified fields will still be used, in the order in which
            they come up in the dtype, to break ties.
        
        See Also
        --------
        numpy.partition : Return a parititioned copy of an array.
        argpartition : Indirect partition.
        sort : Full sort.
        
        Notes
        -----
        See ``np.partition`` for notes on the different algorithms.
        
        Examples
        --------
        >>> a = np.array([3, 4, 2, 1])
        >>> a.partition(3)
        >>> a
        array([2, 1, 3, 4])
        
        >>> a.partition((1, 3))
        >>> a
        array([1, 2, 3, 4])
        """
        return self.value_.partition(*args, **kwargs)
    
    def prod(self, *args, **kwargs):
        """
        a.prod(axis=None, dtype=None, out=None, keepdims=False, initial=1, where=True)
        
        Return the product of the array elements over the given axis
        
        Refer to `numpy.prod` for full documentation.
        
        See Also
        --------
        numpy.prod : equivalent function
        """
        return self.value_.prod(*args, **kwargs)
    
    def ptp(self, *args, **kwargs):
        """
        a.ptp(axis=None, out=None, keepdims=False)
        
        Peak to peak (maximum - minimum) value along a given axis.
        
        Refer to `numpy.ptp` for full documentation.
        
        See Also
        --------
        numpy.ptp : equivalent function
        """
        return self.value_.ptp(*args, **kwargs)
    
    def put(self, *args, **kwargs):
        """
        a.put(indices, values, mode='raise')
        
        Set ``a.flat[n] = values[n]`` for all `n` in indices.
        
        Refer to `numpy.put` for full documentation.
        
        See Also
        --------
        numpy.put : equivalent function
        """
        return self.value_.put(*args, **kwargs)
    
    def ravel(self, *args, **kwargs):
        """
        a.ravel([order])
        
        Return a flattened array.
        
        Refer to `numpy.ravel` for full documentation.
        
        See Also
        --------
        numpy.ravel : equivalent function
        
        ndarray.flat : a flat iterator on the array.
        """
        return self.value_.ravel(*args, **kwargs)
    
    def repeat(self, *args, **kwargs):
        """
        a.repeat(repeats, axis=None)
        
        Repeat elements of an array.
        
        Refer to `numpy.repeat` for full documentation.
        
        See Also
        --------
        numpy.repeat : equivalent function
        """
        return self.value_.repeat(*args, **kwargs)
    
    def reshape(self, *args, **kwargs):
        """
        a.reshape(shape, order='C')
        
        Returns an array containing the same data with a new shape.
        
        Refer to `numpy.reshape` for full documentation.
        
        See Also
        --------
        numpy.reshape : equivalent function
        
        Notes
        -----
        Unlike the free function `numpy.reshape`, this method on `ndarray` allows
        the elements of the shape parameter to be passed in as separate arguments.
        For example, ``a.reshape(10, 11)`` is equivalent to
        ``a.reshape((10, 11))``.
        """
        return self.value_.reshape(*args, **kwargs)
    
    def round(self, *args, **kwargs):
        """
        a.round(decimals=0, out=None)
        
        Return `a` with each element rounded to the given number of decimals.
        
        Refer to `numpy.around` for full documentation.
        
        See Also
        --------
        numpy.around : equivalent function
        """
        return self.value_.round(*args, **kwargs)
    
    def searchsorted(self, *args, **kwargs):
        """
        a.searchsorted(v, side='left', sorter=None)
        
        Find indices where elements of v should be inserted in a to maintain order.
        
        For full documentation, see `numpy.searchsorted`
        
        See Also
        --------
        numpy.searchsorted : equivalent function
        """
        return self.value_.searchsorted(*args, **kwargs)
    
    def setfield(self, *args, **kwargs):
        """
        a.setfield(val, dtype, offset=0)
        
        Put a value into a specified place in a field defined by a data-type.
        
        Place `val` into `a`'s field defined by `dtype` and beginning `offset`
        bytes into the field.
        
        Parameters
        ----------
        val : object
            Value to be placed in field.
        dtype : dtype object
            Data-type of the field in which to place `val`.
        offset : int, optional
            The number of bytes into the field at which to place `val`.
        
        Returns
        -------
        None
        
        See Also
        --------
        getfield
        
        Examples
        --------
        >>> x = np.eye(3)
        >>> x.getfield(np.float64)
        array([[1.,  0.,  0.],
               [0.,  1.,  0.],
               [0.,  0.,  1.]])
        >>> x.setfield(3, np.int32)
        >>> x.getfield(np.int32)
        array([[3, 3, 3],
               [3, 3, 3],
               [3, 3, 3]], dtype=int32)
        >>> x
        array([[1.0e+000, 1.5e-323, 1.5e-323],
               [1.5e-323, 1.0e+000, 1.5e-323],
               [1.5e-323, 1.5e-323, 1.0e+000]])
        >>> x.setfield(np.eye(3), np.int32)
        >>> x
        array([[1.,  0.,  0.],
               [0.,  1.,  0.],
               [0.,  0.,  1.]])
        """
        return self.value_.setfield(*args, **kwargs)
    
    def setflags(self, *args, **kwargs):
        """
        a.setflags(write=None, align=None, uic=None)
        
        Set array flags WRITEABLE, ALIGNED, (WRITEBACKIFCOPY and UPDATEIFCOPY),
        respectively.
        
        These Boolean-valued flags affect how numpy interprets the memory
        area used by `a` (see Notes below). The ALIGNED flag can only
        be set to True if the data is actually aligned according to the type.
        The WRITEBACKIFCOPY and (deprecated) UPDATEIFCOPY flags can never be set
        to True. The flag WRITEABLE can only be set to True if the array owns its
        own memory, or the ultimate owner of the memory exposes a writeable buffer
        interface, or is a string. (The exception for string is made so that
        unpickling can be done without copying memory.)
        
        Parameters
        ----------
        write : bool, optional
            Describes whether or not `a` can be written to.
        align : bool, optional
            Describes whether or not `a` is aligned properly for its type.
        uic : bool, optional
            Describes whether or not `a` is a copy of another "base" array.
        
        Notes
        -----
        Array flags provide information about how the memory area used
        for the array is to be interpreted. There are 7 Boolean flags
        in use, only four of which can be changed by the user:
        WRITEBACKIFCOPY, UPDATEIFCOPY, WRITEABLE, and ALIGNED.
        
        WRITEABLE (W) the data area can be written to;
        
        ALIGNED (A) the data and strides are aligned appropriately for the hardware
        (as determined by the compiler);
        
        UPDATEIFCOPY (U) (deprecated), replaced by WRITEBACKIFCOPY;
        
        WRITEBACKIFCOPY (X) this array is a copy of some other array (referenced
        by .base). When the C-API function PyArray_ResolveWritebackIfCopy is
        called, the base array will be updated with the contents of this array.
        
        All flags can be accessed using the single (upper case) letter as well
        as the full name.
        
        Examples
        --------
        >>> y = np.array([[3, 1, 7],
        ...               [2, 0, 0],
        ...               [8, 5, 9]])
        >>> y
        array([[3, 1, 7],
               [2, 0, 0],
               [8, 5, 9]])
        >>> y.flags
          C_CONTIGUOUS : True
          F_CONTIGUOUS : False
          OWNDATA : True
          WRITEABLE : True
          ALIGNED : True
          WRITEBACKIFCOPY : False
          UPDATEIFCOPY : False
        >>> y.setflags(write=0, align=0)
        >>> y.flags
          C_CONTIGUOUS : True
          F_CONTIGUOUS : False
          OWNDATA : True
          WRITEABLE : False
          ALIGNED : False
          WRITEBACKIFCOPY : False
          UPDATEIFCOPY : False
        >>> y.setflags(uic=1)
        Traceback (most recent call last):
          File "<stdin>", line 1, in <module>
        ValueError: cannot set WRITEBACKIFCOPY flag to True
        """
        return self.value_.setflags(*args, **kwargs)
    
    def sort(self, *args, **kwargs):
        """
        a.sort(axis=-1, kind=None, order=None)
        
        Sort an array in-place. Refer to `numpy.sort` for full documentation.
        
        Parameters
        ----------
        axis : int, optional
            Axis along which to sort. Default is -1, which means sort along the
            last axis.
        kind : {'quicksort', 'mergesort', 'heapsort', 'stable'}, optional
            Sorting algorithm. The default is 'quicksort'. Note that both 'stable'
            and 'mergesort' use timsort under the covers and, in general, the
            actual implementation will vary with datatype. The 'mergesort' option
            is retained for backwards compatibility.
        
            .. versionchanged:: 1.15.0
               The 'stable' option was added.
        
        order : str or list of str, optional
            When `a` is an array with fields defined, this argument specifies
            which fields to compare first, second, etc.  A single field can
            be specified as a string, and not all fields need be specified,
            but unspecified fields will still be used, in the order in which
            they come up in the dtype, to break ties.
        
        See Also
        --------
        numpy.sort : Return a sorted copy of an array.
        numpy.argsort : Indirect sort.
        numpy.lexsort : Indirect stable sort on multiple keys.
        numpy.searchsorted : Find elements in sorted array.
        numpy.partition: Partial sort.
        
        Notes
        -----
        See `numpy.sort` for notes on the different sorting algorithms.
        
        Examples
        --------
        >>> a = np.array([[1,4], [3,1]])
        >>> a.sort(axis=1)
        >>> a
        array([[1, 4],
               [1, 3]])
        >>> a.sort(axis=0)
        >>> a
        array([[1, 3],
               [1, 4]])
        
        Use the `order` keyword to specify a field to use when sorting a
        structured array:
        
        >>> a = np.array([('a', 2), ('c', 1)], dtype=[('x', 'S1'), ('y', int)])
        >>> a.sort(order='y')
        >>> a
        array([(b'c', 1), (b'a', 2)],
              dtype=[('x', 'S1'), ('y', '<i8')])
        """
        return self.value_.sort(*args, **kwargs)
    
    def squeeze(self, *args, **kwargs):
        """
        a.squeeze(axis=None)
        
        Remove axes of length one from `a`.
        
        Refer to `numpy.squeeze` for full documentation.
        
        See Also
        --------
        numpy.squeeze : equivalent function
        """
        return self.value_.squeeze(*args, **kwargs)
    
    def std(self, *args, **kwargs):
        """
        a.std(axis=None, dtype=None, out=None, ddof=0, keepdims=False, *, where=True)
        
        Returns the standard deviation of the array elements along given axis.
        
        Refer to `numpy.std` for full documentation.
        
        See Also
        --------
        numpy.std : equivalent function
        """
        return self.value_.std(*args, **kwargs)
    
    def sum(self, *args, **kwargs):
        """
        a.sum(axis=None, dtype=None, out=None, keepdims=False, initial=0, where=True)
        
        Return the sum of the array elements over the given axis.
        
        Refer to `numpy.sum` for full documentation.
        
        See Also
        --------
        numpy.sum : equivalent function
        """
        return self.value_.sum(*args, **kwargs)
    
    def swapaxes(self, *args, **kwargs):
        """
        a.swapaxes(axis1, axis2)
        
        Return a view of the array with `axis1` and `axis2` interchanged.
        
        Refer to `numpy.swapaxes` for full documentation.
        
        See Also
        --------
        numpy.swapaxes : equivalent function
        """
        return self.value_.swapaxes(*args, **kwargs)
    
    def take(self, *args, **kwargs):
        """
        a.take(indices, axis=None, out=None, mode='raise')
        
        Return an array formed from the elements of `a` at the given indices.
        
        Refer to `numpy.take` for full documentation.
        
        See Also
        --------
        numpy.take : equivalent function
        """
        return self.value_.take(*args, **kwargs)
    
    def tobytes(self, *args, **kwargs):
        """
        a.tobytes(order='C')
        
        Construct Python bytes containing the raw data bytes in the array.
        
        Constructs Python bytes showing a copy of the raw contents of
        data memory. The bytes object is produced in C-order by default.
        This behavior is controlled by the ``order`` parameter.
        
        .. versionadded:: 1.9.0
        
        Parameters
        ----------
        order : {'C', 'F', 'A'}, optional
            Controls the memory layout of the bytes object. 'C' means C-order,
            'F' means F-order, 'A' (short for *Any*) means 'F' if `a` is
            Fortran contiguous, 'C' otherwise. Default is 'C'.
        
        Returns
        -------
        s : bytes
            Python bytes exhibiting a copy of `a`'s raw data.
        
        Examples
        --------
        >>> x = np.array([[0, 1], [2, 3]], dtype='<u2')
        >>> x.tobytes()
        b'\x00\x00\x01\x00\x02\x00\x03\x00'
        >>> x.tobytes('C') == x.tobytes()
        True
        >>> x.tobytes('F')
        b'\x00\x00\x02\x00\x01\x00\x03\x00'
        """
        return self.value_.tobytes(*args, **kwargs)
    
    def tofile(self, *args, **kwargs):
        """
        a.tofile(fid, sep="", format="%s")
        
        Write array to a file as text or binary (default).
        
        Data is always written in 'C' order, independent of the order of `a`.
        The data produced by this method can be recovered using the function
        fromfile().
        
        Parameters
        ----------
        fid : file or str or Path
            An open file object, or a string containing a filename.
        
            .. versionchanged:: 1.17.0
                `pathlib.Path` objects are now accepted.
        
        sep : str
            Separator between array items for text output.
            If "" (empty), a binary file is written, equivalent to
            ``file.write(a.tobytes())``.
        format : str
            Format string for text file output.
            Each entry in the array is formatted to text by first converting
            it to the closest Python type, and then using "format" % item.
        
        Notes
        -----
        This is a convenience function for quick storage of array data.
        Information on endianness and precision is lost, so this method is not a
        good choice for files intended to archive data or transport data between
        machines with different endianness. Some of these problems can be overcome
        by outputting the data as text files, at the expense of speed and file
        size.
        
        When fid is a file object, array contents are directly written to the
        file, bypassing the file object's ``write`` method. As a result, tofile
        cannot be used with files objects supporting compression (e.g., GzipFile)
        or file-like objects that do not support ``fileno()`` (e.g., BytesIO).
        """
        return self.value_.tofile(*args, **kwargs)
    
    def tolist(self, *args, **kwargs):
        """
        a.tolist()
        
        Return the array as an ``a.ndim``-levels deep nested list of Python scalars.
        
        Return a copy of the array data as a (nested) Python list.
        Data items are converted to the nearest compatible builtin Python type, via
        the `~numpy.ndarray.item` function.
        
        If ``a.ndim`` is 0, then since the depth of the nested list is 0, it will
        not be a list at all, but a simple Python scalar.
        
        Parameters
        ----------
        none
        
        Returns
        -------
        y : object, or list of object, or list of list of object, or ...
            The possibly nested list of array elements.
        
        Notes
        -----
        The array may be recreated via ``a = np.array(a.tolist())``, although this
        may sometimes lose precision.
        
        Examples
        --------
        For a 1D array, ``a.tolist()`` is almost the same as ``list(a)``,
        except that ``tolist`` changes numpy scalars to Python scalars:
        
        >>> a = np.uint32([1, 2])
        >>> a_list = list(a)
        >>> a_list
        [1, 2]
        >>> type(a_list[0])
        <class 'numpy.uint32'>
        >>> a_tolist = a.tolist()
        >>> a_tolist
        [1, 2]
        >>> type(a_tolist[0])
        <class 'int'>
        
        Additionally, for a 2D array, ``tolist`` applies recursively:
        
        >>> a = np.array([[1, 2], [3, 4]])
        >>> list(a)
        [array([1, 2]), array([3, 4])]
        >>> a.tolist()
        [[1, 2], [3, 4]]
        
        The base case for this recursion is a 0D array:
        
        >>> a = np.array(1)
        >>> list(a)
        Traceback (most recent call last):
          ...
        TypeError: iteration over a 0-d array
        >>> a.tolist()
        1
        """
        return self.value_.tolist(*args, **kwargs)
    
    def tostring(self, *args, **kwargs):
        """
        a.tostring(order='C')
        
        A compatibility alias for `tobytes`, with exactly the same behavior.
        
        Despite its name, it returns `bytes` not `str`\ s.
        
        .. deprecated:: 1.19.0
        """
        return self.value_.tostring(*args, **kwargs)
    
    def trace(self, *args, **kwargs):
        """
        a.trace(offset=0, axis1=0, axis2=1, dtype=None, out=None)
        
        Return the sum along diagonals of the array.
        
        Refer to `numpy.trace` for full documentation.
        
        See Also
        --------
        numpy.trace : equivalent function
        """
        return self.value_.trace(*args, **kwargs)
    
    def transpose(self, *args, **kwargs):
        """
        a.transpose(*axes)
        
        Returns a view of the array with axes transposed.
        
        For a 1-D array this has no effect, as a transposed vector is simply the
        same vector. To convert a 1-D array into a 2D column vector, an additional
        dimension must be added. `np.atleast2d(a).T` achieves this, as does
        `a[:, np.newaxis]`.
        For a 2-D array, this is a standard matrix transpose.
        For an n-D array, if axes are given, their order indicates how the
        axes are permuted (see Examples). If axes are not provided and
        ``a.shape = (i[0], i[1], ... i[n-2], i[n-1])``, then
        ``a.transpose().shape = (i[n-1], i[n-2], ... i[1], i[0])``.
        
        Parameters
        ----------
        axes : None, tuple of ints, or `n` ints
        
         * None or no argument: reverses the order of the axes.
        
         * tuple of ints: `i` in the `j`-th place in the tuple means `a`'s
           `i`-th axis becomes `a.transpose()`'s `j`-th axis.
        
         * `n` ints: same as an n-tuple of the same ints (this form is
           intended simply as a "convenience" alternative to the tuple form)
        
        Returns
        -------
        out : ndarray
            View of `a`, with axes suitably permuted.
        
        See Also
        --------
        transpose : Equivalent function
        ndarray.T : Array property returning the array transposed.
        ndarray.reshape : Give a new shape to an array without changing its data.
        
        Examples
        --------
        >>> a = np.array([[1, 2], [3, 4]])
        >>> a
        array([[1, 2],
               [3, 4]])
        >>> a.transpose()
        array([[1, 3],
               [2, 4]])
        >>> a.transpose((1, 0))
        array([[1, 3],
               [2, 4]])
        >>> a.transpose(1, 0)
        array([[1, 3],
               [2, 4]])
        """
        return self.value_.transpose(*args, **kwargs)
    
    def var(self, *args, **kwargs):
        """
        a.var(axis=None, dtype=None, out=None, ddof=0, keepdims=False, *, where=True)
        
        Returns the variance of the array elements, along given axis.
        
        Refer to `numpy.var` for full documentation.
        
        See Also
        --------
        numpy.var : equivalent function
        """
        return self.value_.var(*args, **kwargs)
    
    def view(self, *args, **kwargs):
        """
        a.view([dtype][, type])
        
        New view of array with the same data.
        
        .. note::
            Passing None for ``dtype`` is different from omitting the parameter,
            since the former invokes ``dtype(None)`` which is an alias for
            ``dtype('float_')``.
        
        Parameters
        ----------
        dtype : data-type or ndarray sub-class, optional
            Data-type descriptor of the returned view, e.g., float32 or int16.
            Omitting it results in the view having the same data-type as `a`.
            This argument can also be specified as an ndarray sub-class, which
            then specifies the type of the returned object (this is equivalent to
            setting the ``type`` parameter).
        type : Python type, optional
            Type of the returned view, e.g., ndarray or matrix.  Again, omission
            of the parameter results in type preservation.
        
        Notes
        -----
        ``a.view()`` is used two different ways:
        
        ``a.view(some_dtype)`` or ``a.view(dtype=some_dtype)`` constructs a view
        of the array's memory with a different data-type.  This can cause a
        reinterpretation of the bytes of memory.
        
        ``a.view(ndarray_subclass)`` or ``a.view(type=ndarray_subclass)`` just
        returns an instance of `ndarray_subclass` that looks at the same array
        (same shape, dtype, etc.)  This does not cause a reinterpretation of the
        memory.
        
        For ``a.view(some_dtype)``, if ``some_dtype`` has a different number of
        bytes per entry than the previous dtype (for example, converting a
        regular array to a structured array), then the behavior of the view
        cannot be predicted just from the superficial appearance of ``a`` (shown
        by ``print(a)``). It also depends on exactly how ``a`` is stored in
        memory. Therefore if ``a`` is C-ordered versus fortran-ordered, versus
        defined as a slice or transpose, etc., the view may give different
        results.
        
        
        Examples
        --------
        >>> x = np.array([(1, 2)], dtype=[('a', np.int8), ('b', np.int8)])
        
        Viewing array data using a different type and dtype:
        
        >>> y = x.view(dtype=np.int16, type=np.matrix)
        >>> y
        matrix([[513]], dtype=int16)
        >>> print(type(y))
        <class 'numpy.matrix'>
        
        Creating a view on a structured array so it can be used in calculations
        
        >>> x = np.array([(1, 2),(3,4)], dtype=[('a', np.int8), ('b', np.int8)])
        >>> xv = x.view(dtype=np.int8).reshape(-1,2)
        >>> xv
        array([[1, 2],
               [3, 4]], dtype=int8)
        >>> xv.mean(0)
        array([2.,  3.])
        
        Making changes to the view changes the underlying array
        
        >>> xv[0,1] = 20
        >>> x
        array([(1, 20), (3,  4)], dtype=[('a', 'i1'), ('b', 'i1')])
        
        Using a view to convert an array to a recarray:
        
        >>> z = x.view(np.recarray)
        >>> z.a
        array([1, 3], dtype=int8)
        
        Views share data:
        
        >>> x[0] = (9, 10)
        >>> z[0]
        (9, 10)
        
        Views that change the dtype size (bytes per entry) should normally be
        avoided on arrays defined by slices, transposes, fortran-ordering, etc.:
        
        >>> x = np.array([[1,2,3],[4,5,6]], dtype=np.int16)
        >>> y = x[:, 0:2]
        >>> y
        array([[1, 2],
               [4, 5]], dtype=int16)
        >>> y.view(dtype=[('width', np.int16), ('length', np.int16)])
        Traceback (most recent call last):
            ...
        ValueError: To change to a dtype of a different size, the array must be C-contiguous
        >>> z = y.copy()
        >>> z.view(dtype=[('width', np.int16), ('length', np.int16)])
        array([[(1, 2)],
               [(4, 5)]], dtype=[('width', '<i2'), ('length', '<i2')])
        """
        return self.value_.view(*args, **kwargs)
    
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
    def value(BaseArrayTag self):
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
        return tuple(self.value_.shape[i] for i in range(self.value_.ndim))\

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

    def resize(*args, **kwargs):
        raise Exception("The TAG_Array classes are 1D arrays and cannot be resized in place. Try reshape to get a copy.")

    cdef void _fix_dtype(BaseArrayTag self):
        if self.value_.dtype != self.big_endian_data_type:
            print(f'[Warning] Mismatch array dtype. Expected: {self.big_endian_data_type}, got: {self.value_.dtype}')
            self.value_ = self.value_.astype(self.big_endian_data_type)

    cdef numpy.ndarray _as_endianness(BaseArrayTag self, bint little_endian = False):
        self._fix_dtype()
        if little_endian:
            return self.value_.astype(self.little_endian_data_type)
        else:
            return self.value_

    def __repr__(BaseArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__(BaseArrayTag self, other):
        if isinstance(other, (BaseArrayType, numpy.ndarray, list, tuple, TAG_List)):
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
        return (self.value_ + other).astype(self.big_endian_data_type)

    def __radd__(BaseArrayTag self, other):
        return (other + self.value_).astype(self.big_endian_data_type)

    def __iadd__(BaseArrayTag self, other):
        self.value_ += other
        return self

    def __sub__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rsub__(BaseArrayTag self, other):
        return (other - self.value_).astype(self.big_endian_data_type)

    def __isub__(BaseArrayTag self, other):
        self.value_ -= other
        return self

    def __mul__(BaseArrayTag self, other):
        return (self.value_ - other).astype(self.big_endian_data_type)

    def __rmul__(BaseArrayTag self, other):
        return (other * self.value_).astype(self.big_endian_data_type)

    def __imul__(BaseArrayTag self, other):
        self.value_ *= other
        return self

    def __matmul__(BaseArrayTag self, other):
        return (self.value_ @ other).astype(self.big_endian_data_type)

    def __rmatmul__(BaseArrayTag self, other):
        return (other @ self.value_).astype(self.big_endian_data_type)

    def __imatmul__(BaseArrayTag self, other):
        self.value_ @= other
        return self

    def __truediv__(BaseArrayTag self, other):
        return (self.value_ / other).astype(self.big_endian_data_type)

    def __rtruediv__(BaseArrayTag self, other):
        return (other / self.value_).astype(self.big_endian_data_type)

    def __itruediv__(BaseArrayTag self, other):
        self.value_ /= other
        return self

    def __floordiv__(BaseArrayTag self, other):
        return (self.value_ // other).astype(self.big_endian_data_type)

    def __rfloordiv__(BaseArrayTag self, other):
        return (other // self.value_).astype(self.big_endian_data_type)

    def __ifloordiv__(BaseArrayTag self, other):
        self.value_ //= other
        return self

    def __mod__(BaseArrayTag self, other):
        return (self.value_ % other).astype(self.big_endian_data_type)

    def __rmod__(BaseArrayTag self, other):
        return (other % self.value_).astype(self.big_endian_data_type)

    def __imod__(BaseArrayTag self, other):
        self.value_ %= other
        return self

    def __divmod__(BaseArrayTag self, other):
        return divmod(self.value_, other)

    def __rdivmod__(BaseArrayTag self, other):
        return divmod(other, self.value_)

    def __pow__(BaseArrayTag self, power, modulo):
        return pow(self.value_, power, modulo).astype(self.big_endian_data_type)

    def __rpow__(BaseArrayTag self, other, modulo):
        return pow(other, self.value_, modulo).astype(self.big_endian_data_type)

    def __ipow__(BaseArrayTag self, other):
        self.value_ **= other
        return self

    def __lshift__(BaseArrayTag self, other):
        return (self.value_ << other).astype(self.big_endian_data_type)

    def __rlshift__(BaseArrayTag self, other):
        return (other << self.value_).astype(self.big_endian_data_type)

    def __ilshift__(BaseArrayTag self, other):
        self.value_ <<= other
        return self

    def __rshift__(BaseArrayTag self, other):
        return (self.value_ >> other).astype(self.big_endian_data_type)

    def __rrshift__(BaseArrayTag self, other):
        return (other >> self.value_).astype(self.big_endian_data_type)

    def __irshift__(BaseArrayTag self, other):
        self.value_ >>= other
        return self

    def __and__(BaseArrayTag self, other):
        return (self.value_ & other).astype(self.big_endian_data_type)

    def __rand__(BaseArrayTag self, other):
        return (other & self.value_).astype(self.big_endian_data_type)

    def __iand__(BaseArrayTag self, other):
        self.value_ &= other
        return self

    def __xor__(BaseArrayTag self, other):
        return (self.value_ ^ other).astype(self.big_endian_data_type)

    def __rxor__(BaseArrayTag self, other):
        return (other ^ self.value_).astype(self.big_endian_data_type)

    def __ixor__(BaseArrayTag self, other):
        self.value_ ^= other
        return self

    def __or__(BaseArrayTag self, other):
        return (self.value_ | other).astype(self.big_endian_data_type)

    def __ror__(BaseArrayTag self, other):
        return (other | self.value_).astype(self.big_endian_data_type)

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


cdef class TAG_Byte_Array(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a byte."""
    tag_id = ID_BYTE_ARRAY
    big_endian_data_type = little_endian_data_type = numpy.dtype("int8")

    cdef str _to_snbt(TAG_Byte_Array self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}B")
        return f"[B;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Byte_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 1, little_endian)

    @staticmethod
    cdef TAG_Byte_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef char*arr = read_data(buffer, length)
        data_type = TAG_Byte_Array.little_endian_data_type if little_endian else TAG_Byte_Array.big_endian_data_type
        return TAG_Byte_Array(numpy.frombuffer(arr[:length], dtype=data_type, count=length))


cdef class TAG_Int_Array(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 4 bytes."""
    tag_id = ID_INT_ARRAY
    big_endian_data_type = numpy.dtype(">i4")
    little_endian_data_type = numpy.dtype("<i4")

    cdef str _to_snbt(TAG_Int_Array self):
        cdef int elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(str(elem))
        return f"[I;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Int_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 4, little_endian)

    @staticmethod
    cdef TAG_Int_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef int byte_length = length * 4
        cdef char*arr = read_data(buffer, byte_length)
        cdef object data_type = TAG_Int_Array.little_endian_data_type if little_endian else TAG_Int_Array.big_endian_data_type
        return TAG_Int_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))


cdef class TAG_Long_Array(BaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a 8 bytes."""
    tag_id = ID_LONG_ARRAY
    big_endian_data_type = numpy.dtype(">i8")
    little_endian_data_type = numpy.dtype("<i8")

    cdef str _to_snbt(TAG_Long_Array self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}L")
        return f"[L;{CommaSpace.join(tags)}]"

    cdef void write_payload(TAG_Long_Array self, object buffer: BytesIO, bint little_endian) except *:
        write_array(self._as_endianness(little_endian), buffer, 8, little_endian)

    @staticmethod
    cdef TAG_Long_Array read_payload(BufferContext buffer, bint little_endian):
        cdef int length = read_int(buffer, little_endian)
        cdef int byte_length = length * 8
        cdef char*arr = read_data(buffer, byte_length)
        cdef object data_type = TAG_Long_Array.little_endian_data_type if little_endian else TAG_Long_Array.big_endian_data_type
        return TAG_Long_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))
