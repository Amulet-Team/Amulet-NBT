import unittest
import numpy

import amulet_nbt.amulet_py_nbt as pynbt

TEST_CYTHON_LIB = True
try:
    import amulet_nbt.amulet_cy_nbt as cynbt
except (ImportError, ModuleNotFoundError) as e:
    TEST_CYTHON_LIB = False



class AbstractNBTTest:
    class NBTTests(unittest.TestCase):

        def _setUp(self, nbt_library):
            self.nbt = nbt_library

            self._int_types = (
                self.nbt.TAG_Byte,
                self.nbt.TAG_Short,
                self.nbt.TAG_Int,
                self.nbt.TAG_Long,
            )
            self._float_types = (
                self.nbt.TAG_Float,
                self.nbt.TAG_Double,
            )
            self._numerical_types = self._int_types + self._float_types
            self._str_types = (
                self.nbt.TAG_String,
            )
            self._array_types = (
                self.nbt.TAG_Byte_Array,
                self.nbt.TAG_Int_Array,
                self.nbt.TAG_Long_Array,
            )
            self._container_types = (
                self.nbt.TAG_List,
                self.nbt.TAG_Compound,
            )
            self._nbt_types = self._numerical_types + self._str_types + self._array_types + self._container_types

            self._not_nbt = (0, "test", [], {})

        def tearDown(self):
            pass

        def test_numerical_zero_equal(self):
            self.assertEqual(0, self.nbt.TAG_Byte())
            self.assertEqual(0, self.nbt.TAG_Short())
            self.assertEqual(0, self.nbt.TAG_Int())
            self.assertEqual(0, self.nbt.TAG_Long())
            self.assertEqual(0, self.nbt.TAG_Float())
            self.assertEqual(0, self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Byte(), 0)
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Byte(), self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Short(), 0)
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Short(), self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Int(), 0)
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Int(), self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Long(), 0)
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Long(), self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Float(), 0)
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Float(), self.nbt.TAG_Double())
            self.assertEqual(self.nbt.TAG_Double(), 0)
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Byte())
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Short())
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Int())
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Long())
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Float())
            self.assertEqual(self.nbt.TAG_Double(), self.nbt.TAG_Double())

        def test_numerical_positive_equal(self):
            self.assertEqual(50, self.nbt.TAG_Byte(50))
            self.assertEqual(50, self.nbt.TAG_Short(50))
            self.assertEqual(50, self.nbt.TAG_Int(50))
            self.assertEqual(50, self.nbt.TAG_Long(50))
            self.assertEqual(self.nbt.TAG_Byte(50), 50)
            self.assertEqual(self.nbt.TAG_Byte(50), self.nbt.TAG_Byte(50))
            self.assertEqual(self.nbt.TAG_Byte(50), self.nbt.TAG_Short(50))
            self.assertEqual(self.nbt.TAG_Byte(50), self.nbt.TAG_Int(50))
            self.assertEqual(self.nbt.TAG_Byte(50), self.nbt.TAG_Long(50))
            self.assertEqual(self.nbt.TAG_Short(50), 50)
            self.assertEqual(self.nbt.TAG_Short(50), self.nbt.TAG_Byte(50))
            self.assertEqual(self.nbt.TAG_Short(50), self.nbt.TAG_Short(50))
            self.assertEqual(self.nbt.TAG_Short(50), self.nbt.TAG_Int(50))
            self.assertEqual(self.nbt.TAG_Short(50), self.nbt.TAG_Long(50))
            self.assertEqual(self.nbt.TAG_Int(50), 50)
            self.assertEqual(self.nbt.TAG_Int(50), self.nbt.TAG_Byte(50))
            self.assertEqual(self.nbt.TAG_Int(50), self.nbt.TAG_Short(50))
            self.assertEqual(self.nbt.TAG_Int(50), self.nbt.TAG_Int(50))
            self.assertEqual(self.nbt.TAG_Int(50), self.nbt.TAG_Long(50))
            self.assertEqual(self.nbt.TAG_Long(50), 50)
            self.assertEqual(self.nbt.TAG_Long(50), self.nbt.TAG_Byte(50))
            self.assertEqual(self.nbt.TAG_Long(50), self.nbt.TAG_Short(50))
            self.assertEqual(self.nbt.TAG_Long(50), self.nbt.TAG_Int(50))
            self.assertEqual(self.nbt.TAG_Long(50), self.nbt.TAG_Long(50))

        def test_numerical_negative_equal(self):
            self.assertEqual(-50, self.nbt.TAG_Byte(-50))
            self.assertEqual(-50, self.nbt.TAG_Short(-50))
            self.assertEqual(-50, self.nbt.TAG_Int(-50))
            self.assertEqual(-50, self.nbt.TAG_Long(-50))
            self.assertEqual(self.nbt.TAG_Byte(-50), -50)
            self.assertEqual(self.nbt.TAG_Byte(-50), self.nbt.TAG_Byte(-50))
            self.assertEqual(self.nbt.TAG_Byte(-50), self.nbt.TAG_Short(-50))
            self.assertEqual(self.nbt.TAG_Byte(-50), self.nbt.TAG_Int(-50))
            self.assertEqual(self.nbt.TAG_Byte(-50), self.nbt.TAG_Long(-50))
            self.assertEqual(self.nbt.TAG_Short(-50), -50)
            self.assertEqual(self.nbt.TAG_Short(-50), self.nbt.TAG_Byte(-50))
            self.assertEqual(self.nbt.TAG_Short(-50), self.nbt.TAG_Short(-50))
            self.assertEqual(self.nbt.TAG_Short(-50), self.nbt.TAG_Int(-50))
            self.assertEqual(self.nbt.TAG_Short(-50), self.nbt.TAG_Long(-50))
            self.assertEqual(self.nbt.TAG_Int(-50), -50)
            self.assertEqual(self.nbt.TAG_Int(-50), self.nbt.TAG_Byte(-50))
            self.assertEqual(self.nbt.TAG_Int(-50), self.nbt.TAG_Short(-50))
            self.assertEqual(self.nbt.TAG_Int(-50), self.nbt.TAG_Int(-50))
            self.assertEqual(self.nbt.TAG_Int(-50), self.nbt.TAG_Long(-50))
            self.assertEqual(self.nbt.TAG_Long(-50), -50)
            self.assertEqual(self.nbt.TAG_Long(-50), self.nbt.TAG_Byte(-50))
            self.assertEqual(self.nbt.TAG_Long(-50), self.nbt.TAG_Short(-50))
            self.assertEqual(self.nbt.TAG_Long(-50), self.nbt.TAG_Int(-50))
            self.assertEqual(self.nbt.TAG_Long(-50), self.nbt.TAG_Long(-50))

        def test_numerical_addition(self):
            self.assertEqual(5 + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(5 + self.nbt.TAG_Short(5), 10)
            self.assertEqual(5 + self.nbt.TAG_Int(5), 10)
            self.assertEqual(5 + self.nbt.TAG_Long(5), 10)
            self.assertEqual(5 + self.nbt.TAG_Float(5), 10)
            self.assertEqual(5 + self.nbt.TAG_Double(5), 10)

            self.assertEqual(5.5 + self.nbt.TAG_Byte(5), 10.5)
            self.assertEqual(5.5 + self.nbt.TAG_Short(5), 10.5)
            self.assertEqual(5.5 + self.nbt.TAG_Int(5), 10.5)
            self.assertEqual(5.5 + self.nbt.TAG_Long(5), 10.5)
            self.assertEqual(5.5 + self.nbt.TAG_Float(5), 10.5)
            self.assertEqual(5.5 + self.nbt.TAG_Double(5), 10.5)

            self.assertEqual(self.nbt.TAG_Byte(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Byte(5) + self.nbt.TAG_Double(5), 10)

            self.assertEqual(self.nbt.TAG_Short(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Short(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Short(5) + self.nbt.TAG_Double(5), 10)

            self.assertEqual(self.nbt.TAG_Int(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Int(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Int(5) + self.nbt.TAG_Double(5), 10)

            self.assertEqual(self.nbt.TAG_Long(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Long(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Long(5) + self.nbt.TAG_Double(5), 10)

            self.assertEqual(self.nbt.TAG_Float(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Float(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Float(5) + self.nbt.TAG_Double(5), 10)

            self.assertEqual(self.nbt.TAG_Double(5) + 5, 10)
            self.assertEqual(self.nbt.TAG_Double(5) + 5.5, 10.5)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Byte(5), 10)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Short(5), 10)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Int(5), 10)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Long(5), 10)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Float(5), 10)
            self.assertEqual(self.nbt.TAG_Double(5) + self.nbt.TAG_Double(5), 10)

        def test_numerical_subtraction(self):
            self.assertEqual(5 - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(5 - self.nbt.TAG_Short(5), 0)
            self.assertEqual(5 - self.nbt.TAG_Int(5), 0)
            self.assertEqual(5 - self.nbt.TAG_Long(5), 0)
            self.assertEqual(5 - self.nbt.TAG_Float(5), 0)
            self.assertEqual(5 - self.nbt.TAG_Double(5), 0)

            self.assertEqual(5.5 - self.nbt.TAG_Byte(5), 0.5)
            self.assertEqual(5.5 - self.nbt.TAG_Short(5), 0.5)
            self.assertEqual(5.5 - self.nbt.TAG_Int(5), 0.5)
            self.assertEqual(5.5 - self.nbt.TAG_Long(5), 0.5)
            self.assertEqual(5.5 - self.nbt.TAG_Float(5), 0.5)
            self.assertEqual(5.5 - self.nbt.TAG_Double(5), 0.5)

            self.assertEqual(self.nbt.TAG_Byte(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Byte(5) - self.nbt.TAG_Double(5), 0)

            self.assertEqual(self.nbt.TAG_Short(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Short(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Short(5) - self.nbt.TAG_Double(5), 0)

            self.assertEqual(self.nbt.TAG_Int(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Int(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Int(5) - self.nbt.TAG_Double(5), 0)

            self.assertEqual(self.nbt.TAG_Long(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Long(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Long(5) - self.nbt.TAG_Double(5), 0)

            self.assertEqual(self.nbt.TAG_Float(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Float(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Float(5) - self.nbt.TAG_Double(5), 0)

            self.assertEqual(self.nbt.TAG_Double(5) - 5, 0)
            self.assertEqual(self.nbt.TAG_Double(5) - 5.5, -0.5)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Byte(5), 0)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Short(5), 0)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Int(5), 0)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Long(5), 0)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Float(5), 0)
            self.assertEqual(self.nbt.TAG_Double(5) - self.nbt.TAG_Double(5), 0)

        def test_numerical_addition_types(self):
            self.assertIsInstance(5 + self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(5 + self.nbt.TAG_Short(5), int)
            self.assertIsInstance(5 + self.nbt.TAG_Int(5), int)
            self.assertIsInstance(5 + self.nbt.TAG_Long(5), int)
            self.assertIsInstance(5 + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(5 + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(5.5 + self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(5.5 + self.nbt.TAG_Short(5), float)
            self.assertIsInstance(5.5 + self.nbt.TAG_Int(5), float)
            self.assertIsInstance(5.5 + self.nbt.TAG_Long(5), float)
            self.assertIsInstance(5.5 + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(5.5 + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Byte(5) + 5, int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Byte(5) + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Short(5) + 5, int)
            self.assertIsInstance(self.nbt.TAG_Short(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Short(5) + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Int(5) + 5, int)
            self.assertIsInstance(self.nbt.TAG_Int(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Int(5) + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Long(5) + 5, int)
            self.assertIsInstance(self.nbt.TAG_Long(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Long(5) + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Float(5) + 5, float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Short(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Int(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Long(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) + self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Double(5) + 5, float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Short(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Int(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Long(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) + self.nbt.TAG_Double(5), float)

        def test_numerical_subtraction_types(self):
            self.assertIsInstance(5 - self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(5 - self.nbt.TAG_Short(5), int)
            self.assertIsInstance(5 - self.nbt.TAG_Int(5), int)
            self.assertIsInstance(5 - self.nbt.TAG_Long(5), int)
            self.assertIsInstance(5 - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(5 - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(5.5 - self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(5.5 - self.nbt.TAG_Short(5), float)
            self.assertIsInstance(5.5 - self.nbt.TAG_Int(5), float)
            self.assertIsInstance(5.5 - self.nbt.TAG_Long(5), float)
            self.assertIsInstance(5.5 - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(5.5 - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Byte(5) - 5, int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Byte(5) - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Short(5) - 5, int)
            self.assertIsInstance(self.nbt.TAG_Short(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Short(5) - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Int(5) - 5, int)
            self.assertIsInstance(self.nbt.TAG_Int(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Int(5) - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Long(5) - 5, int)
            self.assertIsInstance(self.nbt.TAG_Long(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Byte(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Short(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Int(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Long(5), int)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Long(5) - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Float(5) - 5, float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Short(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Int(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Long(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Float(5) - self.nbt.TAG_Double(5), float)

            self.assertIsInstance(self.nbt.TAG_Double(5) - 5, float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - 5.5, float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Byte(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Short(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Int(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Long(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Float(5), float)
            self.assertIsInstance(self.nbt.TAG_Double(5) - self.nbt.TAG_Double(5), float)

        def test_numerical_errors(self):
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte({}))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short({}))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int({}))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long({}))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float({}))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double('str'))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double([]))
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double({}))

            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Byte() + self.nbt.TAG_Compound())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Short() + self.nbt.TAG_Compound())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Int() + self.nbt.TAG_Compound())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Long() + self.nbt.TAG_Compound())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Float() + self.nbt.TAG_Compound())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + 'str')
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + self.nbt.TAG_String())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + [])
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + self.nbt.TAG_List())
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + {})
            self.assertRaises(Exception, lambda: self.nbt.TAG_Double() + self.nbt.TAG_Compound())

        # We skip the numerical overflow/underflow test since arithmetic operations return Python ints, which aren't
        # bound by a given value range
        @unittest.skip
        def test_numerical_overflow(self):
            self.assertEqual(self.nbt.TAG_Byte() + (2**7 - 1), 2**7 - 1)
            self.assertEqual(self.nbt.TAG_Byte() + 2**7, -(2**7))
            self.assertEqual(self.nbt.TAG_Short() + (2 ** 15 - 1), 2 ** 15 - 1)
            self.assertEqual(self.nbt.TAG_Short() + 2 ** 15, -(2 ** 15))
            self.assertEqual(self.nbt.TAG_Int() + (2 ** 31 - 1), 2 ** 31 - 1)
            self.assertEqual(self.nbt.TAG_Int() + 2 ** 31, -(2 ** 31))
            self.assertEqual(self.nbt.TAG_Long() + (2 ** 63 - 1), 2 ** 63 - 1)
            self.assertEqual(self.nbt.TAG_Long() + 2 ** 63, -(2 ** 63))

        @unittest.skip
        def test_numerical_underflow(self):
            self.assertEqual(self.nbt.TAG_Byte() - (2**7), -(2**7))
            self.assertEqual(self.nbt.TAG_Byte() - (2**7 + 1), 2**7 - 1)
            self.assertEqual(self.nbt.TAG_Short() - (2 ** 15), -(2 ** 15))
            self.assertEqual(self.nbt.TAG_Short() - (2 ** 15 + 1), 2 ** 15 - 1)
            self.assertEqual(self.nbt.TAG_Int() - (2 ** 31), -(2 ** 31))
            self.assertEqual(self.nbt.TAG_Int() - (2 ** 31 + 1), 2 ** 31 - 1)
            self.assertEqual(self.nbt.TAG_Long() - (2 ** 63), -(2 ** 63))
            self.assertEqual(self.nbt.TAG_Long() - (2 ** 63 + 1), 2 ** 63 - 1)

        def test_string(self):
            self.assertEqual(self.nbt.TAG_String(), "")
            self.assertEqual(self.nbt.TAG_String("test"), "test")
            self.assertEqual(self.nbt.TAG_String("test") + "test", "testtest")
            self.assertIsInstance(self.nbt.TAG_String("test") + "test", str)
            self.assertIsInstance("test" + self.nbt.TAG_String("test"), str)
            self.assertEqual(self.nbt.TAG_String("test") * 3, "testtesttest")
            self.assertIsInstance(self.nbt.TAG_String("test") * 3, str)

        def test_array_overflow(self):
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Byte_Array([0]) + (2**7 - 1), [2**7 - 1]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Byte_Array([0]) + 2**7, [-(2**7)]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Int_Array([0]) + (2 ** 31 - 1), [2 ** 31 - 1]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Int_Array([0]) + 2 ** 31, [-(2 ** 31)]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Long_Array([0]) + (2 ** 63 - 1), [2 ** 63 - 1]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Long_Array([0]) + 2 ** 63, [-(2 ** 63)]))

        def test_array_underflow(self):
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Byte_Array([0]) - (2**7), [-(2**7)]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Byte_Array([0]) - (2**7 + 1), [2**7 - 1]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Int_Array([0]) - (2 ** 31), [-(2 ** 31)]))
            self.assertTrue(numpy.array_equal(self.nbt.TAG_Int_Array([0]) - (2 ** 31 + 1), [2 ** 31 - 1]))
            #self.assertTrue(numpy.array_equal(self.nbt.TAG_Long_Array([0]) - (2 ** 63), [-(2 ** 63)]))
            #self.assertTrue(numpy.array_equal(self.nbt.TAG_Long_Array([0]) - (2 ** 63 + 1), [(2 ** 63) - 1]))
            # Skip TAG_Long_Array test since the dtype used doesn't underflow as of Numpy 1.17.4

        def test_list(self):
            self.assertEqual(self.nbt.TAG_List(), [])
            for t in self._nbt_types:
                self.assertEqual(self.nbt.TAG_List([t() for _ in range(5)]), [t() for _ in range(5)])

            # initialisation with and appending not nbt objects
            tag_list = self.nbt.TAG_List()
            for not_nbt in self._not_nbt:
                self.assertRaises(TypeError, lambda: self.nbt.TAG_List([not_nbt]))
                self.assertRaises(TypeError, lambda: tag_list.append(not_nbt))

            # initialisation with different nbt objects
            for nbt_type1 in self._nbt_types:
                for nbt_type2 in self._nbt_types:
                    if nbt_type1 is nbt_type2:
                        self.nbt.TAG_List([nbt_type1(), nbt_type2()])
                    else:
                        self.assertRaises(TypeError, lambda: self.nbt.TAG_List([nbt_type1(), nbt_type2()]))

            # adding different nbt objects
            for nbt_type1 in self._nbt_types:
                tag_list = self.nbt.TAG_List([nbt_type1()])
                for nbt_type2 in self._nbt_types:
                    if nbt_type1 is nbt_type2:
                        tag_list.append(nbt_type2())
                    else:
                        self.assertRaises(TypeError, lambda: tag_list.append(nbt_type2()))

        def test_compound(self):
            self.assertEqual(self.nbt.TAG_Compound(), {})
            for t in self._nbt_types:
                self.assertEqual(self.nbt.TAG_Compound({t.__name__: t()}), {t.__name__: t()})

            # keys must be strings
            self.assertRaises(TypeError, lambda: self.nbt.TAG_Compound({0: self.nbt.TAG_Int()}))
            c = self.nbt.TAG_Compound()

            def f():
                c[0] = self.nbt.TAG_Int()
            self.assertRaises(TypeError, f)

            # initialisation with and adding not nbt objects
            for not_nbt in self._not_nbt:
                self.assertRaises(TypeError, lambda: self.nbt.TAG_Compound({not_nbt.__class__.__name__: not_nbt}))

                def f():
                    c[not_nbt.__class__.__name__] = not_nbt
                self.assertRaises(TypeError, f)


@unittest.skipUnless(TEST_CYTHON_LIB, "Cythonized library not available")
class CythonNBTTest(AbstractNBTTest.NBTTests):

    def setUp(self):
        self._setUp(cynbt)


class PythonNBTTest(AbstractNBTTest.NBTTests):

    def setUp(self):
        self._setUp(pynbt)


if __name__ == '__main__':
    unittest.main()
