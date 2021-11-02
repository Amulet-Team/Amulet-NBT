import unittest

import numpy
from amulet_nbt import (
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
    TAG_Long_Array,
)


class TestString(unittest.TestCase):
    def test_value(self):
        # Immutable types
        self.assertIs(TAG_Byte(5).value, 5)
        self.assertIs(TAG_Short(5).value, 5)
        self.assertIs(TAG_Int(5).value, 5)
        self.assertIs(TAG_Long(5).value, 5)
        self.assertIsInstance(TAG_Float(5.5).value, float)
        self.assertAlmostEqual(TAG_Float(5.5).value, 5.5)
        self.assertIsInstance(TAG_Double(5.5).value, float)
        self.assertAlmostEqual(TAG_Double(5.5).value, 5.5)
        self.assertIs(TAG_String("value").value, "value")

        # Mutable types
        self.assertIsInstance(TAG_List().value, list)
        self.assertEqual(TAG_List([TAG_String("value")]).value, [TAG_String("value")])
        self.assertIsInstance(TAG_Compound().value, dict)
        self.assertEqual(
            TAG_Compound(key=TAG_String("value")).value, {"key": TAG_String("value")}
        )
        self.assertIsInstance(TAG_Byte_Array().value, numpy.ndarray)
        self.assertIsNot(TAG_Byte_Array().value, TAG_Byte_Array().value)
        numpy.testing.assert_array_equal(TAG_Byte_Array([1, 2, 3]).value, [1, 2, 3])
        self.assertIsInstance(TAG_Int_Array().value, numpy.ndarray)
        self.assertIsNot(TAG_Int_Array().value, TAG_Int_Array().value)
        numpy.testing.assert_array_equal(TAG_Int_Array([1, 2, 3]).value, [1, 2, 3])
        self.assertIsInstance(TAG_Long_Array().value, numpy.ndarray)
        self.assertIsNot(TAG_Long_Array().value, TAG_Long_Array().value)
        numpy.testing.assert_array_equal(TAG_Long_Array([1, 2, 3]).value, [1, 2, 3])


if __name__ == "__main__":
    unittest.main()
