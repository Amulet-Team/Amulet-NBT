import unittest
import pickle
import numpy
from amulet_nbt import (
    AbstractBaseTag,
    BaseIntTag,
    BaseArrayTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    BaseNamedTag,
    tag_to_named_tag,
)


class PickleNBTTests(unittest.TestCase):
    def _test_pickle(self, obj):
        pickled_obj = pickle.dumps(obj)
        obj2 = pickle.loads(pickled_obj)
        self.assertIs(obj.__class__, obj2.__class__)
        self.assertEqual(obj, obj2)
        self.assertIsNot(obj, obj2)

        if isinstance(obj, BaseNamedTag):
            tag = obj.tag
        elif isinstance(obj, AbstractBaseTag):
            tag = obj
        else:
            raise TypeError

        if isinstance(tag.py_data, numpy.ndarray):
            numpy.testing.assert_array_equal(tag.py_data, tag.py_data)
        else:
            self.assertEqual(tag.py_data, tag.py_data)
        if isinstance(tag, (BaseIntTag, StringTag, BaseArrayTag)):
            self.assertIs(tag.py_data, tag.py_data)
        else:
            self.assertIsNot(tag.py_data, tag.py_data)

    def test_pickle(self):
        self._test_pickle(ByteTag(10))
        self._test_pickle(ShortTag(10))
        self._test_pickle(IntTag(10))
        self._test_pickle(LongTag(10))
        self._test_pickle(FloatTag(10))
        self._test_pickle(DoubleTag(10))
        self._test_pickle(ByteArrayTag([1, 2, 3]))
        self._test_pickle(StringTag())
        self._test_pickle(ListTag())
        self._test_pickle(CompoundTag())
        self._test_pickle(IntArrayTag([1, 2, 3]))
        self._test_pickle(LongArrayTag([1, 2, 3]))

        self._test_pickle(tag_to_named_tag(ByteTag(10)))
        self._test_pickle(tag_to_named_tag(ShortTag(10)))
        self._test_pickle(tag_to_named_tag(IntTag(10)))
        self._test_pickle(tag_to_named_tag(LongTag(10)))
        self._test_pickle(tag_to_named_tag(FloatTag(10)))
        self._test_pickle(tag_to_named_tag(DoubleTag(10)))
        self._test_pickle(tag_to_named_tag(ByteArrayTag([1, 2, 3])))
        self._test_pickle(tag_to_named_tag(StringTag()))
        self._test_pickle(tag_to_named_tag(ListTag()))
        self._test_pickle(tag_to_named_tag(CompoundTag()))
        self._test_pickle(tag_to_named_tag(IntArrayTag([1, 2, 3])))
        self._test_pickle(tag_to_named_tag(LongArrayTag([1, 2, 3])))


if __name__ == "__main__":
    unittest.main()
