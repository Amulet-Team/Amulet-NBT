import os
import unittest

#import amulet_nbt as nbt
import amulet_nbt.amulet_py_nbt as pynbt

TEST_CYTHON_LIB = True
try:
    import amulet_nbt.amulet_cy_nbt as cynbt
except (ImportError, ModuleNotFoundError) as e:
    TEST_CYTHON_LIB = False

TESTS_DIR = os.path.dirname(__file__)

class AbstractNBTTest:
    class NBTTests(unittest.TestCase):

        def _setUp(self, nbt_library):
            self.nbt = nbt_library
            self.level_root_tag = self.nbt.load(os.path.join(TESTS_DIR, "worlds", "1.13 World", "level.dat"))

        def tearDown(self):
            test_dat = os.path.join(TESTS_DIR, 'test.dat')

            #if os.path.exists(test_dat):
                #os.remove(test_dat)

        def test_load(self):
            self.assertIsInstance(self.level_root_tag, self.nbt.NBTFile)
            self.assertIsInstance(self.level_root_tag.value, self.nbt.TAG_Compound)

        def test_save(self):
            self.level_root_tag.save_to(os.path.join(TESTS_DIR, f'test{self.nbt.__name__}.dat'), compressed=False)

            saved_level_dat = self.nbt.load(os.path.join(TESTS_DIR, f'test{self.nbt.__name__}.dat'))

            self.assertEqual(self.level_root_tag, saved_level_dat)

@unittest.skipIf((not TEST_CYTHON_LIB), "Cythonized library not available")
class CythonNBTTest(AbstractNBTTest.NBTTests):

    def setUp(self):
        self._setUp(cynbt)

class PythonNBTTest(AbstractNBTTest.NBTTests):

    def setUp(self):
        self._setUp(pynbt)



if __name__ == '__main__':
    unittest.main()
