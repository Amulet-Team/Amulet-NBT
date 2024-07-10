import unittest
import os

from amulet_nbt import (
    ListTag,
    IntTag,
    read_nbt,
    read_nbt_array,
    NBTLoadError,
    NamedTag,
)

DirPath = os.path.dirname(__file__)
EmptyPath = os.path.join(DirPath, "empty.nbt")
OnePath = os.path.join(DirPath, "one.nbt")
ArrayPath = os.path.join(DirPath, "array.nbt")


class LoadTests(unittest.TestCase):
    def test_load(self) -> None:
        read_nbt_array(OnePath)

        with self.assertRaises(NBTLoadError):
            read_nbt(EmptyPath)
        with self.assertRaises(NBTLoadError):
            read_nbt_array(EmptyPath, count=1)
        self.assertEqual([], read_nbt_array(EmptyPath, count=0))
        self.assertEqual([], read_nbt_array(EmptyPath, count=-1))

        self.assertEqual(
            NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
            read_nbt(OnePath),
        )
        self.assertEqual(
            [NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)]))],
            read_nbt_array(OnePath),
        )
        self.assertEqual(
            [NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)]))],
            read_nbt_array(OnePath, count=1),
        )
        self.assertEqual(
            [NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)]))],
            read_nbt_array(OnePath, count=-1),
        )
        with self.assertRaises(NBTLoadError):
            read_nbt_array(OnePath, count=2)

        self.assertEqual(
            NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
            read_nbt(ArrayPath),
        )
        self.assertEqual(
            [NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)]))],
            read_nbt_array(ArrayPath),
        )
        self.assertEqual(
            [NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)]))],
            read_nbt_array(ArrayPath, count=1),
        )
        self.assertEqual(
            [
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
            ],
            read_nbt_array(ArrayPath, count=2),
        )
        self.assertEqual(
            [
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
            ],
            read_nbt_array(ArrayPath, count=5),
        )
        self.assertEqual(
            [
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
                NamedTag(ListTag([IntTag(1), IntTag(2), IntTag(3), IntTag(4)])),
            ],
            read_nbt_array(ArrayPath, count=-1),
        )
        with self.assertRaises(NBTLoadError):
            read_nbt_array(ArrayPath, count=6)


if __name__ == "__main__":
    unittest.main()
