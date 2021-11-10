from copy import copy, deepcopy
from io import BytesIO
import warnings
import gzip

from .util cimport write_byte, write_string, BufferContext


cdef class BaseTag:
    tag_id: int = None

    @property
    def value(self):
        """
        An immutable version/copy of the data in the class.
        The immutable types return the internal immutable data.
        The mutable types return a copy of the data. To modify these classes use the public API.
        """
        raise NotImplementedError

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
        """
        Return the NBT data in Stringified NBT format.
        
        :param indent: int, str or None. If int will indent with this many spaces. If string will indent with this string. If None will return on one line.
        :param indent_chr: Depreciated. Use indent instead.
        :return: Stringified NBT representation of the data.
        """
        if indent_chr is not None:
            warnings.warn("indent_chr is deprecated. Use indent instead.", DeprecationWarning)
            indent = indent_chr
        if isinstance(indent, int):
            return self._pretty_to_snbt(" " * indent)
        elif isinstance(indent, str):
            if indent.strip():
                raise ValueError("The indent argument must only contain whitespace.")
            return self._pretty_to_snbt(indent)
        return self._to_snbt()

    cdef str _to_snbt(self):
        """Internal method to format the class data as SNBT."""
        raise NotImplementedError

    cdef str _pretty_to_snbt(self, str indent_chr, int indent_count=0, bint leading_indent=True):
        return f"{indent_chr * indent_count * leading_indent}{self._to_snbt()}"

    cpdef bytes to_nbt(
        self,
        str name="",
        bint compressed=True,
        bint little_endian=False,
    ):
        """
        Get the data in binary NBT format.

        :param name: The root tag name.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :return: The binary NBT representaiton of the class.
        """
        cdef object buffer = BytesIO()
        cdef object gzip_buffer
        self.write_tag(buffer, name, little_endian)
        cdef bytes data = buffer.getvalue()
        if compressed:
            gzip_buffer = BytesIO()
            with gzip.GzipFile(fileobj=gzip_buffer, mode='wb') as gz:
                gz.write(data)
            data = gzip_buffer.getvalue()
        return data

    cpdef bytes save_to(
        self,
        object filepath_or_buffer=None,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        """
        Convert the data to the binary NBT format. Optionally write to a file.
        
        If filepath_or_buffer is a valid file path in string form the data will be written to that file.
        
        If filepath_or_buffer is a file like object the bytes will be written to it using `write`.

        :param filepath_or_buffer: A path or `write`able object to write the data to.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        cdef bytes data = self.to_nbt(name, compressed, little_endian)

        if filepath_or_buffer is None:
            pass
        elif isinstance(filepath_or_buffer, str):
            with open(filepath_or_buffer, 'wb') as fp:
                fp.write(data)
        else:
            filepath_or_buffer.write(data)
        return data

    cdef void write_tag(self, object buffer: BytesIO, str name, bint little_endian) except *:
        """
        Write the header and payload to the buffer.
        type_byte, name_len, name, payload
        
        :param buffer: The buffer to write to.
        :param name: The name of the tag in the header.
        :param little_endian: Should the data be written in little endian format.
        """
        write_byte(self.tag_id, buffer)
        write_string(name, buffer, little_endian)
        self.write_payload(buffer, little_endian)

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        """
        Write the payload to the buffer.
        This is only the data contained in the class and does not include the header.
        
        :param buffer: The buffer to write to.
        :param little_endian: Should the data be written in little endian format.
        """
        raise NotImplementedError

    @staticmethod
    cdef BaseTag read_payload(BufferContext buffer, bint little_endian):
        """
        Read the payload from the buffer.
        The calling code must have read up to the start of the payload.
        
        :param buffer: The buffer to read from.
        :param little_endian: Is the data in little endian format.
        """
        raise NotImplementedError

    def __repr__(self):
        raise NotImplementedError

    def __str__(self):
        raise NotImplementedError

    def __eq__(self, other):
        raise NotImplementedError

    cpdef bint strict_equals(self, other):
        """
        Does the data and data type match the other object.
        
        :param other: The other object to compare with
        :return: True if the classes are identical, False otherwise.
        """
        return isinstance(other, self.__class__) and self.tag_id == other.tag_id and self == other

    def __ge__(self, other):
        raise NotImplementedError

    def __gt__(self, other):
        raise NotImplementedError

    def __le__(self, other):
        raise NotImplementedError

    def __lt__(self, other):
        raise NotImplementedError

    def __reduce__(self):
        raise NotImplementedError

    def copy(self):
        """Return a shallow copy of the class"""
        return copy(self)

    def __deepcopy__(self, memo=None):
        raise NotImplementedError

    def __copy__(self):
        raise NotImplementedError

    def __hash__(self):
        raise NotImplementedError


BaseValueType = BaseTag


cdef class BaseImmutableTag(BaseTag):
    pass


cdef class BaseMutableTag(BaseTag):
    pass
