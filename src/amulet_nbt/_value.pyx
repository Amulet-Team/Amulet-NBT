from copy import copy
from io import BytesIO
import warnings
import gzip
from typing import Any

from mutf8 import encode_modified_utf8
from ._util cimport write_byte, write_string
from ._dtype import EncoderType


cdef class AbstractBase:
    """Abstract Base class for all Tags and the NamedTag"""

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
        """
        Return the NBT data in Stringified NBT format.
        
        :param indent: int, str or None. If int will indent with this many spaces. If string will indent with this string. If None will return on one line.
        :param indent_chr: Depreciated. Use indent instead.
        :return: Stringified NBT representation of the data.
        """
        raise NotImplementedError

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
    ):
        """
        Get the data in binary NBT format.

        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        :return: The binary NBT representation of the class.
        """
        raise NotImplementedError

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
    ):
        """
        Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        :return: The binary NBT representation of the class.
        """
        raise NotImplementedError


cdef class AbstractBaseTag(AbstractBase):
    """Abstract Base Class for all Tag classes"""
    tag_id: int = None

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        raise NotImplementedError

    @property
    def value(self):
        """Legacy property to access the python data. Depreciated. Use :attr:`py_data` or typed py_{type} instead."""
        warnings.warn("value property is depreciated. Use py_{type} instead", DeprecationWarning)
        return self.py_data

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
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

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
        str name="",
    ):
        """
        Get the data in binary NBT format.

        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        cdef object buffer = BytesIO()
        cdef object gzip_buffer
        self.write_tag(buffer, name, little_endian, string_encoder)
        cdef bytes data = buffer.getvalue()
        if compressed:
            gzip_buffer = BytesIO()
            with gzip.GzipFile(fileobj=gzip_buffer, mode='wb') as gz:
                gz.write(data)
            data = gzip_buffer.getvalue()
        return data

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
        str name="",
    ) -> bytes:
        """
        Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """
        cdef bytes data = self.to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            string_encoder=string_encoder,
            name=name,
        )

        if filepath_or_buffer is None:
            pass
        elif isinstance(filepath_or_buffer, str):
            with open(filepath_or_buffer, 'wb') as fp:
                fp.write(data)
        else:
            filepath_or_buffer.write(data)
        return data

    cdef void write_tag(
        self,
        object buffer: BytesIO,
        str name,
        bint little_endian,
        string_encoder: EncoderType
    ) except *:
        """
        Write the header and payload to the buffer.
        type_byte, name_len, name, payload
        
        :param buffer: The buffer to write to.
        :param name: The name of the tag in the header.
        :param little_endian: Should the data be written in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        """
        write_byte(self.tag_id, buffer)
        write_string(name, buffer, little_endian, string_encoder)
        self.write_payload(buffer, little_endian, string_encoder)

    cdef void write_payload(
        self,
        object buffer: BytesIO,
        bint little_endian,
        string_encoder: EncoderType,
    ) except *:
        """
        Write the payload to the buffer.
        This is only the data contained in the class and does not include the header.
        
        :param buffer: The buffer to write to.
        :param little_endian: Should the data be written in little endian format.
        :param string_encoder: A function to encode strings to bytes.
        """
        raise NotImplementedError

    def __repr__(self):
        raise NotImplementedError

    def __str__(self):
        raise NotImplementedError

    def __eq__(self, other):
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


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self):
        raise NotImplementedError


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None
