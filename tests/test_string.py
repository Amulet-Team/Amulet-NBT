from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
)


class TestString(base_type_test.BaseTypeTest):
    def test_init_empty(self):
        pass

    def test_init(self):
        pass

    def test_errors(self):
        pass

    def test_string(self):
        self.assertEqual(TAG_String(), "")
        self.assertEqual(TAG_String("test"), "test")
        self.assertEqual(TAG_String("test") + "test", "testtest")
        self.assertIsInstance(TAG_String("test") + "test", str)
        self.assertIsInstance("test" + TAG_String("test"), str)
        self.assertEqual(TAG_String("test") * 3, "testtesttest")
        self.assertIsInstance(TAG_String("test") * 3, str)
