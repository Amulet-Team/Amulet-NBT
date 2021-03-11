from __future__ import annotations

from typing import (
    TYPE_CHECKING,
    Any,
    ClassVar,
    BinaryIO,
    Union,
    List,
    overload,
    Iterator,
    Iterable,
    Optional,
)
from collections.abc import Sequence
import numpy as np

from amulet_nbt.amulet_nbt_py.const import SNBTType

from .value import TAG_Value
from . import class_map
from ..const import TAG_BYTE, CommaSpace, CommaNewline
from .int import TAG_Int

if TYPE_CHECKING:
    from . import AnyNBT

NBTListType = List["AnyNBT"]


class TAG_List(TAG_Value):
    tag_id: ClassVar[int] = 9
    _value: NBTListType
    _data_type: ClassVar = list

    def __init__(
        self,
        value: Union[NBTListType, TAG_List, None] = None,
        list_data_type: int = TAG_BYTE,
    ):
        self.list_data_type = list_data_type
        super().__init__(value)

    def _sanitise_value(self, value: Optional[Any]) -> Any:
        self._value = self._data_type()
        if value:
            if isinstance(value, TAG_Value):
                value = value.value
            value = self._data_type(value)
            self._check_tag_iterable(value)
        else:
            value = self._value
        return value

    def _check_tag(self, value: TAG_Value, fix_if_empty=True):
        """Check the format of value is correct.

        :param value: The value to check
        :param fix_if_empty: If true and the internal list is empty the internal data type will be set to that of value.
        :return:
        """
        if not isinstance(value, TAG_Value):
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List. Must be an NBT object."
            )
        if fix_if_empty and not self._value:
            self.list_data_type = value.tag_id
        if value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List({class_map.TAG_CLASSES[self.list_data_type].__name__})"
            )

    def _check_tag_iterable(self, value: Sequence[TAG_Value]):
        if value:
            self._check_tag(value[0])
            for tag in value[1:]:
                self._check_tag(tag, False)

    @classmethod
    def load_from(cls, context: BinaryIO, little_endian: bool) -> TAG_List:
        value = []
        list_data_type = context.read(1)[0]

        if little_endian:
            (list_len,) = TAG_Int.tag_format_le.unpack(
                context.read(TAG_Int.tag_format_le.size)
            )
        else:
            (list_len,) = TAG_Int.tag_format_be.unpack(
                context.read(TAG_Int.tag_format_be.size)
            )

        for i in range(list_len):
            child_tag = class_map.TAG_CLASSES[list_data_type].load_from(
                context, little_endian
            )
            value.append(child_tag)

        return cls(value, list_data_type)

    def write_value(self, buffer: BinaryIO, little_endian=False):
        buffer.write(bytes((self.list_data_type,)))
        if little_endian:
            buffer.write(TAG_Int.tag_format_le.pack(len(self._value)))
        else:
            buffer.write(TAG_Int.tag_format_be.pack(len(self._value)))

        for item in self._value:
            item.write_value(buffer, little_endian)

    def _to_snbt(self) -> SNBTType:
        return f"[{CommaSpace.join(elem._to_snbt() for elem in self._value)}]"

    def _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        if self._value:
            return f"{indent_chr * indent_count * leading_indent}[\n{CommaNewline.join(elem._pretty_to_snbt(indent_chr, indent_count + 1) for elem in self._value)}\n{indent_chr * indent_count}]"
        else:
            return f"{indent_chr * indent_count * leading_indent}[]"

    def __eq__(self, other):
        if (
            isinstance(other, TAG_List)
            and self._value
            and self.list_data_type != other.list_data_type
        ):
            return False
        return self._value.__eq__(self.get_primitive(other))

    def __add__(self, other):
        other = self.get_primitive(other)
        self._check_tag_iterable(other)
        return TAG_List(self._value.__add__(other), self.list_data_type)

    def __radd__(self, other):
        other = self.get_primitive(other)
        self._check_tag_iterable(other)
        return TAG_List(other + self._value, self.list_data_type)

    def __contains__(self, item: AnyNBT) -> bool:
        return self._value.__contains__(item)

    def __delitem__(self, item: int):
        self._value.__delitem__(item)

    @overload
    def __getitem__(self, item: int) -> AnyNBT:
        ...

    @overload
    def __getitem__(self, item: slice) -> Iterable[AnyNBT]:
        ...

    def __getitem__(self, item):
        return self._value.__getitem__(item)

    def __iadd__(self, other):
        self.extend(other)
        return self

    def __imul__(self, other):
        other = self.get_primitive(other)
        if isinstance(other, (int, np.integer)):
            self._value.__imul__(int(other))
            return self
        return NotImplemented

    def __iter__(self) -> Iterator[AnyNBT]:
        return self._value.__iter__()

    def __len__(self) -> int:
        return self._value.__len__()

    def __mul__(self, other):
        other = self.get_primitive(other)
        if isinstance(other, (int, np.integer)):
            return TAG_List(self._value.__mul__(int(other)), self.list_data_type)
        return NotImplemented

    def __rmul__(self, other):
        return self.__mul__(other)

    @overload
    def __setitem__(self, item: int, value: AnyNBT):
        ...

    @overload
    def __setitem__(self, item: slice, value: Iterable[AnyNBT]):
        ...

    def __setitem__(self, item, value):
        if isinstance(item, slice):
            self._check_tag_iterable(value)
        else:
            self._check_tag(value)
        self._value.__setitem__(item, value)

    def append(self, value: AnyNBT) -> None:
        self._check_tag(value)
        self._value.append(value)

    def copy(self):
        return TAG_List(self._value.copy(), self.list_data_type)

    def extend(self, other):
        other = self.get_primitive(other)
        self._check_tag_iterable(other)
        self._value.extend(other)
        return self

    def insert(self, index: int, value: AnyNBT):
        self._check_tag(value)
        self._value.insert(index, value)
