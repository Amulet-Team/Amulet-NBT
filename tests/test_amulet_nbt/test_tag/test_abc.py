from abc import ABC, abstractmethod
from typing import Any
import faulthandler

faulthandler.enable()

from amulet_nbt import (
    AbstractBaseTag,
    AbstractBaseNumericTag,
    AbstractBaseIntTag,
    AbstractBaseFloatTag,
    AbstractBaseArrayTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ByteArrayTag,
    ListTag,
    CompoundTag,
    IntArrayTag,
    LongArrayTag,
)


TagNameMap = {
    ByteTag: "byte",
    ShortTag: "short",
    IntTag: "int",
    LongTag: "long",
    FloatTag: "float",
    DoubleTag: "double",
    StringTag: "string",
    ListTag: "list",
    CompoundTag: "compound",
    ByteArrayTag: "byte_array",
    IntArrayTag: "int_array",
    LongArrayTag: "long_array",
}


class AbstractBaseTestCase(ABC):
    int_types: tuple[type[AbstractBaseIntTag], ...] = (
        ByteTag,
        ShortTag,
        IntTag,
        LongTag,
    )
    float_types: tuple[type[AbstractBaseFloatTag], ...] = (
        FloatTag,
        DoubleTag,
    )
    numerical_types: tuple[type[AbstractBaseNumericTag], ...] = int_types + float_types
    string_types: tuple[type[StringTag]] = (StringTag,)
    array_types: tuple[type[AbstractBaseArrayTag], ...] = (
        ByteArrayTag,
        IntArrayTag,
        LongArrayTag,
    )
    container_types: tuple[type[ListTag | CompoundTag]] = (
        ListTag,
        CompoundTag,
    )
    nbt_types: tuple[type[AbstractBaseTag], ...] = (
        numerical_types + string_types + array_types + container_types
    )

    not_nbt: tuple[Any, ...] = (None, True, False, 0, 0.0, "str", [], {}, set())

    @abstractmethod
    def test_constructor(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_equal(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_repr(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_str(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_pickle(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_copy(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_deepcopy(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_hash(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_instance(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_to_nbt(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_from_nbt(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_to_snbt(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_from_snbt(self) -> None:
        raise NotImplementedError


class AbstractBaseTagTestCase(AbstractBaseTestCase):
    @abstractmethod
    def test_py_data(self) -> None:
        raise NotImplementedError


class AbstractBaseImmutableTagTestCase(AbstractBaseTagTestCase):
    pass


class AbstractBaseMutableTagTestCase(AbstractBaseTagTestCase):
    pass
