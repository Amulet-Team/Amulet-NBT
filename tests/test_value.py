import unittest

import numpy
from amulet_nbt import (
    AbstractBaseNumericTag,
    AbstractBaseArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    __major__,
)
from tests.base_type_test import BaseTagsTest


class TestPyData(BaseTagsTest):
    def test_default_py_type(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype().py_int, int)
            self.assertIs(dtype().py_int, 0)
        for dtype in self.float_types:
            self.assertIsInstance(dtype().py_float, float)
            self.assertAlmostEqual(dtype().py_float, 0.0)
        self.assertEqual(StringTag().py_str, "")

        # Mutable types
        l = ListTag()
        self.assertIsInstance(l.py_list, list)
        self.assertEqual(l.py_list, [])
        self.assertIsNot(l.py_list, l.py_list)

        c = CompoundTag()
        self.assertIsInstance(c.py_dict, dict)
        self.assertEqual(c.py_dict, {})
        self.assertIsNot(c.py_dict, c.py_dict)

        for dtype in self.array_types:
            a = dtype()
            self.assertIsInstance(a.np_array, numpy.ndarray)
            self.assertIs(a.np_array, a.np_array)
            self.assertIsNot(a.np_array, dtype().np_array)
            numpy.testing.assert_array_equal(a.np_array, [])

    def test_py_type(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype(5).py_int, int)
            self.assertIs(dtype(5).py_int, 5)
        for dtype in self.float_types:
            self.assertIsInstance(dtype(5.5).py_float, float)
            self.assertAlmostEqual(dtype(5.5).py_float, 5.5)
        self.assertEqual(StringTag("value").py_str, "value")

        # Mutable types
        l = ListTag([StringTag("value")])
        self.assertIsInstance(l.py_list, list)
        self.assertEqual(l.py_list, [StringTag("value")])
        self.assertIsNot(l.py_list, l.py_list)

        c = CompoundTag({"key": StringTag("value")}, key2=StringTag("value"))
        self.assertIsInstance(c.py_dict, dict)
        self.assertEqual(
            c.py_dict, {"key": StringTag("value"), "key2": StringTag("value")}
        )
        self.assertIsNot(c.py_dict, c.py_dict)

        for dtype in self.array_types:
            a = dtype([1, 2, 3])
            self.assertIsInstance(a.np_array, numpy.ndarray)
            self.assertIs(a.np_array, a.np_array)
            self.assertIsNot(a.np_array, dtype([1, 2, 3]).np_array)
            numpy.testing.assert_array_equal(a.np_array, [1, 2, 3])

    # The following ensure that the types are correct in their current state but the return types are undefined so they may change in the future.
    def test_default_py_data(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype().py_data, int)
            self.assertIs(dtype().py_data, 0)
        for dtype in self.float_types:
            self.assertIsInstance(dtype().py_data, float)
            self.assertAlmostEqual(dtype().py_data, 0.0)
        self.assertEqual(StringTag().py_data, "")

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

    def test_py_data(self):
        # Immutable types
        for dtype in self.int_types:
            self.assertIsInstance(dtype(5).py_data, int)
            self.assertIs(dtype(5).py_data, 5)
        for dtype in self.float_types:
            self.assertIsInstance(dtype(5.5).py_data, float)
            self.assertAlmostEqual(dtype(5.5).py_data, 5.5)
        self.assertEqual(StringTag("value").py_data, "value")

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
                elif __major__ > 2:
                    self.assertNotEqual(tag1(), tag2())
                elif (
                    issubclass(tag1, AbstractBaseNumericTag)
                    and issubclass(tag2, AbstractBaseNumericTag)
                ) or (
                    issubclass(tag1, (AbstractBaseArrayTag))
                    and issubclass(tag2, AbstractBaseArrayTag)
                ):
                    self.assertEqual(tag1(), tag2())
                else:
                    self.assertNotEqual(tag1(), tag2())


if __name__ == "__main__":
    unittest.main()
