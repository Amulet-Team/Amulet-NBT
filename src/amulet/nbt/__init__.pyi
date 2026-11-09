from __future__ import annotations

import collections.abc
import types
import typing
from builtins import str as SNBTType

from . import _amulet_nbt, _version

__all__: list[str] = [
    "AbstractBaseArrayTag",
    "AbstractBaseFloatTag",
    "AbstractBaseImmutableTag",
    "AbstractBaseIntTag",
    "AbstractBaseMutableTag",
    "AbstractBaseNumericTag",
    "AbstractBaseTag",
    "AnyNBT",
    "ArrayType",
    "ByteArrayTag",
    "ByteTag",
    "CompoundTag",
    "CompoundTagIterator",
    "DoubleTag",
    "EncodingPreset",
    "FloatTag",
    "FloatType",
    "IntArrayTag",
    "IntTag",
    "IntType",
    "ListTag",
    "ListTagIterator",
    "LongArrayTag",
    "LongTag",
    "NamedTag",
    "NamedTagIterator",
    "NumberType",
    "ReadOffset",
    "SNBTType",
    "ShortTag",
    "StringEncoding",
    "StringTag",
    "TAG_Byte",
    "TAG_Byte_Array",
    "TAG_Compound",
    "TAG_Double",
    "TAG_Float",
    "TAG_Int",
    "TAG_Int_Array",
    "TAG_List",
    "TAG_Long",
    "TAG_Long_Array",
    "TAG_Short",
    "TAG_String",
    "bedrock_encoding",
    "compiler_config",
    "java_encoding",
    "mutf8_encoding",
    "read_nbt",
    "read_nbt_array",
    "read_snbt",
    "utf8_encoding",
    "utf8_escape_encoding",
]

class StringEncoding:
    def decode(self, data: bytes) -> bytes: ...
    def encode(self, data: bytes) -> bytes: ...

class EncodingPreset:
    @property
    def compressed(self) -> bool: ...
    @property
    def little_endian(self) -> bool: ...
    @property
    def string_encoding(self) -> StringEncoding: ...

class AbstractBaseTag:
    """
    Abstract Base Class for all tag classes
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = -1
    def __copy__(self, *args, **kwargs: typing.Any) -> None:
        """
        A string representation of the object.
        """

    def __deepcopy__(self, *args, **kwargs: typing.Any) -> None:
        """
        A string representation of the object.
        """

    def __eq__(self, *args, **kwargs: typing.Any) -> None:
        """
        Check if the instance is equal to another instance.

        This will only return True if the tag type is the same and the data contained is the same.
        """

    def __repr__(self, *args, **kwargs: typing.Any) -> None:
        """
        A string representation of the object to show how it can be constructed.
        """

    def __str__(self, *args, **kwargs: typing.Any) -> None:
        """
        A string representation of the object.
        """

    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> None: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> None: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> None: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> None: ...
    def to_snbt(self, indent: typing.Any = None) -> None: ...
    @property
    def py_data(self, *args, **kwargs: typing.Any) -> None:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

class AbstractBaseImmutableTag(AbstractBaseTag):
    """
    Abstract Base Class for all tag classes
    """

    def __hash__(self, *args, **kwargs: typing.Any) -> None:
        """
        A hash of the data in the class.
        """

class AbstractBaseNumericTag(AbstractBaseImmutableTag):
    """
    Abstract Base Class for all numeric tag classes
    """

    def __bool__(self, *args, **kwargs: typing.Any) -> None:
        """
        Get a python bool representation of the class.
        """

    def __float__(self, *args, **kwargs: typing.Any) -> None:
        """
        Get a python float representation of the class.
        """

    def __int__(self, *args, **kwargs: typing.Any) -> None:
        """
        Get a python int representation of the class.
        """

class AbstractBaseIntTag(AbstractBaseNumericTag):
    """
    Abstract Base Class for all int tag classes
    """

    @property
    def py_int(self, *args, **kwargs: typing.Any) -> None:
        """
        A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class AbstractBaseFloatTag(AbstractBaseNumericTag):
    """
    Abstract Base Class for all float tag classes.
    """

    @property
    def py_float(self, *args, **kwargs: typing.Any) -> None:
        """
        A python float representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class AbstractBaseMutableTag(AbstractBaseTag):
    """
    Abstract Base Class for all mutable tags.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore

class AbstractBaseArrayTag(AbstractBaseMutableTag):
    """
    Abstract Base Class for all array tag classes.
    """

class ByteTag(AbstractBaseIntTag):
    """
    A 1 byte integer class.

    Can Store numbers between -(2^7) and (2^7 - 1)
    """

    tag_id: typing.ClassVar[int] = 1
    def __bool__(self) -> bool: ...
    def __copy__(self) -> ByteTag: ...
    def __deepcopy__(self, memo: dict) -> ByteTag: ...
    @typing.overload
    def __eq__(self, other: ByteTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: ByteTag) -> bool: ...
    def __gt__(self, arg0: ByteTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0) -> None:
        """
        __init__(self: amulet.nbt.ByteTag, value: typing.SupportsInt) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: ByteTag) -> bool: ...
    def __lt__(self, arg0: ByteTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> int:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_int(self) -> int:
        """
        A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class ShortTag(AbstractBaseIntTag):
    """
    A 2 byte integer class.

    Can Store numbers between -(2^15) and (2^15 - 1)
    """

    tag_id: typing.ClassVar[int] = 2
    def __bool__(self) -> bool: ...
    def __copy__(self) -> ShortTag: ...
    def __deepcopy__(self, memo: dict) -> ShortTag: ...
    @typing.overload
    def __eq__(self, other: ShortTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: ShortTag) -> bool: ...
    def __gt__(self, arg0: ShortTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0) -> None:
        """
        __init__(self: amulet.nbt.ShortTag, value: typing.SupportsInt) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: ShortTag) -> bool: ...
    def __lt__(self, arg0: ShortTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> int:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_int(self) -> int:
        """
        A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class IntTag(AbstractBaseIntTag):
    """
    A 4 byte integer class.

    Can Store numbers between -(2^31) and (2^31 - 1)
    """

    tag_id: typing.ClassVar[int] = 3
    def __bool__(self) -> bool: ...
    def __copy__(self) -> IntTag: ...
    def __deepcopy__(self, memo: dict) -> IntTag: ...
    @typing.overload
    def __eq__(self, other: IntTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: IntTag) -> bool: ...
    def __gt__(self, arg0: IntTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0) -> None:
        """
        __init__(self: amulet.nbt.IntTag, value: typing.SupportsInt) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: IntTag) -> bool: ...
    def __lt__(self, arg0: IntTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> int:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_int(self) -> int:
        """
        A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class LongTag(AbstractBaseIntTag):
    """
    A 8 byte integer class.

    Can Store numbers between -(2^63) and (2^63 - 1)
    """

    tag_id: typing.ClassVar[int] = 4
    def __bool__(self) -> bool: ...
    def __copy__(self) -> LongTag: ...
    def __deepcopy__(self, memo: dict) -> LongTag: ...
    @typing.overload
    def __eq__(self, other: LongTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: LongTag) -> bool: ...
    def __gt__(self, arg0: LongTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0) -> None:
        """
        __init__(self: amulet.nbt.LongTag, value: typing.SupportsInt) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: LongTag) -> bool: ...
    def __lt__(self, arg0: LongTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> int:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_int(self) -> int:
        """
        A python int representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class FloatTag(AbstractBaseFloatTag):
    """
    A single precision float class.
    """

    tag_id: typing.ClassVar[int] = 5
    def __bool__(self) -> bool: ...
    def __copy__(self) -> FloatTag: ...
    def __deepcopy__(self, memo: dict) -> FloatTag: ...
    @typing.overload
    def __eq__(self, other: FloatTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: FloatTag) -> bool: ...
    def __gt__(self, arg0: FloatTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0.0) -> None:
        """
        __init__(self: amulet.nbt.FloatTag, value: typing.SupportsFloat) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: FloatTag) -> bool: ...
    def __lt__(self, arg0: FloatTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> float:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_float(self) -> float:
        """
        A python float representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class DoubleTag(AbstractBaseFloatTag):
    """
    A double precision float class.
    """

    tag_id: typing.ClassVar[int] = 6
    def __bool__(self) -> bool: ...
    def __copy__(self) -> DoubleTag: ...
    def __deepcopy__(self, memo: dict) -> DoubleTag: ...
    @typing.overload
    def __eq__(self, other: DoubleTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __float__(self) -> float: ...
    def __ge__(self, arg0: DoubleTag) -> bool: ...
    def __gt__(self, arg0: DoubleTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = 0.0) -> None:
        """
        __init__(self: amulet.nbt.DoubleTag, value: typing.SupportsFloat) -> None
        """

    def __int__(self) -> int: ...
    def __le__(self, arg0: DoubleTag) -> bool: ...
    def __lt__(self, arg0: DoubleTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_data(self) -> float:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_float(self) -> float:
        """
        A python float representation of the class.

        The returned data is immutable so changes will not mirror the instance.
        """

class StringTag(AbstractBaseImmutableTag):
    """
    A class that behaves like a string.
    """

    tag_id: typing.ClassVar[int] = 8
    def __bool__(self) -> bool: ...
    def __bytes__(self) -> bytes: ...
    def __copy__(self) -> StringTag: ...
    def __deepcopy__(self, memo: dict) -> StringTag: ...
    @typing.overload
    def __eq__(self, other: StringTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __ge__(self, arg0: StringTag) -> bool: ...
    def __gt__(self, arg0: StringTag) -> bool: ...
    def __hash__(self) -> int: ...
    def __init__(self, value: typing.Any = "") -> None:
        """
        __init__(self: amulet.nbt.StringTag, value: str | bytes) -> None
        """

    def __le__(self, arg0: StringTag) -> bool: ...
    def __lt__(self, arg0: StringTag) -> bool: ...
    def __repr__(self) -> str: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def py_bytes(self) -> bytes:
        """
        The bytes stored in the class.
        """

    @property
    def py_data(self) -> bytes:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_str(self) -> str:
        """
        The data stored in the class as a python string.

        In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError.
        """

    @property
    def py_str_or_bytes(self) -> str | bytes:
        """
        If the payload is UTF-8 returns a string else returns bytes.
        """

class ByteArrayTag(AbstractBaseArrayTag):
    """
    This class stores a fixed size signed 8 bit vector.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = 7
    def __contains__(self, arg0: typing.Any) -> None: ...
    def __copy__(self) -> ByteArrayTag: ...
    def __deepcopy__(self, memo: dict) -> ByteArrayTag: ...
    @typing.overload
    def __eq__(self, other: ByteArrayTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __getitem__(self, arg0: typing.Any) -> typing.Any: ...
    def __init__(
        self,
        value: collections.abc.Iterable[typing.SupportsInt | typing.SupportsIndex] = (),
    ) -> None: ...
    def __iter__(self) -> collections.abc.Iterator[int]: ...
    def __len__(self) -> int: ...
    def __repr__(self) -> str: ...
    def __reversed__(self) -> collections.abc.Iterator[int]: ...
    def __setitem__(self, arg0: typing.Any, arg1: typing.Any) -> None: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def np_array(self) -> typing.Any:
        """
        A numpy array holding the same internal data.

        Changes to the array will also modify the internal state.
        """

    @property
    def py_data(self) -> typing.Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

class IntArrayTag(AbstractBaseArrayTag):
    """
    This class stores a fixed size signed 32 bit vector.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = 11
    def __contains__(self, arg0: typing.Any) -> None: ...
    def __copy__(self) -> IntArrayTag: ...
    def __deepcopy__(self, memo: dict) -> IntArrayTag: ...
    @typing.overload
    def __eq__(self, other: IntArrayTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __getitem__(self, arg0: typing.Any) -> typing.Any: ...
    def __init__(
        self,
        value: collections.abc.Iterable[typing.SupportsInt | typing.SupportsIndex] = (),
    ) -> None: ...
    def __iter__(self) -> collections.abc.Iterator[int]: ...
    def __len__(self) -> int: ...
    def __repr__(self) -> str: ...
    def __reversed__(self) -> collections.abc.Iterator[int]: ...
    def __setitem__(self, arg0: typing.Any, arg1: typing.Any) -> None: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def np_array(self) -> typing.Any:
        """
        A numpy array holding the same internal data.

        Changes to the array will also modify the internal state.
        """

    @property
    def py_data(self) -> typing.Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

class LongArrayTag(AbstractBaseArrayTag):
    """
    This class stores a fixed size signed 64 bit vector.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = 12
    def __contains__(self, arg0: typing.Any) -> None: ...
    def __copy__(self) -> LongArrayTag: ...
    def __deepcopy__(self, memo: dict) -> LongArrayTag: ...
    @typing.overload
    def __eq__(self, other: LongArrayTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __getitem__(self, arg0: typing.Any) -> typing.Any: ...
    def __init__(
        self,
        value: collections.abc.Iterable[typing.SupportsInt | typing.SupportsIndex] = (),
    ) -> None: ...
    def __iter__(self) -> collections.abc.Iterator[int]: ...
    def __len__(self) -> int: ...
    def __repr__(self) -> str: ...
    def __reversed__(self) -> collections.abc.Iterator[int]: ...
    def __setitem__(self, arg0: typing.Any, arg1: typing.Any) -> None: ...
    def __str__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def np_array(self) -> typing.Any:
        """
        A numpy array holding the same internal data.

        Changes to the array will also modify the internal state.
        """

    @property
    def py_data(self) -> typing.Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

class CompoundTagIterator:
    def __iter__(self) -> CompoundTagIterator: ...
    def __next__(self) -> typing.Any: ...

class CompoundTag(AbstractBaseMutableTag):
    """
    A Python wrapper around a C++ unordered map.

    Note that this class is not thread safe and inherits all the limitations of a C++ unordered_map.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = 10
    @staticmethod
    def fromkeys(
        arg0: typing.Any,
        arg1: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ...
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> CompoundTag: ...
    def __bool__(self) -> bool: ...
    def __contains__(self, arg0: str) -> bool: ...
    def __copy__(self) -> CompoundTag: ...
    def __deepcopy__(self, memo: dict) -> CompoundTag: ...
    def __delitem__(self, arg0: str) -> None: ...
    @typing.overload
    def __eq__(self, other: CompoundTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __getitem__(
        self, arg0: str
    ) -> (
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ...
        | CompoundTag
        | IntArrayTag
        | LongArrayTag
    ): ...
    def __init__(self, value: typing.Any = (), **kwargs: typing.Any) -> None: ...
    def __iter__(self) -> CompoundTagIterator: ...
    def __len__(self) -> int: ...
    def __repr__(self) -> str: ...
    def __setitem__(
        self,
        arg0: str,
        arg1: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ...
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> None: ...
    def __str__(self) -> str: ...
    def clear(self) -> None: ...
    def get(
        self, key: str, default: typing.Any = None, cls: typing.Any = ...
    ) -> typing.Any:
        """
        Get an item from the CompoundTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param cls: The class that the stored tag must inherit from. If the type is incorrect default is returned.
        :return: The tag stored in the CompoundTag if the type is correct else default.
        :raises: KeyError if the key does not exist.
        :raises: TypeError if the stored type is not a subclass of cls.
        """

    def get_byte(
        self, key: str, default: None | ByteTag = None, raise_errors: bool = False
    ) -> None | ByteTag:
        """
        Get the tag stored in key if it is a ByteTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteTag and raise_errors is True.
        """

    def get_byte_array(
        self, key: str, default: None | ByteArrayTag = None, raise_errors: bool = False
    ) -> None | ByteArrayTag:
        """
        Get the tag stored in key if it is a ByteArrayTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteArrayTag and raise_errors is True.
        """

    def get_compound(
        self, key: str, default: None | CompoundTag = None, raise_errors: bool = False
    ) -> None | CompoundTag:
        """
        Get the tag stored in key if it is a CompoundTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The CompoundTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a CompoundTag and raise_errors is True.
        """

    def get_double(
        self, key: str, default: None | DoubleTag = None, raise_errors: bool = False
    ) -> None | DoubleTag:
        """
        Get the tag stored in key if it is a DoubleTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The DoubleTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a DoubleTag and raise_errors is True.
        """

    def get_float(
        self, key: str, default: None | FloatTag = None, raise_errors: bool = False
    ) -> None | FloatTag:
        """
        Get the tag stored in key if it is a FloatTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The FloatTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a FloatTag and raise_errors is True.
        """

    def get_int(
        self, key: str, default: None | IntTag = None, raise_errors: bool = False
    ) -> None | IntTag:
        """
        Get the tag stored in key if it is a IntTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntTag and raise_errors is True.
        """

    def get_int_array(
        self, key: str, default: None | IntArrayTag = None, raise_errors: bool = False
    ) -> None | IntArrayTag:
        """
        Get the tag stored in key if it is a IntArrayTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntArrayTag and raise_errors is True.
        """

    def get_list(
        self, key: str, default: None | ... = None, raise_errors: bool = False
    ) -> None | ...:
        """
        Get the tag stored in key if it is a ListTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ListTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ListTag and raise_errors is True.
        """

    def get_long(
        self, key: str, default: None | LongTag = None, raise_errors: bool = False
    ) -> None | LongTag:
        """
        Get the tag stored in key if it is a LongTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongTag and raise_errors is True.
        """

    def get_long_array(
        self, key: str, default: None | LongArrayTag = None, raise_errors: bool = False
    ) -> None | LongArrayTag:
        """
        Get the tag stored in key if it is a LongArrayTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongArrayTag and raise_errors is True.
        """

    def get_short(
        self, key: str, default: None | ShortTag = None, raise_errors: bool = False
    ) -> None | ShortTag:
        """
        Get the tag stored in key if it is a ShortTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ShortTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ShortTag and raise_errors is True.
        """

    def get_string(
        self, key: str, default: None | StringTag = None, raise_errors: bool = False
    ) -> None | StringTag:
        """
        Get the tag stored in key if it is a StringTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The StringTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a StringTag and raise_errors is True.
        """

    def items(self) -> typing.Any: ...
    def keys(self) -> typing.Any: ...
    def pop(self, key: str, default: typing.Any = ...) -> typing.Any: ...
    def pop_byte(
        self, key: str, default: None | ByteTag = None, raise_errors: bool = False
    ) -> None | ByteTag:
        """
        Remove the specified key and return the corresponding value if it is a ByteTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteTag and raise_errors is True.
        """

    def pop_byte_array(
        self, key: str, default: None | ByteArrayTag = None, raise_errors: bool = False
    ) -> None | ByteArrayTag:
        """
        Remove the specified key and return the corresponding value if it is a ByteArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ByteArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ByteArrayTag and raise_errors is True.
        """

    def pop_compound(
        self, key: str, default: None | CompoundTag = None, raise_errors: bool = False
    ) -> None | CompoundTag:
        """
        Remove the specified key and return the corresponding value if it is a CompoundTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The CompoundTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a CompoundTag and raise_errors is True.
        """

    def pop_double(
        self, key: str, default: None | DoubleTag = None, raise_errors: bool = False
    ) -> None | DoubleTag:
        """
        Remove the specified key and return the corresponding value if it is a DoubleTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The DoubleTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a DoubleTag and raise_errors is True.
        """

    def pop_float(
        self, key: str, default: None | FloatTag = None, raise_errors: bool = False
    ) -> None | FloatTag:
        """
        Remove the specified key and return the corresponding value if it is a FloatTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The FloatTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a FloatTag and raise_errors is True.
        """

    def pop_int(
        self, key: str, default: None | IntTag = None, raise_errors: bool = False
    ) -> None | IntTag:
        """
        Remove the specified key and return the corresponding value if it is a IntTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntTag and raise_errors is True.
        """

    def pop_int_array(
        self, key: str, default: None | IntArrayTag = None, raise_errors: bool = False
    ) -> None | IntArrayTag:
        """
        Remove the specified key and return the corresponding value if it is a IntArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The IntArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a IntArrayTag and raise_errors is True.
        """

    def pop_list(
        self, key: str, default: None | ... = None, raise_errors: bool = False
    ) -> None | ...:
        """
        Remove the specified key and return the corresponding value if it is a ListTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ListTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ListTag and raise_errors is True.
        """

    def pop_long(
        self, key: str, default: None | LongTag = None, raise_errors: bool = False
    ) -> None | LongTag:
        """
        Remove the specified key and return the corresponding value if it is a LongTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongTag and raise_errors is True.
        """

    def pop_long_array(
        self, key: str, default: None | LongArrayTag = None, raise_errors: bool = False
    ) -> None | LongArrayTag:
        """
        Remove the specified key and return the corresponding value if it is a LongArrayTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The LongArrayTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a LongArrayTag and raise_errors is True.
        """

    def pop_short(
        self, key: str, default: None | ShortTag = None, raise_errors: bool = False
    ) -> None | ShortTag:
        """
        Remove the specified key and return the corresponding value if it is a ShortTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The ShortTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a ShortTag and raise_errors is True.
        """

    def pop_string(
        self, key: str, default: None | StringTag = None, raise_errors: bool = False
    ) -> None | StringTag:
        """
        Remove the specified key and return the corresponding value if it is a StringTag.

        If the key exists but the type is incorrect, the value will not be removed.

        :param key: The key to get and remove
        :param default: The value to return if the key does not exist or the type is wrong.
        :param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.
        :return: The StringTag.
        :raises: KeyError if the key does not exist and raise_errors is True.
        :raises: TypeError if the stored type is not a StringTag and raise_errors is True.
        """

    def popitem(
        self,
    ) -> tuple[
        str | bytes,
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ...
        | CompoundTag
        | IntArrayTag
        | LongArrayTag,
    ]: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def setdefault(
        self,
        key: str,
        tag: (
            None
            | ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ...
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ) = None,
        cls: typing.Any = ...,
    ) -> typing.Any: ...
    def setdefault_byte(
        self, key: str, default: None | ByteTag = None
    ) -> None | ByteTag:
        """
        Populate key if not defined or value is not ByteTag. Return the value stored
        .
        If default is a ByteTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ByteTag is used.
        :return: The ByteTag stored in key
        """

    def setdefault_byte_array(
        self, key: str, default: None | ByteArrayTag = None
    ) -> None | ByteArrayTag:
        """
        Populate key if not defined or value is not ByteArrayTag. Return the value stored
        .
        If default is a ByteArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ByteArrayTag is used.
        :return: The ByteArrayTag stored in key
        """

    def setdefault_compound(
        self, key: str, default: None | CompoundTag = None
    ) -> None | CompoundTag:
        """
        Populate key if not defined or value is not CompoundTag. Return the value stored
        .
        If default is a CompoundTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default CompoundTag is used.
        :return: The CompoundTag stored in key
        """

    def setdefault_double(
        self, key: str, default: None | DoubleTag = None
    ) -> None | DoubleTag:
        """
        Populate key if not defined or value is not DoubleTag. Return the value stored
        .
        If default is a DoubleTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default DoubleTag is used.
        :return: The DoubleTag stored in key
        """

    def setdefault_float(
        self, key: str, default: None | FloatTag = None
    ) -> None | FloatTag:
        """
        Populate key if not defined or value is not FloatTag. Return the value stored
        .
        If default is a FloatTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default FloatTag is used.
        :return: The FloatTag stored in key
        """

    def setdefault_int(self, key: str, default: None | IntTag = None) -> None | IntTag:
        """
        Populate key if not defined or value is not IntTag. Return the value stored
        .
        If default is a IntTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default IntTag is used.
        :return: The IntTag stored in key
        """

    def setdefault_int_array(
        self, key: str, default: None | IntArrayTag = None
    ) -> None | IntArrayTag:
        """
        Populate key if not defined or value is not IntArrayTag. Return the value stored
        .
        If default is a IntArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default IntArrayTag is used.
        :return: The IntArrayTag stored in key
        """

    def setdefault_list(self, key: str, default: None | ... = None) -> None | ...:
        """
        Populate key if not defined or value is not ListTag. Return the value stored
        .
        If default is a ListTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ListTag is used.
        :return: The ListTag stored in key
        """

    def setdefault_long(
        self, key: str, default: None | LongTag = None
    ) -> None | LongTag:
        """
        Populate key if not defined or value is not LongTag. Return the value stored
        .
        If default is a LongTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default LongTag is used.
        :return: The LongTag stored in key
        """

    def setdefault_long_array(
        self, key: str, default: None | LongArrayTag = None
    ) -> None | LongArrayTag:
        """
        Populate key if not defined or value is not LongArrayTag. Return the value stored
        .
        If default is a LongArrayTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default LongArrayTag is used.
        :return: The LongArrayTag stored in key
        """

    def setdefault_short(
        self, key: str, default: None | ShortTag = None
    ) -> None | ShortTag:
        """
        Populate key if not defined or value is not ShortTag. Return the value stored
        .
        If default is a ShortTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default ShortTag is used.
        :return: The ShortTag stored in key
        """

    def setdefault_string(
        self, key: str, default: None | StringTag = None
    ) -> None | StringTag:
        """
        Populate key if not defined or value is not StringTag. Return the value stored
        .
        If default is a StringTag then it will be stored under key else a default instance will be created.

        :param key: The key to populate and get
        :param default: The default value to use. If None, the default StringTag is used.
        :return: The StringTag stored in key
        """

    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    def update(self, other: typing.Any = (), /, **kwargs: typing.Any) -> None: ...
    def values(self) -> typing.Any: ...
    @property
    def py_data(self) -> dict:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_dict(self) -> dict:
        """
        A shallow copy of the CompoundTag as a python dictionary.
        """

class ListTagIterator:
    def __iter__(self) -> ListTagIterator: ...
    def __next__(
        self,
    ) -> (
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ...
        | CompoundTag
        | IntArrayTag
        | LongArrayTag
    ): ...

class ListTag(AbstractBaseMutableTag):
    """
    A Python wrapper around a C++ vector.

    All contained data must be of the same NBT data type.
    """

    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag_id: typing.ClassVar[int] = 9
    @staticmethod
    def __class_getitem__(*args, **kwargs: typing.Any):
        """
        (arg0: type, *args) -> type
        """

    def __bool__(self) -> bool: ...
    def __contains__(
        self,
        arg0: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> bool: ...
    def __copy__(self) -> ListTag: ...
    def __deepcopy__(self, memo: dict) -> ListTag: ...
    @typing.overload
    def __delitem__(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> None: ...
    @typing.overload
    def __delitem__(self, arg0: slice) -> None: ...
    @typing.overload
    def __eq__(self, other: ListTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    @typing.overload
    def __getitem__(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> (
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ListTag
        | CompoundTag
        | IntArrayTag
        | LongArrayTag
    ): ...
    @typing.overload
    def __getitem__(self, arg0: slice) -> list: ...
    def __iadd__(self, arg0: typing.Any) -> ListTag: ...
    def __init__(
        self,
        value: typing.Any = (),
        element_tag_id: typing.SupportsInt | typing.SupportsIndex = 1,
    ) -> None:
        """
        __init__(self: amulet.nbt.ListTag, value: typing.Iterable[amulet.nbt.ByteTag] | typing.Iterable[amulet.nbt.ShortTag] | typing.Iterable[amulet.nbt.IntTag] | typing.Iterable[amulet.nbt.LongTag] | typing.Iterable[amulet.nbt.FloatTag] | typing.Iterable[amulet.nbt.DoubleTag] | typing.Iterable[amulet.nbt.ByteArrayTag] | typing.Iterable[amulet.nbt.StringTag] | typing.Iterable[amulet.nbt.ListTag] | typing.Iterable[amulet.nbt.CompoundTag] | typing.Iterable[amulet.nbt.IntArrayTag] | typing.Iterable[amulet.nbt.LongArrayTag] = (), element_tag_id = 1) -> None
        """

    def __iter__(self) -> ListTagIterator: ...
    def __len__(self) -> int: ...
    def __repr__(self) -> str: ...
    def __reversed__(self) -> ListTagIterator: ...
    @typing.overload
    def __setitem__(
        self,
        arg0: typing.SupportsInt | typing.SupportsIndex,
        arg1: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> None: ...
    @typing.overload
    def __setitem__(self, arg0: slice, arg1: typing.Any) -> None: ...
    def __str__(self) -> str: ...
    def append(
        self,
        arg0: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> None: ...
    def clear(self) -> None: ...
    def copy(self) -> ListTag: ...
    def count(
        self,
        arg0: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> int: ...
    def extend(self, arg0: typing.Any) -> None: ...
    def get_byte(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> ByteTag:
        """
        Get the tag at index if it is a ByteTag.

        :param index: The index to get
        :return: The ByteTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteTag
        """

    def get_byte_array(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> ByteArrayTag:
        """
        Get the tag at index if it is a ByteArrayTag.

        :param index: The index to get
        :return: The ByteArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """

    def get_compound(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> CompoundTag:
        """
        Get the tag at index if it is a CompoundTag.

        :param index: The index to get
        :return: The CompoundTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a CompoundTag
        """

    def get_double(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> DoubleTag:
        """
        Get the tag at index if it is a DoubleTag.

        :param index: The index to get
        :return: The DoubleTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a DoubleTag
        """

    def get_float(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> FloatTag:
        """
        Get the tag at index if it is a FloatTag.

        :param index: The index to get
        :return: The FloatTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a FloatTag
        """

    def get_int(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> IntTag:
        """
        Get the tag at index if it is a IntTag.

        :param index: The index to get
        :return: The IntTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntTag
        """

    def get_int_array(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> IntArrayTag:
        """
        Get the tag at index if it is a IntArrayTag.

        :param index: The index to get
        :return: The IntArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a IntArrayTag
        """

    def get_list(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> ListTag:
        """
        Get the tag at index if it is a ListTag.

        :param index: The index to get
        :return: The ListTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ListTag
        """

    def get_long(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> LongTag:
        """
        Get the tag at index if it is a LongTag.

        :param index: The index to get
        :return: The LongTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongTag
        """

    def get_long_array(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> LongArrayTag:
        """
        Get the tag at index if it is a LongArrayTag.

        :param index: The index to get
        :return: The LongArrayTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a LongArrayTag
        """

    def get_short(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> ShortTag:
        """
        Get the tag at index if it is a ShortTag.

        :param index: The index to get
        :return: The ShortTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a ShortTag
        """

    def get_string(self, arg0: typing.SupportsInt | typing.SupportsIndex) -> StringTag:
        """
        Get the tag at index if it is a StringTag.

        :param index: The index to get
        :return: The StringTag.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a StringTag
        """

    def index(
        self,
        tag: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
        start: typing.SupportsInt | typing.SupportsIndex = 0,
        stop: typing.SupportsInt | typing.SupportsIndex = 9223372036854775807,
    ) -> int: ...
    def insert(
        self,
        arg0: typing.SupportsInt | typing.SupportsIndex,
        arg1: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> None: ...
    def pop(
        self, item: typing.SupportsInt | typing.SupportsIndex = -1
    ) -> (
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ListTag
        | CompoundTag
        | IntArrayTag
        | LongArrayTag
    ): ...
    def remove(
        self,
        arg0: (
            ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ),
    ) -> None: ...
    def reverse(self) -> None: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self, *, preset: EncodingPreset = ..., name: str | None = ""
    ) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
        name: str | None = "",
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def element_class(self) -> typing.Any: ...
    @property
    def element_tag_id(self) -> int: ...
    @property
    def py_data(self) -> list:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.

        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    @property
    def py_list(self) -> list:
        """
        A python list representation of the class.

        The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """

class NamedTagIterator:
    def __iter__(self) -> NamedTagIterator: ...
    def __next__(self) -> typing.Any: ...

class NamedTag:
    __hash__: typing.ClassVar[None] = None  # type: ignore
    tag: (
        ByteTag
        | ShortTag
        | IntTag
        | LongTag
        | FloatTag
        | DoubleTag
        | ByteArrayTag
        | StringTag
        | ListTag
        | CompoundTag
        | IntArrayTag
        | LongArrayTag
    )
    def __copy__(self) -> NamedTag: ...
    def __deepcopy__(self, memo: dict) -> NamedTag: ...
    @typing.overload
    def __eq__(self, other: NamedTag) -> bool: ...
    @typing.overload
    def __eq__(self, other: typing.Any) -> bool | types.NotImplementedType: ...
    def __getitem__(
        self, arg0: typing.SupportsInt | typing.SupportsIndex
    ) -> typing.Any: ...
    def __init__(
        self,
        tag: (
            None
            | ByteTag
            | ShortTag
            | IntTag
            | LongTag
            | FloatTag
            | DoubleTag
            | ByteArrayTag
            | StringTag
            | ListTag
            | CompoundTag
            | IntArrayTag
            | LongArrayTag
        ) = None,
        name: str = "",
    ) -> None: ...
    def __iter__(self) -> NamedTagIterator: ...
    def __repr__(self) -> str: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        preset: EncodingPreset = ...,
    ) -> bytes: ...
    @typing.overload
    def save_to(
        self,
        filepath_or_writable: typing.Any = None,
        /,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
    ) -> bytes: ...
    @typing.overload
    def to_nbt(self, *, preset: EncodingPreset = ...) -> bytes: ...
    @typing.overload
    def to_nbt(
        self,
        *,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = ...,
    ) -> bytes: ...
    def to_snbt(self, indent: typing.Any = None) -> str: ...
    @property
    def byte(self) -> ByteTag:
        """
        Get the tag if it is a ByteTag.

        :return: The ByteTag.
        :raises: TypeError if the stored type is not a ByteTag
        """

    @property
    def byte_array(self) -> ByteArrayTag:
        """
        Get the tag if it is a ByteArrayTag.

        :return: The ByteArrayTag.
        :raises: TypeError if the stored type is not a ByteArrayTag
        """

    @property
    def compound(self) -> CompoundTag:
        """
        Get the tag if it is a CompoundTag.

        :return: The CompoundTag.
        :raises: TypeError if the stored type is not a CompoundTag
        """

    @property
    def double(self) -> DoubleTag:
        """
        Get the tag if it is a DoubleTag.

        :return: The DoubleTag.
        :raises: TypeError if the stored type is not a DoubleTag
        """

    @property
    def float(self) -> FloatTag:
        """
        Get the tag if it is a FloatTag.

        :return: The FloatTag.
        :raises: TypeError if the stored type is not a FloatTag
        """

    @property
    def int(self) -> IntTag:
        """
        Get the tag if it is a IntTag.

        :return: The IntTag.
        :raises: TypeError if the stored type is not a IntTag
        """

    @property
    def int_array(self) -> IntArrayTag:
        """
        Get the tag if it is a IntArrayTag.

        :return: The IntArrayTag.
        :raises: TypeError if the stored type is not a IntArrayTag
        """

    @property
    def list(self) -> ListTag:
        """
        Get the tag if it is a ListTag.

        :return: The ListTag.
        :raises: TypeError if the stored type is not a ListTag
        """

    @property
    def long(self) -> LongTag:
        """
        Get the tag if it is a LongTag.

        :return: The LongTag.
        :raises: TypeError if the stored type is not a LongTag
        """

    @property
    def long_array(self) -> LongArrayTag:
        """
        Get the tag if it is a LongArrayTag.

        :return: The LongArrayTag.
        :raises: TypeError if the stored type is not a LongArrayTag
        """

    @property
    def name(self) -> typing.Any: ...
    @name.setter
    def name(self, arg1: str) -> None: ...
    @property
    def short(self) -> ShortTag:
        """
        Get the tag if it is a ShortTag.

        :return: The ShortTag.
        :raises: TypeError if the stored type is not a ShortTag
        """

    @property
    def string(self) -> StringTag:
        """
        Get the tag if it is a StringTag.

        :return: The StringTag.
        :raises: TypeError if the stored type is not a StringTag
        """

class ReadOffset:
    def __init__(
        self, offset: typing.SupportsInt | typing.SupportsIndex = 0
    ) -> None: ...
    @property
    def offset(self) -> int: ...

def __annotate__(format): ...
@typing.overload
def read_nbt(
    filepath_or_readable: typing.Any,
    /,
    *,
    preset: EncodingPreset = ...,
    named: bool = True,
    read_offset: typing.Any = None,
) -> NamedTag:
    """
    Load one binary NBT object.

    :param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.
    :param named: If the tag to read is named, if not, return NamedTag with empty name.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: IndexError if the data is not long enough.
    """

@typing.overload
def read_nbt(
    filepath_or_readable: typing.Any,
    /,
    *,
    compressed: bool = True,
    little_endian: bool = False,
    string_encoding: StringEncoding = ...,
    named: bool = True,
    read_offset: typing.Any = None,
) -> NamedTag:
    """
    Load one binary NBT object.

    :param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param compressed: Is the binary data gzip compressed.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param string_encoding: The bytes decoder function to parse strings. mutf8_encoding for Java, utf8_escape_encoding for Bedrock.
    :param named: If the tag to read is named, if not, return NamedTag with empty name.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: IndexError if the data is not long enough.
    """

@typing.overload
def read_nbt_array(
    filepath_or_readable: typing.Any,
    /,
    *,
    count: typing.SupportsInt | typing.SupportsIndex = 1,
    preset: EncodingPreset = ...,
    named: bool = True,
    read_offset: typing.Any = None,
) -> list[NamedTag]:
    """
    Load an array of binary NBT objects from a contiguous buffer.

    :param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
    :param preset: The encoding preset. If this is defined little_endian and string_encoding have no effect.
    :param named: If the tags to read are named, if not, return NamedTags with empty name.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: IndexError if the data is not long enough.
    """

@typing.overload
def read_nbt_array(
    filepath_or_readable: typing.Any,
    /,
    *,
    count: typing.SupportsInt | typing.SupportsIndex = 1,
    compressed: bool = True,
    little_endian: bool = False,
    string_encoding: StringEncoding = ...,
    named: bool = True,
    read_offset: typing.Any = None,
) -> list[NamedTag]:
    """
    Load an array of binary NBT objects from a contiguous buffer.

    :param filepath_or_readable: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
    :param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param string_encoding: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet.nbt.utf8_escape_decoder for Bedrock.
    :param named: If the tags to read are named, if not, return NamedTags with empty name.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: IndexError if the data is not long enough.
    """

def read_snbt(
    snbt: str,
) -> (
    ByteTag
    | ShortTag
    | IntTag
    | LongTag
    | FloatTag
    | DoubleTag
    | ByteArrayTag
    | StringTag
    | ListTag
    | CompoundTag
    | IntArrayTag
    | LongArrayTag
):
    """
    Parse Stringified NBT.

    :param snbt: The SNBT string to parse.
    :return: The tag
    :raises: ValueError if the SNBT format is invalid.
    :raises: IndexError if the data overflows the given string.
    """

AnyNBT: typing.TypeAlias = (
    ByteTag
    | ShortTag
    | IntTag
    | LongTag
    | FloatTag
    | DoubleTag
    | StringTag
    | ListTag
    | CompoundTag
    | ByteArrayTag
    | IntArrayTag
    | LongArrayTag
)
ArrayType: typing.TypeAlias = ByteArrayTag | IntArrayTag | LongArrayTag
FloatType: typing.TypeAlias = FloatTag | DoubleTag
IntType: typing.TypeAlias = ByteTag | ShortTag | IntTag | LongTag
NumberType: typing.TypeAlias = (
    ByteTag | ShortTag | IntTag | LongTag | FloatTag | DoubleTag
)
__version__: str
bedrock_encoding: EncodingPreset
compiler_config: dict
java_encoding: EncodingPreset
mutf8_encoding: StringEncoding
utf8_encoding: StringEncoding
utf8_escape_encoding: StringEncoding
TAG_Byte = ByteTag
TAG_Short = ShortTag
TAG_Int = IntTag
TAG_Long = LongTag
TAG_Float = FloatTag
TAG_Double = DoubleTag
TAG_Byte_Array = ByteArrayTag
TAG_String = StringTag
TAG_List = ListTag
TAG_Compound = CompoundTag
TAG_Int_Array = IntArrayTag
TAG_Long_Array = LongArrayTag
