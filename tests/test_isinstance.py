import unittest
from amulet_nbt import (
    AbstractBaseTag,
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
    NamedTag,
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
        self.assertIsInstance(NamedTag(), NamedTag)
        self.assertIsInstance(NamedTag().tag, CompoundTag)

        for tag_type in (
            ByteTag,
            ShortTag,
            IntTag,
            LongTag,
            FloatTag,
            DoubleTag,
            StringTag,
            ListTag,
            CompoundTag,
            ByteArrayTag,
            IntArrayTag,
            LongArrayTag,
        ):
            self.assertIsInstance(NamedTag(tag_type()), NamedTag)
            self.assertIsInstance(NamedTag(tag_type()).tag, tag_type)

            self.assertIsInstance(NamedTag(tag_type(), ""), NamedTag)
            self.assertIsInstance(NamedTag(tag_type(), "").tag, tag_type)


if __name__ == "__main__":
    unittest.main()
