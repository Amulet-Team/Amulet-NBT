## This file is generated by tempita. Do not modify this file directly or your changes will get overwritten.
## To edit this file edit the template in template/src

from typing import List, TypeVar, Generic
from io import BytesIO
from copy import copy, deepcopy
from collections.abc import MutableSequence
import sys
import warnings

from ._value cimport AbstractBaseTag, AbstractBaseMutableTag
from ._const cimport ID_LIST, CommaSpace, CommaNewline
from ._util cimport write_byte, write_int, BufferContext, read_byte, read_int
from ._load_nbt cimport load_payload
from ._dtype import AnyNBT, EncoderType
{{py:from template import include}}


cdef inline CyListTag read_list_tag(BufferContext buffer, bint little_endian, string_decoder: DecoderType):
    cdef CyListTag tag = ListTag()
    cdef char list_type = read_byte(buffer)
    tag.list_data_type = list_type
    cdef int length = read_int(buffer, little_endian)
    cdef list val = tag.value_
    cdef int i
    for i in range(length):
        val.append(load_payload(buffer, list_type, little_endian, string_decoder))
    return tag


cdef class CyListTag(AbstractBaseMutableTag):
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

    @classmethod
    def create(cls, object value = (), char list_data_type = 1) -> ListTag:
        return ListTag(value, list_data_type)

{{include("AbstractBaseMutableTag.pyx", cls_name="CyListTag")}}

    @property
    def py_list(CyListTag self) -> List[AnyNBT]:
        """
        A python list representation of the class.
        The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """
        return copy(self.value_)

    @property
    def py_data(self):
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        return self.py_list

    cdef void _check_tag(CyListTag self, AbstractBaseTag value, bint fix_if_empty=True) except *:
        if value is None:
            raise TypeError("List values must be NBT Tags")
        if fix_if_empty and not self.value_:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for ListTag(list_data_type={self.list_data_type})"
            )

    cdef void _check_tag_iterable(CyListTag self, list value) except *:
        cdef int i
        cdef AbstractBaseTag tag
        for i, tag in enumerate(value):
            self._check_tag(tag, not i)

    cdef void write_payload(
        CyListTag self,
        object buffer: BytesIO,
        bint little_endian,
        string_encoder: EncoderType,
    ) except *:
        cdef char list_type = self.list_data_type

        write_byte(list_type, buffer)
        write_int(<int> len(self.value_), buffer, little_endian)

        cdef AbstractBaseTag subtag
        for subtag in self.value_:
            if subtag.tag_id != list_type:
                raise ValueError(
                    f"ListTag must only contain one type! Found {subtag.tag_id} in list type {list_type}"
                )
            subtag.write_payload(buffer, little_endian, string_encoder)

    cdef str _to_snbt(CyListTag self):
        cdef AbstractBaseTag elem
        cdef list tags = []
        for elem in self.value_:
            tags.append(elem._to_snbt())
        return f"[{CommaSpace.join(tags)}]"

    cdef str _pretty_to_snbt(CyListTag self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef AbstractBaseTag elem
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
        return isinstance(item, AbstractBaseTag) and item.tag_id == self.list_data_type and self.value_.__contains__(item)

    def __len__(CyListTag self) -> int:
        return self.value_.__len__()

    def __getitem__(CyListTag self, index) -> AnyNBT:
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

    def insert(CyListTag self, object index, AbstractBaseTag value not None):
        self._check_tag(value)
        self.value_.insert(index, value)

{{include("ListGet.pyx", tag_cls_name="ByteTag", tag_name="byte")}}
{{include("ListGet.pyx", tag_cls_name="ShortTag", tag_name="short")}}
{{include("ListGet.pyx", tag_cls_name="IntTag", tag_name="int")}}
{{include("ListGet.pyx", tag_cls_name="LongTag", tag_name="long")}}
{{include("ListGet.pyx", tag_cls_name="FloatTag", tag_name="float")}}
{{include("ListGet.pyx", tag_cls_name="DoubleTag", tag_name="double")}}
{{include("ListGet.pyx", tag_cls_name="StringTag", tag_name="string")}}
{{include("ListGet.pyx", tag_cls_name="CyListTag", tag_name="list")}}
{{include("ListGet.pyx", tag_cls_name="CyCompoundTag", tag_name="compound")}}
{{include("ListGet.pyx", tag_cls_name="ByteArrayTag", tag_name="byte_array")}}
{{include("ListGet.pyx", tag_cls_name="IntArrayTag", tag_name="int_array")}}
{{include("ListGet.pyx", tag_cls_name="LongArrayTag", tag_name="long_array")}}

class ListTag(CyListTag, MutableSequence):
    pass
