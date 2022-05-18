import unittest
from amulet_nbt import (
    AbstractBaseTag,
    BaseNamedTag,
    AbstractBaseMutableTag,
    AbstractBaseImmutableTag,
    AbstractBaseNumericTag,
    AbstractBaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    AbstractBaseFloatTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTag,
    CompoundTag,
    AbstractBaseArrayTag,
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
        self.assertIsInstance(ByteTag(), AbstractBaseTag)
        self.assertIsInstance(ByteTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(ByteTag(), AbstractBaseNumericTag)
        self.assertIsInstance(ByteTag(), AbstractBaseIntTag)
        self.assertIsInstance(ByteTag(), ByteTag)

        self.assertIsInstance(ShortTag(), AbstractBaseTag)
        self.assertIsInstance(ShortTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(ShortTag(), AbstractBaseNumericTag)
        self.assertIsInstance(ShortTag(), AbstractBaseIntTag)
        self.assertIsInstance(ShortTag(), ShortTag)

        self.assertIsInstance(IntTag(), AbstractBaseTag)
        self.assertIsInstance(IntTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(IntTag(), AbstractBaseNumericTag)
        self.assertIsInstance(IntTag(), AbstractBaseIntTag)
        self.assertIsInstance(IntTag(), IntTag)

        self.assertIsInstance(LongTag(), AbstractBaseTag)
        self.assertIsInstance(LongTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(LongTag(), AbstractBaseNumericTag)
        self.assertIsInstance(LongTag(), AbstractBaseIntTag)
        self.assertIsInstance(LongTag(), LongTag)

        self.assertIsInstance(FloatTag(), AbstractBaseTag)
        self.assertIsInstance(FloatTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(FloatTag(), AbstractBaseNumericTag)
        self.assertIsInstance(FloatTag(), AbstractBaseFloatTag)
        self.assertIsInstance(FloatTag(), FloatTag)

        self.assertIsInstance(DoubleTag(), AbstractBaseTag)
        self.assertIsInstance(DoubleTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(DoubleTag(), AbstractBaseNumericTag)
        self.assertIsInstance(DoubleTag(), AbstractBaseFloatTag)
        self.assertIsInstance(DoubleTag(), DoubleTag)

        self.assertIsInstance(StringTag(), AbstractBaseTag)
        self.assertIsInstance(StringTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(StringTag(), StringTag)

        self.assertIsInstance(ListTag(), AbstractBaseTag)
        self.assertIsInstance(ListTag(), AbstractBaseMutableTag)
        self.assertIsInstance(ListTag(), ListTag)

        self.assertIsInstance(CompoundTag(), AbstractBaseTag)
        self.assertIsInstance(CompoundTag(), AbstractBaseMutableTag)
        self.assertIsInstance(CompoundTag(), CompoundTag)

        self.assertIsInstance(ByteArrayTag(), AbstractBaseTag)
        self.assertIsInstance(ByteArrayTag(), AbstractBaseMutableTag)
        self.assertIsInstance(ByteArrayTag(), AbstractBaseArrayTag)
        self.assertIsInstance(ByteArrayTag(), ByteArrayTag)

        self.assertIsInstance(IntArrayTag(), AbstractBaseTag)
        self.assertIsInstance(IntArrayTag(), AbstractBaseMutableTag)
        self.assertIsInstance(IntArrayTag(), AbstractBaseArrayTag)
        self.assertIsInstance(IntArrayTag(), IntArrayTag)

        self.assertIsInstance(LongArrayTag(), AbstractBaseTag)
        self.assertIsInstance(LongArrayTag(), AbstractBaseMutableTag)
        self.assertIsInstance(LongArrayTag(), AbstractBaseArrayTag)
        self.assertIsInstance(LongArrayTag(), LongArrayTag)

    def test_named_is_instance(self):
        self.assertIsInstance(NamedByteTag(), BaseNamedTag)
        self.assertIsInstance(NamedByteTag(), NamedByteTag)
        self.assertIsInstance(NamedByteTag().tag, ByteTag)

        self.assertIsInstance(NamedShortTag(), BaseNamedTag)
        self.assertIsInstance(NamedShortTag(), NamedShortTag)
        self.assertIsInstance(NamedShortTag().tag, ShortTag)

        self.assertIsInstance(NamedIntTag(), BaseNamedTag)
        self.assertIsInstance(NamedIntTag(), NamedIntTag)
        self.assertIsInstance(NamedIntTag().tag, IntTag)

        self.assertIsInstance(NamedLongTag(), BaseNamedTag)
        self.assertIsInstance(NamedLongTag(), NamedLongTag)
        self.assertIsInstance(NamedLongTag().tag, LongTag)

        self.assertIsInstance(NamedFloatTag(), BaseNamedTag)
        self.assertIsInstance(NamedFloatTag(), NamedFloatTag)
        self.assertIsInstance(NamedFloatTag().tag, FloatTag)

        self.assertIsInstance(NamedDoubleTag(), BaseNamedTag)
        self.assertIsInstance(NamedDoubleTag(), NamedDoubleTag)
        self.assertIsInstance(NamedDoubleTag().tag, DoubleTag)

        self.assertIsInstance(NamedByteArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedByteArrayTag(), NamedByteArrayTag)
        self.assertIsInstance(NamedByteArrayTag().tag, ByteArrayTag)

        self.assertIsInstance(NamedStringTag(), BaseNamedTag)
        self.assertIsInstance(NamedStringTag(), NamedStringTag)
        self.assertIsInstance(NamedStringTag().tag, StringTag)

        self.assertIsInstance(NamedListTag(), BaseNamedTag)
        self.assertIsInstance(NamedListTag(), NamedListTag)
        self.assertIsInstance(NamedListTag().tag, ListTag)

        self.assertIsInstance(NamedCompoundTag(), BaseNamedTag)
        self.assertIsInstance(NamedCompoundTag(), NamedCompoundTag)
        self.assertIsInstance(NamedCompoundTag().tag, CompoundTag)

        self.assertIsInstance(NamedIntArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedIntArrayTag(), NamedIntArrayTag)
        self.assertIsInstance(NamedIntArrayTag().tag, IntArrayTag)

        self.assertIsInstance(NamedLongArrayTag(), BaseNamedTag)
        self.assertIsInstance(NamedLongArrayTag(), NamedLongArrayTag)
        self.assertIsInstance(NamedLongArrayTag().tag, LongArrayTag)


if __name__ == "__main__":
    unittest.main()
