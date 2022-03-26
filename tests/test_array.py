from typing import Tuple, Type
import unittest

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


if __name__ == "__main__":
    unittest.main()
