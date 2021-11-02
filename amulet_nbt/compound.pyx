from io import BytesIO
import re
from typing import Iterator
from copy import copy, deepcopy

from .value cimport BaseTag, BaseMutableTag
from .const cimport ID_END, ID_COMPOUND, CommaSpace, CommaNewline
from .util cimport write_byte, BufferContext, read_byte, read_string
from .load_nbt cimport load_payload
from .dtype import AnyNBT

NON_QUOTED_KEY = re.compile('[A-Za-z0-9._+-]+')


cdef class TAG_Compound(BaseMutableTag):
    tag_id = ID_COMPOUND

    def __init__(self, object value = (), **kwvals):
        cdef dict dict_value = dict(value)
        dict_value.update(kwvals)
        TAG_Compound._check_dict(dict_value)
        self.value_ = dict_value

    def __getattr__(self, item):
        if item == "value_":
            raise Exception
        return getattr(self.value_, item)

    def __str__(self):
        return str(self.value_)

    def __dir__(self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(self, other):
        return self.value_ == other

    def __ge__(self, other):
        return self.value_ >= other

    def __gt__(self, other):
        return self.value_ > other

    def __le__(self, other):
        return self.value_ <= other

    def __lt__(self, other):
        return self.value_ < other

    def __reduce__(self):
        return self.__class__, (self.value_,)

    def __deepcopy__(self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(self):
        return self.__class__(self.value_)

    @property
    def value(self):
        return copy(self.value_)

    __hash__ = None


    @staticmethod
    def fromkeys(object keys, BaseTag value=None):
        cdef dict dict_value = dict.fromkeys(keys, value)
        TAG_Compound._check_dict(dict_value)
        cdef TAG_Compound compound = TAG_Compound.__new__(TAG_Compound)
        compound.value_ = dict_value
        return compound

    @staticmethod
    cdef _check_dict(dict value):
        cdef str key
        cdef BaseTag val
        for key, val in value.items():
            if key is None or val is None:
                raise TypeError()

    cdef str _to_snbt(self):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_):
            elem = self.value_[name]
            if NON_QUOTED_KEY.fullmatch(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f'{name}: {elem.to_snbt()}')
        return f"{{{CommaSpace.join(tags)}}}"

    cdef str _pretty_to_snbt(self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_):
            elem = self.value_[name]
            tags.append(f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}')
        if tags:
            return f"{indent_chr * indent_count * leading_indent}{{\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{}}"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        cdef str key
        cdef BaseTag tag

        for key, tag in self.value_.items():
            tag.write_tag(buffer, key, little_endian)
        write_byte(ID_END, buffer)

    @staticmethod
    cdef TAG_Compound read_payload(BufferContext buffer, bint little_endian):
        cdef char tag_type
        cdef TAG_Compound tag = TAG_Compound()
        cdef str name
        cdef BaseTag child_tag

        while True:
            tag_type = read_byte(buffer)
            if tag_type == ID_END:
                break
            else:
                name = read_string(buffer, little_endian)
                child_tag = load_payload(buffer, tag_type, little_endian)
                tag[name] = child_tag
        return tag

    def __eq__(self, other):
        return self.value_ == other

    cpdef bint strict_equals(self, other):
        cdef str self_key, other_key
        if (
                isinstance(other, TAG_Compound)
                and self.keys() == other.keys()
        ):
            for self_key, other_key in zip(self, other):
                if not self[self_key].strict_equals(other[other_key]):
                    return False
            return True
        return False

    def __repr__(self):
        return f"{self.__class__.__name__}({repr(self.value_)})"

    def __getitem__(self, str key not None) -> BaseTag:
        return self.value_[key]

    def __setitem__(self, str key not None, BaseTag value not None):
        self.value_[key] = value

    def setdefault(self, str key not None, BaseTag value not None):
        self.value_.setdefault(key, value)

    def update(self, object other=(), **others):
        cdef dict dict_other = dict(other)
        dict_other.update(others)
        TAG_Compound._check_dict(dict_other)
        self.value_.update(dict_other)

    def __delitem__(self, str key not None):
        del self.value_[key]

    def __iter__(self) -> Iterator[AnyNBT]:
        yield from self.value_

    def __contains__(self, object key) -> bool:
        return key in self.value_

    def __len__(self) -> int:
        return self.value_.__len__()

    def __reversed__(self):
        return reversed(self.value_)
