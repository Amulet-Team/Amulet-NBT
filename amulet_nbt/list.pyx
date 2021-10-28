from typing import Iterator
from io import BytesIO
from collections.abc import MutableSequence

from .value cimport BaseTag, BaseMutableTag
from .const cimport ID_LIST, CommaSpace, CommaNewline
from .util cimport write_byte, write_int, BufferContext, read_byte, read_int
from .load_nbt cimport load_payload
from .dtype import AnyNBT
from .array import BaseArrayTag

cdef Null = object()


cdef class TAG_List(BaseMutableTag):
    tag_id = ID_LIST

    def __init__(self, object value = Null, char list_data_type = 1):
        self.list_data_type = list_data_type
        self._value = []
        cdef list list_value
        if value is Null:
            list_value = []
        else:
            list_value = list(value)
            self._check_tag_iterable(list_value)
        self._value = list_value

    @property
    def value(self):
        return self._value.copy()

    cdef void _check_tag(self, BaseTag value, bint fix_if_empty=True) except *:
        if value is None:
            raise TypeError("List values must be NBT Tags")
        if fix_if_empty and not self._value:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List({self.list_data_type})"
            )

    cdef void _check_tag_iterable(self, list value) except *:
        cdef int i
        cdef BaseTag tag
        for i, tag in enumerate(value):
            self._check_tag(tag, not i)

    cdef void write_payload(self, object buffer: BytesIO, bint little_endian) except *:
        cdef char list_type = self.list_data_type

        write_byte(list_type, buffer)
        write_int(<int> len(self._value), buffer, little_endian)

        cdef BaseTag subtag
        for subtag in self._value:
            if subtag.tag_id != list_type:
                raise ValueError(
                    f"TAG_List must only contain one type! Found {subtag.tag_id} in list type {list_type}"
                )
            subtag.write_payload(buffer, little_endian)

    @staticmethod
    cdef TAG_List read_payload(BufferContext buffer, bint little_endian):
        cdef char list_type = read_byte(buffer)
        cdef int length = read_int(buffer, little_endian)
        cdef TAG_List self = TAG_List(list_data_type=list_type)
        cdef list val = self._value
        cdef int i
        for i in range(length):
            val.append(load_payload(buffer, list_type, little_endian))
        return self

    cdef str _to_snbt(self):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self._value:
            tags.append(elem._to_snbt())
        return f"[{CommaSpace.join(tags)}]"

    cdef str _pretty_to_snbt(self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self._value:
            tags.append(elem._pretty_to_snbt(indent_chr, indent_count + 1))
        if tags:
            return f"{indent_chr * indent_count * leading_indent}[\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}]"
        else:
            return f"{indent_chr * indent_count * leading_indent}[]"

    def __repr__(self):
        return f"{self.__class__.__name__}({repr(self.value)}, {self.list_data_type})"

    def __getattr__(self, item):
        return getattr(self._value, item)

    def __contains__(self, item: AnyNBT) -> bool:
        return self._value.__contains__(item)

    def __iter__(self) -> Iterator[AnyNBT]:
        return self._value.__iter__()

    def __len__(self) -> int:
        return self._value.__len__()

    def __getitem__(self, index: int) -> AnyNBT:
        return self._value[index]

    def __setitem__(self, index, value):
        if isinstance(index, slice):
            self._check_tag_iterable(list(value))
        else:
            self._check_tag(value)
        self._value[index] = value

    def __delitem__(self, index: int):
        del self._value[index]

    def append(self, value: AnyNBT) -> None:
        self._check_tag(value)
        self._value.append(value)

    def copy(self):
        return TAG_List(self._value.copy(), self.list_data_type)

    def extend(self, other):
        self._check_tag_iterable(list(other))
        self._value.extend(other)
        return self

    def insert(self, index: int, value: AnyNBT):
        self._check_tag(value)
        self._value.insert(index, value)

    def __mul__(self, other):
        return self._value * other

    def __rmul__(self, other):
        return other * self._value

    def __imul__(self, other):
        self._value *= other
        return self

    def __eq__(self, other):
        if isinstance(other, BaseArrayTag):
            return NotImplemented
        return self._value == other

    cpdef bint strict_equals(self, other):
        cdef BaseTag self_val, other_val
        if (
            isinstance(other, TAG_List)
            and self.list_data_type == other.list_data_type
            and len(self) == len(other)
        ):
            for self_val, other_val in zip(self, other):
                if not self_val.strict_equals(other_val):
                    return False
            return True
        return False

    def __add__(self, other):
        return self._value + other

    def __radd__(self, other):
        return other + self._value

    def __iadd__(self, other):
        self.extend(other)
        return self


# class TAG_List(_TAG_List, MutableSequence):
#     pass
