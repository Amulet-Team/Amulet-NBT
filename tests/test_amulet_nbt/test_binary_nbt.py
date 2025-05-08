import unittest
from unittest import TestCase

from amulet.nbt import NamedTag, IntTag


class TestBinaryNBT(TestCase):
    def test_binary_nbt(self) -> None:
        from test_amulet_nbt.test_binary_nbt_ import encode_binary_nbt

        self.assertEqual(b"\x03\x00\x02hi\x00\x00\x00\x05", encode_binary_nbt(NamedTag(IntTag(5), "hi")))


if __name__ == '__main__':
    unittest.main()
