import unittest
from copy import copy

import amulet_nbt
from tests.binary_data import binary_data_tuple


class NBTTests(unittest.TestCase):
    def _load(self, b: bytes, little_endian: bool = False):
        b_copy = copy(b)
        named_tag = amulet_nbt.load(b_copy, little_endian=little_endian)
        self.assertEqual(b, b_copy, msg="The buffer changed.")
        named_tag2 = amulet_nbt.load(b_copy, little_endian=little_endian)
        self.assertEqual(named_tag.name, named_tag2.name)
        self.assertEqual(named_tag.tag, named_tag2.tag)
        return named_tag

    def test_read_big_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag, self._load(data.big_endian), msg=str(data.named_tag)
            )

    def test_read_big_endian_compressed(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                amulet_nbt.load(data.big_endian_compressed),
                msg=str(data.named_tag),
            )

    def test_read_little_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                self._load(data.little_endian, little_endian=True),
                msg=str(data.named_tag),
            )

    def test_read_little_endian_compressed(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                amulet_nbt.load(data.little_endian_compressed, little_endian=True),
                msg=str(data.named_tag),
            )

    def test_write_big_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag.to_nbt(compressed=False),
                data.big_endian,
                msg=str(data.named_tag),
            )

    def test_write_little_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag.to_nbt(compressed=False, little_endian=True),
                data.little_endian,
                msg=str(data.named_tag),
            )


if __name__ == "__main__":
    unittest.main()
