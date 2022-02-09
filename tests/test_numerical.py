import unittest
from typing import Union, Callable, Any
import operator
from copy import deepcopy
import math

from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
)

AnyNum = Union[int, float, BaseNumericTag]


class TestNumerical(base_type_test.BaseTypeTest):
    values = (3, -3, 3.0, -3.0)

    @property
    def this_types(self):
        return self.numerical_types

    def test_init(self):
        for tag_cls in self.numerical_types:
            self.assertEqual(tag_cls(), 0, msg=tag_cls.__name__)
            for val in self.values:
                for tag in self._iter_tags(val):
                    self.assertEqual(
                        tag_cls(tag), val, msg=f"{tag_cls.__name__}({repr(tag)})"
                    )
            for inp in self.not_nbt + tuple(self._iter_instance()):
                if isinstance(inp, (bool, int, float, BaseNumericTag)):
                    tag_cls(inp)
                else:
                    with self.assertRaises(
                        Exception, msg=f"{tag_cls.__name__}({repr(inp)})"
                    ):
                        tag_cls(inp)

    def test_not_equal(self):
        for tag1 in self._iter_tags(5):
            for tag2 in self._iter_tags(10):
                self.assertNotEqual(tag1, tag2, msg=f"{tag1} == {tag2}")

    def test_zero_equal(self):
        for tag1, tag2 in self._iter_two_tags(0):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

    def test_positive_equal(self):
        for tag1, tag2 in self._iter_two_tags(50):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

    def test_negative_equal(self):
        for tag1, tag2 in self._iter_two_tags(-50):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

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
                val1_ = self._fix_type(tag1, val1)
                val2_ = self._fix_type(tag2, val2)
                ground = op(val1_, val2_)
                test = op(tag1, tag2)
                self.assertEqual(
                    test, ground, msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}"
                )
                self.assertIsInstance(
                    test,
                    ground.__class__,
                    msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground.__class__}",
                )

    def _test_iop(
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
                tag1_copy = deepcopy(tag1)
                val1_ = self._fix_type(tag1, val1)
                val2_ = self._fix_type(tag2, val2)
                ground = op(val1_, val2_)
                test = op(tag1_copy, tag2)

                if isinstance(tag1, BaseNumericTag):
                    ground = self._fix_type(tag1, ground)
                    cls = tag1.__class__
                else:
                    cls = ground.__class__

                if isinstance(ground, float):
                    self.assertAlmostEqual(
                        test,
                        ground,
                        msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}",
                    )
                else:
                    self.assertEqual(
                        test,
                        ground,
                        msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}",
                    )
                self.assertIsInstance(
                    test,
                    cls,
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
            self._test_op(val1, val2, operator.add, "+")
            self._test_iop(val1, val2, operator.iadd, "+=")
            self._test_op(val1, val2, operator.sub, "-")
            self._test_iop(val1, val2, operator.isub, "-=")
            self._test_op(val1, val2, operator.mul, "*")
            self._test_iop(val1, val2, operator.imul, "*=")
            self._test_op(val1, val2, operator.truediv, "/")
            self._test_iop(val1, val2, operator.itruediv, "/=")
            self._test_op(val1, val2, operator.floordiv, "//")
            self._test_iop(val1, val2, operator.ifloordiv, "//=")
            self._test_op(val1, val2, operator.mod, "%")
            self._test_iop(val1, val2, operator.imod, "%=")
            self._test_op(val1, val2, operator.pow, "**")
            self._test_iop(val1, val2, operator.ipow, "**=")
            self._test_op(val1, val2, operator.lt, "<")
            self._test_op(val1, val2, operator.le, "<=")
            self._test_op(val1, val2, operator.gt, ">")
            self._test_op(val1, val2, operator.ge, ">=")
        for val1 in self.values:
            self._test_single_op(val1, operator.neg, "-")
            self._test_single_op(val1, operator.pos, "+")
            self._test_single_op(val1, abs, "abs")
            self._test_single_op(val1, int, "int")
            self._test_single_op(val1, float, "float")
            self._test_single_op(val1, round, "round")
            self._test_single_op(val1, math.trunc, "math.trunc")
            self._test_single_op(val1, math.floor, "math.floor")
            self._test_single_op(val1, math.ceil, "math.ceil")
            self._test_single_op(val1, bool, "bool")

    def test_int_operators(self):
        for val1, val2 in self._iter_values():
            if val2 >= 0:
                self._test_op(val1, val2, operator.lshift, "<<", (float, BaseFloatTag))
                self._test_iop(
                    val1, val2, operator.ilshift, "<<=", (float, BaseFloatTag)
                )
                self._test_op(val1, val2, operator.rshift, ">>", (float, BaseFloatTag))
                self._test_iop(
                    val1, val2, operator.irshift, ">>=", (float, BaseFloatTag)
                )
            self._test_op(val1, val2, operator.and_, "&", (float, BaseFloatTag))
            self._test_iop(val1, val2, operator.iand, "&=", (float, BaseFloatTag))
            self._test_op(val1, val2, operator.xor, "^", (float, BaseFloatTag))
            self._test_iop(val1, val2, operator.ixor, "^=", (float, BaseFloatTag))
            self._test_op(val1, val2, operator.or_, "|", (float, BaseFloatTag))
            self._test_iop(val1, val2, operator.ior, "|=", (float, BaseFloatTag))
        for val1 in self.values:
            self._test_single_op(val1, operator.invert, "~", (float, BaseFloatTag))

    def test_overflow(self):
        b = ByteTag()
        s = ShortTag()
        i = IntTag()
        l = LongTag()

        b += 2 ** 7
        s += 2 ** 15
        i += 2 ** 31
        l += 2 ** 63

        self.assertEqual(b, -(2 ** 7))
        self.assertEqual(s, -(2 ** 15))
        self.assertEqual(i, -(2 ** 31))
        self.assertEqual(l, -(2 ** 63))

        b -= 1
        s -= 1
        i -= 1
        l -= 1

        self.assertEqual(b, 2 ** 7 - 1)
        self.assertEqual(s, 2 ** 15 - 1)
        self.assertEqual(i, 2 ** 31 - 1)
        self.assertEqual(l, 2 ** 63 - 1)


if __name__ == "__main__":
    unittest.main()
