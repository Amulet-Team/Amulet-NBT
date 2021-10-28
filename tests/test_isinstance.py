import unittest
from amulet_nbt import (
    BaseTag,
    BaseMutableTag,
    BaseImmutableTag,
    BaseNumericTag,
    BaseIntTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    BaseFloatTag,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
    BaseArrayTag,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestIsInstance(unittest.TestCase):
    def test_is_instance(self):
        self.assertIsInstance(TAG_Byte(), BaseTag)
        self.assertIsInstance(TAG_Byte(), BaseImmutableTag)
        self.assertIsInstance(TAG_Byte(), BaseNumericTag)
        self.assertIsInstance(TAG_Byte(), BaseIntTag)
        self.assertIsInstance(TAG_Byte(), TAG_Byte)

        self.assertIsInstance(TAG_Short(), BaseTag)
        self.assertIsInstance(TAG_Short(), BaseImmutableTag)
        self.assertIsInstance(TAG_Short(), BaseNumericTag)
        self.assertIsInstance(TAG_Short(), BaseIntTag)
        self.assertIsInstance(TAG_Short(), TAG_Short)

        self.assertIsInstance(TAG_Int(), BaseTag)
        self.assertIsInstance(TAG_Int(), BaseImmutableTag)
        self.assertIsInstance(TAG_Int(), BaseNumericTag)
        self.assertIsInstance(TAG_Int(), BaseIntTag)
        self.assertIsInstance(TAG_Int(), TAG_Int)

        self.assertIsInstance(TAG_Long(), BaseTag)
        self.assertIsInstance(TAG_Long(), BaseImmutableTag)
        self.assertIsInstance(TAG_Long(), BaseNumericTag)
        self.assertIsInstance(TAG_Long(), BaseIntTag)
        self.assertIsInstance(TAG_Long(), TAG_Long)

        self.assertIsInstance(TAG_Float(), BaseTag)
        self.assertIsInstance(TAG_Float(), BaseImmutableTag)
        self.assertIsInstance(TAG_Float(), BaseNumericTag)
        self.assertIsInstance(TAG_Float(), BaseFloatTag)
        self.assertIsInstance(TAG_Float(), TAG_Float)

        self.assertIsInstance(TAG_Double(), BaseTag)
        self.assertIsInstance(TAG_Double(), BaseImmutableTag)
        self.assertIsInstance(TAG_Double(), BaseNumericTag)
        self.assertIsInstance(TAG_Double(), BaseFloatTag)
        self.assertIsInstance(TAG_Double(), TAG_Double)

        self.assertIsInstance(TAG_String(), BaseTag)
        self.assertIsInstance(TAG_String(), BaseImmutableTag)
        self.assertIsInstance(TAG_String(), TAG_String)

        self.assertIsInstance(TAG_List(), BaseTag)
        self.assertIsInstance(TAG_List(), BaseMutableTag)
        self.assertIsInstance(TAG_List(), TAG_List)

        self.assertIsInstance(TAG_Compound(), BaseTag)
        self.assertIsInstance(TAG_Compound(), BaseMutableTag)
        self.assertIsInstance(TAG_Compound(), TAG_Compound)

        self.assertIsInstance(TAG_Byte_Array(), BaseTag)
        self.assertIsInstance(TAG_Byte_Array(), BaseMutableTag)
        self.assertIsInstance(TAG_Byte_Array(), BaseArrayTag)
        self.assertIsInstance(TAG_Byte_Array(), TAG_Byte_Array)

        self.assertIsInstance(TAG_Int_Array(), BaseTag)
        self.assertIsInstance(TAG_Int_Array(), BaseMutableTag)
        self.assertIsInstance(TAG_Int_Array(), BaseArrayTag)
        self.assertIsInstance(TAG_Int_Array(), TAG_Int_Array)

        self.assertIsInstance(TAG_Long_Array(), BaseTag)
        self.assertIsInstance(TAG_Long_Array(), BaseMutableTag)
        self.assertIsInstance(TAG_Long_Array(), BaseArrayTag)
        self.assertIsInstance(TAG_Long_Array(), TAG_Long_Array)


if __name__ == "__main__":
    unittest.main()
