import unittest
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


class TestCompound(base_type_test.BaseTypeTest):
    this_types = (TAG_Compound,)

    @property
    def values(self):
        return (
            ({},)
            + tuple({"name": cls()} for cls in self.nbt_types)
            + tuple({"name1": cls(), "name2": cls()} for cls in self.nbt_types)
            + ({cls.__name__: cls() for cls in self.nbt_types},)
        )

    def test_init(self):
        self._test_init(dict, {})

    def test_compound(self):
        self.assertEqual(TAG_Compound(), {})
        for t in self.nbt_types:
            self.assertEqual(TAG_Compound({t.__name__: t()}), {t.__name__: t()})

        # keys must be strings
        with self.assertRaises(TypeError):
            TAG_Compound({0: TAG_Int()})

        c = TAG_Compound()
        with self.assertRaises(TypeError):
            c[0] = TAG_Int()

        # initialisation with and adding not nbt objects
        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                TAG_Compound({not_nbt.__class__.__name__: not_nbt})

            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                c[not_nbt.__class__.__name__] = not_nbt


if __name__ == "__main__":
    unittest.main()
