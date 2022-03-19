from typing import Iterator, Any, List
from io import BytesIO
from copy import deepcopy
import sys

from ._value cimport BaseImmutableTag
from ._const cimport ID_STRING
from ._util cimport write_string, BufferContext, read_string
{{py:from template import include,gen_wrapper}}


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')

cdef inline void _read_string_tag_payload(StringTag tag, BufferContext buffer, bint little_endian):
    tag.value_ = read_string(buffer, little_endian)


cdef class StringTag(BaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(StringTag self, value = ""):
        self.value_ = str(value)

{{gen_wrapper(
    "value_",
    str,
    [
        "capitalize",
        "casefold",
        "center",
        "count",
        "encode",
        "endswith",
        "expandtabs",
        "find",
        "format",
        "format_map",
        "index",
        "isalnum",
        "isalpha",
        "isascii",
        "isdecimal",
        "isdigit",
        "isidentifier",
        "islower",
        "isnumeric",
        "isprintable",
        "isspace",
        "istitle",
        "isupper",
        "ljust",
        "lower",
        "lstrip",
        "replace",
        "rfind",
        "rindex",
        "rjust",
        "rsplit",
        "rstrip",
        "split",
        "splitlines",
        "startswith",
        "strip",
        "swapcase",
        "title",
        "translate",
        "upper",
        "zfill",
    ]
)}}
{{include("BaseImmutableTag.pyx.in", cls_name="StringTag")}}

    def join(StringTag self, iterable: Iterable[str]) -> str:
        return self.value_.join([str(s) for s in iterable])
    join.__doc__ = str.join.__doc__

    def partition(StringTag self, sep):
        return self.value_.partition(str(sep))
    partition.__doc__ = str.partition.__doc__

    def rpartition(StringTag self, sep):
        return self.value_.rpartition(str(sep))
    rpartition.__doc__ = str.rpartition.__doc__

    if sys.version_info >= (3, 9):
        def removeprefix(StringTag self, prefix: str) -> str:
            return self.value_.removeprefix(prefix)
        removeprefix.__doc__ = str.removeprefix.__doc__

        def removesuffix(StringTag self, suffix: str) -> str:
            return self.value_.removesuffix(suffix)
        removesuffix.__doc__ = str.removesuffix.__doc__

    maketrans = str.maketrans

    def __len__(StringTag self) -> int:
        return len(self.value_)

    def __repr__(StringTag self):
        return f"{self.__class__.__name__}(\"{self.value_}\")"

    cdef str _to_snbt(StringTag self):
        return f"\"{escape(self.value_)}\""

    cdef void write_payload(StringTag self, object buffer: BytesIO, bint little_endian) except *:
        write_string(self.value_, buffer, little_endian)

    @staticmethod
    cdef StringTag read_payload(BufferContext buffer, bint little_endian):
        cdef StringTag tag = StringTag.__new__(StringTag)
        _read_string_tag_payload(tag, buffer, little_endian)
        return tag

    def __getitem__(StringTag self, item):
        return self.value_.__getitem__(item)

    def __add__(StringTag self, other):
        return self.value_ + other

    def __radd__(StringTag self, other):
        return other + self.value_

    def __iadd__(StringTag self, other):
        res = self + other
        if isinstance(res, str):
            return self.__class__(res)
        return res

    def __mul__(StringTag self, other):
        return self.value_ * other

    def __rmul__(StringTag self, other):
        return other * self.value_

    def __imul__(StringTag self, other):
        res = self * other
        if isinstance(res, str):
            return self.__class__(res)
        return res

    def __contains__(StringTag self, o: str) -> bool:
        return o in self.value_

    def __iter__(StringTag self) -> Iterator[str]:
        return self.value_.__iter__()

    def __mod__(StringTag self, x: Any) -> str:
        return self.value_ % x

    def __int__(StringTag self) -> int:
        return int(self.value_)
