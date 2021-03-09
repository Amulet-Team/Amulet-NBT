from __future__ import annotations

from typing import (
    TYPE_CHECKING,
    Any,
    ClassVar,
    BinaryIO,
    Union,
)
from struct import Struct
from copy import deepcopy, copy

from amulet_nbt.amulet_nbt_py.const import SNBTType

if TYPE_CHECKING:
    from . import AnyNBT

_string_len_fmt_be = Struct(">H")
_string_len_fmt_le = Struct("<H")


class TAG_Value:
    _value: Any
    tag_id: ClassVar[int] = None
    _data_type: ClassVar = None

    def __init__(self, value=None):
        if self.__class__ is TAG_Value:
            raise TypeError(
                "TAG_Value cannot be directly instanced. Use one of its subclasses."
            )
        assert isinstance(self.tag_id, int), f"tag_id not set for {self.__class__}"
        assert self._data_type is not None, f"_data_type not set for {self.__class__}"
        if value is None:
            value = self._data_type()
        self._value = self._data_type(value)

    @property
    def value(self) -> Any:
        """The raw data stored in the object."""
        return self._value

    @classmethod
    def load_from(cls, context: BinaryIO, little_endian: bool) -> AnyNBT:
        """Load binary NBT from a file like object."""
        raise NotImplementedError

    @staticmethod
    def load_string(context: BinaryIO, little_endian=False) -> str:
        """A helper method to load a string from a file like object."""
        data = context.read(2)
        if little_endian:
            str_len = _string_len_fmt_le.unpack(data)[0]
        else:
            str_len = _string_len_fmt_be.unpack(data)[0]
        return context.read(str_len).decode("utf-8")

    def write_payload(self, buffer: BinaryIO, name="", little_endian=False):
        """Write the tag id, name and value to a file like object."""
        self.write_tag_id(buffer)
        self.write_string(buffer, name, little_endian)
        self.write_value(buffer, little_endian)

    def write_tag_id(self, buffer: BinaryIO):
        """Write the current class's tag id to the file like object."""
        buffer.write(bytes((self.tag_id,)))

    @staticmethod
    def write_string(buffer: BinaryIO, _str, little_endian=False):
        """Write a string to a file like object."""
        encoded_str = _str.encode("utf-8")
        if little_endian:
            buffer.write(_string_len_fmt_le.pack(len(encoded_str)))
        else:
            buffer.write(_string_len_fmt_be.pack(len(encoded_str)))
        buffer.write(encoded_str)

    def write_value(self, buffer: BinaryIO, little_endian=False):
        """Write the value to a file like object."""
        raise NotImplementedError

    def to_snbt(self, indent_chr: Union[str, int, None] = None) -> SNBTType:
        """Return the NBT data in Stringified NBT format."""
        if isinstance(indent_chr, int):
            return self._pretty_to_snbt(" " * indent_chr)
        elif isinstance(indent_chr, str):
            return self._pretty_to_snbt(indent_chr)
        return self._to_snbt()

    def _to_snbt(self) -> SNBTType:
        """Internal method to format the class data as SNBT."""
        raise NotImplementedError

    def _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        """Internal method to format the class data as SNBT with indentation."""
        return f"{indent_chr * indent_count * leading_indent}{self._to_snbt()}"

    def __repr__(self):
        return self._to_snbt()

    def __eq__(self, other):
        return self._value == self.get_primitive(other)

    def strict_equals(self, other):
        """Extension of equals that also compares types."""
        return type(self) is type(other) and self == other

    @staticmethod
    def get_primitive(obj):
        """Get the primitive object of the data.
        If obj is an instance of TAG_Value then obj.value is used.
        Else obj is returned."""
        return obj.value if isinstance(obj, TAG_Value) else obj

    def __deepcopy__(self, memo=None):
        return self.__class__(deepcopy(self._value, memo=memo))

    def __copy__(self):
        return self.__class__(copy(self._value))
