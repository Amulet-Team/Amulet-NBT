from __future__ import annotations
from io import BytesIO
from copy import copy, deepcopy
from collections.abc import MutableSequence
import sys

from ._value cimport BaseTag, BaseMutableTag
from ._const cimport ID_LIST, CommaSpace, CommaNewline
from ._util cimport write_byte, write_int, BufferContext, read_byte, read_int
from ._load_nbt cimport load_payload
from ._dtype import AnyNBT
{{py:from template import include, gen_wrapper}}


cdef inline void _read_list_tag_payload(CyListTag tag, BufferContext buffer, bint little_endian):
    cdef char list_type = read_byte(buffer)
    tag.list_data_type = list_type
    cdef int length = read_int(buffer, little_endian)
    cdef list val = tag.value_
    cdef int i
    for i in range(length):
        val.append(load_payload(buffer, list_type, little_endian))


cdef class CyListTag(BaseMutableTag):
    """
    This class behaves like a python list.
    All contained data must be of the same NBT data type.
    """
    tag_id = ID_LIST

    def __init__(CyListTag self, object value = (), char list_data_type = 1):
        self.list_data_type = list_data_type
        self.value_ = []
        cdef list list_value
        list_value = list(value)
        self._check_tag_iterable(list_value)
        self.value_ = list_value

{{include("BaseMutableTag.pyx", cls_name="CyListTag")}}

    @property
    def py_data(CyListTag self):
        """
        The python representation of the class.
        The returned list is a copy of the internal data, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """
        return copy(self.value_)

    cdef void _check_tag(CyListTag self, BaseTag value, bint fix_if_empty=True) except *:
        if value is None:
            raise TypeError("List values must be NBT Tags")
        if fix_if_empty and not self.value_:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for ListTag({self.list_data_type})"
            )

    cdef void _check_tag_iterable(CyListTag self, list value) except *:
        cdef int i
        cdef BaseTag tag
        for i, tag in enumerate(value):
            self._check_tag(tag, not i)

    cdef void write_payload(CyListTag self, object buffer: BytesIO, bint little_endian) except *:
        cdef char list_type = self.list_data_type

        write_byte(list_type, buffer)
        write_int(<int> len(self.value_), buffer, little_endian)

        cdef BaseTag subtag
        for subtag in self.value_:
            if subtag.tag_id != list_type:
                raise ValueError(
                    f"ListTag must only contain one type! Found {subtag.tag_id} in list type {list_type}"
                )
            subtag.write_payload(buffer, little_endian)

    @staticmethod
    cdef CyListTag read_payload(BufferContext buffer, bint little_endian):
        cdef CyListTag tag = ListTag()
        _read_list_tag_payload(tag, buffer, little_endian)
        return tag

    cdef str _to_snbt(CyListTag self):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(elem._to_snbt())
        return f"[{CommaSpace.join(tags)}]"

    cdef str _pretty_to_snbt(CyListTag self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(elem._pretty_to_snbt(indent_chr, indent_count + 1))
        if tags:
            return f"{indent_chr * indent_count * leading_indent}[\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}]"
        else:
            return f"{indent_chr * indent_count * leading_indent}[]"

    def __repr__(CyListTag self):
        return f"{self.__class__.__name__}({repr(self.value_)}, {self.list_data_type})"

    def __contains__(CyListTag self, object item) -> bool:
        return isinstance(item, BaseTag) and item.tag_id == self.list_data_type and self.value_.__contains__(item)

    def __len__(CyListTag self) -> int:
        return self.value_.__len__()

    def __getitem__(CyListTag self, index: int) -> AnyNBT:
        return self.value_[index]

    def __setitem__(CyListTag self, index, value):
        if isinstance(index, slice):
            value = list(value)
            self._check_tag_iterable(value)
        else:
            self._check_tag(value)
        self.value_[index] = value

    def __delitem__(CyListTag self, object index):
        self.value_.__delitem__(index)

    def copy(CyListTag self):
        """Return a shallow copy of the class"""
        return ListTag(self.value_.copy(), self.list_data_type)

    def insert(CyListTag self, object index, BaseTag value not None):
        self._check_tag(value)
        self.value_.insert(index, value)
    insert.__doc__ = list.insert.__doc__

    cpdef bint strict_equals(CyListTag self, other):
        """
        Does the data and data type match the other object.
        
        :param other: The other object to compare with
        :return: True if the classes are identical, False otherwise.
        """
        cdef BaseTag self_val, other_val
        if (
            isinstance(other, ListTag)
            and self.list_data_type == other.list_data_type
            and len(self) == len(other)
        ):
            for self_val, other_val in zip(self, other):
                if not self_val.strict_equals(other_val):
                    return False
            return True
        return False


if sys.version_info >= (3, 9):
    class ListTag(CyListTag, MutableSequence[AnyNBT]):
        pass

else:
    class ListTag(CyListTag, MutableSequence):
        pass
