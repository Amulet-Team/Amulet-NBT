from io import BytesIO
import re
from typing import Iterator

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
        self._value = dict_value

    @staticmethod
    def fromkeys(object keys, BaseTag value=None):
        cdef dict dict_value = dict.fromkeys(keys, value)
        TAG_Compound._check_dict(dict_value)
        cdef TAG_Compound compound = TAG_Compound.__new__(TAG_Compound)
        compound._value = dict_value
        return compound

    @staticmethod
    cdef _check_dict(dict value):
        cdef str key
        cdef BaseTag val
        for key, val in value.items():
            if key is None or val is None:
                raise TypeError()

    @property
    def value(self):
        return self._value.copy()

    cdef str _to_snbt(self):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self._value):
            elem = self._value[name]
            if NON_QUOTED_KEY.fullmatch(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f'{name}: {elem.to_snbt()}')
        return f"{{{CommaSpace.join(tags)}}}"

    cdef str _pretty_to_snbt(self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self._value):
            elem = self._value[name]
            tags.append(f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}')
        if tags:
            return f"{indent_chr * indent_count * leading_indent}{{\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{}}"

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        cdef str key
        cdef BaseTag tag

        for key, tag in self._value.items():
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
        return self._value == other

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
        return f"{self.__class__.__name__}({repr(self.value)})"

    def __getattr__(self, item):
        return getattr(self._value, item)

    def __getitem__(self, str key not None) -> BaseTag:
        return self._value[key]

    def __setitem__(self, str key not None, BaseTag value not None):
        self._value[key] = value

    def setdefault(self, str key not None, BaseTag value not None):
        self._value.setdefault(key, value)

    def update(self, object other=(), **others):
        cdef dict dict_other = dict(other)
        dict_other.update(others)
        TAG_Compound._check_dict(dict_other)
        self._value.update(dict_other)

    def __delitem__(self, str key not None):
        del self._value[key]

    def __iter__(self) -> Iterator[AnyNBT]:
        yield from self._value

    def __contains__(self, str key not None) -> bool:
        return key in self._value

    def __len__(self) -> int:
        return self._value.__len__()

    def __reversed__(self):
        return reversed(self._value)
