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

    def test_transpose(self):
        for dtype in self.this_types:
            # array is 1D so transpose is itself
            numpy.testing.assert_array_equal([1, 2, 3], dtype([1, 2, 3]).T)
            numpy.testing.assert_array_equal(
                [1, 2, 3], numpy.transpose(dtype([1, 2, 3]))
            )

    def test_dtype(self):
        self.assertEqual(numpy.int8, ByteArrayTag().dtype)
        self.assertEqual(numpy.int32, IntArrayTag().dtype)
        self.assertEqual(numpy.int64, LongArrayTag().dtype)

    def test_flat(self):
        for dtype in self.this_types:
            numpy.testing.assert_array_equal([1, 2, 3], dtype([1, 2, 3]).flat)

    def test_real_imag(self):
        for dtype in self.this_types:
            numpy.testing.assert_array_equal([1, 2, 3], dtype([1, 2, 3]).real)
            numpy.testing.assert_array_equal([0, 0, 0], dtype([1, 2, 3]).imag)

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

    def test_all(self):
        for dtype in self.this_types:
            self.assertFalse(dtype([1, 2, 0]).all())
            self.assertTrue(dtype([1, 2, 3]).all())

    def test_any(self):
        for dtype in self.this_types:
            self.assertFalse(dtype([0, 0, 0]).any())
            self.assertTrue(dtype([0, 0, 1]).any())

    def test_argmax(self):
        for dtype in self.this_types:
            self.assertEqual(0, dtype([3, 2, 1]).argmax())

    def test_argmin(self):
        for dtype in self.this_types:
            self.assertEqual(2, dtype([3, 2, 1]).argmin())

    def test_argpartition(self):
        pass

    def test_argsort(self):
        pass

    def test_astype(self):
        self.assertEqual(numpy.uint16, ByteArrayTag().astype(numpy.uint16).dtype)
        self.assertEqual(numpy.uint16, IntArrayTag().astype(numpy.uint16).dtype)
        self.assertEqual(numpy.uint16, LongArrayTag().astype(numpy.uint16).dtype)

    def test_byteswap(self):
        for dtype, ground in zip(
            (ByteArrayTag, IntArrayTag, LongArrayTag),
            (
                (
                    b"\x01\x02\x03",
                    b"\x01\x02\x03",
                ),
                (
                    b"\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x03",
                    b"\x01\x00\x00\x00\x02\x00\x00\x00\x03\x00\x00\x00",
                ),
                (
                    b"\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x03",
                    b"\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00",
                ),
            ),
        ):
            t = dtype([1, 2, 3])
            self.assertEqual(ground[sys.byteorder == "little"], t.tobytes())
            self.assertEqual(ground[sys.byteorder != "little"], t.byteswap().tobytes())

    def test_choose(self):
        pass

    def test_clip(self):
        for dtype in self.this_types:
            numpy.testing.assert_array_equal([1, 1, 0], dtype([1, 2, 0]).clip(max=1))
            numpy.testing.assert_array_equal([1, 2, 1], dtype([1, 2, 0]).clip(min=1))
            numpy.testing.assert_array_equal([1, 1, 1], dtype([1, 2, 0]).clip(1, 1))

    def test_compress(self):
        pass

    def test_conj(self):
        pass

    def test_conjugate(self):
        pass

    def test_cumprod(self):
        for dtype in self.this_types:
            numpy.testing.assert_array_equal(
                [1, 2, 6, 24], dtype([1, 2, 3, 4]).cumprod()
            )

    def test_cumsum(self):
        for dtype in self.this_types:
            numpy.testing.assert_array_equal(
                [1, 3, 6, 10], dtype([1, 2, 3, 4]).cumsum()
            )

    def test_diagonal(self):
        for dtype in self.this_types:
            with self.assertRaises(ValueError):
                dtype([1, 2, 3, 4]).diagonal()

    def test_dot(self):
        pass

    def test_dump(self):
        pass

    def test_fill(self):
        pass

    def test_flatten(self):
        pass

    def test_getfield(self):
        pass

    def test_item(self):
        pass

    def test_itemset(self):
        pass

    def test_max(self):
        pass

    def test_mean(self):
        pass

    def test_min(self):
        pass

    def test_newbyteorder(self):
        pass

    def test_nonzero(self):
        pass

    def test_partition(self):
        pass

    def test_prod(self):
        pass

    def test_ptp(self):
        pass

    def test_put(self):
        pass

    def test_ravel(self):
        pass

    def test_repeat(self):
        pass

    def test_reshape(self):
        pass

    def test_round(self):
        pass

    def test_searchsorted(self):
        pass

    def test_setfield(self):
        pass

    def test_setflags(self):
        pass

    def test_sort(self):
        pass

    def test_squeeze(self):
        pass

    def test_std(self):
        pass

    def test_sum(self):
        pass

    def test_swapaxis(self):
        pass

    def test_take(self):
        pass

    def test_tobytes(self):
        pass

    def test_tofile(self):
        pass

    def test_tolist(self):
        pass

    def test_tostring(self):
        pass

    def test_trace(self):
        pass

    def test_var(self):
        pass

    def test_view(self):
        pass

    def test_str(self):
        pass

    def test_dir(self):
        pass

    def test_eq(self):
        pass

    def test_ge(self):
        pass

    def test_gt(self):
        pass

    def test_le(self):
        pass

    def test_lt(self):
        pass

    def test_copy(self):
        pass

    def test_pickle(self):
        pass

    def test_shape(self):
        pass

    def test_strides(self):
        pass

    def test_resize(self):
        pass

    def test_getitem(self):
        pass

    def test_setitem(self):
        pass

    def test_array(self):
        pass

    def test_len(self):
        pass

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
