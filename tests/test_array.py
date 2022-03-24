from typing import Tuple, Type
import unittest
import sys

from tests import base_type_test
import numpy
import numpy.testing

from amulet_nbt import (
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)


class TestArray(base_type_test.BaseTypeTest):
    @property
    def this_types(
        self,
    ) -> Tuple[Type[ByteArrayTag], Type[IntArrayTag], Type[LongArrayTag]]:
        return self.array_types

    @property
    def values(self):
        values = []
        for t in (list, tuple, numpy.array) + self.array_types:
            for v in ([], [1], [1, 2, 3]):
                values.append(t(v))
        return values

    def test_init(self):
        self._test_init(lambda x: numpy.array(x, dtype=numpy.int64), [])

    def test_array_overflow(self):
        b_arr = ByteArrayTag([0])
        b_arr += 2**7
        i_arr = IntArrayTag([0])
        i_arr += 2**31
        # numpy throws an error when overflowing int64
        # l_arr = LongArrayTag([0])
        # l_arr += 2 ** 63

        self.assertTrue(numpy.array_equal(b_arr, [-(2**7)]))
        self.assertTrue(numpy.array_equal(i_arr, [-(2**31)]))
        # self.assertTrue(numpy.array_equal(l_arr, [-(2 ** 63)]))

        b_arr -= 1
        i_arr -= 1
        # l_arr -= 1

        self.assertTrue(numpy.array_equal(b_arr, [2**7 - 1]))
        self.assertTrue(numpy.array_equal(i_arr, [2**31 - 1]))
        # self.assertTrue(numpy.array_equal(l_arr, [2 ** 63 - 1]))

    def test_dtype(self):
        self.assertEqual(numpy.int8, ByteArrayTag().dtype)
        self.assertEqual(numpy.int32, IntArrayTag().dtype)
        self.assertEqual(numpy.int64, LongArrayTag().dtype)

    def test_itemsize(self):
        self.assertEqual(1, ByteArrayTag().itemsize)
        self.assertEqual(4, IntArrayTag().itemsize)
        self.assertEqual(8, LongArrayTag().itemsize)

    def test_nbytes(self):
        self.assertEqual(1 * 3, ByteArrayTag([1, 2, 3]).nbytes)
        self.assertEqual(4 * 3, IntArrayTag([1, 2, 3]).nbytes)
        self.assertEqual(8 * 3, LongArrayTag([1, 2, 3]).nbytes)

    def test_ndim(self):
        self.assertEqual(1, ByteArrayTag([1, 2, 3]).ndim)
        self.assertEqual(1, IntArrayTag([1, 2, 3]).ndim)
        self.assertEqual(1, LongArrayTag([1, 2, 3]).ndim)

    def test_size(self):
        self.assertEqual(3, ByteArrayTag([1, 2, 3]).size)
        self.assertEqual(3, IntArrayTag([1, 2, 3]).size)
        self.assertEqual(3, LongArrayTag([1, 2, 3]).size)

    def test_dir(self):
        pass

    def test_eq(self):
        for dtype1 in self.array_types:  # + (numpy.array,):
            for dtype2 in self.array_types + (numpy.array,):
                self.assertEqual(
                    dtype1([-1, 1, 2, 3, 4, 5]), dtype2([-1, 1, 2, 3, 4, 5])
                )

    def test_ge(self):
        for dtype1 in self.array_types + (numpy.array,):
            for dtype2 in self.array_types + (numpy.array,):
                a = dtype1([4, -1, 10, 4])
                b = dtype2([1, 2, 3, 4])
                numpy.testing.assert_array_equal([True, False, True, True], a >= b)

    def test_gt(self):
        for dtype1 in self.array_types + (numpy.array,):
            for dtype2 in self.array_types + (numpy.array,):
                a = dtype1([4, -1, 10, 4])
                b = dtype2([1, 2, 3, 4])
                numpy.testing.assert_array_equal([True, False, True, False], a > b)

    def test_le(self):
        for dtype1 in self.array_types + (numpy.array,):
            for dtype2 in self.array_types + (numpy.array,):
                a = dtype1([1, 2, 3, 4])
                b = dtype2([4, -1, 10, 4])
                numpy.testing.assert_array_equal([True, False, True, True], a <= b)

    def test_lt(self):
        for dtype1 in self.array_types + (numpy.array,):
            for dtype2 in self.array_types + (numpy.array,):
                a = dtype1([1, 2, 3, 4])
                b = dtype2([4, -1, 10, 4])
                numpy.testing.assert_array_equal([True, False, True, False], a < b)

    def test_shape(self):
        self.assertEqual((3,), ByteArrayTag([1, 2, 3]).shape)
        self.assertEqual((3,), IntArrayTag([1, 2, 3]).shape)
        self.assertEqual((3,), LongArrayTag([1, 2, 3]).shape)

    def test_strides(self):
        self.assertEqual((1,), ByteArrayTag([1, 2, 3]).strides)
        self.assertEqual((4,), IntArrayTag([1, 2, 3]).strides)
        self.assertEqual((8,), LongArrayTag([1, 2, 3]).strides)
        self.assertEqual((2,), ByteArrayTag([1, 2, 3])[::2].strides)
        self.assertEqual((8,), IntArrayTag([1, 2, 3])[::2].strides)
        self.assertEqual((16,), LongArrayTag([1, 2, 3])[::2].strides)

    def test_getitem(self):
        self.assertEqual(2, ByteArrayTag([1, 2, 3])[1])
        self.assertEqual(2, IntArrayTag([1, 2, 3])[1])
        self.assertEqual(2, LongArrayTag([1, 2, 3])[1])

    def test_setitem(self):
        pass

    def test_array(self):
        pass

    def test_len(self):
        self.assertEqual(3, len(ByteArrayTag([1, 2, 3])))
        self.assertEqual(3, len(IntArrayTag([1, 2, 3])))
        self.assertEqual(3, len(LongArrayTag([1, 2, 3])))

    def test_add(self):
        pass

    def test_sub(self):
        pass

    def test_mul(self):
        pass

    def test_matmul(self):
        pass

    def test_truediv(self):
        pass

    def test_floordiv(self):
        pass

    def test_mod(self):
        pass

    def test_divmod(self):
        pass

    def test_pow(self):
        pass

    def test_lshift(self):
        pass

    def test_rshift(self):
        pass

    def test_and(self):
        pass

    def test_xor(self):
        pass

    def test_or(self):
        pass

    def test_neg(self):
        pass

    def test_pos(self):
        pass

    def test_abs(self):
        pass


if __name__ == "__main__":
    unittest.main()
