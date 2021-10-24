from typing import Union, BinaryIO
from .util cimport BufferContext
from .value cimport BaseTag
from .nbtfile cimport NBTFile

cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian)
cpdef tuple load_tag(BufferContext buffer, bint little_endian)

cdef class ReadContext:
    cdef readonly int offset

cpdef NBTFile load_one(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    bint compressed=*,
    bint little_endian: bool = *,
    ReadContext read_context = *
)

cpdef list load_many(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    int count = *,
    bint compressed=*,
    bint little_endian: bool = *,
    ReadContext read_context = *
)

cpdef object load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    bint compressed=*,
    object count: int = *,
    bint offset: bool = *,
    bint little_endian: bool = *,
)