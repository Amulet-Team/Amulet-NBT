import os
import unittest

import amulet_nbt as nbt

TESTS_DIR = os.path.dirname(__file__)

class MyTestCase(unittest.TestCase):

    def setUp(self):
        self.level_root_tag = nbt.load(os.path.join(TESTS_DIR, "worlds", "1.13 World", "level.dat"))

    def tearDown(self):
        test_dat = os.path.join(TESTS_DIR, 'test.dat')

        if os.path.exists(test_dat):
            os.remove(test_dat)

    def test_load(self):
        self.assertIsInstance(self.level_root_tag, nbt.NBTFile)
        self.assertIsInstance(self.level_root_tag.value, nbt.TAG_Compound)

    def test_save(self):
        self.level_root_tag.save_to(os.path.join(TESTS_DIR, 'test.dat'))

        saved_level_dat = nbt.load(os.path.join(TESTS_DIR, 'test.dat'))

        self.assertEqual(self.level_root_tag, saved_level_dat)



if __name__ == '__main__':
    unittest.main()
