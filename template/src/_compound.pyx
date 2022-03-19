from io import BytesIO
import re
from typing import Iterator, List
from copy import copy, deepcopy

from ._value cimport BaseTag, BaseMutableTag
from ._const cimport ID_END, ID_COMPOUND, CommaSpace, CommaNewline
from ._util cimport write_byte, BufferContext, read_byte, read_string
from ._load_nbt cimport load_payload
{{py:from template import include, gen_wrapper}}

NON_QUOTED_KEY = re.compile('[A-Za-z0-9._+-]+')


cdef inline void _read_compound_tag_payload(CompoundTag tag, BufferContext buffer, bint little_endian):
    cdef char tag_type
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


cdef class CompoundTag(BaseMutableTag):
    """
    This class behaves like a python dictionary.
    All keys must be strings and all values must be NBT data types.
    """
    tag_id = ID_COMPOUND

    def __init__(CompoundTag self, object value = (), **kwvals):
        cdef dict dict_value = dict(value)
        dict_value.update(kwvals)
        CompoundTag._check_dict(dict_value)
        self.value_ = dict_value

{{gen_wrapper(
    "value_",
    dict,
    [
        "get",
        "pop",
        "popitem",
        "clear",
        "keys",
        "values",
        "items",
    ]
)}}
{{include("BaseMutableTag.pyx.in", cls_name="CompoundTag")}}

    @staticmethod
    def fromkeys(object keys, BaseTag value=None):
        cdef dict dict_value = dict.fromkeys(keys, value)
        CompoundTag._check_dict(dict_value)
        cdef CompoundTag compound = CompoundTag.__new__(CompoundTag)
        compound.value_ = dict_value
        return compound
    fromkeys.__func__.__doc__ = dict.fromkeys.__doc__

    @staticmethod
    cdef _check_dict(dict value):
        cdef str key
        cdef BaseTag val
        for key, val in value.items():
            if key is None or val is None:
                raise TypeError()

    cdef str _to_snbt(CompoundTag self):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_, key=lambda k: (k.lower(), k.swapcase())):
            elem = self.value_[name]
            if NON_QUOTED_KEY.fullmatch(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f'{name}: {elem.to_snbt()}')
        return f"{{start_braces}}{CommaSpace.join(tags)}{{end_braces}}"

    cdef str _pretty_to_snbt(CompoundTag self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_, key=lambda k: (k.lower(), k.swapcase())):
            elem = self.value_[name]
            tags.append(f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}')
        if tags:
            return f"{indent_chr * indent_count * leading_indent}{{start_braces}}\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}{{end_braces}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{start_braces}}{{end_braces}}"

    cdef void write_payload(CompoundTag self, object buffer: BytesIO, bint little_endian) except *:
        cdef str key
        cdef BaseTag tag

        for key, tag in self.value_.items():
            tag.write_tag(buffer, key, little_endian)
        write_byte(ID_END, buffer)

    @staticmethod
    cdef CompoundTag read_payload(BufferContext buffer, bint little_endian):
        cdef CompoundTag tag = CompoundTag()
        _read_compound_tag_payload(tag, buffer, little_endian)
        return tag

    cpdef bint strict_equals(CompoundTag self, other):
        """Does the data and data type match the other object."""
        cdef str self_key, other_key
        if (
                isinstance(other, CompoundTag)
                and self.keys() == other.keys()
        ):
            for self_key, other_key in zip(self, other):
                if not self[self_key].strict_equals(other[other_key]):
                    return False
            return True
        return False

    def __repr__(CompoundTag self):
        return f"{self.__class__.__name__}({repr(self.value_)})"

    def __getitem__(CompoundTag self, str key not None) -> BaseTag:
        return self.value_[key]

    def __setitem__(CompoundTag self, str key not None, BaseTag value not None):
        self.value_[key] = value

    def setdefault(CompoundTag self, str key not None, BaseTag value not None):
        return self.value_.setdefault(key, value)
    setdefault.__doc__ = dict.setdefault.__doc__

    def update(CompoundTag self, object other=(), **others):
        cdef dict dict_other = dict(other)
        dict_other.update(others)
        CompoundTag._check_dict(dict_other)
        self.value_.update(dict_other)
    update.__doc__ = dict.update.__doc__

    def __delitem__(CompoundTag self, str key not None):
        del self.value_[key]

    def __iter__(CompoundTag self) -> Iterator[str]:
        yield from self.value_

    def __contains__(CompoundTag self, object key) -> bool:
        return key in self.value_

    def __len__(CompoundTag self) -> int:
        return self.value_.__len__()

    def __reversed__(CompoundTag self):
        return reversed(self.value_)
