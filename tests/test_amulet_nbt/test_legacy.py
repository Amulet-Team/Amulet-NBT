import unittest
import amulet.nbt


class LegacyNBTTests(unittest.TestCase):
    def test_legacy(self) -> None:
        self.assertIs(amulet.nbt.ByteTag, amulet.nbt.TAG_Byte)
        self.assertIs(amulet.nbt.ShortTag, amulet.nbt.TAG_Short)
        self.assertIs(amulet.nbt.IntTag, amulet.nbt.TAG_Int)
        self.assertIs(amulet.nbt.LongTag, amulet.nbt.TAG_Long)
        self.assertIs(amulet.nbt.FloatTag, amulet.nbt.TAG_Float)
        self.assertIs(amulet.nbt.DoubleTag, amulet.nbt.TAG_Double)
        self.assertIs(amulet.nbt.StringTag, amulet.nbt.TAG_String)
        self.assertIs(amulet.nbt.ListTag, amulet.nbt.TAG_List)
        self.assertIs(amulet.nbt.CompoundTag, amulet.nbt.TAG_Compound)
        self.assertIs(amulet.nbt.ByteArrayTag, amulet.nbt.TAG_Byte_Array)
        self.assertIs(amulet.nbt.IntArrayTag, amulet.nbt.TAG_Int_Array)
        self.assertIs(amulet.nbt.LongArrayTag, amulet.nbt.TAG_Long_Array)


if __name__ == "__main__":
    unittest.main()
