import unittest
import amulet.nbt


class LegacyNBTTests(unittest.TestCase):
    def test_version(self) -> None:
        self.assertIsInstance(amulet.nbt.__version__, str)


if __name__ == "__main__":
    unittest.main()
