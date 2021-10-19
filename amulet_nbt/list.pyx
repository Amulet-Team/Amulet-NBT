from collections.abc import MutableSequence
from .value import BaseMutableTag
from .const import ID_LIST


cdef class _TAG_List(BaseMutableTag):
    tag_id = ID_LIST
    cdef public list value
    cdef public char list_data_type

    def __init__(self, value = None, char list_data_type = 1):
        self.list_data_type = list_data_type
        self.value = []
        if value:
            self._check_tag_iterable(value)
            self.value = list(value)

    def _check_tag(self, value: AnyNBT, fix_if_empty=True):
        if not isinstance(value, BaseTag):
            raise TypeError(f"Invalid type {value.__class__.__name__} TAG_List. Must be an NBT object.")
        if fix_if_empty and not self.value:
            self.list_data_type = value.tag_id
        elif value.tag_id != self.list_data_type:
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for TAG_List({TAG_CLASSES[self.list_data_type].__name__})"
            )

    def _check_tag_iterable(self, value: Sequence[BaseTag]):
        for i, tag in enumerate(value):
            self._check_tag(tag, not i)

    cdef void write_payload(self, buffer, little_endian) except *:
        cdef char list_type = self.list_data_type

        write_tag_id(list_type, buffer)
        write_int(<int> len(self.value), buffer, little_endian)

        cdef BaseTag subtag
        for subtag in self.value:
            if subtag.tag_id != list_type:
                raise ValueError("Asked to save TAG_List with different types! Found %s and %s" % (subtag.tag_id,
                                                                                                   list_type))
            subtag.write_payload(buffer, little_endian)

    cdef str _to_snbt(self):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self.value:
            tags.append(elem._to_snbt())
        return f"[{CommaSpace.join(tags)}]"

    cdef str _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        cdef BaseTag elem
        cdef list tags = []
        for elem in self.value:
            tags.append(elem._pretty_to_snbt(indent_chr, indent_count + 1))
        if tags:
            return f"{indent_chr * indent_count * leading_indent}[\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}]"
        else:
            return f"{indent_chr * indent_count * leading_indent}[]"

    def __contains__(self, item: AnyNBT) -> bool:
        return self.value.__contains__(item)

    def __iter__(self) -> Iterator[AnyNBT]:
        return self.value.__iter__()

    def __len__(self) -> int:
        return self.value.__len__()

    def __getitem__(self, index: int) -> AnyNBT:
        return self.value[index]

    def __setitem__(self, index, value):
        if isinstance(index, slice):
            self._check_tag_iterable(value)
        else:
            self._check_tag(value)
        self.value[index] = value

    def __delitem__(self, index: int):
        del self.value[index]

    def append(self, value: AnyNBT) -> None:
        self._check_tag(value)
        self.value.append(value)

    def copy(self):
        return TAG_List(self.value.copy(), self.list_data_type)

    def extend(self, other):
        self._check_tag_iterable(other)
        self.value.extend(other)
        return self

    def insert(self, index: int, value: AnyNBT):
        self._check_tag(value)
        self.value.insert(index, value)

    def __mul__(self, other):
        return self.value * other

    def __rmul__(self, other):
        return other * self.value

    def __imul__(self, other):
        self.value *= other
        return self

    def __eq__(self, other):
        if (
                isinstance(other, TAG_List)
                and self.value
                and self.list_data_type != other.list_data_type
        ):
            return False
        return self.value == other

    def __add__(self, other):
        return self.value + other

    def __radd__(self, other):
        return other + self.value

    def __iadd__(self, other):
        self.extend(other)
        return self


class TAG_List(_TAG_List, MutableSequence):
    pass
