import unittest
from copy import copy

import amulet_nbt
from tests.binary_data import binary_data_tuple


class NBTTests(unittest.TestCase):
    def _load(self, b: bytes, little_endian: bool = False) -> amulet_nbt.NamedTag:
        b_copy = copy(b)
        named_tag = amulet_nbt.read_nbt(b_copy, little_endian=little_endian)
        self.assertEqual(b, b_copy, msg="The buffer changed.")
        named_tag2 = amulet_nbt.read_nbt(b_copy, little_endian=little_endian)
        self.assertEqual(named_tag.name, named_tag2.name)
        self.assertEqual(named_tag.tag, named_tag2.tag)
        return named_tag

    def test_read_big_endian(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag, self._load(data.big_endian), msg=str(data.named_tag)
            )

    def test_read_big_endian_compressed(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                amulet_nbt.read_nbt(data.big_endian_compressed),
                msg=str(data.named_tag),
            )

    def test_read_little_endian(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                self._load(data.little_endian, little_endian=True),
                msg=str(data.named_tag),
            )

    def test_read_little_endian_compressed(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag,
                amulet_nbt.read_nbt(data.little_endian_compressed, little_endian=True),
                msg=str(data.named_tag),
            )

    def test_write_big_endian(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag.to_nbt(compressed=False),
                data.big_endian,
                msg=str(data.named_tag),
            )

    def test_write_little_endian(self) -> None:
        for data in binary_data_tuple:
            self.assertEqual(
                data.named_tag.to_nbt(compressed=False, little_endian=True),
                data.little_endian,
                msg=str(data.named_tag),
            )

    def test_unnamed(self) -> None:
        # Only one case is tested as the implementation of this is shared among all tag types and thus behaves the same
        self.assertEqual(
            amulet_nbt.read_nbt(
                b"\x01\x05", named=False, compressed=False, little_endian=False
            ),
            amulet_nbt.NamedTag(amulet_nbt.ByteTag(5), ""),
            "reading unnamed tag",
        )
        self.assertEqual(
            amulet_nbt.read_nbt_array(
                b"\x01\x05\x01\x06\x01\x07",
                named=False,
                count=-1,
                compressed=False,
                little_endian=False,
            ),
            [amulet_nbt.NamedTag(amulet_nbt.ByteTag(i), "") for i in (5, 6, 7)],
            "reading unnamed tag array",
        )
        self.assertEqual(
            amulet_nbt.ByteTag(5).to_nbt(
                name=None, compressed=False, little_endian=False
            ),
            b"\x01\x05",
            msg="writing unnamed tag",
        )


if __name__ == "__main__":
    unittest.main()
