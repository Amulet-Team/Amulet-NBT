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

    def tearDown(self):
        pass

    def test_numerical_zero_equal(self):
        self.assertEqual(0, TAG_Byte())
        self.assertEqual(0, TAG_Short())
        self.assertEqual(0, TAG_Int())
        self.assertEqual(0, TAG_Long())
        self.assertEqual(0, TAG_Float())
        self.assertEqual(0, TAG_Double())
        self.assertEqual(TAG_Byte(), 0)
        self.assertEqual(TAG_Byte(), TAG_Byte())
        self.assertEqual(TAG_Byte(), TAG_Short())
        self.assertEqual(TAG_Byte(), TAG_Int())
        self.assertEqual(TAG_Byte(), TAG_Long())
        self.assertEqual(TAG_Byte(), TAG_Float())
        self.assertEqual(TAG_Byte(), TAG_Double())
        self.assertEqual(TAG_Short(), 0)
        self.assertEqual(TAG_Short(), TAG_Byte())
        self.assertEqual(TAG_Short(), TAG_Short())
        self.assertEqual(TAG_Short(), TAG_Int())
        self.assertEqual(TAG_Short(), TAG_Long())
        self.assertEqual(TAG_Short(), TAG_Float())
        self.assertEqual(TAG_Short(), TAG_Double())
        self.assertEqual(TAG_Int(), 0)
        self.assertEqual(TAG_Int(), TAG_Byte())
        self.assertEqual(TAG_Int(), TAG_Short())
        self.assertEqual(TAG_Int(), TAG_Int())
        self.assertEqual(TAG_Int(), TAG_Long())
        self.assertEqual(TAG_Int(), TAG_Float())
        self.assertEqual(TAG_Int(), TAG_Double())
        self.assertEqual(TAG_Long(), 0)
        self.assertEqual(TAG_Long(), TAG_Byte())
        self.assertEqual(TAG_Long(), TAG_Short())
        self.assertEqual(TAG_Long(), TAG_Int())
        self.assertEqual(TAG_Long(), TAG_Long())
        self.assertEqual(TAG_Long(), TAG_Float())
        self.assertEqual(TAG_Long(), TAG_Double())
        self.assertEqual(TAG_Float(), 0)
        self.assertEqual(TAG_Float(), TAG_Byte())
        self.assertEqual(TAG_Float(), TAG_Short())
        self.assertEqual(TAG_Float(), TAG_Int())
        self.assertEqual(TAG_Float(), TAG_Long())
        self.assertEqual(TAG_Float(), TAG_Float())
        self.assertEqual(TAG_Float(), TAG_Double())
        self.assertEqual(TAG_Double(), 0)
        self.assertEqual(TAG_Double(), TAG_Byte())
        self.assertEqual(TAG_Double(), TAG_Short())
        self.assertEqual(TAG_Double(), TAG_Int())
        self.assertEqual(TAG_Double(), TAG_Long())
        self.assertEqual(TAG_Double(), TAG_Float())
        self.assertEqual(TAG_Double(), TAG_Double())

    def test_numerical_positive_equal(self):
        self.assertEqual(50, TAG_Byte(50))
        self.assertEqual(50, TAG_Short(50))
        self.assertEqual(50, TAG_Int(50))
        self.assertEqual(50, TAG_Long(50))
        self.assertEqual(TAG_Byte(50), 50)
        self.assertEqual(TAG_Byte(50), TAG_Byte(50))
        self.assertEqual(TAG_Byte(50), TAG_Short(50))
        self.assertEqual(TAG_Byte(50), TAG_Int(50))
        self.assertEqual(TAG_Byte(50), TAG_Long(50))
        self.assertEqual(TAG_Short(50), 50)
        self.assertEqual(TAG_Short(50), TAG_Byte(50))
        self.assertEqual(TAG_Short(50), TAG_Short(50))
        self.assertEqual(TAG_Short(50), TAG_Int(50))
        self.assertEqual(TAG_Short(50), TAG_Long(50))
        self.assertEqual(TAG_Int(50), 50)
        self.assertEqual(TAG_Int(50), TAG_Byte(50))
        self.assertEqual(TAG_Int(50), TAG_Short(50))
        self.assertEqual(TAG_Int(50), TAG_Int(50))
        self.assertEqual(TAG_Int(50), TAG_Long(50))
        self.assertEqual(TAG_Long(50), 50)
        self.assertEqual(TAG_Long(50), TAG_Byte(50))
        self.assertEqual(TAG_Long(50), TAG_Short(50))
        self.assertEqual(TAG_Long(50), TAG_Int(50))
        self.assertEqual(TAG_Long(50), TAG_Long(50))

    def test_numerical_negative_equal(self):
        self.assertEqual(-50, TAG_Byte(-50))
        self.assertEqual(-50, TAG_Short(-50))
        self.assertEqual(-50, TAG_Int(-50))
        self.assertEqual(-50, TAG_Long(-50))
        self.assertEqual(TAG_Byte(-50), -50)
        self.assertEqual(TAG_Byte(-50), TAG_Byte(-50))
        self.assertEqual(TAG_Byte(-50), TAG_Short(-50))
        self.assertEqual(TAG_Byte(-50), TAG_Int(-50))
        self.assertEqual(TAG_Byte(-50), TAG_Long(-50))
        self.assertEqual(TAG_Short(-50), -50)
        self.assertEqual(TAG_Short(-50), TAG_Byte(-50))
        self.assertEqual(TAG_Short(-50), TAG_Short(-50))
        self.assertEqual(TAG_Short(-50), TAG_Int(-50))
        self.assertEqual(TAG_Short(-50), TAG_Long(-50))
        self.assertEqual(TAG_Int(-50), -50)
        self.assertEqual(TAG_Int(-50), TAG_Byte(-50))
        self.assertEqual(TAG_Int(-50), TAG_Short(-50))
        self.assertEqual(TAG_Int(-50), TAG_Int(-50))
        self.assertEqual(TAG_Int(-50), TAG_Long(-50))
        self.assertEqual(TAG_Long(-50), -50)
        self.assertEqual(TAG_Long(-50), TAG_Byte(-50))
        self.assertEqual(TAG_Long(-50), TAG_Short(-50))
        self.assertEqual(TAG_Long(-50), TAG_Int(-50))
        self.assertEqual(TAG_Long(-50), TAG_Long(-50))

    def test_numerical_addition(self):
        self.assertEqual(5 + TAG_Byte(5), 10)
        self.assertEqual(5 + TAG_Short(5), 10)
        self.assertEqual(5 + TAG_Int(5), 10)
        self.assertEqual(5 + TAG_Long(5), 10)
        self.assertEqual(5 + TAG_Float(5), 10)
        self.assertEqual(5 + TAG_Double(5), 10)

        self.assertEqual(5.5 + TAG_Byte(5), 10.5)
        self.assertEqual(5.5 + TAG_Short(5), 10.5)
        self.assertEqual(5.5 + TAG_Int(5), 10.5)
        self.assertEqual(5.5 + TAG_Long(5), 10.5)
        self.assertEqual(5.5 + TAG_Float(5), 10.5)
        self.assertEqual(5.5 + TAG_Double(5), 10.5)

        self.assertEqual(TAG_Byte(5) + 5, 10)
        self.assertEqual(TAG_Byte(5) + 5.5, 10.5)
        self.assertEqual(TAG_Byte(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Byte(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Byte(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Byte(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Byte(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Byte(5) + TAG_Double(5), 10)

        self.assertEqual(TAG_Short(5) + 5, 10)
        self.assertEqual(TAG_Short(5) + 5.5, 10.5)
        self.assertEqual(TAG_Short(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Short(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Short(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Short(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Short(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Short(5) + TAG_Double(5), 10)

        self.assertEqual(TAG_Int(5) + 5, 10)
        self.assertEqual(TAG_Int(5) + 5.5, 10.5)
        self.assertEqual(TAG_Int(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Int(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Int(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Int(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Int(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Int(5) + TAG_Double(5), 10)

        self.assertEqual(TAG_Long(5) + 5, 10)
        self.assertEqual(TAG_Long(5) + 5.5, 10.5)
        self.assertEqual(TAG_Long(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Long(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Long(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Long(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Long(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Long(5) + TAG_Double(5), 10)

        self.assertEqual(TAG_Float(5) + 5, 10)
        self.assertEqual(TAG_Float(5) + 5.5, 10.5)
        self.assertEqual(TAG_Float(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Float(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Float(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Float(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Float(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Float(5) + TAG_Double(5), 10)

        self.assertEqual(TAG_Double(5) + 5, 10)
        self.assertEqual(TAG_Double(5) + 5.5, 10.5)
        self.assertEqual(TAG_Double(5) + TAG_Byte(5), 10)
        self.assertEqual(TAG_Double(5) + TAG_Short(5), 10)
        self.assertEqual(TAG_Double(5) + TAG_Int(5), 10)
        self.assertEqual(TAG_Double(5) + TAG_Long(5), 10)
        self.assertEqual(TAG_Double(5) + TAG_Float(5), 10)
        self.assertEqual(TAG_Double(5) + TAG_Double(5), 10)

    def test_numerical_subtraction(self):
        self.assertEqual(5 - TAG_Byte(5), 0)
        self.assertEqual(5 - TAG_Short(5), 0)
        self.assertEqual(5 - TAG_Int(5), 0)
        self.assertEqual(5 - TAG_Long(5), 0)
        self.assertEqual(5 - TAG_Float(5), 0)
        self.assertEqual(5 - TAG_Double(5), 0)

        self.assertEqual(5.5 - TAG_Byte(5), 0.5)
        self.assertEqual(5.5 - TAG_Short(5), 0.5)
        self.assertEqual(5.5 - TAG_Int(5), 0.5)
        self.assertEqual(5.5 - TAG_Long(5), 0.5)
        self.assertEqual(5.5 - TAG_Float(5), 0.5)
        self.assertEqual(5.5 - TAG_Double(5), 0.5)

        self.assertEqual(TAG_Byte(5) - 5, 0)
        self.assertEqual(TAG_Byte(5) - 5.5, -0.5)
        self.assertEqual(TAG_Byte(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Byte(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Byte(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Byte(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Byte(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Byte(5) - TAG_Double(5), 0)

        self.assertEqual(TAG_Short(5) - 5, 0)
        self.assertEqual(TAG_Short(5) - 5.5, -0.5)
        self.assertEqual(TAG_Short(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Short(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Short(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Short(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Short(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Short(5) - TAG_Double(5), 0)

        self.assertEqual(TAG_Int(5) - 5, 0)
        self.assertEqual(TAG_Int(5) - 5.5, -0.5)
        self.assertEqual(TAG_Int(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Int(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Int(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Int(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Int(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Int(5) - TAG_Double(5), 0)

        self.assertEqual(TAG_Long(5) - 5, 0)
        self.assertEqual(TAG_Long(5) - 5.5, -0.5)
        self.assertEqual(TAG_Long(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Long(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Long(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Long(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Long(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Long(5) - TAG_Double(5), 0)

        self.assertEqual(TAG_Float(5) - 5, 0)
        self.assertEqual(TAG_Float(5) - 5.5, -0.5)
        self.assertEqual(TAG_Float(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Float(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Float(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Float(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Float(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Float(5) - TAG_Double(5), 0)

        self.assertEqual(TAG_Double(5) - 5, 0)
        self.assertEqual(TAG_Double(5) - 5.5, -0.5)
        self.assertEqual(TAG_Double(5) - TAG_Byte(5), 0)
        self.assertEqual(TAG_Double(5) - TAG_Short(5), 0)
        self.assertEqual(TAG_Double(5) - TAG_Int(5), 0)
        self.assertEqual(TAG_Double(5) - TAG_Long(5), 0)
        self.assertEqual(TAG_Double(5) - TAG_Float(5), 0)
        self.assertEqual(TAG_Double(5) - TAG_Double(5), 0)

    def test_numerical_addition_types(self):
        self.assertIsInstance(5 + TAG_Byte(5), int)
        self.assertIsInstance(5 + TAG_Short(5), int)
        self.assertIsInstance(5 + TAG_Int(5), int)
        self.assertIsInstance(5 + TAG_Long(5), int)
        self.assertIsInstance(5.0 + TAG_Float(5), float)
        self.assertIsInstance(5.0 + TAG_Double(5), float)

        self.assertIsInstance(5.5 + TAG_Byte(5), float)
        self.assertIsInstance(5.5 + TAG_Short(5), float)
        self.assertIsInstance(5.5 + TAG_Int(5), float)
        self.assertIsInstance(5.5 + TAG_Long(5), float)
        self.assertIsInstance(5.5 + TAG_Float(5), float)
        self.assertIsInstance(5.5 + TAG_Double(5), float)

        self.assertIsInstance(TAG_Byte(5) + 5, int)
        self.assertIsInstance(TAG_Byte(5) + 5.5, float)
        self.assertIsInstance(TAG_Byte(5) + TAG_Byte(5), int)
        self.assertIsInstance(TAG_Byte(5) + TAG_Short(5), int)
        self.assertIsInstance(TAG_Byte(5) + TAG_Int(5), int)
        self.assertIsInstance(TAG_Byte(5) + TAG_Long(5), int)
        self.assertIsInstance(TAG_Byte(5) + TAG_Float(5), float)
        self.assertIsInstance(TAG_Byte(5) + TAG_Double(5), float)

        self.assertIsInstance(TAG_Short(5) + 5, int)
        self.assertIsInstance(TAG_Short(5) + 5.5, float)
        self.assertIsInstance(TAG_Short(5) + TAG_Byte(5), int)
        self.assertIsInstance(TAG_Short(5) + TAG_Short(5), int)
        self.assertIsInstance(TAG_Short(5) + TAG_Int(5), int)
        self.assertIsInstance(TAG_Short(5) + TAG_Long(5), int)
        self.assertIsInstance(TAG_Short(5) + TAG_Float(5), float)
        self.assertIsInstance(TAG_Short(5) + TAG_Double(5), float)

        self.assertIsInstance(TAG_Int(5) + 5, int)
        self.assertIsInstance(TAG_Int(5) + 5.5, float)
        self.assertIsInstance(TAG_Int(5) + TAG_Byte(5), int)
        self.assertIsInstance(TAG_Int(5) + TAG_Short(5), int)
        self.assertIsInstance(TAG_Int(5) + TAG_Int(5), int)
        self.assertIsInstance(TAG_Int(5) + TAG_Long(5), int)
        self.assertIsInstance(TAG_Int(5) + TAG_Float(5), float)
        self.assertIsInstance(TAG_Int(5) + TAG_Double(5), float)

        self.assertIsInstance(TAG_Long(5) + 5, int)
        self.assertIsInstance(TAG_Long(5) + 5.5, float)
        self.assertIsInstance(TAG_Long(5) + TAG_Byte(5), int)
        self.assertIsInstance(TAG_Long(5) + TAG_Short(5), int)
        self.assertIsInstance(TAG_Long(5) + TAG_Int(5), int)
        self.assertIsInstance(TAG_Long(5) + TAG_Long(5), int)
        self.assertIsInstance(TAG_Long(5) + TAG_Float(5), float)
        self.assertIsInstance(TAG_Long(5) + TAG_Double(5), float)

        self.assertIsInstance(TAG_Float(5) + 5, float)
        self.assertIsInstance(TAG_Float(5) + 5.5, float)
        self.assertIsInstance(TAG_Float(5) + TAG_Byte(5), float)
        self.assertIsInstance(TAG_Float(5) + TAG_Short(5), float)
        self.assertIsInstance(TAG_Float(5) + TAG_Int(5), float)
        self.assertIsInstance(TAG_Float(5) + TAG_Long(5), float)
        self.assertIsInstance(TAG_Float(5) + TAG_Float(5), float)
        self.assertIsInstance(TAG_Float(5) + TAG_Double(5), float)

        self.assertIsInstance(TAG_Double(5) + 5, float)
        self.assertIsInstance(TAG_Double(5) + 5.5, float)
        self.assertIsInstance(TAG_Double(5) + TAG_Byte(5), float)
        self.assertIsInstance(TAG_Double(5) + TAG_Short(5), float)
        self.assertIsInstance(TAG_Double(5) + TAG_Int(5), float)
        self.assertIsInstance(TAG_Double(5) + TAG_Long(5), float)
        self.assertIsInstance(TAG_Double(5) + TAG_Float(5), float)
        self.assertIsInstance(
            TAG_Double(5) + TAG_Double(5), float
        )

    def test_numerical_subtraction_types(self):
        self.assertIsInstance(5 - TAG_Byte(5), int)
        self.assertIsInstance(5 - TAG_Short(5), int)
        self.assertIsInstance(5 - TAG_Int(5), int)
        self.assertIsInstance(5 - TAG_Long(5), int)
        self.assertIsInstance(5 - TAG_Float(5), float)
        self.assertIsInstance(5 - TAG_Double(5), float)

        self.assertIsInstance(5.5 - TAG_Byte(5), float)
        self.assertIsInstance(5.5 - TAG_Short(5), float)
        self.assertIsInstance(5.5 - TAG_Int(5), float)
        self.assertIsInstance(5.5 - TAG_Long(5), float)
        self.assertIsInstance(5.5 - TAG_Float(5), float)
        self.assertIsInstance(5.5 - TAG_Double(5), float)

        self.assertIsInstance(TAG_Byte(5) - 5, int)
        self.assertIsInstance(TAG_Byte(5) - 5.5, float)
        self.assertIsInstance(TAG_Byte(5) - TAG_Byte(5), int)
        self.assertIsInstance(TAG_Byte(5) - TAG_Short(5), int)
        self.assertIsInstance(TAG_Byte(5) - TAG_Int(5), int)
        self.assertIsInstance(TAG_Byte(5) - TAG_Long(5), int)
        self.assertIsInstance(TAG_Byte(5) - TAG_Float(5), float)
        self.assertIsInstance(TAG_Byte(5) - TAG_Double(5), float)

        self.assertIsInstance(TAG_Short(5) - 5, int)
        self.assertIsInstance(TAG_Short(5) - 5.5, float)
        self.assertIsInstance(TAG_Short(5) - TAG_Byte(5), int)
        self.assertIsInstance(TAG_Short(5) - TAG_Short(5), int)
        self.assertIsInstance(TAG_Short(5) - TAG_Int(5), int)
        self.assertIsInstance(TAG_Short(5) - TAG_Long(5), int)
        self.assertIsInstance(TAG_Short(5) - TAG_Float(5), float)
        self.assertIsInstance(TAG_Short(5) - TAG_Double(5), float)

        self.assertIsInstance(TAG_Int(5) - 5, int)
        self.assertIsInstance(TAG_Int(5) - 5.5, float)
        self.assertIsInstance(TAG_Int(5) - TAG_Byte(5), int)
        self.assertIsInstance(TAG_Int(5) - TAG_Short(5), int)
        self.assertIsInstance(TAG_Int(5) - TAG_Int(5), int)
        self.assertIsInstance(TAG_Int(5) - TAG_Long(5), int)
        self.assertIsInstance(TAG_Int(5) - TAG_Float(5), float)
        self.assertIsInstance(TAG_Int(5) - TAG_Double(5), float)

        self.assertIsInstance(TAG_Long(5) - 5, int)
        self.assertIsInstance(TAG_Long(5) - 5.5, float)
        self.assertIsInstance(TAG_Long(5) - TAG_Byte(5), int)
        self.assertIsInstance(TAG_Long(5) - TAG_Short(5), int)
        self.assertIsInstance(TAG_Long(5) - TAG_Int(5), int)
        self.assertIsInstance(TAG_Long(5) - TAG_Long(5), int)
        self.assertIsInstance(TAG_Long(5) - TAG_Float(5), float)
        self.assertIsInstance(TAG_Long(5) - TAG_Double(5), float)

        self.assertIsInstance(TAG_Float(5) - 5, float)
        self.assertIsInstance(TAG_Float(5) - 5.5, float)
        self.assertIsInstance(TAG_Float(5) - TAG_Byte(5), float)
        self.assertIsInstance(TAG_Float(5) - TAG_Short(5), float)
        self.assertIsInstance(TAG_Float(5) - TAG_Int(5), float)
        self.assertIsInstance(TAG_Float(5) - TAG_Long(5), float)
        self.assertIsInstance(TAG_Float(5) - TAG_Float(5), float)
        self.assertIsInstance(TAG_Float(5) - TAG_Double(5), float)

        self.assertIsInstance(TAG_Double(5) - 5, float)
        self.assertIsInstance(TAG_Double(5) - 5.5, float)
        self.assertIsInstance(TAG_Double(5) - TAG_Byte(5), float)
        self.assertIsInstance(TAG_Double(5) - TAG_Short(5), float)
        self.assertIsInstance(TAG_Double(5) - TAG_Int(5), float)
        self.assertIsInstance(TAG_Double(5) - TAG_Long(5), float)
        self.assertIsInstance(TAG_Double(5) - TAG_Float(5), float)
        self.assertIsInstance(
            TAG_Double(5) - TAG_Double(5), float
        )

    def test_numerical_errors(self):
        with self.assertRaises(Exception):
            TAG_Byte("str")
        with self.assertRaises(Exception):
            TAG_Byte([])
        with self.assertRaises(Exception):
            TAG_Byte({})
        with self.assertRaises(Exception):
            TAG_Short("str")
        with self.assertRaises(Exception):
            TAG_Short([])
        with self.assertRaises(Exception):
            TAG_Short({})
        with self.assertRaises(Exception):
            TAG_Int("str")
        with self.assertRaises(Exception):
            TAG_Int([])
        with self.assertRaises(Exception):
            TAG_Int({})
        with self.assertRaises(Exception):
            TAG_Long("str")
        with self.assertRaises(Exception):
            TAG_Long([])
        with self.assertRaises(Exception):
            TAG_Long({})
        with self.assertRaises(Exception):
            TAG_Float("str")
        with self.assertRaises(Exception):
            TAG_Float([])
        with self.assertRaises(Exception):
            TAG_Float({})
        with self.assertRaises(Exception):
            TAG_Double("str")
        with self.assertRaises(Exception):
            TAG_Double([])
        with self.assertRaises(Exception):
            TAG_Double({})
        with self.assertRaises(Exception):
            TAG_Byte() + "str"
        with self.assertRaises(Exception):
            TAG_Byte() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Byte() + []
        with self.assertRaises(Exception):
            TAG_Byte() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Byte() + {}
        with self.assertRaises(Exception):
            TAG_Byte() + TAG_Compound()
        with self.assertRaises(Exception):
            TAG_Short() + "str"
        with self.assertRaises(Exception):
            TAG_Short() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Short() + []
        with self.assertRaises(Exception):
            TAG_Short() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Short() + {}
        with self.assertRaises(Exception):
            TAG_Short() + TAG_Compound()
        with self.assertRaises(Exception):
            TAG_Int() + "str"
        with self.assertRaises(Exception):
            TAG_Int() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Int() + []
        with self.assertRaises(Exception):
            TAG_Int() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Int() + {}
        with self.assertRaises(Exception):
            TAG_Int() + TAG_Compound()
        with self.assertRaises(Exception):
            TAG_Long() + "str"
        with self.assertRaises(Exception):
            TAG_Long() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Long() + []
        with self.assertRaises(Exception):
            TAG_Long() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Long() + {}
        with self.assertRaises(Exception):
            TAG_Long() + TAG_Compound()
        with self.assertRaises(Exception):
            TAG_Float() + "str"
        with self.assertRaises(Exception):
            TAG_Float() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Float() + []
        with self.assertRaises(Exception):
            TAG_Float() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Float() + {}
        with self.assertRaises(Exception):
            TAG_Float() + TAG_Compound()
        with self.assertRaises(Exception):
            TAG_Double() + "str"
        with self.assertRaises(Exception):
            TAG_Double() + TAG_String()
        with self.assertRaises(Exception):
            TAG_Double() + []
        with self.assertRaises(Exception):
            TAG_Double() + TAG_List()
        with self.assertRaises(Exception):
            TAG_Double() + {}
        with self.assertRaises(Exception):
            TAG_Double() + TAG_Compound()

    def test_numerical_overflow(self):
        b = TAG_Byte()
        s = TAG_Short()
        i = TAG_Int()
        l = TAG_Long()

        b += 2 ** 7
        s += 2 ** 15
        i += 2 ** 31
        l += 2 ** 63

        self.assertEqual(b, -(2 ** 7))
        self.assertEqual(s, -(2 ** 15))
        self.assertEqual(i, -(2 ** 31))
        self.assertEqual(l, -(2 ** 63))

        b -= 1
        s -= 1
        i -= 1
        l -= 1

        self.assertEqual(b, 2 ** 7 - 1)
        self.assertEqual(s, 2 ** 15 - 1)
        self.assertEqual(i, 2 ** 31 - 1)
        self.assertEqual(l, 2 ** 63 - 1)

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
            self.assertEqual(
                TAG_List([t() for _ in range(5)]), [t() for _ in range(5)]
            )

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
            self.assertEqual(
                TAG_Compound({t.__name__: t()}), {t.__name__: t()}
            )

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
