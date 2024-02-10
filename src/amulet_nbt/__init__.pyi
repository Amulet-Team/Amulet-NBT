from typing import (
    Union,
    Any,
    SupportsInt,
    SupportsFloat,
    Iterator,
    Iterable,
    overload,
    TypeVar,
    BinaryIO,
    Self,
    Type,
    Mapping,
    Optional,
)
from collections.abc import MutableSequence, MutableMapping
import numpy
from numpy.typing import NDArray, ArrayLike


__version__: str
__major__: int
__all__ = [
    "AbstractBaseTag",
    "AbstractBaseImmutableTag",
    "AbstractBaseMutableTag",
    "AbstractBaseNumericTag",
    "AbstractBaseIntTag",
    "ByteTag",
    "ShortTag",
    "IntTag",
    "LongTag",
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
    "DoubleTag",
    "FloatTag",
    "TAG_Float",
    "DoubleTag",
    "TAG_Double",
    "AbstractBaseArrayTag",
    "ByteArrayTag",
    "IntArrayTag",
    "LongArrayTag",
    "ByteArrayTag",
    "TAG_Byte_Array",
    "IntArrayTag",
    "TAG_Int_Array",
    "LongArrayTag",
    "TAG_Long_Array",
    "StringTag",
    "StringTag",
    "TAG_String",
    "NamedTag",
    "ListTag",
    "ListTag",
    "TAG_List",
    "CompoundTag",
    "CompoundTag",
    "TAG_Compound",
    "load",
    "load_array",
    "ReadOffset",
    "from_snbt",
    "NBTError",
    "NBTLoadError",
    "NBTFormatError",
    "SNBTParseError",
    "SNBTType",
    "IntType",
    "FloatType",
    "NumberType",
    "ArrayType",
    "AnyNBT",
    "mutf8_encoding",
    "utf8_encoding",
    "utf8_escape_encoding",
    "java_encoding",
    "bedrock_encoding"
]


class NBTError(Exception):
    """Some error in the NBT library."""


class NBTLoadError(NBTError):
    """The NBT data failed to load for some reason."""
    pass


class NBTFormatError(NBTLoadError):
    """Indicates the NBT format is invalid."""
    pass


class SNBTParseError(NBTError):
    """Indicates the SNBT format is invalid."""
    index: Optional[int]  # The index at which the error occurred


class StringEncoding:
    def encode(self, data: bytes) -> bytes:...
    def decode(self, data: bytes) -> bytes:...


mutf8_encoding: StringEncoding
utf8_encoding: StringEncoding
utf8_escape_encoding: StringEncoding


class EncodingPreset:
    pass


java_encoding: EncodingPreset
bedrock_encoding: EncodingPreset


class AbstractBase:
    """Abstract Base class for all Tags and the NamedTag"""

class AbstractBaseTag(AbstractBase):
    """Abstract Base Class for all Tag classes"""
    tag_id: int

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """

    def to_nbt(
        self,
        *,
        preset: EncodingPreset = None,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
        name: str | bytes = b"",
    ) -> bytes:
        """
        Get the data in binary NBT format.

        :param preset: A class containing compression, endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip. Ignored if preset is defined.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """

    def save_to(
        self,
        filepath_or_buffer: bytes | str | BinaryIO | memoryview | None = None,
        *,
        preset: EncodingPreset = None,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
        name: str | bytes = b"",
    ) -> bytes:
        """
        Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param preset: A class containing compression, endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip. Ignored if preset is defined.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :param name: The root tag name.
        :return: The binary NBT representation of the class.
        """

    def __eq__(self, other: Any) -> bool:
        """
        Check if the instance is equal to another instance.
        This will only return True if the tag type is the same and the data contained is the same.

        >>> from amulet_nbt import ByteTag, ShortTag
        >>> tag1 = ByteTag(1)
        >>> tag2 = ByteTag(2)
        >>> tag3 = ShortTag(1)
        >>> tag1 == tag1  # True
        >>> tag1 == tag2  # False
        >>> tag1 == tag3  # False
        """
        ...

    def __repr__(self) -> str:
        """
        A string representation of the object to show how it can be constructed.
        >>> from amulet_nbt import ByteTag
        >>> tag = ByteTag(1)
        >>> repr(tag)  # "ByteTag(1)"
        """

    def __str__(self) -> str:
        """A string representation of the object."""

    def __reduce__(self):
        ...

    def copy(self) -> Self:
        """Return a shallow copy of the class"""

    def __copy__(self) -> Self:
        """
        A shallow copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.copy(tag)
        """

    def __deepcopy__(self, memo=None) -> Self:
        """
        A deep copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.deepcopy(tag)
        """


class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self) -> int:
        """A hash of the data in the class."""


class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None


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
        """
        A python int representation of the class.
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
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """


class FloatTag(AbstractBaseFloatTag):
    """A single precision float class."""


class DoubleTag(AbstractBaseFloatTag):
    """A double precision float class."""


class StringTag(AbstractBaseImmutableTag):
    def __init__(self, value: str | bytes | Any = "") -> None:
        ...

    @property
    def py_str(self) -> str:
        """
        The data stored in the class as a python string.
        In some rare cases the data cannot be decoded to a string and this will raise a UnicodeDecodeError.
        """

    @property
    def py_bytes(self) -> bytes:
        """The bytes stored in the class."""

    def __ge__(self, other: Any) -> bool:
        """Check if the tag is greater than or equal to another tag."""

    def __gt__(self, other: Any) -> bool:
        """Check if the tag is greater than another tag."""

    def __le__(self, other: Any) -> bool:
        """Check if the tag is less than or equal to another tag."""

    def __lt__(self, other: Any) -> bool:
        """Check if the tag is less than another tag."""



AnyNBTT = TypeVar("AnyNBTT", bound=AnyNBT)


class ListTag(AbstractBaseMutableTag, MutableSequence[AnyNBTT]):
    @overload
    def __init__(self, value: Iterable[AnyNBTT] = ()) -> None: ...
    @overload
    def __init__(self, value: Iterable[AnyNBTT] = (), element_tag_id=1) -> None: ...

    @property
    def py_list(self) -> list[AnyNBTT]:
        """
        A python list representation of the class.
        The returned list is a shallow copy of the class, meaning changes will not mirror the instance.
        Use the public API to modify the internal data.
        """

    @property
    def element_tag_id(self) -> int:
        """
        The numerical id of the element type in this list.
        Will be an int in the range 0-12.
        """

    @property
    def element_class(self) -> (
        None |
        Type[ByteTag] |
        Type[ShortTag] |
        Type[IntTag] |
        Type[LongTag] |
        Type[FloatTag] |
        Type[DoubleTag] |
        Type[StringTag] |
        Type[ByteArrayTag] |
        Type[ListTag] |
        Type[CompoundTag] |
        Type[IntArrayTag] |
        Type[LongArrayTag]
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


class CompoundTag(AbstractBaseMutableTag, MutableMapping[str | bytes, AnyNBT]):
    def __init__(self, value: Mapping[str | bytes, AnyNBT] | Iterable[tuple[str | bytes, AnyNBT]] = (), **kwvals: AnyNBT): ...

    @property
    def py_dict(self) -> dict[str, AnyNBT]:
        """A shallow copy of the CompoundTag as a python dictionary."""

    def get(self, key: str | bytes, default: Any = None, cls: Type[AbstractBaseTag] = AbstractBaseTag):
        """
        Get an item from the CompoundTag.

        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong. If not defined and the type is not correct a TypeError is raised.
        :param cls: The class that the stored tag must inherit from. If the type is incorrect default is returned if defined else a TypeError is raised.
        :return: The tag stored in the CompoundTag if the type is correct else default if defined.
        :raises: KeyError if the key does not exist.
        :raises: TypeError if the stored type is not a subclass of cls.
        """

    @staticmethod
    def fromkeys(keys: Iterable[str | bytes], value: AnyNBT = None): ...

    def get_byte(self, key: str | bytes, default: ByteTag = None) -> ByteTag: ...
    def get_short(self, key: str | bytes, default: ShortTag = None) -> ShortTag: ...
    def get_int(self, key: str | bytes, default: IntTag = None) -> IntTag: ...
    def get_long(self, key: str | bytes, default: LongTag = None) -> LongTag: ...
    def get_float(self, key: str | bytes, default: FloatTag = None) -> FloatTag: ...
    def get_double(self, key: str | bytes, default: DoubleTag = None) -> DoubleTag: ...
    def get_string(self, key: str | bytes, default: StringTag = None) -> StringTag: ...
    def get_list(self, key: str | bytes, default: ListTag = None) -> ListTag: ...
    def get_compound(self, key: str | bytes, default: CompoundTag = None) -> CompoundTag: ...
    def get_byte_array(
        self, key: str | bytes, default: ByteArrayTag = None
    ) -> ByteArrayTag: ...
    def get_int_array(self, key: str | bytes, default: IntArrayTag = None) -> IntArrayTag: ...
    def get_long_array(
        self, key: str | bytes, default: LongArrayTag = None
    ) -> LongArrayTag: ...
    def setdefault_byte(self, key: str | bytes, default: ByteTag = None) -> ByteTag: ...
    def setdefault_short(self, key: str | bytes, default: ShortTag = None) -> ShortTag: ...
    def setdefault_int(self, key: str | bytes, default: IntTag = None) -> IntTag: ...
    def setdefault_long(self, key: str | bytes, default: LongTag = None) -> LongTag: ...
    def setdefault_float(self, key: str | bytes, default: FloatTag = None) -> FloatTag: ...
    def setdefault_double(self, key: str | bytes, default: DoubleTag = None) -> DoubleTag: ...
    def setdefault_string(self, key: str | bytes, default: StringTag = None) -> StringTag: ...
    def setdefault_list(self, key: str | bytes, default: ListTag = None) -> ListTag: ...
    def setdefault_compound(
        self, key: str | bytes, default: CompoundTag = None
    ) -> CompoundTag: ...
    def setdefault_byte_array(
        self, key: str | bytes, default: ByteArrayTag = None
    ) -> ByteArrayTag: ...
    def setdefault_int_array(
        self, key: str | bytes, default: IntArrayTag = None
    ) -> IntArrayTag: ...
    def setdefault_long_array(
        self, key: str | bytes, default: LongArrayTag = None
    ) -> LongArrayTag: ...


class AbstractBaseArrayTag(AbstractBaseMutableTag):
    @property
    def np_array(self) -> numpy.ndarray:
        """
        A numpy array holding the same internal data.
        Changes to the array will also modify the internal state.
        """

    def __len__(self):
        """
        The length of the array.
        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """

    @overload
    def __getitem__(self, item: int) -> numpy.int8 | numpy.int32 | numpy.int64:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        ...

    @overload
    def __getitem__(self, item: ArrayLike) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        ...

    def __getitem__(self, item):
        """
        Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """

    def __iter__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
        """
        Iterate through the items in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """

    def __reversed__(self) -> Iterator[numpy.int8 | numpy.int32 | numpy.int64]:
        """
        Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass
        """

    def __contains__(self, item: Any) -> bool:
        """
        Check if an item is in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """

    @overload
    def __setitem__(self, item: int, value: numpy.int8 | numpy.int32 | numpy.int64) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: ArrayLike[numpy.int8 | numpy.int32 | numpy.int64]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: ArrayLike[numpy.int8 | numpy.int32 | numpy.int64]) -> None:
        """
        Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """

    def __array__(self, dtype=None) -> NDArray[numpy.int8 | numpy.int32 | numpy.int64]:
        """
        Get a numpy array representation of the stored data.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)
        """


class ByteArrayTag(AbstractBaseArrayTag):
    @property
    def np_array(self) -> NDArray[numpy.int8]:
        ...

    def __len__(self) -> int:
        """
        The length of the array.
        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """

    @overload
    def __getitem__(self, item: int) -> numpy.int8:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int8]:
        ...

    @overload
    def __getitem__(self, item: ArrayLike) -> NDArray[numpy.int8]:
        """
        Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int8)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int8)
        """

    def __iter__(self) -> Iterator[numpy.int8]:
        """
        Iterate through the items in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """

    def __reversed__(self) -> Iterator[numpy.int8]:
        """
        Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass
        """

    def __contains__(self, value) -> bool:
        """
        Check if an item is in the array.

        >>> from amulet_nbt import ByteArrayTag
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """

    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: ArrayLike[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: ArrayLike[numpy.integer]) -> None:
        """
        Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """

    def __array__(self, dtype=None) -> NDArray[numpy.int8]:
        """
        Get a numpy array representation of the stored data.

        >>> from amulet_nbt import ByteArrayTag
        >>> import numpy
        >>> tag = ByteArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)
        """


class IntArrayTag(AbstractBaseArrayTag):
    @property
    def np_array(self) -> NDArray[numpy.int32]:
        ...

    def __len__(self) -> int:
        """
        The length of the array.
        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """

    @overload
    def __getitem__(self, item: int) -> numpy.int32:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int32]:
        ...

    @overload
    def __getitem__(self, item: ArrayLike) -> NDArray[numpy.int32]:
        """
        Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int32)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int32)
        """

    def __iter__(self) -> Iterator[numpy.int32]:
        """
        Iterate through the items in the array.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """

    def __reversed__(self) -> Iterator[numpy.int32]:
        """
        Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass
        """

    def __contains__(self, value) -> bool:
        """
        Check if an item is in the array.

        >>> from amulet_nbt import IntArrayTag
        >>> tag = IntArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """

    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: ArrayLike[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: ArrayLike[numpy.integer]) -> None:
        """
        Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """

    def __array__(self, dtype=None) -> NDArray[numpy.int32]:
        """
        Get a numpy array representation of the stored data.

        >>> from amulet_nbt import IntArrayTag
        >>> import numpy
        >>> tag = IntArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)
        """


class LongArrayTag(AbstractBaseArrayTag):
    @property
    def np_array(self) -> NDArray[numpy.int64]:
        ...

    def __len__(self) -> int:
        """
        The length of the array.
        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> len(tag)  # 3
        """

    @overload
    def __getitem__(self, item: int) -> numpy.int64:
        ...

    @overload
    def __getitem__(self, item: slice) -> NDArray[numpy.int64]:
        ...

    @overload
    def __getitem__(self, item: ArrayLike) -> NDArray[numpy.int64]:
        """
        Get item(s) from the array.

        This supports the full numpy protocol.
        If a numpy array is returned, the array data is the same as the data contained in this class.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> tag[0]  # 1
        >>> tag[:1]  # numpy.array([1], dtype=numpy.int64)
        >>> tag[numpy.array([1, 2])]  # numpy.array([2, 3], dtype=int64)
        """

    def __iter__(self) -> Iterator[numpy.int64]:
        """
        Iterate through the items in the array.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> for num in tag:
        >>>     pass
        >>> iter(tag)
        """

    def __reversed__(self) -> Iterator[numpy.int64]:
        """
        Iterate through the items in the array in reverse order.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> for num in reversed(tag):
        >>>     pass
        """

    def __contains__(self, value) -> bool:
        """
        Check if an item is in the array.

        >>> from amulet_nbt import LongArrayTag
        >>> tag = LongArrayTag([1, 2, 3])
        >>> 1 in tag  # True
        """

    @overload
    def __setitem__(self, item: int, value: numpy.integer) -> None:
        ...

    @overload
    def __setitem__(self, item: slice, value: ArrayLike[numpy.integer]) -> None:
        ...

    @overload
    def __setitem__(self, item: ArrayLike, value: ArrayLike[numpy.integer]) -> None:
        """
        Set item(s) in the array.

        This supports the full numpy protocol.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> tag[0] = 10  # [10, 2, 3]
        >>> tag[:2] = [4, 5]  # [4, 5, 3]
        >>> tag[numpy.array([1, 2])] = [6, 7]  # [4, 6, 7]
        """

    def __array__(self, dtype=None) -> NDArray[numpy.int64]:
        """
        Get a numpy array representation of the stored data.

        >>> from amulet_nbt import LongArrayTag
        >>> import numpy
        >>> tag = LongArrayTag([1, 2, 3])
        >>> arr = numpy.asarray(tag)
        """


# Alias
TAG_Byte = ByteTag
TAG_Short = ShortTag
TAG_Int = IntTag
TAG_Long = LongTag
TAG_Float = FloatTag
TAG_Double = DoubleTag
TAG_String = StringTag
TAG_Byte_Array = ByteArrayTag
TAG_List = ListTag
TAG_Compound = CompoundTag
TAG_Int_Array = IntArrayTag
TAG_Long_Array = LongArrayTag


class NamedTag(AbstractBase):
    def __init__(self, tag: AnyNBT = None, name: str | bytes = "") -> None: ...

    @property
    def tag(self) -> AnyNBT:
        ...

    @tag.setter
    def tag(self, tag: AnyNBT) -> None:
        ...

    @property
    def name(self) -> str | bytes:
        ...

    @name.setter
    def name(self, name: str | bytes) -> None:
        ...

    def to_nbt(
        self,
        *,
        preset: EncodingPreset = None,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
    ) -> bytes:
        """
        Get the data in binary NBT format.

        :param preset: A class containing compression, endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip.
        :param little_endian: Should the bytes be saved in little endian format.
        :param string_encoding: A function to encode strings to bytes.
        :return: The binary NBT representation of the class.
        """

    def save_to(
        self,
        filepath_or_buffer: bytes | str | BinaryIO | memoryview | None = None,
        *,
        preset: EncodingPreset = None,
        compressed: bool = True,
        little_endian: bool = False,
        string_encoding: StringEncoding = mutf8_encoding,
    ) -> bytes:
        """
        Convert the data to the binary NBT format. Optionally write to a file.

        If filepath_or_buffer is a valid file path in string form the data will be written to that file.

        If filepath_or_buffer is a file like object the bytes will be written to it using .write method.

        :param filepath_or_buffer: A path or writeable object to write the data to.
        :param preset: A class containing compression, endianness and encoding presets.
        :param compressed: Should the bytes be compressed with gzip. Ignored if preset is defined.
        :param little_endian: Should the bytes be saved in little endian format. Ignored if preset is defined.
        :param string_encoding: The StringEncoding to use. Ignored if preset is defined.
        :return: The binary NBT representation of the class.
        """

    def to_snbt(self, indent=None, indent_chr=None) -> str: ...

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


def load(
    filepath_or_buffer: str | bytes | BinaryIO | memoryview | None,
    *,
    preset: EncodingPreset = None,
    compressed: bool = True,
    little_endian: bool = False,
    string_encoding: StringEncoding = mutf8_encoding,
    read_offset: ReadOffset = None,
) -> NamedTag:
    """Load one binary NBT object.

    :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param preset: The encoding preset. If this is defined compressed, little_endian and string_encoding have no effect.
    :param compressed: Is the binary data gzip compressed.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param string_encoding: The bytes decoder function to parse strings. mutf8_encoding for Java, utf8_escape_encoding for Bedrock.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: NBTLoadError if an error occurred when loading the data.
    """


def load_array(
    filepath_or_buffer: str | bytes | BinaryIO | memoryview | None,
    *,
    count: int = 1,
    preset: EncodingPreset = None,
    compressed: bool = True,
    little_endian: bool = False,
    string_encoding: StringEncoding = mutf8_encoding,
    read_offset: ReadOffset = None,
) -> list[NamedTag]:
    """Load an array of binary NBT objects from a contiguous buffer.

    :param filepath_or_buffer: A string path to a file on disk, a bytes or memory view object containing the binary NBT or a file-like object to read the binary data from.
    :param count: The number of binary NBT objects to read. Use -1 to exhaust the buffer.
    :param preset: The encoding preset. If this is defined compressed, little_endian and string_encoding have no effect.
    :param compressed: Is the binary data gzip compressed. This only supports the whole buffer compressed as one.
    :param little_endian: Are the numerical values stored as little endian. True for Bedrock, False for Java.
    :param string_encoding: The bytes decoder function to parse strings. mutf8.decode_modified_utf8 for Java, amulet_nbt.utf8_escape_decoder for Bedrock.
    :param read_offset: Optional ReadOffset object to get read end offset.
    :raises: NBTLoadError if an error occurred when loading the data.
    """


def from_snbt(snbt: str) -> AbstractBaseTag:
    """
    Load Stringified NBT into a tag.
    """


SNBTType = str

IntType = Union[ByteTag, ShortTag, IntTag, LongTag]

FloatType = Union[FloatTag, DoubleTag]

NumberType = Union[ByteTag, ShortTag, IntTag, LongTag, FloatTag, DoubleTag]

ArrayType = Union[ByteArrayTag, IntArrayTag, LongArrayTag]

AnyNBT = Union[
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    IntArrayTag,
    LongArrayTag,
]
