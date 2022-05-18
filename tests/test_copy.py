import unittest
import copy
import numpy
from amulet_nbt import (
    AbstractBaseTag,
    BaseNamedTag,
    BaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    BaseFloatTag,
    LongTag,
    FloatTag,
    DoubleTag,
    BaseArrayTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
)


class CopyNBTTests(unittest.TestCase):
    def _test_copy(self, obj: AbstractBaseTag):
        obj_copy: AbstractBaseTag = copy.copy(obj)
        obj_copy2: AbstractBaseTag = obj.copy()
        obj_deepcopy: AbstractBaseTag = copy.deepcopy(obj)

        self.assertIsInstance(obj_copy, AbstractBaseTag)
        self.assertIsInstance(obj_copy2, AbstractBaseTag)
        self.assertIsInstance(obj_deepcopy, AbstractBaseTag)
        self.assertIsInstance(obj_copy, obj.__class__)
        self.assertIsInstance(obj_copy2, obj.__class__)
        self.assertIsInstance(obj_deepcopy, obj.__class__)

        # Compare the objects
        self.assertEqual(obj, obj_copy)
        self.assertEqual(obj, obj_copy2)
        self.assertEqual(obj, obj_deepcopy)

        # Check if they are the same
        self.assertIsNot(obj, obj_copy)
        self.assertIsNot(obj, obj_copy2)
        self.assertIsNot(obj, obj_deepcopy)

        if isinstance(obj, BaseNamedTag):
            obj_copy: BaseNamedTag
            obj_copy2: BaseNamedTag
            obj_deepcopy: BaseNamedTag
            # Check if the names are the same
            self.assertIs(obj.name, obj_copy.name)
            self.assertIs(obj.name, obj_copy2.name)
            # python caches strings
            self.assertIs(obj.name, obj_deepcopy.name)

        # Check the values match
        if isinstance(obj, BaseArrayTag):
            numpy.testing.assert_array_equal(obj.py_data, obj_copy.py_data)
            numpy.testing.assert_array_equal(obj.py_data, obj_copy2.py_data)
            numpy.testing.assert_array_equal(obj.py_data, obj_deepcopy.py_data)
        else:
            self.assertEqual(obj.py_data, obj_copy.py_data)
            self.assertEqual(obj.py_data, obj_copy2.py_data)
            self.assertEqual(obj.py_data, obj_deepcopy.py_data)

        # Check if the values are the same
        if isinstance(obj, (BaseFloatTag, BaseArrayTag, ListTag, CompoundTag)):
            # some tags always create copies
            self.assertIsNot(obj.py_data, obj_copy.py_data)
            self.assertIsNot(obj.py_data, obj_copy2.py_data)
            self.assertIsNot(obj.py_data, obj_deepcopy.py_data)
        elif isinstance(obj, (BaseIntTag, StringTag)):
            # python does some caching
            self.assertIs(obj.py_data, obj_copy.py_data)
            self.assertIs(obj.py_data, obj_copy2.py_data)
            self.assertIs(obj.py_data, obj_deepcopy.py_data)
        else:
            self.assertIs(obj.py_data, obj_copy.py_data)
            self.assertIs(obj.py_data, obj_copy2.py_data)
            self.assertIsNot(obj.py_data, obj_deepcopy.py_data)

    def test_copy(self):
        self._test_copy(ByteTag(10))
        self._test_copy(ShortTag(10))
        self._test_copy(IntTag(10))
        self._test_copy(LongTag(10))
        self._test_copy(FloatTag(10))
        self._test_copy(DoubleTag(10))
        self._test_copy(ByteArrayTag([1, 2, 3]))
        self._test_copy(StringTag())
        self._test_copy(ListTag())
        self._test_copy(CompoundTag())
        self._test_copy(IntArrayTag([1, 2, 3]))
        self._test_copy(LongArrayTag([1, 2, 3]))


if __name__ == "__main__":
    unittest.main()
