from collections.abc import MutableMapping
from .value import BaseMutableTag, BaseTag
from .const import ID_COMPOUND, CommaSpace


cdef class _TAG_Compound(BaseMutableTag):
    tag_id = ID_COMPOUND
    cdef public dict value

    def __init__(self, value = None):
        self.value = value or {}
        for key, value in self.value.items():
            self._check_entry(key, value)

    @staticmethod
    def _check_entry(key: str, value: AnyNBT):
        if not isinstance(key, str):
            raise TypeError(
                f"TAG_Compound key must be a string. Got {key.__class__.__name__}"
            )
        if not isinstance(value, BaseTag):
            raise TypeError(
                f"Invalid type {value.__class__.__name__} for key \"{key}\" in TAG_Compound. Must be an NBT object."
            )

    cdef str _to_snbt(self):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name, elem in self.value.items():
            if _NON_QUOTED_KEY.match(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f'{name}: {elem.to_snbt()}')
        return f"{{{CommaSpace.join(tags)}}}"

    cdef str _pretty_to_snbt(self, indent_chr="", indent_count=0, leading_indent=True):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name, elem in self.value.items():
            tags.append(f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}')
        if tags:
            return f"{indent_chr * indent_count * leading_indent}{{\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{}}"

    cdef void write_payload(self, buffer, little_endian) except *:
        cdef str key
        cdef BaseTag stag

        for key, stag in self.value.items():
            write_tag_id(stag.tag_id, buffer)
            write_string(key, buffer, little_endian)
            stag.write_payload(buffer, little_endian)
        write_tag_id(ID_END, buffer)

    def write_payload(self, buffer, name="", little_endian=False):
        write_tag_id(self.tag_id, buffer)
        write_string(name, buffer, little_endian)
        self.write_payload(buffer, little_endian)

    def __getitem__(self, key: str) -> AnyNBT:
        return self.value[key]

    def __setitem__(self, key: str, value: AnyNBT):
        self._check_entry(key, value)
        self.value[key] = value

    def __delitem__(self, key: str):
        del self.value[key]

    def __iter__(self) -> Iterator[AnyNBT]:
        yield from self.value

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __len__(self) -> int:
        return self.value.__len__()


class TAG_Compound(_TAG_Compound, MutableMapping):
    pass
