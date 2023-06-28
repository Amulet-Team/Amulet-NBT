from typing import Type, TypeVar
import warnings

from mutf8 import encode_modified_utf8

from amulet_nbt._tags._value cimport AbstractBaseTag, AbstractBase
from amulet_nbt._tags._numeric._int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from amulet_nbt._tags._numeric._float cimport (
    FloatTag,
    DoubleTag,
)
from amulet_nbt._tags._array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from amulet_nbt._tags._string cimport StringTag
from amulet_nbt._tags._list cimport ListTag
from amulet_nbt._tags._compound cimport CompoundTag
from amulet_nbt._dtype import EncoderType, AnyNBT
from amulet_nbt._tags._wrap cimport wrap_tag_node


T = TypeVar("T")


cdef class NamedTag(AbstractBase):
    def __init__(self, AbstractBaseTag tag = None, str name not None = ""):
        if tag is None:
            self.tag = CompoundTag.create()
        else:
            self.tag = tag
        self.name = name

    @property
    def tag(self) -> AbstractBaseTag:
        return wrap_tag_node(self.tag_node)

    @property
    def byte(self) -> ByteTag:
        """Get the tag if it is a ByteTag.

        :return: The ByteTag.
        :raises: TypeError if the stored type is not a ByteTag
        """
        cdef ByteTag tag = self.tag
        return tag

    @property
    def short(self) -> ShortTag:
        """Get the tag if it is a ShortTag.

        :return: The ShortTag.
        :raises: TypeError if the stored type is not a ShortTag
        """
        cdef ShortTag tag = self.tag
        return tag

    @property
    def int(self) -> IntTag:
        """Get the tag if it is a IntTag.

        :return: The IntTag.
        :raises: TypeError if the stored type is not a IntTag
        """
        cdef IntTag tag = self.tag
        return tag

    @property
    def long(self) -> LongTag:
        """Get the tag if it is a LongTag.

        :return: The LongTag.
        :raises: TypeError if the stored type is not a LongTag
        """
        cdef LongTag tag = self.tag
        return tag

    @property
    def float(self) -> FloatTag:
        """Get the tag if it is a FloatTag.

        :return: The FloatTag.
        :raises: TypeError if the stored type is not a FloatTag
        """
        cdef FloatTag tag = self.tag
        return tag

    @property
    def double(self) -> DoubleTag:
        """Get the tag if it is a DoubleTag.

        :return: The DoubleTag.
        :raises: TypeError if the stored type is not a DoubleTag
        """
        cdef DoubleTag tag = self.tag
        return tag

    @property
    def string(self) -> StringTag:
        """Get the tag if it is a StringTag.

        :return: The StringTag.
        :raises: TypeError if the stored type is not a StringTag
        """
        cdef StringTag tag = self.tag
        return tag

    @property
    def list(self) -> ListTag:
        """Get the tag if it is a ListTag.

        :return: The ListTag.
        :raises: TypeError if the stored type is not a ListTag
        """
        cdef ListTag tag = self.tag
        return tag

    @property
    def compound(self) -> CompoundTag:
        """Get the tag if it is a CompoundTag.

        :return: The CompoundTag.
        :raises: TypeError if the stored type is not a CompoundTag
        """
        cdef CompoundTag tag = self.tag
        return tag

    @property
    def byte_array(self) -> ByteArrayTag:
        """Get the tag if it is a ByteArrayTag.

        :return: The ByteArrayTag.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """
        cdef ByteArrayTag tag = self.tag
        return tag

    @property
    def int_array(self) -> IntArrayTag:
        """Get the tag if it is a IntArrayTag.

        :return: The IntArrayTag.
        :raises: TypeError if the stored type is not a IntArrayTag
        """
        cdef IntArrayTag tag = self.tag
        return tag

    @property
    def long_array(self) -> LongArrayTag:
        """Get the tag if it is a LongArrayTag.

        :return: The LongArrayTag.
        :raises: TypeError if the stored type is not a LongArrayTag
        """
        cdef LongArrayTag tag = self.tag
        return tag

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
        return self.tag.to_snbt(indent=indent, indent_chr=indent_chr)

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
    ) -> bytes:
        return self.tag.to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            string_encoder=string_encoder,
            name = self.name,
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *args,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = encode_modified_utf8,
    ) -> bytes:
        if args:
            raise TypeError(f"save_to() takes 1 to 2 positional arguments but {2+len(args)} were given")
        return self.tag.save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            string_encoder=string_encoder,
            name=self.name,
        )

    def __eq__(self, other):
        if isinstance(other, NamedTag):
            return self.name == other.name and self.tag == other.tag
        return NotImplemented

    def __repr__(self):
        return f'NamedTag({repr(self.tag)}, "{self.name}")'

    def __getitem__(self, object item):
        if isinstance(item, int):
            return (self.name, self.tag)[item]
        elif isinstance(item, str):
            warnings.warn("The behaviour of __getitem__ is changing to make NamedTag behave like a named tuple. access the tag to get the same behaviour", DeprecationWarning)
            return self.compound[item]
        else:
            raise TypeError("Item must be an int")

    # def __getitem__(self, int item):
    #     return (self.name, self.tag)[item]

    def __iter__(self):
        yield self.name
        yield self.tag
