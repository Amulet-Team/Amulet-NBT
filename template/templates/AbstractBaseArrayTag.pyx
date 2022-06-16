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
        self.value_ = numpy.array(value, {{native_data_type}}).ravel()

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
        return NotImplemented

    def __getitem__({{dtype.capitalize()}}ArrayTag self, item):
        return self.value_.__getitem__(item)

    def __setitem__({{dtype.capitalize()}}ArrayTag self, key, value):
        self.value_.__setitem__(key, value)

    def __array__({{dtype.capitalize()}}ArrayTag self, dtype=None):
        return numpy.array(self.value_, dtype=dtype)

    def __len__({{dtype.capitalize()}}ArrayTag self):
        return len(self.value_)
