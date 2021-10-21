import gzip
import zlib
from io import BytesIO
from typing import Union, BinaryIO
import os

from .errors import NBTLoadError
from .nbtfile cimport NBTFile
from .util cimport BufferContext, read_string, read_byte
from .value cimport BaseTag
from .int cimport TAG_Byte, TAG_Short, TAG_Int, TAG_Long
from .float cimport TAG_Float, TAG_Double
from .array cimport TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array
from .string cimport TAG_String
from .list cimport TAG_List
from .compound cimport TAG_Compound


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
    buffer = BufferContext()
    buffer.offset = 0
    buffer.buffer = data
    buffer.size = len(data)
    return buffer


cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian):
    if tag_type == 1:
        return TAG_Byte.read_payload(buffer, little_endian)
    elif tag_type == 2:
        return TAG_Short.read_payload(buffer, little_endian)
    elif tag_type == 3:
        return TAG_Int.read_payload(buffer, little_endian)
    elif tag_type == 4:
        return TAG_Long.read_payload(buffer, little_endian)
    elif tag_type == 5:
        return TAG_Float.read_payload(buffer, little_endian)
    elif tag_type == 6:
        return TAG_Double.read_payload(buffer, little_endian)
    elif tag_type == 7:
        return TAG_Byte_Array.read_payload(buffer, little_endian)
    elif tag_type == 8:
        return TAG_String.read_payload(buffer, little_endian)
    elif tag_type == 9:
        return TAG_List.read_payload(buffer, little_endian)
    elif tag_type == 10:
        return TAG_Compound.read_payload(buffer, little_endian)
    elif tag_type == 11:
        return TAG_Int_Array.read_payload(buffer, little_endian)
    elif tag_type == 12:
        return TAG_Long_Array.read_payload(buffer, little_endian)
    else:
        raise NBTLoadError(f"Tag {tag_type} does not exist.")


cdef tuple load_tag(BufferContext buffer, bint little_endian):
    cdef char tag_type = read_byte(buffer)
    cdef str name = read_string(buffer, little_endian)
    return name, load_payload(buffer, tag_type, little_endian)


cpdef object load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    bint compressed=True,
    object count: int = None,
    bint offset: bool = False,
    bint little_endian: bool = False,
):# -> Union[NBTFile, Tuple[Union[NBTFile, List[NBTFile]], int]]:
    cdef BufferContext buffer = get_buffer(filepath_or_buffer, compressed)

    results = []

    if buffer.size < 1:
        raise EOFError("load() was supplied an empty buffer")

    cdef size_t i
    cdef str name
    cdef BaseTag tag
    for i in range(count or 1):
        name, tag = load_tag(buffer, little_endian)
        results.append(NBTFile(tag, name))

    if count is None:
        results = results[0]

    if offset:
        return results, buffer.offset

    return results
