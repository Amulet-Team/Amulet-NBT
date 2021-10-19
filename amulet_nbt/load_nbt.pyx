import gzip
import zlib
from io import BytesIO

cpdef bytes safe_gunzip(bytes data):
    if data[:2] == b'\x1f\x8b':  # if the first two bytes are this it should be gzipped
        try:
            data = gzip.GzipFile(fileobj=BytesIO(data)).read()
        except (IOError, zlib.error) as e:
            pass
    return data

def load(
        filepath_or_buffer: Union[str, bytes, BinaryIO, None] = None,  # TODO: This should become a required input
        compressed=True,
        count: int = None,
        offset: bool = False,
        little_endian: bool = False,
        buffer=None,  # TODO: this should get depreciated and removed.
) -> Union[NBTFile, Tuple[Union[NBTFile, List[NBTFile]], int]]:
    if isinstance(filepath_or_buffer, str):
        # if a string load from the file path
        if not os.path.isfile(filepath_or_buffer):
            raise NBTLoadError(f"There is no file at {filepath_or_buffer}")
        with open(filepath_or_buffer, "rb") as f:
            data_in = f.read()
    else:
        # TODO: when buffer is removed, remove this if block and make the next if block an elif part of the parent if block
        if filepath_or_buffer is None:  # For backwards compatability with buffer.
            if buffer is None:
                raise NBTLoadError("No object given to load.")
            filepath_or_buffer = buffer

        if isinstance(filepath_or_buffer, bytes):
            data_in = filepath_or_buffer
        elif hasattr(filepath_or_buffer, "read"):
            data_in = filepath_or_buffer.read()
            if not isinstance(data_in, bytes):
                raise NBTLoadError(f"buffer.read() must return a bytes object. Got {type(data_in)} instead.")
            if hasattr(filepath_or_buffer, "close"):
                filepath_or_buffer.close()
            elif hasattr(filepath_or_buffer, "open"):
                print(
                    "[Warning]: Input buffer didn't have close() function. Memory leak may occur!"
                )
        else:
            raise NBTLoadError("buffer did not have a read method.")

    if compressed:
        data_in = safe_gunzip(data_in)

    cdef buffer_context context = buffer_context()
    context.offset = 0
    context.buffer = data_in
    context.size = len(data_in)

    results = []

    if len(data_in) < 1:
        raise EOFError("load() was supplied an empty buffer")

    for i in range(count or 1):
        tag_type = context.buffer[context.offset]
        if tag_type != ID_COMPOUND:
            raise NBTFormatError(f"Expecting tag type {ID_COMPOUND}, got {tag_type} instead")
        context.offset += 1

        name = load_name(context, little_endian)
        tag = load_compound_tag(context, little_endian)

        results.append(NBTFile(tag, name))

    if count is None:
        results = results[0]

    if offset:
        return results, context.offset

    return results