import unittest
from amulet_nbt import (
    BaseTag,
    BaseMutableTag,
    BaseImmutableTag,
    BaseNumericTag,
    BaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    BaseFloatTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTag,
    CompoundTag,
    BaseArrayTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
)


class TestIsInstance(unittest.TestCase):
    def test_is_instance(self):
        self.assertIsInstance(ByteTag(), BaseTag)
        self.assertIsInstance(ByteTag(), BaseImmutableTag)
        self.assertIsInstance(ByteTag(), BaseNumericTag)
        self.assertIsInstance(ByteTag(), BaseIntTag)
        self.assertIsInstance(ByteTag(), ByteTag)

        self.assertIsInstance(ShortTag(), BaseTag)
        self.assertIsInstance(ShortTag(), BaseImmutableTag)
        self.assertIsInstance(ShortTag(), BaseNumericTag)
        self.assertIsInstance(ShortTag(), BaseIntTag)
        self.assertIsInstance(ShortTag(), ShortTag)

        self.assertIsInstance(IntTag(), BaseTag)
        self.assertIsInstance(IntTag(), BaseImmutableTag)
        self.assertIsInstance(IntTag(), BaseNumericTag)
        self.assertIsInstance(IntTag(), BaseIntTag)
        self.assertIsInstance(IntTag(), IntTag)

        self.assertIsInstance(LongTag(), BaseTag)
        self.assertIsInstance(LongTag(), BaseImmutableTag)
        self.assertIsInstance(LongTag(), BaseNumericTag)
        self.assertIsInstance(LongTag(), BaseIntTag)
        self.assertIsInstance(LongTag(), LongTag)

        self.assertIsInstance(FloatTag(), BaseTag)
        self.assertIsInstance(FloatTag(), BaseImmutableTag)
        self.assertIsInstance(FloatTag(), BaseNumericTag)
        self.assertIsInstance(FloatTag(), BaseFloatTag)
        self.assertIsInstance(FloatTag(), FloatTag)

        self.assertIsInstance(DoubleTag(), BaseTag)
        self.assertIsInstance(DoubleTag(), BaseImmutableTag)
        self.assertIsInstance(DoubleTag(), BaseNumericTag)
        self.assertIsInstance(DoubleTag(), BaseFloatTag)
        self.assertIsInstance(DoubleTag(), DoubleTag)

        self.assertIsInstance(StringTag(), BaseTag)
        self.assertIsInstance(StringTag(), BaseImmutableTag)
        self.assertIsInstance(StringTag(), StringTag)

        self.assertIsInstance(ListTag(), BaseTag)
        self.assertIsInstance(ListTag(), BaseMutableTag)
        self.assertIsInstance(ListTag(), ListTag)

        self.assertIsInstance(CompoundTag(), BaseTag)
        self.assertIsInstance(CompoundTag(), BaseMutableTag)
        self.assertIsInstance(CompoundTag(), CompoundTag)

        self.assertIsInstance(ByteArrayTag(), BaseTag)
        self.assertIsInstance(ByteArrayTag(), BaseMutableTag)
        self.assertIsInstance(ByteArrayTag(), BaseArrayTag)
        self.assertIsInstance(ByteArrayTag(), ByteArrayTag)

        self.assertIsInstance(IntArrayTag(), BaseTag)
        self.assertIsInstance(IntArrayTag(), BaseMutableTag)
        self.assertIsInstance(IntArrayTag(), BaseArrayTag)
        self.assertIsInstance(IntArrayTag(), IntArrayTag)

        self.assertIsInstance(LongArrayTag(), BaseTag)
        self.assertIsInstance(LongArrayTag(), BaseMutableTag)
        self.assertIsInstance(LongArrayTag(), BaseArrayTag)
        self.assertIsInstance(LongArrayTag(), LongArrayTag)


if __name__ == "__main__":
    unittest.main()
