import unittest
import copy
import numpy
import amulet_nbt


class CopyNBTTests(unittest.TestCase):
    def _test_copy(self, obj):
        obj2 = copy.deepcopy(obj)
        self.assertEqual(obj, obj2)
        self.assertIsNot(obj, obj2)
        if isinstance(obj.value, numpy.ndarray):
            numpy.testing.assert_array_equal(obj.value, obj2.value)
        else:
            self.assertEqual(obj.value, obj2.value)
        if not isinstance(obj.value, (int, str)):
            self.assertIsNot(obj.value, obj2.value)

    def test_copy(self):
        self._test_copy(amulet_nbt.TAG_Byte(10))
        self._test_copy(amulet_nbt.TAG_Short(10))
        self._test_copy(amulet_nbt.TAG_Int(10))
        self._test_copy(amulet_nbt.TAG_Long(10))
        self._test_copy(amulet_nbt.TAG_Float(10))
        self._test_copy(amulet_nbt.TAG_Double(10))
        self._test_copy(amulet_nbt.TAG_Byte_Array([1, 2, 3]))
        self._test_copy(amulet_nbt.TAG_String())
        self._test_copy(amulet_nbt.TAG_List())
        self._test_copy(amulet_nbt.TAG_Compound())
        self._test_copy(amulet_nbt.TAG_Int_Array([1, 2, 3]))
        self._test_copy(amulet_nbt.TAG_Long_Array([1, 2, 3]))
        self._test_copy(amulet_nbt.NBTFile())


if __name__ == "__main__":
    unittest.main()
