import unittest
import os
import amulet_nbt


class LegacyNBTTests(unittest.TestCase):
    def test_version(self) -> None:
        self.assertIsInstance(amulet_nbt.__version__, str)
        self.assertIsInstance(amulet_nbt.__major__, int)

    def test_paths(self) -> None:
        self.assertIsInstance(amulet_nbt.get_include(), str)
        self.assertIsInstance(amulet_nbt.get_source(), str)
        self.assertTrue(os.path.isdir(amulet_nbt.get_include()))
        self.assertTrue(os.path.isdir(amulet_nbt.get_source()))


if __name__ == "__main__":
    unittest.main()
