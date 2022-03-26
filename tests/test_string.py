import sys
from typing import Union
import unittest
from tests import base_type_test
import operator

from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    StringTag,
)

AnyStr = Union[str, StringTag]


class TestString(base_type_test.BaseTypeTest):
    values = ("", "test", "value", "value" * 500)
    num_values = (-5, 0, 1, 5)
    this_types = (StringTag,)

    def test_init(self):
        self._test_init(str, "")

    def _test_op2(self, val1, val2, op, res_cls, res_val):
        res = op(val1, val2)
        self.assertIsInstance(res, res_cls, msg=f"{op}, {repr(val1)}, {repr(val2)}")
        self.assertEqual(res_val, res)

    def assertStrictEqual(self, expected_type, expected_value, test):
        self.assertIsInstance(test, expected_type)
        self.assertEqual(expected_value, test)

    def test_contains(self):
        self.assertIn("test", StringTag("hitesthi"))

    def test_eq(self):
        self.assertEqual(StringTag("val1"), StringTag("val1"))
        self.assertNotEqual(StringTag("val1"), StringTag("Val1"))
        self.assertNotEqual(StringTag("val1"), StringTag("val2"))

    def test_comp(self):
        self.assertLess(StringTag("val1"), StringTag("val2"))
        self.assertLessEqual(StringTag("val1"), StringTag("val2"))
        self.assertLessEqual(StringTag("val1"), StringTag("val1"))
        self.assertGreater(StringTag("val2"), StringTag("val1"))
        self.assertGreaterEqual(StringTag("val2"), StringTag("val1"))
        self.assertGreaterEqual(StringTag("val1"), StringTag("val1"))

    def test_getitem(self):
        self.assertEqual("e", StringTag("test")[1])
        self.assertEqual("es", StringTag("test")[1:3])

    def test_iter(self):
        it = iter(StringTag("test"))
        self.assertEqual("t", next(it))
        self.assertEqual("e", next(it))
        self.assertEqual("s", next(it))
        self.assertEqual("t", next(it))
        with self.assertRaises(StopIteration):
            next(it)

    def test_len(self):
        self.assertEqual(4, len(StringTag("test")))

    def test_str(self):
        self.assertStrictEqual(str, "test", str(StringTag("test")))


if __name__ == "__main__":
    unittest.main()
