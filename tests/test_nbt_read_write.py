import unittest
from copy import copy

import amulet_nbt
from amulet_nbt.load_nbt import load_tag
from amulet_nbt.util import BufferContext
from tests.binary_data import binary_data_tuple


class NBTTests(unittest.TestCase):
    def _load(self, b: bytes, little_endian: bool = False):
        buffer = BufferContext(copy(b))
        name, tag = load_tag(buffer, little_endian)
        self.assertEqual(b, buffer.get_buffer(), msg="The buffer changed.")
        nbt_file = amulet_nbt.load(b, little_endian=little_endian)
        self.assertEqual(name, nbt_file.name)
        self.assertEqual(tag, nbt_file.value)
        return nbt_file

    def test_read_big_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file, self._load(data.big_endian), msg=str(data.nbt_file)
            )

    def test_read_big_endian_compressed(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file,
                amulet_nbt.load(data.big_endian_compressed),
                msg=str(data.nbt_file),
            )

    def test_read_little_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file,
                self._load(data.little_endian, little_endian=True),
                msg=str(data.nbt_file),
            )

    def test_read_little_endian_compressed(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file,
                amulet_nbt.load(data.little_endian_compressed, little_endian=True),
                msg=str(data.nbt_file),
            )

    def test_write_big_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file.to_nbt(False), data.big_endian, msg=str(data.nbt_file)
            )

    def test_write_little_endian(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file.to_nbt(False, True),
                data.little_endian,
                msg=str(data.nbt_file),
            )


if __name__ == "__main__":
    unittest.main()
