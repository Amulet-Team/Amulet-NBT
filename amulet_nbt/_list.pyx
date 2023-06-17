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

    def __str__(CyListTag self):
        return str(self.value_)

    def __eq__(CyListTag self, other):
        cdef CyListTag other_
        if isinstance(other, CyListTag):
            other_ = other
            return self.value_ == other_.value_
        return NotImplemented

    def __reduce__(CyListTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(CyListTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(CyListTag self):
        return self.__class__(self.value_)

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

    cpdef ByteTag get_byte(self, int index):
        """Get the tag at index if it is a ByteTag.
    
        :param index: The index to get
        :return: The ByteTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteTag
        """
        cdef ByteTag tag = self[index]
        return tag

    cpdef ShortTag get_short(self, int index):
        """Get the tag at index if it is a ShortTag.
    
        :param index: The index to get
        :return: The ShortTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ShortTag
        """
        cdef ShortTag tag = self[index]
        return tag

    cpdef IntTag get_int(self, int index):
        """Get the tag at index if it is a IntTag.
    
        :param index: The index to get
        :return: The IntTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntTag
        """
        cdef IntTag tag = self[index]
        return tag

    cpdef LongTag get_long(self, int index):
        """Get the tag at index if it is a LongTag.
    
        :param index: The index to get
        :return: The LongTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongTag
        """
        cdef LongTag tag = self[index]
        return tag

    cpdef FloatTag get_float(self, int index):
        """Get the tag at index if it is a FloatTag.
    
        :param index: The index to get
        :return: The FloatTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a FloatTag
        """
        cdef FloatTag tag = self[index]
        return tag

    cpdef DoubleTag get_double(self, int index):
        """Get the tag at index if it is a DoubleTag.
    
        :param index: The index to get
        :return: The DoubleTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a DoubleTag
        """
        cdef DoubleTag tag = self[index]
        return tag

    cpdef StringTag get_string(self, int index):
        """Get the tag at index if it is a StringTag.
    
        :param index: The index to get
        :return: The StringTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a StringTag
        """
        cdef StringTag tag = self[index]
        return tag

    cpdef CyListTag get_list(self, int index):
        """Get the tag at index if it is a CyListTag.
    
        :param index: The index to get
        :return: The CyListTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a CyListTag
        """
        cdef CyListTag tag = self[index]
        return tag

    cpdef CyCompoundTag get_compound(self, int index):
        """Get the tag at index if it is a CyCompoundTag.
    
        :param index: The index to get
        :return: The CyCompoundTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a CyCompoundTag
        """
        cdef CyCompoundTag tag = self[index]
        return tag

    cpdef ByteArrayTag get_byte_array(self, int index):
        """Get the tag at index if it is a ByteArrayTag.
    
        :param index: The index to get
        :return: The ByteArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """
        cdef ByteArrayTag tag = self[index]
        return tag

    cpdef IntArrayTag get_int_array(self, int index):
        """Get the tag at index if it is a IntArrayTag.
    
        :param index: The index to get
        :return: The IntArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntArrayTag
        """
        cdef IntArrayTag tag = self[index]
        return tag

    cpdef LongArrayTag get_long_array(self, int index):
        """Get the tag at index if it is a LongArrayTag.
    
        :param index: The index to get
        :return: The LongArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongArrayTag
        """
        cdef LongArrayTag tag = self[index]
        return tag


class ListTag(CyListTag, MutableSequence):
    pass
