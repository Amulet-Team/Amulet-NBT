import unittest

import numpy
from amulet_nbt import (
    StringTag,
    ListTag,
    CompoundTag,
)
from tests.base_type_test import BaseTagsTest


class TestPyData(BaseTagsTest):
    def test_default_value(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype().py_data, int)
            self.assertIs(dtype().py_data, 0)
        for dtype in self.float_types:
            self.assertIsInstance(dtype().py_data, float)
            self.assertAlmostEqual(dtype().py_data, 0.0)
        self.assertIs(StringTag().py_data, "")

        # Mutable types
        l = ListTag()
        self.assertIsInstance(l.py_data, list)
        self.assertEqual(l.py_data, [])
        self.assertIsNot(l.py_data, l.py_data)

        c = CompoundTag()
        self.assertIsInstance(c.py_data, dict)
        self.assertEqual(c.py_data, {})
        self.assertIsNot(c.py_data, c.py_data)

        for dtype in self.array_types:
            a = dtype()
            self.assertIsInstance(a.py_data, numpy.ndarray)
            self.assertIs(a.py_data, a.py_data)
            self.assertIsNot(a.py_data, dtype().py_data)
            numpy.testing.assert_array_equal(a.py_data, [])

    def test_value(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype(5).py_data, int)
            self.assertIs(dtype(5).py_data, 5)
        for dtype in self.float_types:
            self.assertIsInstance(dtype(5.5).py_data, float)
            self.assertAlmostEqual(dtype(5.5).py_data, 5.5)
        self.assertIs(StringTag("value").py_data, "value")

        # Mutable types
        l = ListTag([StringTag("value")])
        self.assertIsInstance(l.py_data, list)
        self.assertEqual(l.py_data, [StringTag("value")])
        self.assertIsNot(l.py_data, l.py_data)

        c = CompoundTag({"key": StringTag("value")}, key2=StringTag("value"))
        self.assertIsInstance(c.py_data, dict)
        self.assertEqual(
            c.py_data, {"key": StringTag("value"), "key2": StringTag("value")}
        )
        self.assertIsNot(c.py_data, c.py_data)

        for dtype in self.array_types:
            a = dtype([1, 2, 3])
            self.assertIsInstance(a.py_data, numpy.ndarray)
            self.assertIs(a.py_data, a.py_data)
            self.assertIsNot(a.py_data, dtype([1, 2, 3]).py_data)
            numpy.testing.assert_array_equal(a.py_data, [1, 2, 3])

    def test_equal(self):
        for tag1 in self.nbt_types:
            for tag2 in self.nbt_types:
                if tag1 is tag2:
                    self.assertEqual(tag1(), tag2())
                else:
                    self.assertNotEqual(tag1(), tag2())


if __name__ == "__main__":
    unittest.main()
