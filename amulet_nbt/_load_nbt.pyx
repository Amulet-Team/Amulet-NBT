import gzip
import warnings
import zlib
from io import BytesIO
from typing import Union, BinaryIO, List, Tuple
import os

from mutf8 import decode_modified_utf8

from ._errors import NBTLoadError
from ._util cimport BufferContext, read_string, read_byte
from ._value cimport AbstractBaseTag
from ._int cimport (
    read_byte_tag,
    read_short_tag,
    read_int_tag,
    read_long_tag,
)
from ._float cimport (
    read_float_tag,
    read_double_tag,
)
from ._array cimport (
    read_byte_array_tag,
    read_int_array_tag,
    read_long_array_tag,
)
from ._string cimport read_string_tag
from ._list cimport read_list_tag
from ._compound cimport read_compound_tag
from ._named_tag cimport NamedTag
from ._dtype import DecoderType


cpdef inline bytes safe_gunzip(bytes data):
    if data[:2] == b'\x1f\x8b':  # if the first two bytes are this it should be gzipped
        try:
            data = gzip.GzipFile(fileobj=BytesIO(data)).read()
        except (IOError, zlib.error) as e:
            pass
    return data


cdef BufferContext get_buffer(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    bint compressed=True,
):
    cdef bytes data
    if isinstance(filepath_or_buffer, str):
        # if a string load from the file path
        if not os.path.isfile(filepath_or_buffer):
            raise NBTLoadError(f"There is no file at {filepath_or_buffer}")
        with open(filepath_or_buffer, "rb") as f:
            data = f.read()
    elif isinstance(filepath_or_buffer, bytes):
        data = filepath_or_buffer
    elif isinstance(filepath_or_buffer, memoryview):
        data = filepath_or_buffer.tobytes()
    elif hasattr(filepath_or_buffer, "read"):
        buffer_data = filepath_or_buffer.read()
        if not isinstance(buffer_data, bytes):
            raise NBTLoadError(f"buffer.read() must return a bytes object. Got {type(buffer_data)} instead.")
        data = buffer_data
    else:
        raise NBTLoadError("buffer did not have a read method.")

    if compressed:
        data = safe_gunzip(data)
    return BufferContext(data)


cdef AbstractBaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian, string_decoder: DecoderType):
    if tag_type == 1:
        return read_byte_tag(buffer, little_endian)
    elif tag_type == 2:
        return read_short_tag(buffer, little_endian)
    elif tag_type == 3:
        return read_int_tag(buffer, little_endian)
    elif tag_type == 4:
        return read_long_tag(buffer, little_endian)
    elif tag_type == 5:
        return read_float_tag(buffer, little_endian)
    elif tag_type == 6:
        return read_double_tag(buffer, little_endian)
    elif tag_type == 7:
        return read_byte_array_tag(buffer, little_endian)
    elif tag_type == 8:
        return read_string_tag(buffer, little_endian, string_decoder)
    elif tag_type == 9:
        return read_list_tag(buffer, little_endian, string_decoder)
    elif tag_type == 10:
        return read_compound_tag(buffer, little_endian, string_decoder)
    elif tag_type == 11:
        return read_int_array_tag(buffer, little_endian)
    elif tag_type == 12:
        return read_long_array_tag(buffer, little_endian)
    else:
        raise NBTLoadError(f"Tag {tag_type} does not exist.")


cdef inline tuple load_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType):
    cdef char tag_type = read_byte(buffer)
    cdef str name = read_string(buffer, little_endian, string_decoder)
    return name, load_payload(buffer, tag_type, little_endian, string_decoder)


cdef NamedTag load_named_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType):
    cdef str name
    cdef AbstractBaseTag tag
    name, tag = load_tag(buffer, little_endian, string_decoder)
    return NamedTag(tag, name)


cdef class ReadContext:
    def __cinit__(self):
        self.offset = 0


def _load_one(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    bint compressed: bool=True,
    bint little_endian: bool = False,
    ReadContext read_context = None,
    string_decoder: DecoderType = decode_modified_utf8
) -> NamedTag:
    cdef BufferContext buffer = get_buffer(filepath_or_buffer, compressed)
    if buffer.size < 1:
        raise EOFError("buffer is empty")
    cdef NamedTag tag = load_named_tag(buffer, little_endian, string_decoder)
    if read_context is not None:
        read_context.offset = buffer.offset
    return tag


def load_array(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    int count = 1,
    bint compressed: bool=True,
    bint little_endian: bool = False,
    ReadContext read_context = None,
    string_decoder: DecoderType = decode_modified_utf8
) -> List[NamedTag]:
    if count < -1:
        raise ValueError("Count must be -1 or higher")
    cdef BufferContext buffer = get_buffer(filepath_or_buffer, compressed)
    cdef list results = []
    cdef size_t i
    if count == -1:
        while buffer.offset < buffer.size:
            results.append(
                load_named_tag(buffer, little_endian, string_decoder)
            )
    else:
        for i in range(count):
            results.append(
                load_named_tag(buffer, little_endian, string_decoder)
            )

    if read_context is not None:
        read_context.offset = buffer.offset
    return results


def load_many(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    int count = 1,
    bint compressed: bool=True,
    bint little_endian: bool = False,
    ReadContext read_context = None,
    string_decoder: DecoderType = decode_modified_utf8
):
    warnings.warn("load_many is depreciated. Use load_array instead.", DeprecationWarning)
    return load_array(
        filepath_or_buffer,
        count=count,
        compressed=compressed,
        little_endian=little_endian,
        read_context=read_context,
        string_decoder=string_decoder
    )


def load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *args,
    bint compressed: bool=True,
    object count: int = None,
    bint offset: bool = False,
    bint little_endian: bool = False,
    string_decoder: DecoderType = decode_modified_utf8,
    ReadContext read_context = None,
) -> Union[NamedTag, Tuple[Union[NamedTag, List[NamedTag]], int]]:
    if args:
        warnings.warn("load arguments are going to be keyword only in the future. This function passes the inputs positionally.", FutureWarning)
        compressed, *args = args
        if args:
            count, *args = args
        if args:
            offset, *args = args
        if args:
            little_endian, *args = args

    if offset and read_context is None:
        warnings.warn("load with offset is depreciated. In future versions this function will only return the result. To get the offset pass a ReadContext instance to read_context input.", FutureWarning)
        read_context = ReadContext()

    cdef object result

    if count is None:
        result = _load_one(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            read_context=read_context,
            string_decoder=string_decoder
        )
    else:
        warnings.warn("load with count is depreciated. Use load_array", DeprecationWarning)
        result = load_array(
            filepath_or_buffer,
            count=count,
            compressed=compressed,
            little_endian=little_endian,
            read_context=read_context,
            string_decoder=string_decoder
        )

    if offset:
        # depreciated
        return result, read_context.offset
    else:
        return result
