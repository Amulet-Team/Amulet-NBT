import unittest
from typing import Union, Callable
import operator
import math

from tests import base_type_test

from amulet_nbt import (
    BaseTag,
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
)

AnyNum = Union[int, float, BaseNumericTag]


class TestNumerical(base_type_test.BaseTypeTest):
    values = (3, -3, 3.0, -3.0)

    @property
    def this_types(self):
        return self.numerical_types

    def test_init(self):
        for tag_cls in self.numerical_types:
            self.assertEqual(tag_cls().py_data, 0, msg=tag_cls.__name__)
            self.assertEqual(tag_cls(), tag_cls(), msg=tag_cls.__name__)
            for val in self.values:
                for tag in self._iter_tags(val):
                    self.assertEqual(
                        tag_cls(tag),
                        tag_cls(val),
                        msg=f"{tag_cls.__name__}({repr(tag)})",
                    )
            for inp in self.not_nbt + tuple(self._iter_instance()):
                if isinstance(inp, (bool, int, float, BaseNumericTag)):
                    tag_cls(inp)
                else:
                    with self.assertRaises(
                        Exception, msg=f"{tag_cls.__name__}({repr(inp)})"
                    ):
                        tag_cls(inp)

    def test_equal(self):
        for value in (-50, 0, 50):
            for tag1, tag2 in self._iter_two_tags(value):
                if tag1.__class__ is tag2.__class__:
                    self.assertEqual(tag1, tag2, msg=f"{tag1} == {tag2}")
                else:
                    self.assertNotEqual(tag1, tag2, msg=f"{tag1} == {tag2}")

        for tag1 in self._iter_tags(5):
            for tag2 in self._iter_tags(10):
                self.assertNotEqual(tag1, tag2, msg=f"{tag1} == {tag2}")

    @staticmethod
    def _fix_type(tag: AnyNum, val: AnyNum):
        if isinstance(tag, BaseIntTag):
            val = int(val)
        elif isinstance(tag, BaseFloatTag):
            val = float(val)
        return val

    def _test_op(
        self,
        val1: AnyNum,
        val2: AnyNum,
        op: Callable[[AnyNum, AnyNum], AnyNum],
        op_char: str,
        skip_types=(),
    ):
        for tag1 in self._iter_tags(val1):
            for tag2 in self._iter_tags(val2):
                if skip_types and (
                    isinstance(tag1, skip_types) or isinstance(tag2, skip_types)
                ):
                    continue
                if tag1.__class__ is tag2.__class__ or (
                    not isinstance(tag1, BaseTag) and not isinstance(tag2, BaseTag)
                ):
                    test = op(tag1, tag2)
                else:
                    with self.assertRaises(
                        TypeError, msg=f"{op}, {tag1.__class__}, {tag2.__class__}"
                    ):
                        op(tag1, tag2)
                    continue
                val1_ = self._fix_type(tag1, val1)
                val2_ = self._fix_type(tag2, val2)
                ground = op(val1_, val2_)

                self.assertEqual(
                    test, ground, msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}"
                )
                self.assertIsInstance(
                    test,
                    ground.__class__,
                    msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground.__class__}",
                )

    def _test_single_op(
        self,
        val1: AnyNum,
        op: Callable[[AnyNum], AnyNum],
        op_name: str,
        skip_types=(),
    ):
        for tag1 in self._iter_tags(val1):
            if skip_types and isinstance(tag1, skip_types):
                continue
            val1_ = self._fix_type(tag1, val1)
            ground = op(val1_)
            test = op(tag1)

            if isinstance(ground, float):
                self.assertAlmostEqual(
                    test, ground, msg=f"{op_name}({repr(tag1)}) != {ground}"
                )
            else:
                self.assertEqual(
                    test, ground, msg=f"{op_name}({repr(tag1)}) != {ground}"
                )
            self.assertIsInstance(
                test,
                ground.__class__,
                msg=f"{op_name}({repr(tag1)}) != {ground.__class__}",
            )

    def test_numerical_operators(self):
        for val1, val2 in self._iter_values():
            self._test_op(val1, val2, operator.lt, "<")
            self._test_op(val1, val2, operator.le, "<=")
            self._test_op(val1, val2, operator.gt, ">")
            self._test_op(val1, val2, operator.ge, ">=")
        for val1 in self.values:
            self._test_single_op(val1, int, "int")
            self._test_single_op(val1, float, "float")
            self._test_single_op(val1, bool, "bool")


if __name__ == "__main__":
    unittest.main()
