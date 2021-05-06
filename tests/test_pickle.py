import unittest
import pickle
import numpy
import amulet_nbt.amulet_nbt_py as pynbt

try:
    import amulet_nbt.amulet_cy_nbt as cynbt
except (ImportError, ModuleNotFoundError) as e:
    cynbt = None


class AbstractNBTTest:
    class PickleNBTTests(unittest.TestCase):
        def _setUp(self, nbt_library):
            self.maxDiff = None
            self.nbt = nbt_library

        def _test_pickle(self, obj):
            pickled_obj = pickle.dumps(obj)
            obj2 = pickle.loads(pickled_obj)
            self.assertEqual(obj, obj2)
            self.assertIsNot(obj, obj2)
            if isinstance(obj.value, numpy.ndarray):
                numpy.testing.assert_array_equal(obj.value, obj2.value)
            else:
                self.assertEqual(obj.value, obj2.value)
            if not isinstance(obj.value, (int, str)):
                self.assertIsNot(obj.value, obj2.value)

        def test_pickle(self):
            self._test_pickle(self.nbt.TAG_Byte(10))
            self._test_pickle(self.nbt.TAG_Short(10))
            self._test_pickle(self.nbt.TAG_Int(10))
            self._test_pickle(self.nbt.TAG_Long(10))
            self._test_pickle(self.nbt.TAG_Float(10))
            self._test_pickle(self.nbt.TAG_Double(10))
            self._test_pickle(self.nbt.TAG_Byte_Array([1, 2, 3]))
            self._test_pickle(self.nbt.TAG_String())
            self._test_pickle(self.nbt.TAG_List())
            self._test_pickle(self.nbt.TAG_Compound())
            self._test_pickle(self.nbt.TAG_Int_Array([1, 2, 3]))
            self._test_pickle(self.nbt.TAG_Long_Array([1, 2, 3]))
            self._test_pickle(self.nbt.NBTFile())


@unittest.skipUnless(cynbt, "Cythonized library not available")
class CythonPickleNBTTest(AbstractNBTTest.PickleNBTTests):
    def setUp(self):
        self._setUp(cynbt)


class PythonPickleNBTTest(AbstractNBTTest.PickleNBTTests):
    def setUp(self):
        self._setUp(pynbt)


if __name__ == "__main__":
    unittest.main()
