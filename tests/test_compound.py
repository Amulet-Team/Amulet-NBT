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
    def test_init_empty(self):
        pass

    def test_init(self):
        pass

    def test_errors(self):
        pass

    def test_compound(self):
        self.assertEqual(TAG_Compound(), {})
        for t in self._nbt_types:
            self.assertEqual(TAG_Compound({t.__name__: t()}), {t.__name__: t()})

        # keys must be strings
        with self.assertRaises(TypeError):
            TAG_Compound({0: TAG_Int()})

        c = TAG_Compound()
        with self.assertRaises(TypeError):
            c[0] = TAG_Int()

        # initialisation with and adding not nbt objects
        for not_nbt in self._not_nbt:
            with self.assertRaises(TypeError):
                TAG_Compound({not_nbt.__class__.__name__: not_nbt})

            with self.assertRaises(TypeError):
                c[not_nbt.__class__.__name__] = not_nbt
