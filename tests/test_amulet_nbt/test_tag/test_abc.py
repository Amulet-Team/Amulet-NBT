import unittest
from abc import ABC, abstractmethod
import faulthandler
faulthandler.enable()

from amulet_nbt import ByteTag, ShortTag, IntTag, LongTag, FloatTag, DoubleTag, StringTag, ByteArrayTag, ListTag, CompoundTag, IntArrayTag, LongArrayTag


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
    int_types = (
        ByteTag,
        ShortTag,
        IntTag,
        LongTag,
    )
    float_types = (
        FloatTag,
        DoubleTag,
    )
    numerical_types = int_types + float_types
    string_types = (StringTag,)
    array_types = (
        ByteArrayTag,
        IntArrayTag,
        LongArrayTag,
    )
    container_types = (
        ListTag,
        CompoundTag,
    )
    nbt_types = (
        numerical_types
        + string_types
        + array_types
        + container_types
    )

    not_nbt = (None, True, False, 0, 0.0, "str", [], {}, set())

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


class AbstractBaseTagTestCase(AbstractBaseTestCase):
    @abstractmethod
    def test_py_data(self) -> None:
        raise NotImplementedError


class AbstractBaseImmutableTagTestCase(AbstractBaseTagTestCase):
    pass


class AbstractBaseMutableTagTestCase(AbstractBaseTagTestCase):
    pass


class CreateAbstractTestCase(unittest.TestCase):
    def test_create_abc(self) -> None:
        pass

    def test_create_abc_tag(self) -> None:
        pass

    def test_create_abc_immutable_tag(self) -> None:
        pass

    def test_create_abc_mutable_tag(self) -> None:
        pass
