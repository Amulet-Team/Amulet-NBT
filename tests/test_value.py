import unittest

import numpy
from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTag,
    CompoundTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)


class TestString(unittest.TestCase):
    def test_value(self):
        # Immutable types
        self.assertIs(ByteTag(5).value, 5)
        self.assertIs(ShortTag(5).value, 5)
        self.assertIs(IntTag(5).value, 5)
        self.assertIs(LongTag(5).value, 5)
        self.assertIsInstance(FloatTag(5.5).value, float)
        self.assertAlmostEqual(FloatTag(5.5).value, 5.5)
        self.assertIsInstance(DoubleTag(5.5).value, float)
        self.assertAlmostEqual(DoubleTag(5.5).value, 5.5)
        self.assertIs(StringTag("value").value, "value")

        # Mutable types
        self.assertIsInstance(ListTag().value, list)
        self.assertEqual(ListTag([StringTag("value")]).value, [StringTag("value")])
        self.assertIsInstance(CompoundTag().value, dict)
        self.assertEqual(
            CompoundTag(key=StringTag("value")).value, {"key": StringTag("value")}
        )
        self.assertIsInstance(ByteArrayTag().value, numpy.ndarray)
        self.assertIsNot(ByteArrayTag().value, ByteArrayTag().value)
        numpy.testing.assert_array_equal(ByteArrayTag([1, 2, 3]).value, [1, 2, 3])
        self.assertIsInstance(IntArrayTag().value, numpy.ndarray)
        self.assertIsNot(IntArrayTag().value, IntArrayTag().value)
        numpy.testing.assert_array_equal(IntArrayTag([1, 2, 3]).value, [1, 2, 3])
        self.assertIsInstance(LongArrayTag().value, numpy.ndarray)
        self.assertIsNot(LongArrayTag().value, LongArrayTag().value)
        numpy.testing.assert_array_equal(LongArrayTag([1, 2, 3]).value, [1, 2, 3])


if __name__ == "__main__":
    unittest.main()
