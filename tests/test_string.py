from typing import Union
import unittest
from tests import base_type_test
import operator

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
)

AnyStr = Union[str, TAG_String]


class TestString(base_type_test.BaseTypeTest):
    values = ("", "test", "value", "value" * 500)
    num_values = (-5, 0, 1, 5)
    this_types = (TAG_String,)

    def test_init(self):
        self._test_init(str, "")

    def test_string(self):
        self.assertEqual(TAG_String(), "")
        self.assertEqual(TAG_String("test"), "test")
        self.assertEqual(TAG_String("test") + "test", "testtest")
        self.assertIsInstance(TAG_String("test") + "test", str)
        self.assertIsInstance("test" + TAG_String("test"), str)
        self.assertEqual(TAG_String("test") * 3, "testtesttest")
        self.assertIsInstance(TAG_String("test") * 3, str)

    def _test_op2(self, val1, val2, op, res_cls, res_val):
        res = op(val1, val2)
        self.assertIsInstance(res, res_cls, msg=f"{op}, {repr(val1)}, {repr(val2)}")
        self.assertEqual(res, res_val)

    def test_add(self):
        self._test_op2("val1", TAG_String("val2"), operator.add, str, "val1val2")
        self._test_op2(TAG_String("val1"), "val2", operator.add, str, "val1val2")
        self._test_op2(
            TAG_String("val1"), TAG_String("val2"), operator.add, str, "val1val2"
        )

        self._test_op2("val1", TAG_String("val2"), operator.iadd, str, "val1val2")
        self._test_op2(
            TAG_String("val1"), "val2", operator.iadd, TAG_String, "val1val2"
        )
        self._test_op2(
            TAG_String("val1"),
            TAG_String("val2"),
            operator.iadd,
            TAG_String,
            "val1val2",
        )

    def test_multiply(self):
        for num_cls in (int, TAG_Byte, TAG_Short, TAG_Int, TAG_Long):
            for num_val in self.num_values:
                self._test_op2(
                    num_cls(num_val),
                    TAG_String("val1"),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    TAG_String("val1"),
                    num_cls(num_val),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )

                self._test_op2(
                    num_cls(num_val),
                    TAG_String("val1"),
                    operator.imul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    TAG_String("val1"),
                    num_cls(num_val),
                    operator.imul,
                    TAG_String,
                    "val1" * num_val,
                )

    def test_getitem(self):
        self.assertEqual(TAG_String("test")[1], "e")
        self.assertEqual(TAG_String("test")[1:3], "es")

    def test_contains(self):
        self.assertIn("test", TAG_String("hitesthi"))

    def test_iter(self):
        it = iter(TAG_String("test"))
        self.assertEqual(next(it), "t")
        self.assertEqual(next(it), "e")
        self.assertEqual(next(it), "s")
        self.assertEqual(next(it), "t")
        with self.assertRaises(StopIteration):
            next(it)


if __name__ == "__main__":
    unittest.main()
