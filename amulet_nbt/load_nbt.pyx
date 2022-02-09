import gzip
import warnings
import zlib
from io import BytesIO
from typing import Union, BinaryIO, List, Tuple
import os

from .errors import NBTLoadError
from .util cimport BufferContext, read_string, read_byte
from .value cimport BaseTag
from .int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from .float cimport (
    FloatTag,
    DoubleTag,
)
from .array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from .string cimport StringTag
from .list cimport ListTag
from .compound cimport CompoundTag
from .named_tag import (
    BaseNamedTag,
    NamedByteTag,
    NamedShortTag,
    NamedIntTag,
    NamedLongTag,
    NamedFloatTag,
    NamedDoubleTag,
    NamedByteArrayTag,
    NamedStringTag,
    NamedListTag,
    NamedCompoundTag,
    NamedIntArrayTag,
    NamedLongArrayTag,
)


cpdef inline bytes safe_gunzip(bytes data):
    if data[:2] == b'\x1f\x8b':  # if the first two bytes are this it should be gzipped
        try:
            data = gzip.GzipFile(fileobj=BytesIO(data)).read()
        except (IOError, zlib.error) as e:
            pass
    return data


cdef BufferContext get_buffer(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    bint compressed=True,
):
    if isinstance(filepath_or_buffer, str):
        # if a string load from the file path
        if not os.path.isfile(filepath_or_buffer):
            raise NBTLoadError(f"There is no file at {filepath_or_buffer}")
        with open(filepath_or_buffer, "rb") as f:
            data = f.read()
    elif isinstance(filepath_or_buffer, bytes):
        data = filepath_or_buffer
    elif hasattr(filepath_or_buffer, "read"):
        data = filepath_or_buffer.read()
        if not isinstance(data, bytes):
            raise NBTLoadError(f"buffer.read() must return a bytes object. Got {type(data)} instead.")
        if hasattr(filepath_or_buffer, "close"):
            filepath_or_buffer.close()
        elif hasattr(filepath_or_buffer, "open"):
            print(
                "[Warning]: Input buffer didn't have close() function. Memory leak may occur!"
            )
    else:
        raise NBTLoadError("buffer did not have a read method.")

    if compressed:
        data = safe_gunzip(data)
    return BufferContext(
        data
    )


cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian):
    if tag_type == 1:
        return ByteTag.read_payload(buffer, little_endian)
    elif tag_type == 2:
        return ShortTag.read_payload(buffer, little_endian)
    elif tag_type == 3:
        return IntTag.read_payload(buffer, little_endian)
    elif tag_type == 4:
        return LongTag.read_payload(buffer, little_endian)
    elif tag_type == 5:
        return FloatTag.read_payload(buffer, little_endian)
    elif tag_type == 6:
        return DoubleTag.read_payload(buffer, little_endian)
    elif tag_type == 7:
        return ByteArrayTag.read_payload(buffer, little_endian)
    elif tag_type == 8:
        return StringTag.read_payload(buffer, little_endian)
    elif tag_type == 9:
        return ListTag.read_payload(buffer, little_endian)
    elif tag_type == 10:
        return CompoundTag.read_payload(buffer, little_endian)
    elif tag_type == 11:
        return IntArrayTag.read_payload(buffer, little_endian)
    elif tag_type == 12:
        return LongArrayTag.read_payload(buffer, little_endian)
    else:
        raise NBTLoadError(f"Tag {tag_type} does not exist.")


cpdef tuple load_tag(BufferContext buffer, bint little_endian):
    cdef char tag_type = read_byte(buffer)
    cdef str name = read_string(buffer, little_endian)
    return name, load_payload(buffer, tag_type, little_endian)


cdef inline BaseNamedTag wrap_tag(char tag_type, BaseTag tag, str name):
    """Wrap a tag in its named variant."""
    if tag_type == 1:
        return NamedByteTag(tag, name)
    elif tag_type == 2:
        return NamedShortTag(tag, name)
    elif tag_type == 3:
        return NamedIntTag(tag, name)
    elif tag_type == 4:
        return NamedLongTag(tag, name)
    elif tag_type == 5:
        return NamedFloatTag(tag, name)
    elif tag_type == 6:
        return NamedDoubleTag(tag, name)
    elif tag_type == 7:
        return NamedByteArrayTag(tag, name)
    elif tag_type == 8:
        return NamedStringTag(tag, name)
    elif tag_type == 9:
        return NamedListTag(tag, name)
    elif tag_type == 10:
        return NamedCompoundTag(tag, name)
    elif tag_type == 11:
        return NamedIntArrayTag(tag, name)
    elif tag_type == 12:
        return NamedLongArrayTag(tag, name)
    else:
        raise NBTLoadError(f"Tag {tag_type} does not exist.")


cdef BaseNamedTag load_named_tag(BufferContext buffer, bint little_endian):
    cdef char tag_type = read_byte(buffer)
    cdef str name = read_string(buffer, little_endian)
    cdef BaseTag tag = load_payload(buffer, tag_type, little_endian)
    return wrap_tag(tag_type, tag, name)


cpdef BaseNamedTag tag_to_named_tag(BaseTag tag, str name = ""):
    cdef char tag_type = tag.tag_id
    return wrap_tag(tag_type, tag, name)


cdef class ReadContext:
    def __cinit__(self):
        self.offset = 0


def load_one(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    *,
    bint compressed=True,
    bint little_endian: bool = False,
    ReadContext read_context = None
) -> BaseNamedTag:
    cdef BufferContext buffer = get_buffer(filepath_or_buffer, compressed)
    if buffer.size < 1:
        raise EOFError("load_one() was supplied an empty buffer")
    cdef object tag = load_named_tag(buffer, little_endian)
    if read_context is not None:
        read_context.offset = buffer.offset
    return tag


def load_many(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    *,
    int count = 1,
    bint compressed=True,
    bint little_endian: bool = False,
    ReadContext read_context = None
) -> List[BaseNamedTag]:
    if count < 1:
        raise ValueError("Count must be 1 or more.")
    cdef BufferContext buffer = get_buffer(filepath_or_buffer, compressed)
    if buffer.size < 1:
        raise EOFError("load_many() was supplied an empty buffer")
    cdef list results = []
    cdef size_t i
    for i in range(count):
        results.append(
            load_named_tag(buffer, little_endian)
        )
    if read_context is not None:
        read_context.offset = buffer.offset
    return results


def load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    *,
    bint compressed=True,
    object count: int = None,
    bint offset: bool = False,
    bint little_endian: bool = False,
) -> Union[BaseNamedTag, Tuple[Union[BaseNamedTag, List[BaseNamedTag]], int]]:
    warnings.warn("load is depreciated. Use load_one or load_many", DeprecationWarning)
    if offset:
        read_context = ReadContext()
    else:
        read_context = None

    cdef object result

    if count is None:
        result = load_one(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            read_context=read_context
        )
    else:
        result = load_many(
            filepath_or_buffer,
            count=count,
            compressed=compressed,
            little_endian=little_endian,
            read_context=read_context
        )

    if read_context is None:
        return result
    else:
        return result, read_context.offset
