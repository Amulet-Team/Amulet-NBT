from typing import Type, TypeVar
import warnings

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
from ._list import ListTag
from ._compound import CompoundTag
from ._dtype import EncoderType, AnyNBT
from ._util import utf8_encoder


T = TypeVar("T")


cdef class NamedTag(AbstractBase):
    def __init__(self, AbstractBaseTag tag = None, str name not None = ""):
        if tag is None:
            self._tag = CompoundTag()
        else:
            self._tag = tag
        self._name = name

    @property
    def tag(self) -> AbstractBaseTag:
        return self._tag

    if __major__ <= 2:
        @tag.setter
        def tag(self, AbstractBaseTag tag):
            warnings.warn("NamedTag.tag setter is depreciated. In the future tag will be immutable.", DeprecationWarning)
            self._tag = tag

    @property
    def name(self) -> str:
        return self._name

    if __major__ <= 2:
        @name.setter
        def name(self, str name):
            warnings.warn("NamedTag.name setter is depreciated. In the future name will be immutable.", DeprecationWarning)
            self._name = name

    if __major__ <= 2:
        @property
        def value(self):
            warnings.warn("value property is depreciated. Use tag attribute instead.", DeprecationWarning)
            return self.tag

        @value.setter
        def value(self, AbstractBaseTag value):
            warnings.warn("value property is depreciated.", DeprecationWarning)
            self.tag = value

    def _get_tag(self, t: Type[T]) -> T:
        if not isinstance(self.tag, t):
            raise TypeError(f"Expected tag to be of type {t} but got {type(self.tag)}")
        return self.tag

    def get_byte(self) -> ByteTag:
        return self._get_tag(ByteTag)

    def get_short(self) -> ShortTag:
        return self._get_tag(ShortTag)

    def get_int(self) -> IntTag:
        return self._get_tag(IntTag)

    def get_long(self) -> LongTag:
        return self._get_tag(LongTag)

    def get_float(self) -> FloatTag:
        return self._get_tag(FloatTag)

    def get_double(self) -> DoubleTag:
        return self._get_tag(DoubleTag)

    def get_string(self) -> StringTag:
        return self._get_tag(StringTag)

    def get_list(self) -> ListTag:
        return self._get_tag(ListTag)

    def get_compound(self) -> CompoundTag:
        return self._get_tag(CompoundTag)

    def get_byte_array(self) -> ByteArrayTag:
        return self._get_tag(ByteArrayTag)

    def get_int_array(self) -> IntArrayTag:
        return self._get_tag(IntArrayTag)

    def get_long_array(self) -> LongArrayTag:
        return self._get_tag(LongArrayTag)

    cpdef str to_snbt(self, object indent=None, object indent_chr=None):
        return self.tag.to_snbt(indent=indent, indent_chr=indent_chr)

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        string_encoder: EncoderType = utf8_encoder,
    ):
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
        string_encoder: EncoderType = utf8_encoder,
    ):
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

    if __major__ >= 3:
        def __iter__(self):
            yield self.name
            yield self.tag

        def __getitem__(self, int item):
            return (self.name, self.tag)[item]
    else:
        def __len__(self) -> int:
            warnings.warn("len on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return len(self.get_compound())

        def keys(self):
            warnings.warn("keys on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return self.get_compound().keys()

        def values(self):
            warnings.warn("values on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            self.get_compound().values()

        def items(self):
            warnings.warn("items on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return self.get_compound().items()

        def __getitem__(self, key: str) -> AnyNBT:
            warnings.warn("The behaviour of __getitem__ is changing to make NamedTag behave like a named tuple. access the tag to get the same behaviour", FutureWarning)
            return self.get_compound()[key]

        def __setitem__(self, key: str, tag: AnyNBT):
            warnings.warn("setitem on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            self.get_compound()[key] = tag

        def __delitem__(self, key: str):
            warnings.warn("delitem on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            del self.get_compound()[key]

        def __contains__(self, key: str) -> bool:
            warnings.warn("contains on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return key in self.get_compound()

        def pop(self, k, default=None) -> AnyNBT:
            warnings.warn("pop on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return self.get_compound().pop(k, default)

        def get(self, k, default=None) -> AnyNBT:
            warnings.warn("get on NamedTag is depreciated. access the tag to get the same behaviour", DeprecationWarning)
            return self.get_compound().get(k, default)
