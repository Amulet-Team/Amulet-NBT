import unittest

from tests import base_type_test

from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    IntArrayTag,
    LongArrayTag,
)


class TestHash(base_type_test.BaseTagsTest):
    def test_hash(self):
        hash(ByteTag())
        hash(ShortTag())
        hash(IntTag())
        hash(LongTag())
        hash(FloatTag())
        hash(DoubleTag())
        hash(StringTag())
        with self.assertRaises(TypeError):
            hash(ListTag())
        with self.assertRaises(TypeError):
            hash(CompoundTag())
        with self.assertRaises(TypeError):
            hash(ByteArrayTag())
        with self.assertRaises(TypeError):
            hash(IntArrayTag())
        with self.assertRaises(TypeError):
            hash(LongArrayTag())

    def test_hash_num(self):
        for num in (-5, 0, 5):
            for tag_cls1 in self.numerical_types:
                for tag_cls2 in self.numerical_types:
                    if tag_cls1 is tag_cls2:
                        self.assertEqual(hash(tag_cls1(num)), hash(tag_cls2(num)))
                    else:
                        self.assertNotEqual(hash(tag_cls1(num)), hash(tag_cls2(num)))


if __name__ == "__main__":
    unittest.main()
