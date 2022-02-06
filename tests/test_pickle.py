import unittest
import pickle
import numpy
import amulet_nbt


class PickleNBTTests(unittest.TestCase):
    def _test_pickle(self, obj):
        pickled_obj = pickle.dumps(obj)
        obj2 = pickle.loads(pickled_obj)
        self.assertEqual(obj, obj2)
        self.assertIsNot(obj, obj2)
        if isinstance(obj.value, numpy.ndarray):
            numpy.testing.assert_array_equal(obj.value, obj2.value)
        else:
            self.assertEqual(obj.value, obj2.value)
        if not isinstance(obj.value, (int, str)):
            self.assertIsNot(obj.value, obj2.value)

    def test_pickle(self):
        self._test_pickle(amulet_nbt.ByteTag(10))
        self._test_pickle(amulet_nbt.ShortTag(10))
        self._test_pickle(amulet_nbt.IntTag(10))
        self._test_pickle(amulet_nbt.LongTag(10))
        self._test_pickle(amulet_nbt.FloatTag(10))
        self._test_pickle(amulet_nbt.DoubleTag(10))
        self._test_pickle(amulet_nbt.ByteArrayTag([1, 2, 3]))
        self._test_pickle(amulet_nbt.StringTag())
        self._test_pickle(amulet_nbt.ListTag())
        self._test_pickle(amulet_nbt.CompoundTag())
        self._test_pickle(amulet_nbt.IntArrayTag([1, 2, 3]))
        self._test_pickle(amulet_nbt.LongArrayTag([1, 2, 3]))
        self._test_pickle(amulet_nbt.NBTFile())


if __name__ == "__main__":
    unittest.main()
