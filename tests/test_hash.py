import unittest

from tests import base_type_test

from amulet_nbt import (
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestHash(base_type_test.BaseTagsTest):
    def test_hash(self):
        hash(TAG_Byte())
        hash(TAG_Short())
        hash(TAG_Int())
        hash(TAG_Long())
        hash(TAG_Float())
        hash(TAG_Double())
        hash(TAG_String())
        with self.assertRaises(TypeError):
            hash(TAG_List())
        with self.assertRaises(TypeError):
            hash(TAG_Compound())
        with self.assertRaises(TypeError):
            hash(TAG_Byte_Array())
        with self.assertRaises(TypeError):
            hash(TAG_Int_Array())
        with self.assertRaises(TypeError):
            hash(TAG_Long_Array())

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
