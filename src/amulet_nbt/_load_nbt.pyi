from typing import Union, BinaryIO, List
from ._util import DecoderType
from mutf8 import decode_modified_utf8
from ._named_tag import NamedTag

class ReadContext:
    offset: int

def load(
    filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    compressed: bool = True,
    little_endian: bool = False,
    read_context: ReadContext = None,
    string_decoder: DecoderType = decode_modified_utf8,
) -> NamedTag:
    """Load one binary NBT object.

    :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param compressed: Is the binary data gzip compressed.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param read_context: Optional ReadContext object to get read end offset
    :param string_decoder: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet_nbt.utf8_escape_decoder for Bedrock.
    :raises: NBTLoadError if an error occurred when loading the data.
    """
    ...

def load_array(
    filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    count: int = 1,
    compressed: bool = True,
    little_endian: bool = False,
    read_context: ReadContext = None,
    string_decoder: DecoderType = decode_modified_utf8,
) -> List[NamedTag]:
    """Load an array of binary NBT objects from a contiguous buffer.

    :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
    :param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param read_context: Optional ReadContext object to get read end offset
    :param string_decoder: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet_nbt.utf8_escape_decoder for Bedrock.
    :raises: NBTLoadError if an error occurred when loading the data.
    """
    ...
