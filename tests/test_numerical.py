from typing import Iterable, Tuple, Union

from tests import base_type_test

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

NUMERICAL_TYPES = (
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
)

AnyNum = Union[int, float, BaseNumericTag]


class TestNumerical(base_type_test.BaseTypeTest):
    def test_init_empty(self):
        for tag in NUMERICAL_TYPES:
            self.assertEqual(tag(), 0, msg=tag.__name__)

    def test_init(self):
        for tag_cls in NUMERICAL_TYPES:
            for val in (5, -5, 5.0, -5.0):
                for tag in self._iter_tags(val):
                    self.assertEqual(tag_cls(tag), val, msg=f"{tag_cls.__name__}({repr(tag)})")

    def _iter_tags(self, val) -> Iterable[AnyNum]:
        yield val
        for tag in NUMERICAL_TYPES:
            yield tag(val)

    def _iter_two_tags(self, val) -> Iterable[Tuple[AnyNum, AnyNum]]:
        for tag1 in self._iter_tags(val):
            for tag2 in self._iter_tags(val):
                yield tag1, tag2

    def test_not_equal(self):
        for tag1 in self._iter_tags(5):
            for tag2 in self._iter_tags(10):
                self.assertNotEqual(tag1, tag2, msg=f"{tag1} == {tag2}")

    def test_numerical_zero_equal(self):
        for tag1, tag2 in self._iter_two_tags(0):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

    def test_numerical_positive_equal(self):
        for tag1, tag2 in self._iter_two_tags(50):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

    def test_numerical_negative_equal(self):
        for tag1, tag2 in self._iter_two_tags(-50):
            self.assertEqual(tag1, tag2, msg=f"{tag1} != {tag2}")

    def _test_op(self, val1, val2, op, op_char):
        for tag1 in self._iter_tags(val1):
            for tag2 in self._iter_tags(val2):
                val1_, val2_ = val1, val2
                if isinstance(tag1, BaseIntTag):
                    val1_ = int(val1_)
                elif isinstance(tag1, BaseFloatTag):
                    val1_ = float(val1_)
                if isinstance(tag2, BaseIntTag):
                    val2_ = int(val2_)
                elif isinstance(tag2, BaseFloatTag):
                    val2_ = float(val2_)
                ground = op(val1_, val2_)
                test = op(tag1, tag2)
                self.assertEqual(
                    test, ground, msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}"
                )
                self.assertIsInstance(
                    test,
                    ground.__class__,
                    msg=f"{repr(tag1)} {op_char} {repr(tag2)} != {ground}",
                )

    def _test_addition(self, val1, val2):
        self._test_op(val1, val2, lambda x, y: x + y, "+")

    def test_numerical_addition(self):
        for val1 in (5, 5.5):
            for val2 in (5, 5.5):
                self._test_addition(val1, val2)

    def _test_subtraction(self, val1, val2):
        self._test_op(val1, val2, lambda x, y: x - y, "-")

    def test_numerical_subtraction(self):
        for val1 in (5, 5.5):
            for val2 in (5, 5.5):
                self._test_subtraction(val1, val2)

    def test_numerical_overflow(self):
        b = TAG_Byte()
        s = TAG_Short()
        i = TAG_Int()
        l = TAG_Long()

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

    def test_errors(self):
        invalid_inputs = ("str", TAG_String(), [], TAG_List(), {}, TAG_Compound())
        for inp in invalid_inputs:
            for tag in NUMERICAL_TYPES:
                with self.assertRaises(Exception, msg=f"{tag.__name__}({inp})"):
                    tag(inp)
                with self.assertRaises(Exception, msg=f"{tag.__name__}() + {inp}"):
                    tag() + inp
