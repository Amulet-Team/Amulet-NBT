import unittest
from amulet_nbt import (
    BaseTag,
    BaseNamedTag,
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
    NamedByteTag,
    NamedShortTag,
    NamedIntTag,
    NamedLongTag,
    NamedFloatTag,
    NamedDoubleTag,
    NamedStringTag,
    NamedListTag,
    NamedCompoundTag,
    NamedByteArrayTag,
    NamedIntArrayTag,
    NamedLongArrayTag,
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

    def test_named_is_instance(self):
        self.assertIsInstance(NamedByteTag(), BaseTag)
        self.assertIsInstance(NamedByteTag(), BaseNamedTag)
        self.assertIsInstance(NamedByteTag(), BaseImmutableTag)
        self.assertIsInstance(NamedByteTag(), BaseNumericTag)
        self.assertIsInstance(NamedByteTag(), BaseIntTag)
        self.assertIsInstance(NamedByteTag(), ByteTag)

        self.assertIsInstance(NamedShortTag(), BaseTag)
        self.assertIsInstance(NamedShortTag(), BaseNamedTag)
        self.assertIsInstance(NamedShortTag(), BaseImmutableTag)
        self.assertIsInstance(NamedShortTag(), BaseNumericTag)
        self.assertIsInstance(NamedShortTag(), BaseIntTag)
        self.assertIsInstance(NamedShortTag(), ShortTag)

        self.assertIsInstance(NamedIntTag(), BaseTag)
        self.assertIsInstance(NamedIntTag(), BaseNamedTag)
        self.assertIsInstance(NamedIntTag(), BaseImmutableTag)
        self.assertIsInstance(NamedIntTag(), BaseNumericTag)
        self.assertIsInstance(NamedIntTag(), BaseIntTag)
        self.assertIsInstance(NamedIntTag(), IntTag)

        self.assertIsInstance(NamedLongTag(), BaseTag)
        self.assertIsInstance(NamedLongTag(), BaseNamedTag)
        self.assertIsInstance(NamedLongTag(), BaseImmutableTag)
        self.assertIsInstance(NamedLongTag(), BaseNumericTag)
        self.assertIsInstance(NamedLongTag(), BaseIntTag)
        self.assertIsInstance(NamedLongTag(), LongTag)

        self.assertIsInstance(NamedFloatTag(), BaseTag)
        self.assertIsInstance(NamedFloatTag(), BaseNamedTag)
        self.assertIsInstance(NamedFloatTag(), BaseImmutableTag)
        self.assertIsInstance(NamedFloatTag(), BaseNumericTag)
        self.assertIsInstance(NamedFloatTag(), BaseFloatTag)
        self.assertIsInstance(NamedFloatTag(), FloatTag)

        self.assertIsInstance(NamedDoubleTag(), BaseTag)
        self.assertIsInstance(NamedDoubleTag(), BaseNamedTag)
        self.assertIsInstance(NamedDoubleTag(), BaseImmutableTag)
        self.assertIsInstance(NamedDoubleTag(), BaseNumericTag)
        self.assertIsInstance(NamedDoubleTag(), BaseFloatTag)
        self.assertIsInstance(NamedDoubleTag(), DoubleTag)

        self.assertIsInstance(NamedStringTag(), BaseTag)
        self.assertIsInstance(NamedStringTag(), BaseNamedTag)
        self.assertIsInstance(NamedStringTag(), BaseImmutableTag)
        self.assertIsInstance(NamedStringTag(), StringTag)

        self.assertIsInstance(NamedListTag(), BaseTag)
        self.assertIsInstance(NamedListTag(), BaseNamedTag)
        self.assertIsInstance(NamedListTag(), BaseMutableTag)
        self.assertIsInstance(NamedListTag(), ListTag)

        self.assertIsInstance(NamedCompoundTag(), BaseTag)
        self.assertIsInstance(NamedCompoundTag(), BaseNamedTag)
        self.assertIsInstance(NamedCompoundTag(), BaseMutableTag)
        self.assertIsInstance(NamedCompoundTag(), CompoundTag)

        self.assertIsInstance(NamedByteArrayTag(), BaseTag)
        self.assertIsInstance(NamedByteArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedByteArrayTag(), BaseMutableTag)
        self.assertIsInstance(NamedByteArrayTag(), BaseArrayTag)
        self.assertIsInstance(NamedByteArrayTag(), ByteArrayTag)

        self.assertIsInstance(NamedIntArrayTag(), BaseTag)
        self.assertIsInstance(NamedIntArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedIntArrayTag(), BaseMutableTag)
        self.assertIsInstance(NamedIntArrayTag(), BaseArrayTag)
        self.assertIsInstance(NamedIntArrayTag(), IntArrayTag)

        self.assertIsInstance(NamedLongArrayTag(), BaseTag)
        self.assertIsInstance(NamedLongArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedLongArrayTag(), BaseMutableTag)
        self.assertIsInstance(NamedLongArrayTag(), BaseArrayTag)
        self.assertIsInstance(NamedLongArrayTag(), LongArrayTag)


if __name__ == "__main__":
    unittest.main()
