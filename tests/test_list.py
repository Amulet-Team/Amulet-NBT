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

    def test_list(self):
        for t in self.nbt_types:
            self.assertEqual(TAG_List([t() for _ in range(5)]), [t() for _ in range(5)])

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
