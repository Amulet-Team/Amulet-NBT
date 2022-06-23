{{py:
from template import include
}}
cdef inline {{dtype.capitalize()}}ArrayTag read_{{dtype}}_array_tag(BufferContext buffer, bint little_endian):
    cdef {{dtype.capitalize()}}ArrayTag tag = {{dtype.capitalize()}}ArrayTag.__new__({{dtype.capitalize()}}ArrayTag)
    cdef int length = read_int(buffer, little_endian)
    cdef int byte_length = length * {{width}}
    cdef char*arr = read_data(buffer, byte_length)
    data_type = {{little_endian_data_type}} if little_endian else {{big_endian_data_type}}
    tag.value_ = numpy.array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length), {{native_data_type}}).ravel()
    return tag


cdef class {{dtype.capitalize()}}ArrayTag(AbstractBaseArrayTag):
    """This class behaves like an 1D Numpy signed integer array with each value stored in a {{dtype}}."""
    tag_id = ID_{{dtype.upper()}}_ARRAY

    def __init__({{dtype.capitalize()}}ArrayTag self, object value = ()):
        self.value_ = numpy.asarray(value, {{native_data_type}}).ravel()

    cdef str _to_snbt({{dtype.capitalize()}}ArrayTag self):
        cdef long long elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(f"{elem}{{snbt_suffix}}")
        return f"[{{snbt_prefix}};{CommaSpace.join(tags)}]"

    cdef void write_payload(
        {{dtype.capitalize()}}ArrayTag self,
        object buffer: BytesIO,
        bint little_endian,
        string_encoder: EncoderType,
    ) except *:
        write_array(
            numpy.asarray(self.value_, {{little_endian_data_type}} if little_endian else {{big_endian_data_type}}),
            buffer,
            {{width}},
            little_endian
        )

{{include("AbstractBaseMutableTag.pyx", cls_name=f"{dtype.capitalize()}ArrayTag", show_eq=False, **locals())}}

    @property
    def np_array({{dtype.capitalize()}}ArrayTag self):
        """
        A numpy array holding the same internal data.
        Changes to the array will also modify the internal state.
        """
        return self.value_

    def __repr__({{dtype.capitalize()}}ArrayTag self):
        return f"{self.__class__.__name__}({list(self.value_)})"

    def __eq__({{dtype.capitalize()}}ArrayTag self, other):
        cdef {{dtype.capitalize()}}ArrayTag other_
        if isinstance(other, {{dtype.capitalize()}}ArrayTag):
            other_ = other
            return numpy.array_equal(self.value_, other_.value_)
        elif __major__ <= 2 and isinstance(other, AbstractBaseArrayTag):
            warnings.warn("NBT comparison operator (a == b) will only return True between classes of the same type.", FutureWarning)
            return numpy.array_equal(self.value_, primitive_conversion(other))
        return NotImplemented

    def __getitem__({{dtype.capitalize()}}ArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__({{dtype.capitalize()}}ArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__({{dtype.capitalize()}}ArrayTag self, dtype=None):
        return numpy.asarray(self.value_, dtype=dtype)

    def __len__({{dtype.capitalize()}}ArrayTag self):
        return len(self.value_)

    if __major__ <= 2:
        def __add__(self, other):
            warnings.warn(f"__add__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) + primitive_conversion(other)).astype({{big_endian_data_type}})

        def __sub__(self, other):
            warnings.warn(f"__sub__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) - primitive_conversion(other)).astype({{big_endian_data_type}})

        def __mul__(self, other):
            warnings.warn(f"__mul__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) * primitive_conversion(other)).astype({{big_endian_data_type}})

        def __matmul__(self, other):
            warnings.warn(f"__matmul__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) @ primitive_conversion(other)).astype({{big_endian_data_type}})

        def __truediv__(self, other):
            warnings.warn(f"__truediv__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) / primitive_conversion(other)).astype({{big_endian_data_type}})

        def __floordiv__(self, other):
            warnings.warn(f"__floordiv__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) // primitive_conversion(other)).astype({{big_endian_data_type}})

        def __mod__(self, other):
            warnings.warn(f"__mod__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) % primitive_conversion(other)).astype({{big_endian_data_type}})

        def __divmod__(self, other):
            warnings.warn(f"__divmod__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return divmod(primitive_conversion(self), primitive_conversion(other))

        def __pow__(self, power, modulo):
            warnings.warn(f"__pow__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return pow(primitive_conversion(self), power, modulo).astype({{big_endian_data_type}})

        def __lshift__(self, other):
            warnings.warn(f"__lshift__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) << primitive_conversion(other)).astype({{big_endian_data_type}})

        def __rshift__(self, other):
            warnings.warn(f"__rshift__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) >> primitive_conversion(other)).astype({{big_endian_data_type}})

        def __and__(self, other):
            warnings.warn(f"__and__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) & primitive_conversion(other)).astype({{big_endian_data_type}})

        def __xor__(self, other):
            warnings.warn(f"__xor__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) ^ primitive_conversion(other)).astype({{big_endian_data_type}})

        def __or__(self, other):
            warnings.warn(f"__or__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(self) | primitive_conversion(other)).astype({{big_endian_data_type}})

        def __radd__(self, other):
            warnings.warn(f"__radd__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) + primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rsub__(self, other):
            warnings.warn(f"__rsub__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) - primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rmul__(self, other):
            warnings.warn(f"__rmul__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) * primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rtruediv__(self, other):
            warnings.warn(f"__rtruediv__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) / primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rfloordiv__(self, other):
            warnings.warn(f"__rfloordiv__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) // primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rmod__(self, other):
            warnings.warn(f"__rmod__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) % primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rdivmod__(self, other):
            warnings.warn(f"__rdivmod__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return divmod(primitive_conversion(other), primitive_conversion(self))

        def __rpow__(self, other, modulo):
            warnings.warn(f"__rpow__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return pow(primitive_conversion(other), primitive_conversion(self), modulo).astype({{big_endian_data_type}})

        def __rlshift__(self, other):
            warnings.warn(f"__rlshift__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) << primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rrshift__(self, other):
            warnings.warn(f"__rrshift__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) >> primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rand__(self, other):
            warnings.warn(f"__rand__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) & primitive_conversion(self)).astype({{big_endian_data_type}})

        def __rxor__(self, other):
            warnings.warn(f"__rxor__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) ^ primitive_conversion(self)).astype({{big_endian_data_type}})

        def __ror__(self, other):
            warnings.warn(f"__ror__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (primitive_conversion(other) | primitive_conversion(self)).astype({{big_endian_data_type}})

        def __neg__(self):
            warnings.warn(f"__neg__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (-self.value_).astype({{big_endian_data_type}})

        def __pos__(self):
            warnings.warn(f"__pos__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return (+self.value_).astype({{big_endian_data_type}})

        def __abs__(self):
            warnings.warn(f"__abs__ is depreciated on {{dtype.capitalize()}}ArrayTag and will be removed in the future. Please use .np_array to achieve the same behaviour.", DeprecationWarning)
            return abs(self.value_).astype({{big_endian_data_type}})