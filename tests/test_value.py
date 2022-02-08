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
        self.assertIs(ByteTag(5).py_data, 5)
        self.assertIs(ShortTag(5).py_data, 5)
        self.assertIs(IntTag(5).py_data, 5)
        self.assertIs(LongTag(5).py_data, 5)
        self.assertIsInstance(FloatTag(5.5).py_data, float)
        self.assertAlmostEqual(FloatTag(5.5).py_data, 5.5)
        self.assertIsInstance(DoubleTag(5.5).py_data, float)
        self.assertAlmostEqual(DoubleTag(5.5).py_data, 5.5)
        self.assertIs(StringTag("value").py_data, "value")

        # Mutable types
        self.assertIsInstance(ListTag().py_data, list)
        self.assertEqual(ListTag([StringTag("value")]).py_data, [StringTag("value")])
        self.assertIsInstance(CompoundTag().py_data, dict)
        self.assertEqual(
            CompoundTag(key=StringTag("value")).py_data, {"key": StringTag("value")}
        )
        self.assertIsInstance(ByteArrayTag().py_data, numpy.ndarray)
        self.assertIsNot(ByteArrayTag().py_data, ByteArrayTag().py_data)
        numpy.testing.assert_array_equal(ByteArrayTag([1, 2, 3]).py_data, [1, 2, 3])
        self.assertIsInstance(IntArrayTag().py_data, numpy.ndarray)
        self.assertIsNot(IntArrayTag().py_data, IntArrayTag().py_data)
        numpy.testing.assert_array_equal(IntArrayTag([1, 2, 3]).py_data, [1, 2, 3])
        self.assertIsInstance(LongArrayTag().py_data, numpy.ndarray)
        self.assertIsNot(LongArrayTag().py_data, LongArrayTag().py_data)
        numpy.testing.assert_array_equal(LongArrayTag([1, 2, 3]).py_data, [1, 2, 3])


if __name__ == "__main__":
    unittest.main()
