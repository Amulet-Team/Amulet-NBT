import unittest
from copy import deepcopy

from amulet_nbt import (
    BaseTag,
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
)


class TestNumerical(unittest.TestCase):
    def test_strict_equals(self):
        tags = (
            5,
            5.0,
            "value",
            [0],
            {"key", 0},
            ByteTag(),
            ByteTag(5),
            ShortTag(),
            ShortTag(5),
            IntTag(),
            IntTag(5),
            LongTag(),
            LongTag(5),
            FloatTag(),
            FloatTag(5.0),
            DoubleTag(),
            DoubleTag(5.0),
            StringTag(),
            StringTag("value"),
            ListTag(),
            ListTag([ByteTag()]),
            ListTag([ShortTag()]),
            ListTag([IntTag()]),
            ListTag([LongTag()]),
            ListTag([FloatTag()]),
            ListTag([DoubleTag()]),
            ListTag([StringTag()]),
            ListTag([ListTag()]),
            ListTag([CompoundTag()]),
            ListTag([ByteArrayTag()]),
            ListTag([IntArrayTag()]),
            ListTag([LongArrayTag()]),
            CompoundTag(),
            CompoundTag({"key": ByteTag()}),
            CompoundTag({"key": ShortTag()}),
            CompoundTag({"key": IntTag()}),
            CompoundTag({"key": LongTag()}),
            CompoundTag({"key": FloatTag()}),
            CompoundTag({"key": DoubleTag()}),
            CompoundTag({"key": StringTag()}),
            CompoundTag({"key": ListTag()}),
            CompoundTag({"key": CompoundTag()}),
            CompoundTag({"key": ByteArrayTag()}),
            CompoundTag({"key": IntArrayTag()}),
            CompoundTag({"key": LongArrayTag()}),
            ByteArrayTag(),
            ByteArrayTag([1, 2, 3]),
            IntArrayTag(),
            IntArrayTag([1, 2, 3]),
            LongArrayTag(),
            LongArrayTag([1, 2, 3]),
        )
        for tag1 in tags:
            for tag2 in tags:
                if isinstance(tag1, BaseTag):
                    if tag1 is tag2:
                        self.assertTrue(
                            tag1.strict_equals(tag2), msg=f"{repr(tag1)} {repr(tag2)}"
                        )
                        self.assertTrue(
                            tag1.strict_equals(deepcopy(tag2)),
                            msg=f"{repr(tag1)} {repr(tag2)}",
                        )
                    else:
                        self.assertFalse(
                            tag1.strict_equals(tag2), msg=f"{repr(tag1)} {repr(tag2)}"
                        )


if __name__ == "__main__":
    unittest.main()
