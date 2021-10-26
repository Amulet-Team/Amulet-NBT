import unittest
import numpy

from amulet_nbt import (
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
)


class NBTTests(unittest.TestCase):
    def setUp(self):
        self._int_types = (
            TAG_Byte,
            TAG_Short,
            TAG_Int,
            TAG_Long,
        )
        self._float_types = (
            TAG_Float,
            TAG_Double,
        )
        self._numerical_types = self._int_types + self._float_types
        self._str_types = (TAG_String,)
        self._array_types = (
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        )
        self._container_types = (
            TAG_List,
            TAG_Compound,
        )
        self._nbt_types = (
            self._numerical_types
            + self._str_types
            + self._array_types
            + self._container_types
        )

        self._not_nbt = (0, "test", [], {})

    def test_string(self):
        self.assertEqual(TAG_String(), "")
        self.assertEqual(TAG_String("test"), "test")
        self.assertEqual(TAG_String("test") + "test", "testtest")
        self.assertIsInstance(TAG_String("test") + "test", str)
        self.assertIsInstance("test" + TAG_String("test"), str)
        self.assertEqual(TAG_String("test") * 3, "testtesttest")
        self.assertIsInstance(TAG_String("test") * 3, str)

    def test_array_overflow(self):
        b_arr = TAG_Byte_Array([0])
        b_arr += 2 ** 7
        i_arr = TAG_Int_Array([0])
        i_arr += 2 ** 31
        # numpy throws an error when overflowing int64
        # l_arr = TAG_Long_Array([0])
        # l_arr += 2 ** 63

        self.assertTrue(numpy.array_equal(b_arr, [-(2 ** 7)]))
        self.assertTrue(numpy.array_equal(i_arr, [-(2 ** 31)]))
        # self.assertTrue(numpy.array_equal(l_arr, [-(2 ** 63)]))

        b_arr -= 1
        i_arr -= 1
        # l_arr -= 1

        self.assertTrue(numpy.array_equal(b_arr, [2 ** 7 - 1]))
        self.assertTrue(numpy.array_equal(i_arr, [2 ** 31 - 1]))
        # self.assertTrue(numpy.array_equal(l_arr, [2 ** 63 - 1]))

    def test_list(self):
        self.assertEqual(TAG_List(), [])
        for t in self._nbt_types:
            self.assertEqual(TAG_List([t() for _ in range(5)]), [t() for _ in range(5)])

        # initialisation with and appending not nbt objects
        tag_list = TAG_List()
        for not_nbt in self._not_nbt:
            with self.assertRaises(TypeError):
                TAG_List([not_nbt])
            with self.assertRaises(TypeError):
                tag_list.append(not_nbt)

        # initialisation with different nbt objects
        for nbt_type1 in self._nbt_types:
            for nbt_type2 in self._nbt_types:
                if nbt_type1 is nbt_type2:
                    TAG_List([nbt_type1(), nbt_type2()])
                else:
                    with self.assertRaises(TypeError):
                        TAG_List([nbt_type1(), nbt_type2()]),

        # adding different nbt objects
        for nbt_type1 in self._nbt_types:
            tag_list = TAG_List([nbt_type1()])
            for nbt_type2 in self._nbt_types:
                if nbt_type1 is nbt_type2:
                    tag_list.append(nbt_type2())
                else:
                    with self.assertRaises(TypeError):
                        tag_list.append(nbt_type2())

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

    def test_init(self):
        for inp in (
            5,
            TAG_Byte(5),
            TAG_Short(5),
            TAG_Int(5),
            TAG_Long(5),
            5.5,
            TAG_Float(5.5),
            TAG_Double(5.5),
        ):
            for nbt_type in self._int_types:
                self.assertIsInstance(nbt_type(inp).value, int)
                self.assertEqual(nbt_type(inp), 5)
            for nbt_type in self._float_types:
                self.assertIsInstance(nbt_type(inp).value, float)
                if inp == 5:
                    self.assertEqual(nbt_type(inp), 5)
                else:
                    self.assertEqual(nbt_type(inp), 5.5)

        TAG_String(TAG_String())
        TAG_List(TAG_List())
        TAG_Compound(TAG_Compound())

        TAG_Byte_Array(TAG_Byte_Array())
        TAG_Int_Array(TAG_Int_Array())
        TAG_Long_Array(TAG_Long_Array())


if __name__ == "__main__":
    unittest.main()
