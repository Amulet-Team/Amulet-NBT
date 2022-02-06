import unittest
import copy
import numpy
from amulet_nbt import (
    BaseTag,
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
    NBTFile,
)


class CopyNBTTests(unittest.TestCase):
    def _test_copy(self, obj):
        obj_copy = copy.copy(obj)
        if isinstance(obj, BaseTag):
            obj_copy2 = obj.copy()
        else:
            obj_copy2 = obj_copy
        obj_deepcopy = copy.deepcopy(obj)

        tag_cls = NBTFile if isinstance(obj, NBTFile) else BaseTag

        self.assertIsInstance(obj_copy, tag_cls)
        self.assertIsInstance(obj_copy2, tag_cls)
        self.assertIsInstance(obj_deepcopy, tag_cls)

        # Compare the objects
        self.assertEqual(obj, obj_copy)
        self.assertEqual(obj, obj_copy2)
        self.assertEqual(obj, obj_deepcopy)

        # Check if they are the same
        self.assertIsNot(obj, obj_copy)
        self.assertIsNot(obj, obj_copy2)
        self.assertIsNot(obj, obj_deepcopy)

        if isinstance(obj, NBTFile):
            # Check if the names are the same
            self.assertIs(obj.name, obj_copy.name)
            self.assertIs(obj.name, obj_copy2.name)
            # python caches strings
            self.assertIs(obj.name, obj_deepcopy.name)

        # Check the values match
        if isinstance(obj.value, numpy.ndarray):
            numpy.testing.assert_array_equal(obj.value, obj_copy.value)
            numpy.testing.assert_array_equal(obj.value, obj_copy2.value)
            numpy.testing.assert_array_equal(obj.value, obj_deepcopy.value)
        else:
            self.assertEqual(obj.value, obj_copy.value)
            self.assertEqual(obj.value, obj_copy2.value)
            self.assertEqual(obj.value, obj_deepcopy.value)

        # Check if the values are the same
        if isinstance(obj, (BaseFloatTag, BaseArrayTag, ListTag, CompoundTag)):
            # some tags always create copies
            self.assertIsNot(obj.value, obj_copy.value)
            self.assertIsNot(obj.value, obj_copy2.value)
            self.assertIsNot(obj.value, obj_deepcopy.value)
        elif isinstance(obj, (BaseIntTag, StringTag)):
            # python does some caching
            self.assertIs(obj.value, obj_copy.value)
            self.assertIs(obj.value, obj_copy2.value)
            self.assertIs(obj.value, obj_deepcopy.value)
        else:
            self.assertIs(obj.value, obj_copy.value)
            self.assertIs(obj.value, obj_copy2.value)
            self.assertIsNot(obj.value, obj_deepcopy.value)

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
        self._test_copy(NBTFile())


if __name__ == "__main__":
    unittest.main()
