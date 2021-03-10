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

from amulet_nbt.amulet_nbt_py.const import SNBTType

from .value import TAG_Value
from . import class_map
from ..const import TAG_BYTE, CommaSpace, CommaNewline
from .int import TAG_Int

if TYPE_CHECKING:
    from . import AnyNBT


class TAG_List(TAG_Value):
    tag_id: ClassVar[int] = 9
    _value: List[AnyNBT]
    _data_type: ClassVar = list

    def __init__(
        self,
        value: Union[List[AnyNBT], TAG_List, None] = None,
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
            self._check_tag(value[0])
            self._value = value
            for tag in value[1:]:
                self._check_tag(tag)
        return self._value

    def _check_tag(self, value: TAG_Value):
        if not isinstance(value, TAG_Value):
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List. Must be an NBT object."
            )
        if not self._value:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List({class_map.TAG_CLASSES[self.list_data_type].__name__})"
            )

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

    def __getitem__(self, index: int) -> AnyNBT:
        return self._value[index]

    @overload
    def __setitem__(self, index: int, value: AnyNBT):
        ...

    @overload
    def __setitem__(self, index: slice, value: Iterable[AnyNBT]):
        ...

    def __setitem__(self, index, value):
        if isinstance(index, slice):
            map(self._check_tag, value)
        else:
            self._check_tag(value)
        self._value[index] = value

    def __delitem__(self, index: int):
        del self._value[index]

    def __iter__(self) -> Iterator[AnyNBT]:
        return iter(self._value)

    def __contains__(self, item: AnyNBT) -> bool:
        return item in self._value

    def __len__(self) -> int:
        return len(self._value)

    def insert(self, index: int, value: AnyNBT):
        self._check_tag(value)
        self._value.insert(index, value)

    def append(self, value: AnyNBT) -> None:
        self._check_tag(value)
        self._value.append(value)
