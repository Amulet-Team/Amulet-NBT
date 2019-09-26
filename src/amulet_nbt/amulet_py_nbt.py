from __future__ import annotations

import gzip
import itertools
from collections.abc import MutableMapping, MutableSequence
from dataclasses import dataclass, field
from io import BytesIO
from struct import Struct, pack
from typing import Any, ClassVar, get_type_hints, Dict, List, Type

import numpy as np

TAG_END = 0
TAG_BYTE = 1
TAG_SHORT = 2
TAG_INT = 3
TAG_LONG = 4
TAG_FLOAT = 5
TAG_DOUBLE = 6
TAG_BYTE_ARRAY = 7
TAG_STRING = 8
TAG_LIST = 9
TAG_COMPOUND = 10
TAG_INT_ARRAY = 11
TAG_LONG_ARRAY = 12

NBT_WRAPPER = "python"

_string_len_fmt = Struct(">H")


class NBTFormatError(Exception):
    pass


class _BufferContext:
    __slots__ = ("buffer", "offset", "size")

    def __init__(self, offset: int, buffer, size: int):
        self.offset = offset
        self.buffer = buffer
        self.size = size


def load_string(context: _BufferContext) -> str:
    data = context.buffer[context.offset :]
    (str_len,) = _string_len_fmt.unpack_from(data)

    value = data[2 : str_len + 2].decode("utf-8")
    context.offset += str_len + 2
    return value


def write_string(buffer, _str):
    encoded_str = _str.encode("utf-8")
    buffer.write(pack(f">h{len(encoded_str)}s", len(encoded_str), encoded_str))


@dataclass
class _TAG_Value:
    value: Any
    tag_id: ClassVar[int]
    _data_type: ClassVar[Any]
    tag_format: Struct = field(init=False, repr=False, compare=False)

    def __new__(cls, *args, **kwargs):
        cls._data_type = get_type_hints(cls)["value"]

        return super(_TAG_Value, cls).__new__(cls)

    def __init__(self, value):
        self.value = self.format(value)

    @classmethod
    def load_from(cls, context: _BufferContext) -> _TAG_Value:
        data = context.buffer[context.offset :]
        tag = cls(cls.tag_format.unpack_from(data)[0])
        context.offset += cls.tag_format.size
        return tag

    def format(self, value):
        return self._data_type(value)

    def write_tag_id(self, buffer):
        buffer.write(bytes(chr(self.tag_id), "utf-8"))

    def save(self, buffer, name=None):
        self.write_tag_id(buffer)
        if name is not None:
            write_string(buffer, name)

        self.write_value(buffer)

    def write_value(self, buffer):
        buffer.write(self.tag_format.pack(self.value))

    def to_snbt(self):
        raise NotImplemented


@dataclass
class TAG_Byte(_TAG_Value):
    value: int = 0
    tag_id = TAG_BYTE
    tag_format = Struct(">b")

    def to_snbt(self):
        return f"{self.value}b"


@dataclass
class TAG_Short(_TAG_Value):
    value: int = 0
    tag_id = TAG_SHORT
    tag_format = Struct(">h")

    def to_snbt(self):
        return f"{self.value}s"


@dataclass
class TAG_Int(_TAG_Value):
    value: int = 0
    tag_id = TAG_INT
    tag_format = Struct(">i")

    def to_snbt(self):
        return f"{self.value}"


@dataclass
class TAG_Long(_TAG_Value):
    value: int = 0
    tag_id = TAG_LONG
    tag_format = Struct(">q")

    def to_snbt(self):
        return f"{self.value}l"


@dataclass
class TAG_Float(_TAG_Value):
    value: float = 0
    tag_id = TAG_FLOAT
    tag_format = Struct(">f")

    def to_snbt(self):
        return f"{self.value}f"


@dataclass
class TAG_Double(_TAG_Value):
    value: float = 0
    tag_id = TAG_DOUBLE
    tag_format = Struct(">d")

    def to_snbt(self):
        return f"{self.value}d"


@dataclass(eq=False)
class _TAG_Array(_TAG_Value):
    data_type: ClassVar[Any]
    value: np.ndarray = np.zeros(0)

    def __eq__(self, other: _TAG_Array):
        return (
            self.data_type == other.data_type
            and self.tag_id == other.tag_id
            and np.array_equal(self.value, other.value)
        )

    def __len__(self):
        return len(self.value)

    @classmethod
    def load_from(cls, context: _BufferContext) -> _TAG_Value:
        data = context.buffer[context.offset :]
        (string_len,) = TAG_Int.tag_format.unpack_from(data)
        value = np.frombuffer(
            data[4 : string_len * cls.data_type.itemsize + 4], cls.data_type
        )
        context.offset += string_len * cls.data_type.itemsize + 4

        return cls(value)

    def write_value(self, buffer):
        value = self.value.tostring()
        buffer.write(pack(f">I{len(value)}s", self.value.size, value))


@dataclass(eq=False)
class TAG_Byte_Array(_TAG_Array):
    data_type = np.dtype("uint8")
    value: np.ndarray = np.zeros(0, data_type)
    tag_id = TAG_BYTE_ARRAY

    def to_snbt(self):
        return f"[B;{', '.join(str(val) for val in self.value)}]"


@dataclass(eq=False)
class TAG_Int_Array(_TAG_Array):
    data_type = np.dtype(">u4")
    value: np.ndarray = np.zeros(0, data_type)
    tag_id = TAG_INT_ARRAY

    def to_snbt(self):
        return f"[I;{', '.join(str(val) for val in self.value)}]"


@dataclass(eq=False)
class TAG_Long_Array(_TAG_Array):
    data_type = np.dtype(">q")
    value: np.ndarray = np.zeros(0, data_type)
    tag_id = TAG_LONG_ARRAY

    def to_snbt(self):
        return f"[L;{', '.join(str(val) for val in self.value)}]"


def escape(string: str):
    return string.replace('\\', '\\\\').replace('"', '\\"')


@dataclass
class TAG_String(_TAG_Value):
    tag_id = TAG_STRING
    value: str = ""

    @classmethod
    def load_from(cls, context: _BufferContext) -> _TAG_Value:
        return cls(load_string(context))

    def write_value(self, buffer):
        write_string(buffer, self.value)

    def to_snbt(self):
        return f"\"{escape(self.value)}\""


@dataclass
class TAG_List(_TAG_Value, MutableSequence):
    tag_id = TAG_LIST
    list_data_type: int = TAG_END
    value: List[_TAG_Value] = field(default_factory=list)

    def __getitem__(self, index: int) -> _TAG_Value:
        return self.value.__getitem__(index)

    def __setitem__(self, index: int, value: _TAG_Value):
        self.value.__setitem__(index, value)

    def __delitem__(self, index: int):
        self.value.__delitem__(index)

    def __contains__(self, item: _TAG_Value) -> bool:
        return self.value.__contains__(item)

    def __len__(self) -> int:
        return self.value.__len__()

    def __iter__(self):
        return self.value.__iter__()

    def insert(self, index: int, value: _TAG_Value):
        self.value.insert(index, value)

    @classmethod
    def load_from(cls, context: _BufferContext) -> _TAG_Value:
        tag = cls()
        tag.list_data_type = list_data_type = context.buffer[context.offset]
        context.offset += 1

        (list_len,) = TAG_Int.tag_format.unpack_from(context.buffer, context.offset)
        context.offset += TAG_Int.tag_format.size

        for i in range(list_len):
            child_tag = TAG_CLASSES[list_data_type].load_from(context)
            tag.append(child_tag)

        return tag

    def write_value(self, buffer):
        buffer.write(bytes(chr(self.list_data_type), "utf-8"))
        buffer.write(TAG_Int.tag_format.pack(len(self.value)))

        for item in self.value:
            item.write_value(buffer)

    def to_snbt(self):
        return f"[{', '.join(elem.to_snbt() for elem in self.value)}]"


@dataclass
class TAG_Compound(_TAG_Value, MutableMapping):
    tag_id = TAG_COMPOUND
    value: Dict[str, _TAG_Value] = field(default_factory=dict)

    @classmethod
    def load_from(cls, context: _BufferContext) -> TAG_Compound:
        tag = cls()

        while context.offset < context.size:
            tag_id = context.buffer[context.offset]
            context.offset += 1

            if tag_id == TAG_END:
                break

            tag_name = load_string(context)
            child_tag = TAG_CLASSES[tag_id].load_from(context)

            tag[tag_name] = child_tag

        return tag

    def write_value(self, buffer):
        for key, value in self.value.items():
            value.save(buffer, key)

        buffer.write(bytes(chr(TAG_END), "utf-8"))

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value.__getitem__(key)

    def __setitem__(self, key: str, value: _TAG_Value):
        self.value.__setitem__(key, value)

    def __delitem__(self, key: str):
        self.value.__delitem__(key)

    def __contains__(self, item: str) -> bool:
        return self.value.__contains__(item)

    def __len__(self) -> int:
        return self.value.__len__()

    def __iter__(self):
        return self.value.__iter__()

    def to_snbt(self):
        return f"{{{', '.join(f'{name}: {elem.to_snbt()}' for name, elem in self.value.items())}}}"


@dataclass
class NBTFile(MutableMapping):
    value: TAG_Compound
    name: str = ""

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value[key]

    def __setitem__(self, key: str, tag: _TAG_Value):
        self.value[key] = tag

    def __delitem__(self, key: str):
        del self.value[key]

    def __iter__(self):
        yield from self.value

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __len__(self) -> int:
        return self.value.__len__()

    def save_to(self, filename_or_buffer=None, compressed=True) -> Optional[BytesIO]:
        buffer = BytesIO()
        self.value.save(buffer, self.name)

        data = buffer.getvalue()

        if compressed:
            gzip_buffer = BytesIO()
            gz = gzip.GzipFile(fileobj=gzip_buffer, mode="wb")
            gz.write(data)
            gz.close()
            data = gzip_buffer.getvalue()

        if not filename_or_buffer:
            return data

        if isinstance(filename_or_buffer, str):
            fp = open(filename_or_buffer, "wb")
            fp.write(data)
            fp.close()
        else:
            filename_or_buffer.write(data)

    def to_snbt(self):
        return self.value.to_snbt()


def safe_gunzip(data):
    try:
        data = gzip.GzipFile(fileobj=BytesIO(data)).read()
    except IOError as e:
        pass
    return data


def load(filename="", buffer=None) -> NBTFile:
    if filename:
        buffer = open(filename, "rb")
    data_in = buffer

    if hasattr(buffer, "read"):
        data_in = buffer.read()

    if hasattr(buffer, "close"):
        buffer.close()
    else:
        print(
            "[Warning]: Input buffer didn't have close() function. Memory leak may occur!"
        )

    data_in = safe_gunzip(data_in)

    tag_type = data_in[0]
    if tag_type != TAG_COMPOUND:
        magic_num = data_in[:4]
        raise NBTFormatError()

    context: _BufferContext = _BufferContext(
        offset=1, buffer=data_in, size=len(data_in)
    )

    tag_name = load_string(context)
    tag: TAG_Compound = TAG_Compound.load_from(context)

    return NBTFile(tag, tag_name)


TAG_CLASSES: Dict[int, Type[_TAG_Value]] = {
    t().tag_id: t
    for t in itertools.chain(_TAG_Value.__subclasses__(), _TAG_Array.__subclasses__())
    if t is not _TAG_Array
}
