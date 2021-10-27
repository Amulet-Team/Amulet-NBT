import unittest
import copy
import numpy
from amulet_nbt import (
    BaseIntTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    BaseFloatTag,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    BaseArrayTag,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
    NBTFile,
)


class CopyNBTTests(unittest.TestCase):
    def _test_copy(self, obj):
        obj_copy = copy.copy(obj)
        obj_deepcopy = copy.deepcopy(obj)

        # Compare the objects
        self.assertEqual(obj, obj_copy)
        self.assertEqual(obj, obj_deepcopy)

        # Check if they are the same
        self.assertIsNot(obj, obj_copy)
        self.assertIsNot(obj, obj_deepcopy)

        if isinstance(obj, NBTFile):
            # Check if the names are the same
            self.assertIs(obj.name, obj_copy.name)
            # python caches strings
            self.assertIs(obj.name, obj_deepcopy.name)

        # Check the values match
        if isinstance(obj.value, numpy.ndarray):
            numpy.testing.assert_array_equal(obj.value, obj_copy.value)
            numpy.testing.assert_array_equal(obj.value, obj_deepcopy.value)
        else:
            self.assertEqual(obj.value, obj_copy.value)
            self.assertEqual(obj.value, obj_deepcopy.value)

        # Check if the values are the same
        if isinstance(obj, (BaseFloatTag, BaseArrayTag, TAG_List, TAG_Compound)):
            # some tags always create copies
            self.assertIsNot(obj.value, obj_copy.value)
            self.assertIsNot(obj.value, obj_deepcopy.value)
        elif isinstance(obj, (BaseIntTag, TAG_String)):
            # python does some caching
            self.assertIs(obj.value, obj_copy.value)
            self.assertIs(obj.value, obj_deepcopy.value)
        else:
            self.assertIs(obj.value, obj_copy.value)
            self.assertIsNot(obj.value, obj_deepcopy.value)

    def test_copy(self):
        self._test_copy(TAG_Byte(10))
        self._test_copy(TAG_Short(10))
        self._test_copy(TAG_Int(10))
        self._test_copy(TAG_Long(10))
        self._test_copy(TAG_Float(10))
        self._test_copy(TAG_Double(10))
        self._test_copy(TAG_Byte_Array([1, 2, 3]))
        self._test_copy(TAG_String())
        self._test_copy(TAG_List())
        self._test_copy(TAG_Compound())
        self._test_copy(TAG_Int_Array([1, 2, 3]))
        self._test_copy(TAG_Long_Array([1, 2, 3]))
        self._test_copy(NBTFile())


if __name__ == "__main__":
    unittest.main()
