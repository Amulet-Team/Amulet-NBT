import unittest
from copy import copy

import amulet_nbt
from amulet_nbt._load_nbt import load_tag
from amulet_nbt._util import BufferContext
from tests.binary_data import binary_data_tuple


class NBTTests(unittest.TestCase):
    def _load(self, b: bytes, little_endian: bool = False):
        buffer = BufferContext(copy(b))
        name, tag = load_tag(buffer, little_endian)
        self.assertEqual(b, buffer.get_buffer(), msg="The buffer changed.")
        named_tag = amulet_nbt.load_one(b, little_endian=little_endian)
        self.assertEqual(name, named_tag.name)
        self.assertEqual(tag, named_tag.tag)
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
                amulet_nbt.load_one(data.big_endian_compressed),
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
                amulet_nbt.load_one(data.little_endian_compressed, little_endian=True),
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
