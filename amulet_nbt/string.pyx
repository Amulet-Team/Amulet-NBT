from typing import Iterator, Any, List
from io import BytesIO
from copy import deepcopy
import sys

from .value cimport BaseImmutableTag
from .const cimport ID_STRING
from .util cimport write_string, BufferContext, read_string


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')

cdef inline void _read_string_tag_payload(StringTag tag, BufferContext buffer, bint little_endian):
    tag.value_ = read_string(buffer, little_endian)


cdef class StringTag(BaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(StringTag self, value = ""):
        self.value_ = str(value)

    def capitalize(self):
        return self.value_.capitalize()
    capitalize.__doc__ = str.capitalize.__doc__
    
    def casefold(self):
        return self.value_.casefold()
    casefold.__doc__ = str.casefold.__doc__
    
    def center(self, width, fillchar=' '):
        return self.value_.center(width, fillchar)
    center.__doc__ = str.center.__doc__
    
    def count(self, *args, **kwargs):
        return self.value_.count(*args, **kwargs)
    count.__doc__ = str.count.__doc__
    
    def encode(self, encoding='utf-8', errors='strict'):
        return self.value_.encode(encoding, errors)
    encode.__doc__ = str.encode.__doc__
    
    def endswith(self, *args, **kwargs):
        return self.value_.endswith(*args, **kwargs)
    endswith.__doc__ = str.endswith.__doc__
    
    def expandtabs(self, tabsize=8):
        return self.value_.expandtabs(tabsize)
    expandtabs.__doc__ = str.expandtabs.__doc__
    
    def find(self, *args, **kwargs):
        return self.value_.find(*args, **kwargs)
    find.__doc__ = str.find.__doc__
    
    def format(self, *args, **kwargs):
        return self.value_.format(*args, **kwargs)
    format.__doc__ = str.format.__doc__
    
    def format_map(self, *args, **kwargs):
        return self.value_.format_map(*args, **kwargs)
    format_map.__doc__ = str.format_map.__doc__
    
    def index(self, *args, **kwargs):
        return self.value_.index(*args, **kwargs)
    index.__doc__ = str.index.__doc__
    
    def isalnum(self):
        return self.value_.isalnum()
    isalnum.__doc__ = str.isalnum.__doc__
    
    def isalpha(self):
        return self.value_.isalpha()
    isalpha.__doc__ = str.isalpha.__doc__
    
    def isascii(self):
        return self.value_.isascii()
    isascii.__doc__ = str.isascii.__doc__
    
    def isdecimal(self):
        return self.value_.isdecimal()
    isdecimal.__doc__ = str.isdecimal.__doc__
    
    def isdigit(self):
        return self.value_.isdigit()
    isdigit.__doc__ = str.isdigit.__doc__
    
    def isidentifier(self):
        return self.value_.isidentifier()
    isidentifier.__doc__ = str.isidentifier.__doc__
    
    def islower(self):
        return self.value_.islower()
    islower.__doc__ = str.islower.__doc__
    
    def isnumeric(self):
        return self.value_.isnumeric()
    isnumeric.__doc__ = str.isnumeric.__doc__
    
    def isprintable(self):
        return self.value_.isprintable()
    isprintable.__doc__ = str.isprintable.__doc__
    
    def isspace(self):
        return self.value_.isspace()
    isspace.__doc__ = str.isspace.__doc__
    
    def istitle(self):
        return self.value_.istitle()
    istitle.__doc__ = str.istitle.__doc__
    
    def isupper(self):
        return self.value_.isupper()
    isupper.__doc__ = str.isupper.__doc__
    
    def ljust(self, width, fillchar=' '):
        return self.value_.ljust(width, fillchar)
    ljust.__doc__ = str.ljust.__doc__
    
    def lower(self):
        return self.value_.lower()
    lower.__doc__ = str.lower.__doc__
    
    def lstrip(self, chars=None):
        return self.value_.lstrip(chars)
    lstrip.__doc__ = str.lstrip.__doc__
    
    def replace(self, old, new, count=-1):
        return self.value_.replace(old, new, count)
    replace.__doc__ = str.replace.__doc__
    
    def rfind(self, *args, **kwargs):
        return self.value_.rfind(*args, **kwargs)
    rfind.__doc__ = str.rfind.__doc__
    
    def rindex(self, *args, **kwargs):
        return self.value_.rindex(*args, **kwargs)
    rindex.__doc__ = str.rindex.__doc__
    
    def rjust(self, width, fillchar=' '):
        return self.value_.rjust(width, fillchar)
    rjust.__doc__ = str.rjust.__doc__
    
    def rsplit(self, sep=None, maxsplit=-1):
        return self.value_.rsplit(sep, maxsplit)
    rsplit.__doc__ = str.rsplit.__doc__
    
    def rstrip(self, chars=None):
        return self.value_.rstrip(chars)
    rstrip.__doc__ = str.rstrip.__doc__
    
    def split(self, sep=None, maxsplit=-1):
        return self.value_.split(sep, maxsplit)
    split.__doc__ = str.split.__doc__
    
    def splitlines(self, keepends=False):
        return self.value_.splitlines(keepends)
    splitlines.__doc__ = str.splitlines.__doc__
    
    def startswith(self, *args, **kwargs):
        return self.value_.startswith(*args, **kwargs)
    startswith.__doc__ = str.startswith.__doc__
    
    def strip(self, chars=None):
        return self.value_.strip(chars)
    strip.__doc__ = str.strip.__doc__
    
    def swapcase(self):
        return self.value_.swapcase()
    swapcase.__doc__ = str.swapcase.__doc__
    
    def title(self):
        return self.value_.title()
    title.__doc__ = str.title.__doc__
    
    def translate(self, table):
        return self.value_.translate(table)
    translate.__doc__ = str.translate.__doc__
    
    def upper(self):
        return self.value_.upper()
    upper.__doc__ = str.upper.__doc__
    
    def zfill(self, width):
        return self.value_.zfill(width)
    zfill.__doc__ = str.zfill.__doc__
    
    def __str__(StringTag self):
        return str(self.value_)

    def __dir__(StringTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(StringTag self, other):
        return self.value_ == other

    def __ge__(StringTag self, other):
        return self.value_ >= other

    def __gt__(StringTag self, other):
        return self.value_ > other

    def __le__(StringTag self, other):
        return self.value_ <= other

    def __lt__(StringTag self, other):
        return self.value_ < other

    def __reduce__(StringTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(StringTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(StringTag self):
        return self.__class__(self.value_)

    def __hash__(StringTag self):
        return hash((self.tag_id, self.value_))

    @property
    def py_data(StringTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

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


cdef class NamedStringTag(StringTag):
    def __init__(self, object value="", str name=""):
        super().__init__(value)
        self.name = name

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    @staticmethod
    cdef NamedStringTag read_named_payload(BufferContext buffer, bint little_endian):
        cdef NamedStringTag tag = NamedStringTag.__new__(NamedStringTag)
        tag.name = read_string(buffer, little_endian)
        _read_string_tag_payload(tag, buffer, little_endian)
        return tag

    def __eq__(self, other):
        if isinstance(other, StringTag) and super().__eq__(other):
            if isinstance(other, NamedStringTag):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return NamedStringTag(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return NamedStringTag(
            deepcopy(self.value_),
            self.name
        )

    def __reduce__(self):
        return NamedStringTag, (self.value_, self.name)
