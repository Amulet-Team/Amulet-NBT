from typing import Type, TypeVar
import warnings

from mutf8 import encode_modified_utf8

from . import __major__
from ._value cimport AbstractBaseTag, AbstractBase
from ._int cimport (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)
from ._float cimport (
    FloatTag,
    DoubleTag,
)
from ._array cimport (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)
from ._string cimport StringTag
from ._list cimport CyListTag
from ._compound cimport CyCompoundTag
from ._dtype import EncoderType, AnyNBT
{{py:from template import include}}


T = TypeVar("T")


cdef class NamedTag(AbstractBase):
    def __init__(self, AbstractBaseTag tag = None, str name not None = ""):
        if tag is None:
            self.tag = CyCompoundTag.create()
        else:
            self.tag = tag
        self.name = name

    if __major__ <= 2:
        @property
        def value(self):
            """Legacy property to get the tag. Depreciated. Use :attr:`tag` or get_{type} instead."""
            warnings.warn("value property is depreciated. Use tag attribute instead.", DeprecationWarning)
            return self.tag

        @value.setter
        def value(self, AbstractBaseTag value):
            warnings.warn("value property is depreciated.", DeprecationWarning)
            self.tag = value

{{include("NamedTagGet.pyx", tag_cls_name="ByteTag", tag_name="byte")}}
{{include("NamedTagGet.pyx", tag_cls_name="ShortTag", tag_name="short")}}
{{include("NamedTagGet.pyx", tag_cls_name="IntTag", tag_name="int")}}
{{include("NamedTagGet.pyx", tag_cls_name="LongTag", tag_name="long")}}
{{include("NamedTagGet.pyx", tag_cls_name="FloatTag", tag_name="float")}}
{{include("NamedTagGet.pyx", tag_cls_name="DoubleTag", tag_name="double")}}
{{include("NamedTagGet.pyx", tag_cls_name="StringTag", tag_name="string")}}
{{include("NamedTagGet.pyx", tag_cls_name="CyListTag", tag_name="list")}}
{{include("NamedTagGet.pyx", tag_cls_name="CyCompoundTag", tag_name="compound")}}
{{include("NamedTagGet.pyx", tag_cls_name="ByteArrayTag", tag_name="byte_array")}}
{{include("NamedTagGet.pyx", tag_cls_name="IntArrayTag", tag_name="int_array")}}
{{include("NamedTagGet.pyx", tag_cls_name="LongArrayTag", tag_name="long_array")}}
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
            if __major__ <= 2:
                warnings.warn("save_to arguments are going to become keyword only", FutureWarning)
                compressed, *args = args
                if args:
                    little_endian, *args = args
            else:
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

    if __major__ >= 3:
        def __iter__(self):
            yield self.name
            yield self.tag

    else:
        def __iter__(self):
            warnings.warn("iter behaviour on NamedTag is changing. Use the compound property to implement the same behaviour.", FutureWarning)
            yield from self.compound

        def __len__(self) -> int:
            """Depreciated. Do not use."""
            warnings.warn("len on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return len(self.compound)

        def keys(self):
            """Depreciated. Do not use."""
            warnings.warn("keys on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return self.compound.keys()

        def values(self):
            """Depreciated. Do not use."""
            warnings.warn("values on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            self.compound.values()

        def items(self):
            """Depreciated. Do not use."""
            warnings.warn("items on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return self.compound.items()

        def __setitem__(self, key: str, tag: AnyNBT):
            """Depreciated. Do not use."""
            warnings.warn("setitem on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            self.compound[key] = tag

        def __delitem__(self, key: str):
            """Depreciated. Do not use."""
            warnings.warn("delitem on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            del self.compound[key]

        def __contains__(self, key: str) -> bool:
            """Depreciated. Do not use."""
            warnings.warn("contains on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return key in self.compound

        def pop(self, k, default=None) -> AnyNBT:
            """Depreciated. Do not use."""
            warnings.warn("pop on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return self.compound.pop(k, default)

        def get(self, k, default=None) -> AnyNBT:
            """Depreciated. Do not use."""
            warnings.warn("get on NamedTag is depreciated. Use the compound property to implement the same behaviour.", DeprecationWarning)
            return self.compound.get(k, default)
