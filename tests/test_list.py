import unittest
from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    BaseArrayTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestList(base_type_test.BaseTypeTest):
    this_types = (TAG_List,)

    @property
    def values(self):
        return (
            ([],)
            + tuple([cls()] for cls in self.nbt_types)
            + tuple([cls(), cls()] for cls in self.nbt_types)
        )

    def test_init(self):
        self._test_init(list, [], (str,))

    def test_equal(self):
        for tag_cls in self.nbt_types:
            lval = [tag_cls() for _ in range(5)]
            self.assertEqual(TAG_List(lval), lval)
            self.assertEqual(TAG_List(lval), TAG_List(lval))
        for tag_cls1 in self.nbt_types:
            for tag_cls2 in self.nbt_types:
                tag1 = TAG_List([tag_cls1() for _ in range(5)])
                tag2 = TAG_List([tag_cls2() for _ in range(5)])
                if (
                    (tag_cls1 is tag_cls2)
                    or (
                        issubclass(tag_cls1, BaseNumericTag)
                        and issubclass(tag_cls2, BaseNumericTag)
                    )
                    or (
                        issubclass(tag_cls1, (BaseArrayTag, TAG_List))
                        and issubclass(tag_cls2, (BaseArrayTag, TAG_List))
                    )
                ):
                    self.assertEqual(tag1, tag2)
                else:
                    self.assertNotEqual(tag1, tag2)

                if tag_cls1 is tag_cls2:
                    self.assertTrue(tag1.strict_equals(tag2))
                else:
                    self.assertFalse(tag1.strict_equals(tag2))

        # make sure numerical lists are equal to arrays
        num_list = [-3, -2, -1, 0, 1, 2, 3]
        for array_tag_cls in self.array_types:
            for num_tag_cls in self.numerical_types:
                self.assertEqual(
                    TAG_List([num_tag_cls(i) for i in num_list]),
                    array_tag_cls(num_list),
                )
                self.assertEqual(
                    array_tag_cls(num_list),
                    TAG_List([num_tag_cls(i) for i in num_list]),
                )
                self.assertNotEqual(
                    TAG_List([num_tag_cls(i) for i in reversed(num_list)]),
                    array_tag_cls(num_list),
                )
                self.assertNotEqual(
                    array_tag_cls(num_list),
                    TAG_List([num_tag_cls(i) for i in reversed(num_list)]),
                )

    def test_list(self):
        # initialisation with and appending not nbt objects
        tag_list = TAG_List()
        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                TAG_List([not_nbt])
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                tag_list.append(not_nbt)

        # initialisation with different nbt objects
        for nbt_type1 in self.nbt_types:
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    TAG_List([nbt_type1(), nbt_type2()])
                else:
                    with self.assertRaises(TypeError):
                        TAG_List([nbt_type1(), nbt_type2()]),

        # adding different nbt objects
        for nbt_type1 in self.nbt_types:
            tag_list = TAG_List([nbt_type1()])
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    tag_list.append(nbt_type2())
                else:
                    with self.assertRaises(TypeError):
                        tag_list.append(nbt_type2())


if __name__ == "__main__":
    unittest.main()
