from __future__ import annotations
from typing import TYPE_CHECKING
import logging as _logging
import re

from . import _version

# init a default logger
_logging.basicConfig(level=_logging.INFO, format="%(levelname)s - %(message)s")

if TYPE_CHECKING:
    from typing import (
        Any,
        SupportsInt,
        SupportsFloat,
        Iterator,
        Iterable,
        overload,
        TypeVar,
        Self,
        Type,
        Mapping,
        Literal,
        TypeAlias,
        ClassVar,
        Protocol,
    )
    from collections.abc import MutableSequence, MutableMapping
    import numpy
    from numpy.typing import NDArray, ArrayLike

    _T = TypeVar("_T")

    class _Readable(Protocol):
        def read(self) -> bytes: ...

    class _Writeable(Protocol):
        def write(self, s: bytes) -> Any: ...

    class StringEncoding:
        def encode(self, data: bytes) -> bytes: ...

        def decode(self, data: bytes) -> bytes: ...

    mutf8_encoding: StringEncoding
    utf8_encoding: StringEncoding
    utf8_escape_encoding: StringEncoding

    class EncodingPreset:
        pass

    java_encoding: EncodingPreset
    bedrock_encoding: EncodingPreset

    class AbstractBaseTag:
        """Abstract Base Class for all Tag classes"""

        tag_id: ClassVar[int]

        @property
        def py_data(self) -> Any:
            """A python representation of the class. Note that the return type is undefined and may change in the future.

            You would be better off using the py_{type} or np_array properties if you require a fixed type.
            This is here for convenience to get a python representation under the same property name.
            """

        def to_nbt(
            self,
            *,
            preset: EncodingPreset | None = None,
            compressed: bool = True,
            little_endian: bool = False,
            string_encoding: StringEncoding = mutf8_encoding,
            name: str | bytes | None = b"",
        ) -> bytes:
            """Get the data in binary NBT format.

            :param preset: A class containing endianness and encoding presets.
            :param compressed: Should the bytes be compressed with gzip.
            :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
            :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
            :param name: The root tag name, or `None` for unnamed tag.
            :return: The binary NBT representation of the class.
            """

        def save_to(
            self,
            filepath_or_buffer: str | _Writeable | None = None,
            *,
            preset: EncodingPreset | None = None,
            compressed: bool = True,
            little_endian: bool = False,
            string_encoding: StringEncoding = mutf8_encoding,
            name: str | bytes | None = b"",
        ) -> bytes:
            """Convert the data to the binary NBT format. Optionally write to a file.

            If filepath_or_buffer is a valid file path in string form the data will be written to that file.

            If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

            :param filepath_or_buffer: A path or writeable object to write the data to.
            :param preset: A class containing endianness and encoding presets.
            :param compressed: Should the bytes be compressed with gzip.
            :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
            :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
            :param name: The root tag name, or `None` for unnamed tag.
            :return: The binary NBT representation of the class.
            """

        def to_snbt(self, indent: None | str | int = None) -> str:
            """Convert the data to the Stringified NBT format.

            :param indent:
                If None (the default) the SNBT will be on one line.
                If an int will be multi-line SNBT with this many spaces per indentation.
                If a string will be multi-line SNBT with this string as the indentation.
            :return: The SNBT string.
            """

        def __eq__(self, other: Any) -> bool:
            """Check if the instance is equal to another instance.

            This will only return True if the tag type is the same and the data contained is the same.

            >>> from amulet.nbt import ByteTag, ShortTag
            >>> tag1 = ByteTag(1)
            >>> tag2 = ByteTag(2)
            >>> tag3 = ShortTag(1)
            >>> tag1 == tag1  # True
            >>> tag1 == tag2  # False
            >>> tag1 == tag3  # False
            """

        def __repr__(self) -> str:
            """A string representation of the object to show how it can be constructed.

            >>> from amulet.nbt import ByteTag
            >>> tag = ByteTag(1)
            >>> repr(tag)  # "ByteTag(1)"
            """

        def __str__(self) -> str:
            """A string representation of the object."""

        def __reduce__(self) -> Any: ...

        def copy(self) -> Self:
            """Return a shallow copy of the class"""

        def __copy__(self) -> Self:
            """A shallow copy of the class

            >>> import copy
            >>> from amulet.nbt import ListTag
            >>> tag = ListTag()
            >>> tag2 = copy.copy(tag)
            """

        def __deepcopy__(self, memo: dict[int, object] | None = None) -> Self:
            """A deep copy of the class

            >>> import copy
            >>> from amulet.nbt import ListTag
            >>> tag = ListTag()
            >>> tag2 = copy.deepcopy(tag)
            """

    class AbstractBaseImmutableTag(AbstractBaseTag):
        """Abstract Base Class for all immutable Tag classes"""

        def __hash__(self) -> int:
            """A hash of the data in the class."""

    class AbstractBaseMutableTag(AbstractBaseTag):
        """Abstract Base Class for all mutable Tag classes"""

        __hash__ = None  # type: ignore

    class AbstractBaseNumericTag(AbstractBaseImmutableTag):
        """Abstract Base Class for all numeric Tag classes"""

        def __int__(self) -> int:
            """Get a python int representation of the class."""

        def __float__(self) -> float:
            """Get a python float representation of the class."""

        def __bool__(self) -> bool:
            """Get a python bool representation of the class."""

        def __ge__(self, other: Any) -> bool:
            """Check if the tag is greater than or equal to another tag."""

        def __gt__(self, other: Any) -> bool:
            """Check if the tag is greater than another tag."""

        def __le__(self, other: Any) -> bool:
            """Check if the tag is less than or equal to another tag."""

        def __lt__(self, other: Any) -> bool:
            """Check if the tag is less than another tag."""

    # Types
    class AbstractBaseIntTag(AbstractBaseNumericTag):
        def __init__(self, value: SupportsInt = 0) -> None: ...

        @property
        def py_int(self) -> int:
            """A python int representation of the class.

            The returned data is immutable so changes will not mirror the instance.
            """

    class ByteTag(AbstractBaseIntTag):
        """
        A 1 byte integer class.
        Can Store numbers between -(2^7) and (2^7 - 1)
        """

    class ShortTag(AbstractBaseIntTag):
        """
        A 2 byte integer class.
        Can Store numbers between -(2^15) and (2^15 - 1)
        """

    class IntTag(AbstractBaseIntTag):
        """
        A 4 byte integer class.
        Can Store numbers between -(2^31) and (2^31 - 1)
        """

    class LongTag(AbstractBaseIntTag):
        """
        An 8 byte integer class.
        Can Store numbers between -(2^63) and (2^63 - 1)
        """

    class AbstractBaseFloatTag(AbstractBaseNumericTag):
        def __init__(self, value: SupportsFloat = 0): ...

        @property
        def py_float(self) -> float:
            """A python float representation of the class.

            The returned data is immutable so changes will not mirror the instance.
            """

    class FloatTag(AbstractBaseFloatTag):
        """A single precision float class."""

    class DoubleTag(AbstractBaseFloatTag):
        """A double precision float class."""

    class StringTag(AbstractBaseImmutableTag):
        def __init__(self, value: str | bytes | Any = "") -> None: ...

        @property
        def py_str(self) -> str:
            """The data stored in the class as a python string.

            In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError.
            """

        @property
        def py_bytes(self) -> bytes:
            """The bytes stored in the class."""

        @property
        def py_str_or_bytes(self) -> str | bytes:
            """If the payload is UTF-8 returns a string else returns bytes."""

        def __ge__(self, other: Any) -> bool:
            """Check if the tag is greater than or equal to another tag."""

        def __gt__(self, other: Any) -> bool:
            """Check if the tag is greater than another tag."""

        def __le__(self, other: Any) -> bool:
            """Check if the tag is less than or equal to another tag."""

        def __lt__(self, other: Any) -> bool:
            """Check if the tag is less than another tag."""

    AnyNBTT = TypeVar("AnyNBTT", bound=AbstractBaseTag)

    class ListTag(AbstractBaseMutableTag, MutableSequence[AnyNBTT]):
        @overload
        def __init__(self, value: Iterable[AnyNBTT] = ()) -> None: ...

        @overload
        def __init__(
            self, value: Iterable[AnyNBTT] = (), element_tag_id: int = 1
        ) -> None: ...

        @property
        def py_list(self) -> list[AnyNBTT]:
            """A python list representation of the class.

            The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
            Use the public API to modify the internal data.
            """

        @property
        def element_tag_id(self) -> int:
            """The numerical id of the element type in this list.

            Will be an int in the range 0-12.
            """

        @property
        def element_class(
            self,
        ) -> (
            None
            | Type[ByteTag]
            | Type[ShortTag]
            | Type[IntTag]
            | Type[LongTag]
            | Type[FloatTag]
            | Type[DoubleTag]
            | Type[StringTag]
            | Type[ByteArrayTag]
            | Type[ListTag]
            | Type[CompoundTag]
            | Type[IntArrayTag]
            | Type[LongArrayTag]
        ):
            """The python class for the tag type contained in this list or None if the list tag is in the 0 state."""

        def get_byte(self, index: int) -> ByteTag: ...

        def get_short(self, index: int) -> ShortTag: ...

        def get_int(self, index: int) -> IntTag: ...

        def get_long(self, index: int) -> LongTag: ...

        def get_float(self, index: int) -> FloatTag: ...

        def get_double(self, index: int) -> DoubleTag: ...

        def get_string(self, index: int) -> StringTag: ...

        def get_list(self, index: int) -> ListTag: ...

        def get_compound(self, index: int) -> CompoundTag: ...

        def get_byte_array(self, index: int) -> ByteArrayTag: ...

        def get_int_array(self, index: int) -> IntArrayTag: ...

        def get_long_array(self, index: int) -> LongArrayTag: ...

        def insert(self, index: int, value: AnyNBTT) -> None: ...

        @overload
        def __getitem__(self, index: int) -> AnyNBTT: ...

        @overload
        def __getitem__(self, index: slice) -> list[AnyNBTT]: ...

        @overload
        def __setitem__(self, index: int, value: AnyNBTT) -> None: ...

        @overload
        def __setitem__(
            self, index: slice, value: Iterable[AbstractBaseTag]
        ) -> None: ...

        @overload
        def __delitem__(self, index: int) -> None: ...

        @overload
        def __delitem__(self, index: slice) -> None: ...

        def __len__(self) -> int:
            pass

    _TagT = TypeVar("_TagT", bound=AbstractBaseTag)

    class CompoundTag(AbstractBaseMutableTag, MutableMapping[str | bytes, AnyNBT]):
        def __init__(
            self,
            value: (
                Mapping[str | bytes, AnyNBT | AbstractBaseTag]
                | Iterable[tuple[str | bytes, AnyNBT | AbstractBaseTag]]
                | Mapping[str, AnyNBT | AbstractBaseTag]
                | Mapping[bytes, AnyNBT | AbstractBaseTag]
            ) = (),
            **kwvals: AnyNBT,
        ): ...

        @property
        def py_dict(self) -> dict[str, AnyNBT]:
            """A shallow copy of the CompoundTag as a python dictionary."""

        @overload
        def get(self, key: str | bytes) -> AnyNBT | None: ...

        @overload
        def get(self, key: str | bytes, default: _T) -> AnyNBT | _T: ...

        @overload
        def get(self, key: str | bytes, *, cls: Type[_TagT]) -> _TagT | None: ...

        @overload
        def get(self, key: str | bytes, default: _T, cls: Type[_TagT]) -> _TagT | _T:
            """Get an item from the CompoundTag.

            :param key: The key to get
            :param default: The value to return if the key does not exist or the type is wrong.
            :param cls: The class that the stored tag must inherit from. If the type is incorrect default is returned.
            :return: The tag stored in the CompoundTag if the type is correct else default.
            :raises: KeyError if the key does not exist.
            :raises: TypeError if the stored type is not a subclass of cls.
            """

        @classmethod
        def fromkeys(cls, keys: Iterable[str | bytes], value: AnyNBT) -> Self: ...

        @overload
        def get_byte(self, key: str | bytes) -> ByteTag | None: ...

        @overload
        def get_byte(self, key: str | bytes, default: None) -> ByteTag | None: ...

        @overload
        def get_byte(self, key: str | bytes, default: ByteTag) -> ByteTag: ...

        @overload
        def get_byte(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ByteTag | None: ...

        @overload
        def get_byte(
            self, key: str | bytes, default: ByteTag, raise_errors: Literal[False]
        ) -> ByteTag: ...

        @overload
        def get_byte(
            self, key: str | bytes, default: ByteTag | None, raise_errors: Literal[True]
        ) -> ByteTag: ...

        @overload
        def get_byte(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ByteTag | None: ...

        @overload
        def get_byte(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ByteTag: ...

        @overload
        def get_short(self, key: str | bytes) -> ShortTag | None: ...

        @overload
        def get_short(self, key: str | bytes, default: None) -> ShortTag | None: ...

        @overload
        def get_short(self, key: str | bytes, default: ShortTag) -> ShortTag: ...

        @overload
        def get_short(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ShortTag | None: ...

        @overload
        def get_short(
            self, key: str | bytes, default: ShortTag, raise_errors: Literal[False]
        ) -> ShortTag: ...

        @overload
        def get_short(
            self,
            key: str | bytes,
            default: ShortTag | None,
            raise_errors: Literal[True],
        ) -> ShortTag: ...

        @overload
        def get_short(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ShortTag | None: ...

        @overload
        def get_short(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ShortTag: ...

        @overload
        def get_int(self, key: str | bytes) -> IntTag | None: ...

        @overload
        def get_int(self, key: str | bytes, default: None) -> IntTag | None: ...

        @overload
        def get_int(self, key: str | bytes, default: IntTag) -> IntTag: ...

        @overload
        def get_int(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> IntTag | None: ...

        @overload
        def get_int(
            self, key: str | bytes, default: IntTag, raise_errors: Literal[False]
        ) -> IntTag: ...

        @overload
        def get_int(
            self, key: str | bytes, default: IntTag | None, raise_errors: Literal[True]
        ) -> IntTag: ...

        @overload
        def get_int(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> IntTag | None: ...

        @overload
        def get_int(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> IntTag: ...

        @overload
        def get_long(self, key: str | bytes) -> LongTag | None: ...

        @overload
        def get_long(self, key: str | bytes, default: None) -> LongTag | None: ...

        @overload
        def get_long(self, key: str | bytes, default: LongTag) -> LongTag: ...

        @overload
        def get_long(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> LongTag | None: ...

        @overload
        def get_long(
            self, key: str | bytes, default: LongTag, raise_errors: Literal[False]
        ) -> LongTag: ...

        @overload
        def get_long(
            self, key: str | bytes, default: LongTag | None, raise_errors: Literal[True]
        ) -> LongTag: ...

        @overload
        def get_long(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> LongTag | None: ...

        @overload
        def get_long(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> LongTag: ...

        @overload
        def get_float(self, key: str | bytes) -> FloatTag | None: ...

        @overload
        def get_float(self, key: str | bytes, default: None) -> FloatTag | None: ...

        @overload
        def get_float(self, key: str | bytes, default: FloatTag) -> FloatTag: ...

        @overload
        def get_float(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> FloatTag | None: ...

        @overload
        def get_float(
            self, key: str | bytes, default: FloatTag, raise_errors: Literal[False]
        ) -> FloatTag: ...

        @overload
        def get_float(
            self,
            key: str | bytes,
            default: FloatTag | None,
            raise_errors: Literal[True],
        ) -> FloatTag: ...

        @overload
        def get_float(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> FloatTag | None: ...

        @overload
        def get_float(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> FloatTag: ...

        @overload
        def get_double(self, key: str | bytes) -> DoubleTag | None: ...

        @overload
        def get_double(self, key: str | bytes, default: None) -> DoubleTag | None: ...

        @overload
        def get_double(self, key: str | bytes, default: DoubleTag) -> DoubleTag: ...

        @overload
        def get_double(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> DoubleTag | None: ...

        @overload
        def get_double(
            self, key: str | bytes, default: DoubleTag, raise_errors: Literal[False]
        ) -> DoubleTag: ...

        @overload
        def get_double(
            self,
            key: str | bytes,
            default: DoubleTag | None,
            raise_errors: Literal[True],
        ) -> DoubleTag: ...

        @overload
        def get_double(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> DoubleTag | None: ...

        @overload
        def get_double(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> DoubleTag: ...

        @overload
        def get_byte_array(self, key: str | bytes) -> ByteArrayTag | None: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, default: None
        ) -> ByteArrayTag | None: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, default: ByteArrayTag
        ) -> ByteArrayTag: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ByteArrayTag | None: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, default: ByteArrayTag, raise_errors: Literal[False]
        ) -> ByteArrayTag: ...

        @overload
        def get_byte_array(
            self,
            key: str | bytes,
            default: ByteArrayTag | None,
            raise_errors: Literal[True],
        ) -> ByteArrayTag: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ByteArrayTag | None: ...

        @overload
        def get_byte_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ByteArrayTag: ...

        @overload
        def get_string(self, key: str | bytes) -> StringTag | None: ...

        @overload
        def get_string(self, key: str | bytes, default: None) -> StringTag | None: ...

        @overload
        def get_string(self, key: str | bytes, default: StringTag) -> StringTag: ...

        @overload
        def get_string(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> StringTag | None: ...

        @overload
        def get_string(
            self, key: str | bytes, default: StringTag, raise_errors: Literal[False]
        ) -> StringTag: ...

        @overload
        def get_string(
            self,
            key: str | bytes,
            default: StringTag | None,
            raise_errors: Literal[True],
        ) -> StringTag: ...

        @overload
        def get_string(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> StringTag | None: ...

        @overload
        def get_string(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> StringTag: ...

        @overload
        def get_list(self, key: str | bytes) -> ListTag | None: ...

        @overload
        def get_list(self, key: str | bytes, default: None) -> ListTag | None: ...

        @overload
        def get_list(self, key: str | bytes, default: ListTag) -> ListTag: ...

        @overload
        def get_list(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ListTag | None: ...

        @overload
        def get_list(
            self, key: str | bytes, default: ListTag, raise_errors: Literal[False]
        ) -> ListTag: ...

        @overload
        def get_list(
            self, key: str | bytes, default: ListTag | None, raise_errors: Literal[True]
        ) -> ListTag: ...

        @overload
        def get_list(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ListTag | None: ...

        @overload
        def get_list(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ListTag: ...

        @overload
        def get_compound(self, key: str | bytes) -> CompoundTag | None: ...

        @overload
        def get_compound(
            self, key: str | bytes, default: None
        ) -> CompoundTag | None: ...

        @overload
        def get_compound(
            self, key: str | bytes, default: CompoundTag
        ) -> CompoundTag: ...

        @overload
        def get_compound(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> CompoundTag | None: ...

        @overload
        def get_compound(
            self, key: str | bytes, default: CompoundTag, raise_errors: Literal[False]
        ) -> CompoundTag: ...

        @overload
        def get_compound(
            self,
            key: str | bytes,
            default: CompoundTag | None,
            raise_errors: Literal[True],
        ) -> CompoundTag: ...

        @overload
        def get_compound(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> CompoundTag | None: ...

        @overload
        def get_compound(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> CompoundTag: ...

        @overload
        def get_int_array(self, key: str | bytes) -> IntArrayTag | None: ...

        @overload
        def get_int_array(
            self, key: str | bytes, default: None
        ) -> IntArrayTag | None: ...

        @overload
        def get_int_array(
            self, key: str | bytes, default: IntArrayTag
        ) -> IntArrayTag: ...

        @overload
        def get_int_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> IntArrayTag | None: ...

        @overload
        def get_int_array(
            self, key: str | bytes, default: IntArrayTag, raise_errors: Literal[False]
        ) -> IntArrayTag: ...

        @overload
        def get_int_array(
            self,
            key: str | bytes,
            default: IntArrayTag | None,
            raise_errors: Literal[True],
        ) -> IntArrayTag: ...

        @overload
        def get_int_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> IntArrayTag | None: ...

        @overload
        def get_int_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> IntArrayTag: ...

        @overload
        def get_long_array(self, key: str | bytes) -> LongArrayTag | None: ...

        @overload
        def get_long_array(
            self, key: str | bytes, default: None
        ) -> LongArrayTag | None: ...

        @overload
        def get_long_array(
            self, key: str | bytes, default: LongArrayTag
        ) -> LongArrayTag: ...

        @overload
        def get_long_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> LongArrayTag | None: ...

        @overload
        def get_long_array(
            self, key: str | bytes, default: LongArrayTag, raise_errors: Literal[False]
        ) -> LongArrayTag: ...

        @overload
        def get_long_array(
            self,
            key: str | bytes,
            default: LongArrayTag | None,
            raise_errors: Literal[True],
        ) -> LongArrayTag: ...

        @overload
        def get_long_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> LongArrayTag | None: ...

        @overload
        def get_long_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> LongArrayTag: ...

        def setdefault_byte(
            self, key: str | bytes, default: ByteTag | None = None
        ) -> ByteTag: ...

        def setdefault_short(
            self, key: str | bytes, default: ShortTag | None = None
        ) -> ShortTag: ...

        def setdefault_int(
            self, key: str | bytes, default: IntTag | None = None
        ) -> IntTag: ...

        def setdefault_long(
            self, key: str | bytes, default: LongTag | None = None
        ) -> LongTag: ...

        def setdefault_float(
            self, key: str | bytes, default: FloatTag | None = None
        ) -> FloatTag: ...

        def setdefault_double(
            self, key: str | bytes, default: DoubleTag | None = None
        ) -> DoubleTag: ...

        def setdefault_string(
            self, key: str | bytes, default: StringTag | None = None
        ) -> StringTag: ...

        def setdefault_list(
            self, key: str | bytes, default: ListTag | None = None
        ) -> ListTag: ...

        def setdefault_compound(
            self, key: str | bytes, default: CompoundTag | None = None
        ) -> CompoundTag: ...

        def setdefault_byte_array(
            self, key: str | bytes, default: ByteArrayTag | None = None
        ) -> ByteArrayTag: ...

        def setdefault_int_array(
            self, key: str | bytes, default: IntArrayTag | None = None
        ) -> IntArrayTag: ...

        def setdefault_long_array(
            self, key: str | bytes, default: LongArrayTag | None = None
        ) -> LongArrayTag: ...

        @overload
        def pop_byte(self, key: str | bytes) -> ByteTag | None: ...

        @overload
        def pop_byte(self, key: str | bytes, default: None) -> ByteTag | None: ...

        @overload
        def pop_byte(self, key: str | bytes, default: ByteTag) -> ByteTag: ...

        @overload
        def pop_byte(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ByteTag | None: ...

        @overload
        def pop_byte(
            self, key: str | bytes, default: ByteTag, raise_errors: Literal[False]
        ) -> ByteTag: ...

        @overload
        def pop_byte(
            self, key: str | bytes, default: ByteTag | None, raise_errors: Literal[True]
        ) -> ByteTag: ...

        @overload
        def pop_byte(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ByteTag | None: ...

        @overload
        def pop_byte(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ByteTag: ...

        @overload
        def pop_short(self, key: str | bytes) -> ShortTag | None: ...

        @overload
        def pop_short(self, key: str | bytes, default: None) -> ShortTag | None: ...

        @overload
        def pop_short(self, key: str | bytes, default: ShortTag) -> ShortTag: ...

        @overload
        def pop_short(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ShortTag | None: ...

        @overload
        def pop_short(
            self, key: str | bytes, default: ShortTag, raise_errors: Literal[False]
        ) -> ShortTag: ...

        @overload
        def pop_short(
            self,
            key: str | bytes,
            default: ShortTag | None,
            raise_errors: Literal[True],
        ) -> ShortTag: ...

        @overload
        def pop_short(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ShortTag | None: ...

        @overload
        def pop_short(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ShortTag: ...

        @overload
        def pop_int(self, key: str | bytes) -> IntTag | None: ...

        @overload
        def pop_int(self, key: str | bytes, default: None) -> IntTag | None: ...

        @overload
        def pop_int(self, key: str | bytes, default: IntTag) -> IntTag: ...

        @overload
        def pop_int(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> IntTag | None: ...

        @overload
        def pop_int(
            self, key: str | bytes, default: IntTag, raise_errors: Literal[False]
        ) -> IntTag: ...

        @overload
        def pop_int(
            self, key: str | bytes, default: IntTag | None, raise_errors: Literal[True]
        ) -> IntTag: ...

        @overload
        def pop_int(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> IntTag | None: ...

        @overload
        def pop_int(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> IntTag: ...

        @overload
        def pop_long(self, key: str | bytes) -> LongTag | None: ...

        @overload
        def pop_long(self, key: str | bytes, default: None) -> LongTag | None: ...

        @overload
        def pop_long(self, key: str | bytes, default: LongTag) -> LongTag: ...

        @overload
        def pop_long(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> LongTag | None: ...

        @overload
        def pop_long(
            self, key: str | bytes, default: LongTag, raise_errors: Literal[False]
        ) -> LongTag: ...

        @overload
        def pop_long(
            self, key: str | bytes, default: LongTag | None, raise_errors: Literal[True]
        ) -> LongTag: ...

        @overload
        def pop_long(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> LongTag | None: ...

        @overload
        def pop_long(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> LongTag: ...

        @overload
        def pop_float(self, key: str | bytes) -> FloatTag | None: ...

        @overload
        def pop_float(self, key: str | bytes, default: None) -> FloatTag | None: ...

        @overload
        def pop_float(self, key: str | bytes, default: FloatTag) -> FloatTag: ...

        @overload
        def pop_float(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> FloatTag | None: ...

        @overload
        def pop_float(
            self, key: str | bytes, default: FloatTag, raise_errors: Literal[False]
        ) -> FloatTag: ...

        @overload
        def pop_float(
            self,
            key: str | bytes,
            default: FloatTag | None,
            raise_errors: Literal[True],
        ) -> FloatTag: ...

        @overload
        def pop_float(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> FloatTag | None: ...

        @overload
        def pop_float(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> FloatTag: ...

        @overload
        def pop_double(self, key: str | bytes) -> DoubleTag | None: ...

        @overload
        def pop_double(self, key: str | bytes, default: None) -> DoubleTag | None: ...

        @overload
        def pop_double(self, key: str | bytes, default: DoubleTag) -> DoubleTag: ...

        @overload
        def pop_double(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> DoubleTag | None: ...

        @overload
        def pop_double(
            self, key: str | bytes, default: DoubleTag, raise_errors: Literal[False]
        ) -> DoubleTag: ...

        @overload
        def pop_double(
            self,
            key: str | bytes,
            default: DoubleTag | None,
            raise_errors: Literal[True],
        ) -> DoubleTag: ...

        @overload
        def pop_double(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> DoubleTag | None: ...

        @overload
        def pop_double(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> DoubleTag: ...

        @overload
        def pop_byte_array(self, key: str | bytes) -> ByteArrayTag | None: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, default: None
        ) -> ByteArrayTag | None: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, default: ByteArrayTag
        ) -> ByteArrayTag: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ByteArrayTag | None: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, default: ByteArrayTag, raise_errors: Literal[False]
        ) -> ByteArrayTag: ...

        @overload
        def pop_byte_array(
            self,
            key: str | bytes,
            default: ByteArrayTag | None,
            raise_errors: Literal[True],
        ) -> ByteArrayTag: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ByteArrayTag | None: ...

        @overload
        def pop_byte_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ByteArrayTag: ...

        @overload
        def pop_string(self, key: str | bytes) -> StringTag | None: ...

        @overload
        def pop_string(self, key: str | bytes, default: None) -> StringTag | None: ...

        @overload
        def pop_string(self, key: str | bytes, default: StringTag) -> StringTag: ...

        @overload
        def pop_string(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> StringTag | None: ...

        @overload
        def pop_string(
            self, key: str | bytes, default: StringTag, raise_errors: Literal[False]
        ) -> StringTag: ...

        @overload
        def pop_string(
            self,
            key: str | bytes,
            default: StringTag | None,
            raise_errors: Literal[True],
        ) -> StringTag: ...

        @overload
        def pop_string(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> StringTag | None: ...

        @overload
        def pop_string(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> StringTag: ...

        @overload
        def pop_list(self, key: str | bytes) -> ListTag | None: ...

        @overload
        def pop_list(self, key: str | bytes, default: None) -> ListTag | None: ...

        @overload
        def pop_list(self, key: str | bytes, default: ListTag) -> ListTag: ...

        @overload
        def pop_list(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> ListTag | None: ...

        @overload
        def pop_list(
            self, key: str | bytes, default: ListTag, raise_errors: Literal[False]
        ) -> ListTag: ...

        @overload
        def pop_list(
            self, key: str | bytes, default: ListTag | None, raise_errors: Literal[True]
        ) -> ListTag: ...

        @overload
        def pop_list(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> ListTag | None: ...

        @overload
        def pop_list(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> ListTag: ...

        @overload
        def pop_compound(self, key: str | bytes) -> CompoundTag | None: ...

        @overload
        def pop_compound(
            self, key: str | bytes, default: None
        ) -> CompoundTag | None: ...

        @overload
        def pop_compound(
            self, key: str | bytes, default: CompoundTag
        ) -> CompoundTag: ...

        @overload
        def pop_compound(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> CompoundTag | None: ...

        @overload
        def pop_compound(
            self, key: str | bytes, default: CompoundTag, raise_errors: Literal[False]
        ) -> CompoundTag: ...

        @overload
        def pop_compound(
            self,
            key: str | bytes,
            default: CompoundTag | None,
            raise_errors: Literal[True],
        ) -> CompoundTag: ...

        @overload
        def pop_compound(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> CompoundTag | None: ...

        @overload
        def pop_compound(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> CompoundTag: ...

        @overload
        def pop_int_array(self, key: str | bytes) -> IntArrayTag | None: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, default: None
        ) -> IntArrayTag | None: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, default: IntArrayTag
        ) -> IntArrayTag: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> IntArrayTag | None: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, default: IntArrayTag, raise_errors: Literal[False]
        ) -> IntArrayTag: ...

        @overload
        def pop_int_array(
            self,
            key: str | bytes,
            default: IntArrayTag | None,
            raise_errors: Literal[True],
        ) -> IntArrayTag: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> IntArrayTag | None: ...

        @overload
        def pop_int_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> IntArrayTag: ...

        @overload
        def pop_long_array(self, key: str | bytes) -> LongArrayTag | None: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, default: None
        ) -> LongArrayTag | None: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, default: LongArrayTag
        ) -> LongArrayTag: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, default: None, raise_errors: Literal[False]
        ) -> LongArrayTag | None: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, default: LongArrayTag, raise_errors: Literal[False]
        ) -> LongArrayTag: ...

        @overload
        def pop_long_array(
            self,
            key: str | bytes,
            default: LongArrayTag | None,
            raise_errors: Literal[True],
        ) -> LongArrayTag: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, *, raise_errors: Literal[False]
        ) -> LongArrayTag | None: ...

        @overload
        def pop_long_array(
            self, key: str | bytes, *, raise_errors: Literal[True]
        ) -> LongArrayTag: ...

        def __setitem__(self, key: str | bytes, value: AnyNBT) -> None: ...

        def __delitem__(self, key: str | bytes) -> None: ...

        def __getitem__(self, key: str | bytes) -> AnyNBT: ...

        def __len__(self) -> int: ...

        def __iter__(self) -> Iterator[str | bytes]: ...

    class AbstractBaseArrayTag(AbstractBaseMutableTag):
        def __init__(self, value: Iterable[SupportsInt] = ()) -> None: ...

        @property
        def np_array(self) -> numpy.ndarray:
            """A numpy array holding the same internal data.

            Changes to the array will also modify the internal state.
            """

        def __len__(self) -> int:
            """The length of the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> len(tag)  # 3
            """

        @overload
        def __getitem__(self, item: int) -> numpy.int8 | numpy.int32 | numpy.int64:
            """Get item(s) from the array.

            This supports the full numpy protocol.
            If a numpy array is returned, the array data is the same as the data contained in this class.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> tag[0]  # 1
            >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
            >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
            """

        @overload
        def __getitem__(
            self, item: slice
        ) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]: ...

        @overload
        def __getitem__(
            self, item: NDArray[numpy.integer]
        ) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]: ...

        def __iter__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
            """Iterate through the items in the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> for num in tag:
            >>>     pass
            >>> iter(tag)
            """

        def __reversed__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
            """Iterate through the items in the array in reverse order.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> for num in reversed(tag):
            >>>     pass
            """

        def __contains__(self, item: Any) -> bool:
            """Check if an item is in the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> 1 in tag  # True
            """

        @overload
        def __setitem__(self, item: int, value: SupportsInt) -> None: ...

        @overload
        def __setitem__(
            self,
            item: slice,
            value: Iterable[SupportsInt],
        ) -> None: ...

        @overload
        def __setitem__(
            self,
            item: ArrayLike,
            value: Iterable[SupportsInt],
        ) -> None:
            """Set item(s) in the array.

            This supports the full numpy protocol.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> tag[0] = 10  # [10, 2, 3]
            >>> tag[:2] = [4, 5]  # [4, 5, 3]
            >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
            """

        def __array__(
            self, dtype: numpy.dtype | None = None
        ) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
            """Get a numpy array representation of the stored data.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> arr = numpy.asarray(tag)
            """

    class ByteArrayTag(AbstractBaseArrayTag):
        @property
        def np_array(self) -> NDArray[numpy.int8]: ...

        def __len__(self) -> int:
            """The length of the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> len(tag)  # 3
            """

        @overload
        def __getitem__(self, item: int) -> numpy.int8:
            """Get item(s) from the array.

            This supports the full numpy protocol.
            If a numpy array is returned, the array data is the same as the data contained in this class.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> tag[0]  # 1
            >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
            >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
            """

        @overload
        def __getitem__(self, item: slice) -> NDArray[numpy.int8]: ...

        @overload
        def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int8]: ...

        def __iter__(self) -> Iterator[numpy.int8]:
            """Iterate through the items in the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> for num in tag:
            >>>     pass
            >>> iter(tag)
            """

        def __reversed__(self) -> Iterator[numpy.int8]:
            """Iterate through the items in the array in reverse order.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> for num in reversed(tag):
            >>>     pass
            """

        def __contains__(self, value: int) -> bool:
            """Check if an item is in the array.

            >>> from amulet.nbt import ByteArrayTag
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> 1 in tag  # True
            """

        @overload
        def __setitem__(self, item: int, value: SupportsInt) -> None: ...

        @overload
        def __setitem__(self, item: slice, value: Iterable[SupportsInt]) -> None: ...

        @overload
        def __setitem__(self, item: ArrayLike, value: Iterable[SupportsInt]) -> None:
            """Set item(s) in the array.

            This supports the full numpy protocol.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> tag[0] = 10  # [10, 2, 3]
            >>> tag[:2] = [4, 5]  # [4, 5, 3]
            >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
            """

        def __array__(self, dtype: numpy.dtype | None = None) -> NDArray[numpy.int8]:
            """Get a numpy array representation of the stored data.

            >>> from amulet.nbt import ByteArrayTag
            >>> import numpy
            >>> tag = ByteArrayTag([1, 2, 3])
            >>> arr = numpy.asarray(tag)
            """

    class IntArrayTag(AbstractBaseArrayTag):
        @property
        def np_array(self) -> NDArray[numpy.int32]: ...

        def __len__(self) -> int:
            """The length of the array.

            >>> from amulet.nbt import IntArrayTag
            >>> tag = IntArrayTag([1, 2, 3])
            >>> len(tag)  # 3
            """

        @overload
        def __getitem__(self, item: int) -> numpy.int32:
            """Get item(s) from the array.

            This supports the full numpy protocol.
            If a numpy array is returned, the array data is the same as the data contained in this class.

            >>> from amulet.nbt import IntArrayTag
            >>> import numpy
            >>> tag = IntArrayTag([1, 2, 3])
            >>> tag[0]  # 1
            >>> tag[:1]  # numpy.array([1], dtype=numpy.int32)
            >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int32)
            """

        @overload
        def __getitem__(self, item: slice) -> NDArray[numpy.int32]: ...

        @overload
        def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int32]: ...

        def __iter__(self) -> Iterator[numpy.int32]:
            """Iterate through the items in the array.

            >>> from amulet.nbt import IntArrayTag
            >>> tag = IntArrayTag([1, 2, 3])
            >>> for num in tag:
            >>>     pass
            >>> iter(tag)
            """

        def __reversed__(self) -> Iterator[numpy.int32]:
            """Iterate through the items in the array in reverse order.

            >>> from amulet.nbt import IntArrayTag
            >>> tag = IntArrayTag([1, 2, 3])
            >>> for num in reversed(tag):
            >>>     pass
            """

        def __contains__(self, value: int) -> bool:
            """Check if an item is in the array.

            >>> from amulet.nbt import IntArrayTag
            >>> tag = IntArrayTag([1, 2, 3])
            >>> 1 in tag  # True
            """

        @overload
        def __setitem__(self, item: int, value: SupportsInt) -> None: ...

        @overload
        def __setitem__(self, item: slice, value: Iterable[SupportsInt]) -> None: ...

        @overload
        def __setitem__(self, item: ArrayLike, value: Iterable[SupportsInt]) -> None:
            """Set item(s) in the array.

            This supports the full numpy protocol.

            >>> from amulet.nbt import IntArrayTag
            >>> import numpy
            >>> tag = IntArrayTag([1, 2, 3])
            >>> tag[0] = 10  # [10, 2, 3]
            >>> tag[:2] = [4, 5]  # [4, 5, 3]
            >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
            """

        def __array__(self, dtype: numpy.dtype | None = None) -> NDArray[numpy.int32]:
            """Get a numpy array representation of the stored data.

            >>> from amulet.nbt import IntArrayTag
            >>> import numpy
            >>> tag = IntArrayTag([1, 2, 3])
            >>> arr = numpy.asarray(tag)
            """

    class LongArrayTag(AbstractBaseArrayTag):
        @property
        def np_array(self) -> NDArray[numpy.int64]: ...

        def __len__(self) -> int:
            """The length of the array.

            >>> from amulet.nbt import LongArrayTag
            >>> tag = LongArrayTag([1, 2, 3])
            >>> len(tag)  # 3
            """

        @overload
        def __getitem__(self, item: int) -> numpy.int64:
            """Get item(s) from the array.

            This supports the full numpy protocol.
            If a numpy array is returned, the array data is the same as the data contained in this class.

            >>> from amulet.nbt import LongArrayTag
            >>> import numpy
            >>> tag = LongArrayTag([1, 2, 3])
            >>> tag[0]  # 1
            >>> tag[:1]  # numpy.array([1], dtype=numpy.int64)
            >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int64)
            """

        @overload
        def __getitem__(self, item: slice) -> NDArray[numpy.int64]: ...

        @overload
        def __getitem__(self, item: NDArray[numpy.integer]) -> NDArray[numpy.int64]: ...

        def __iter__(self) -> Iterator[numpy.int64]:
            """Iterate through the items in the array.

            >>> from amulet.nbt import LongArrayTag
            >>> tag = LongArrayTag([1, 2, 3])
            >>> for num in tag:
            >>>     pass
            >>> iter(tag)
            """

        def __reversed__(self) -> Iterator[numpy.int64]:
            """Iterate through the items in the array in reverse order.

            >>> from amulet.nbt import LongArrayTag
            >>> tag = LongArrayTag([1, 2, 3])
            >>> for num in reversed(tag):
            >>>     pass
            """

        def __contains__(self, value: int) -> bool:
            """Check if an item is in the array.

            >>> from amulet.nbt import LongArrayTag
            >>> tag = LongArrayTag([1, 2, 3])
            >>> 1 in tag  # True
            """

        @overload
        def __setitem__(self, item: int, value: SupportsInt) -> None: ...

        @overload
        def __setitem__(self, item: slice, value: Iterable[SupportsInt]) -> None: ...

        @overload
        def __setitem__(self, item: ArrayLike, value: Iterable[SupportsInt]) -> None:
            """Set item(s) in the array.

            This supports the full numpy protocol.

            >>> from amulet.nbt import LongArrayTag
            >>> import numpy
            >>> tag = LongArrayTag([1, 2, 3])
            >>> tag[0] = 10  # [10, 2, 3]
            >>> tag[:2] = [4, 5]  # [4, 5, 3]
            >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
            """

        def __array__(self, dtype: numpy.dtype | None = None) -> NDArray[numpy.int64]:
            """Get a numpy array representation of the stored data.

            >>> from amulet.nbt import LongArrayTag
            >>> import numpy
            >>> tag = LongArrayTag([1, 2, 3])
            >>> arr = numpy.asarray(tag)
            """

    # Alias
    TAG_Byte: TypeAlias = ByteTag
    TAG_Short: TypeAlias = ShortTag
    TAG_Int: TypeAlias = IntTag
    TAG_Long: TypeAlias = LongTag
    TAG_Float: TypeAlias = FloatTag
    TAG_Double: TypeAlias = DoubleTag
    TAG_String: TypeAlias = StringTag
    TAG_Byte_Array: TypeAlias = ByteArrayTag
    TAG_List: TypeAlias = ListTag
    TAG_Compound: TypeAlias = CompoundTag
    TAG_Int_Array: TypeAlias = IntArrayTag
    TAG_Long_Array: TypeAlias = LongArrayTag

    class NamedTag(tuple[str | bytes, AnyNBT]):
        def __init__(
            self, tag: AbstractBaseTag | AnyNBT | None = None, name: str | bytes = ""
        ) -> None: ...

        @property
        def tag(self) -> AnyNBT: ...

        @tag.setter
        def tag(self, tag: AnyNBT) -> None: ...

        @property
        def name(self) -> str | bytes: ...

        @name.setter
        def name(self, name: str | bytes) -> None: ...

        def to_nbt(
            self,
            *,
            preset: EncodingPreset | None = None,
            compressed: bool = True,
            little_endian: bool = False,
            string_encoding: StringEncoding = mutf8_encoding,
        ) -> bytes:
            """Get the data in binary NBT format.

            :param preset: A class containing endianness and encoding presets.
            :param compressed: Should the bytes be compressed with gzip.
            :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
            :param string_encoding: A function to encode strings to bytes. Ignored if preset is defined.
            :return: The binary NBT representation of the class.
            """

        def save_to(
            self,
            filepath_or_buffer: str | _Writeable | None = None,
            *,
            preset: EncodingPreset | None = None,
            compressed: bool = True,
            little_endian: bool = False,
            string_encoding: StringEncoding = mutf8_encoding,
        ) -> bytes:
            """Convert the data to the binary NBT format. Optionally write to a file.

            If filepath_or_buffer is a valid file path in string form the data will be written to that file.

            If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

            :param filepath_or_buffer: A path or writeable object to write the data to.
            :param preset: A class containing endianness and encoding presets.
            :param compressed: Should the bytes be compressed with gzip.
            :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
            :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
            :return: The binary NBT representation of the class.
            """

        def to_snbt(self, indent: None | str | int = None) -> str:
            """Convert the data to the Stringified NBT format.

            :param indent:
                If None (the default) the SNBT will be on one line.
                If an int will be multi-line SNBT with this many spaces per indentation.
                If a string will be multi-line SNBT with this string as the indentation.
            :return: The SNBT string.
            """

        @property
        def byte(self) -> ByteTag: ...

        @property
        def short(self) -> ShortTag: ...

        @property
        def int(self) -> IntTag: ...

        @property
        def long(self) -> LongTag: ...

        @property
        def float(self) -> FloatTag: ...

        @property
        def double(self) -> DoubleTag: ...

        @property
        def string(self) -> StringTag: ...

        @property
        def list(self) -> ListTag: ...

        @property
        def compound(self) -> CompoundTag: ...

        @property
        def byte_array(self) -> ByteArrayTag: ...

        @property
        def int_array(self) -> IntArrayTag: ...

        @property
        def long_array(self) -> LongArrayTag: ...

    class ReadOffset:
        offset: int

    @overload
    def read_nbt(
        filepath_or_buffer: str | bytes | memoryview | _Readable | None,
        *,
        preset: EncodingPreset | None = None,
        named: bool = True,
        read_offset: ReadOffset | None = None,
    ) -> NamedTag:
        """Load one binary NBT object.

        :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
        :param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.
        :param named: If the tag to read is named, if not, return NamedTag with empty name.
        :param read_offset: Optional ReadOffset object to get read end offset.
        :raises: IndexError if the data is not long enough.
        """

    @overload
    def read_nbt(
        filepath_or_buffer: str | bytes | memoryview | _Readable | None,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
        named: bool = True,
        read_offset: ReadOffset | None = None,
    ) -> NamedTag:
        """Load one binary NBT object.

        :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
        :param compressed: Is the binary data gzip compressed.
        :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
        :param string_encoding: The bytes decoder function to parse strings. mutf8_encoding for Java, utf8_escape_encoding for Bedrock.
        :param named: If the tag to read is named, if not, return NamedTag with empty name.
        :param read_offset: Optional ReadOffset object to get read end offset.
        :raises: IndexError if the data is not long enough.
        """

    @overload
    def read_nbt_array(
        filepath_or_buffer: str | bytes | memoryview | _Readable | None,
        *,
        count: int = 1,
        preset: EncodingPreset | None = None,
        named: bool = True,
        read_offset: ReadOffset | None = None,
    ) -> list[NamedTag]:
        """Load an array of binary NBT objects from a contiguous buffer.

        :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
        :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
        :param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.
        :param named: If the tags to read are named, if not, return NamedTags with empty name.
        :param read_offset: Optional ReadOffset object to get read end offset.
        :raises: IndexError if the data is not long enough.
        """

    @overload
    def read_nbt_array(
        filepath_or_buffer: str | bytes | memoryview | _Readable | None,
        *,
        count: int = 1,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
        named: bool = True,
        read_offset: ReadOffset | None = None,
    ) -> list[NamedTag]:
        """Load an array of binary NBT objects from a contiguous buffer.

        :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
        :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
        :param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.
        :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
        :param string_encoding: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet.nbt.utf8_escape_decoder for Bedrock.
        :param named: If the tags to read are named, if not, return NamedTags with empty name.
        :param read_offset: Optional ReadOffset object to get read end offset.
        :raises: IndexError if the data is not long enough.
        """

    def read_snbt(snbt: str) -> AnyNBT:
        """
        Load Stringified NBT into a tag.
        """


__version__ = _version.get_versions()["version"]
__major__ = int(re.match(r"\d+", __version__).group())


def _init() -> None:
    import os
    import sys
    import ctypes

    if sys.platform == "win32":
        lib_path = os.path.join(os.path.dirname(__file__), "amulet_nbt.dll")
    elif sys.platform == "darwin":
        lib_path = os.path.join(os.path.dirname(__file__), "libamulet_nbt.dylib")
    elif sys.platform == "linux":
        lib_path = os.path.join(os.path.dirname(__file__), "libamulet_nbt.so")
    else:
        raise RuntimeError(f"Unsupported platform {sys.platform}")

    # Import dependencies
    import amulet.zlib

    # Load the shared library
    ctypes.cdll.LoadLibrary(lib_path)

    from ._amulet_nbt import init

    init(sys.modules[__name__])


_init()


__all__ = [
    "__version__",
    "__major__",
    "AbstractBaseTag",
    "AbstractBaseImmutableTag",
    "AbstractBaseMutableTag",
    "AbstractBaseNumericTag",
    "AbstractBaseIntTag",
    "ByteTag",
    "TAG_Byte",
    "ShortTag",
    "TAG_Short",
    "IntTag",
    "TAG_Int",
    "LongTag",
    "TAG_Long",
    "AbstractBaseFloatTag",
    "FloatTag",
    "TAG_Float",
    "DoubleTag",
    "TAG_Double",
    "AbstractBaseArrayTag",
    "ByteArrayTag",
    "TAG_Byte_Array",
    "IntArrayTag",
    "TAG_Int_Array",
    "LongArrayTag",
    "TAG_Long_Array",
    "StringTag",
    "TAG_String",
    "ListTag",
    "TAG_List",
    "CompoundTag",
    "TAG_Compound",
    "NamedTag",
    "read_nbt",
    "read_nbt_array",
    "ReadOffset",
    "read_snbt",
    "SNBTType",
    "IntType",
    "FloatType",
    "NumberType",
    "ArrayType",
    "AnyNBT",
    "StringEncoding",
    "mutf8_encoding",
    "utf8_encoding",
    "utf8_escape_encoding",
    "EncodingPreset",
    "java_encoding",
    "bedrock_encoding",
]


SNBTType: TypeAlias = str
IntType: TypeAlias = ByteTag | ShortTag | IntTag | LongTag
FloatType: TypeAlias = FloatTag | DoubleTag
NumberType: TypeAlias = IntType | FloatType
ArrayType: TypeAlias = ByteArrayTag | IntArrayTag | LongArrayTag

AnyNBT: TypeAlias = NumberType | StringTag | ListTag | CompoundTag | ArrayType
