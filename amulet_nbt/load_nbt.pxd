from typing import Union, BinaryIO
from .util cimport BufferContext
from .value cimport BaseTag

cdef BaseTag load_payload(BufferContext buffer, char tag_type, bint little_endian)
cpdef tuple load_tag(BufferContext buffer, bint little_endian)

cpdef object load(
    object filepath_or_buffer: Union[str, bytes, BinaryIO, None],
    bint compressed=*,
    object count: int = *,
    bint offset: bool = *,
    bint little_endian: bool = *,
)