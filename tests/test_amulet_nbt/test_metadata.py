import unittest
import os
import amulet_nbt


class LegacyNBTTests(unittest.TestCase):
    def test_version(self) -> None:
        self.assertIsInstance(amulet_nbt.__version__, str)
        self.assertIsInstance(amulet_nbt.__major__, int)


if __name__ == "__main__":
    unittest.main()
