import unittest
import amulet_nbt


class LegacyNBTTests(unittest.TestCase):
    def test_legacy(self):
        self.assertIs(amulet_nbt.ByteTag, amulet_nbt.TAG_Byte)
        self.assertIs(amulet_nbt.ShortTag, amulet_nbt.TAG_Short)
        self.assertIs(amulet_nbt.IntTag, amulet_nbt.TAG_Int)
        self.assertIs(amulet_nbt.LongTag, amulet_nbt.TAG_Long)
        self.assertIs(amulet_nbt.FloatTag, amulet_nbt.TAG_Float)
        self.assertIs(amulet_nbt.DoubleTag, amulet_nbt.TAG_Double)
        self.assertIs(amulet_nbt.StringTag, amulet_nbt.TAG_String)
        self.assertIs(amulet_nbt.ListTag, amulet_nbt.TAG_List)
        self.assertIs(amulet_nbt.CompoundTag, amulet_nbt.TAG_Compound)
        self.assertIs(amulet_nbt.ByteArrayTag, amulet_nbt.TAG_Byte_Array)
        self.assertIs(amulet_nbt.IntArrayTag, amulet_nbt.TAG_Int_Array)
        self.assertIs(amulet_nbt.LongArrayTag, amulet_nbt.TAG_Long_Array)


if __name__ == "__main__":
    unittest.main()
