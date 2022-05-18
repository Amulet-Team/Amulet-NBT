import unittest
from typing import Iterable, Tuple, Any, Type

from amulet_nbt import (
    AbstractBaseTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
)


class BaseTagsTest(unittest.TestCase):
    def setUp(self):
        self.int_types = (
            ByteTag,
            ShortTag,
            IntTag,
            LongTag,
        )
        self.float_types = (
            FloatTag,
            DoubleTag,
        )
        self.numerical_types = self.int_types + self.float_types
        self.string_types = (StringTag,)
        self.array_types = (
            ByteArrayTag,
            IntArrayTag,
            LongArrayTag,
        )
        self.container_types = (
            ListTag,
            CompoundTag,
        )
        self.nbt_types = (
            self.numerical_types
            + self.string_types
            + self.array_types
            + self.container_types
        )

        self.not_nbt = (None, True, False, 0, 0.0, "str", [], {}, set())


class BaseTypeTest(BaseTagsTest):
    def _iter_instance(self):
        for cls in self.nbt_types:
            yield cls()

    @property
    def values(self) -> Tuple[Any, ...]:
        raise NotImplementedError

    @property
    def this_types(self) -> Tuple[Type[AbstractBaseTag], ...]:
        raise NotImplementedError

    def _iter_values(self) -> Iterable[Tuple[Any, Any]]:
        for val1 in self.values:
            for val2 in self.values:
                yield val1, val2

    def _iter_tags(self, val: Any) -> Iterable[Any]:
        yield val
        for tag in self.this_types:
            yield tag(val)

    def _iter_two_tags(self, val: Any) -> Iterable[Tuple[Any, Any]]:
        for tag1 in self._iter_tags(val):
            for tag2 in self._iter_tags(val):
                yield tag1, tag2

    def _test_init(self, cls, default, invalid=()):
        for tag_cls in self.this_types:
            # check init with no inputs
            self.assertEqual(tag_cls(), tag_cls(default), msg=tag_cls.__name__)
            # check init with valid inputs
            for val in self.values:
                for tag in self._iter_tags(val):
                    self.assertEqual(
                        tag_cls(tag),
                        tag_cls(val),
                        msg=f"{tag_cls.__name__}({repr(tag)})",
                    )
            # check init with various inputs. Should match the python behaviour.
            for inp in self.not_nbt + tuple(self._iter_instance()):
                if isinstance(inp, invalid):
                    valid = False
                else:
                    try:
                        cls(inp)
                    except:
                        valid = False
                    else:
                        valid = True

                if valid:
                    tag_cls(inp)
                else:
                    with self.assertRaises(
                        Exception, msg=f"{tag_cls.__name__}({repr(inp)})"
                    ):
                        tag_cls(inp)

    def test_init(self):
        raise NotImplementedError
