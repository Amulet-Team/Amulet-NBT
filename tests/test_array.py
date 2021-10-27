from tests import base_type_test
import numpy

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
    TAG_Byte_Array,
    TAG_Int_Array,
)


class TestArray(base_type_test.BaseTypeTest):
    @property
    def this_types(self):
        return self.array_types

    @property
    def values(self):
        values = []
        for t in (list, tuple, numpy.array) + self.array_types:
            for v in ([], [1], [1,2,3]):
                values.append(t(v))
        return values

    def test_init(self):
        self._test_init(lambda x: numpy.array(x, dtype=numpy.int64), [])

    def test_array_overflow(self):
        b_arr = TAG_Byte_Array([0])
        b_arr += 2 ** 7
        i_arr = TAG_Int_Array([0])
        i_arr += 2 ** 31
        # numpy throws an error when overflowing int64
        # l_arr = TAG_Long_Array([0])
        # l_arr += 2 ** 63

        self.assertTrue(numpy.array_equal(b_arr, [-(2 ** 7)]))
        self.assertTrue(numpy.array_equal(i_arr, [-(2 ** 31)]))
        # self.assertTrue(numpy.array_equal(l_arr, [-(2 ** 63)]))

        b_arr -= 1
        i_arr -= 1
        # l_arr -= 1

        self.assertTrue(numpy.array_equal(b_arr, [2 ** 7 - 1]))
        self.assertTrue(numpy.array_equal(i_arr, [2 ** 31 - 1]))
        # self.assertTrue(numpy.array_equal(l_arr, [2 ** 63 - 1]))
