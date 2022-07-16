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
) -> NamedTag: ...
def load_many(
    filepath_or_buffer: Union[str, bytes, BinaryIO, memoryview, None],
    *,
    count: int = 1,
    compressed: bool = True,
    little_endian: bool = False,
    read_context: ReadContext = None,
    string_decoder: DecoderType = decode_modified_utf8,
) -> List[NamedTag]: ...
