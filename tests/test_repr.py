import unittest

from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
)


class TestRepr(unittest.TestCase):
    def test_repr(self):
        self.assertEqual(repr(ByteTag(5)), "ByteTag(5)")
        self.assertEqual(repr(ByteTag(-5)), "ByteTag(-5)")
        self.assertEqual(repr(ShortTag(5)), "ShortTag(5)")
        self.assertEqual(repr(ShortTag(-5)), "ShortTag(-5)")
        self.assertEqual(repr(IntTag(5)), "IntTag(5)")
        self.assertEqual(repr(IntTag(-5)), "IntTag(-5)")
        self.assertEqual(repr(LongTag(5)), "LongTag(5)")
        self.assertEqual(repr(LongTag(-5)), "LongTag(-5)")
        self.assertEqual(repr(FloatTag(5)), "FloatTag(5.0)")
        self.assertEqual(repr(FloatTag(-5)), "FloatTag(-5.0)")
        self.assertEqual(repr(DoubleTag(5)), "DoubleTag(5.0)")
        self.assertEqual(repr(DoubleTag(-5)), "DoubleTag(-5.0)")
        self.assertEqual(repr(StringTag("value")), 'StringTag("value")')
        self.assertEqual(
            repr(ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])),
            "ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(
            repr(IntArrayTag([-3, -2, -1, 0, 1, 2, 3])),
            "IntArrayTag([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(
            repr(LongArrayTag([-3, -2, -1, 0, 1, 2, 3])),
            "LongArrayTag([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(repr(ListTag()), "ListTag([], 1)")

    def test_repr_list(self):
        self.assertEqual(repr(ListTag([ByteTag(-5)])), "ListTag([ByteTag(-5)], 1)")
        self.assertEqual(
            repr(ListTag([ByteTag(-5), ByteTag(-5)])),
            "ListTag([ByteTag(-5), ByteTag(-5)], 1)",
        )
        self.assertEqual(repr(ListTag([ByteTag(5)])), "ListTag([ByteTag(5)], 1)")
        self.assertEqual(
            repr(ListTag([ByteTag(5), ByteTag(5)])),
            "ListTag([ByteTag(5), ByteTag(5)], 1)",
        )
        self.assertEqual(repr(ListTag([ShortTag(-5)])), "ListTag([ShortTag(-5)], 2)")
        self.assertEqual(
            repr(ListTag([ShortTag(-5), ShortTag(-5)])),
            "ListTag([ShortTag(-5), ShortTag(-5)], 2)",
        )
        self.assertEqual(repr(ListTag([ShortTag(5)])), "ListTag([ShortTag(5)], 2)")
        self.assertEqual(
            repr(ListTag([ShortTag(5), ShortTag(5)])),
            "ListTag([ShortTag(5), ShortTag(5)], 2)",
        )
        self.assertEqual(repr(ListTag([IntTag(-5)])), "ListTag([IntTag(-5)], 3)")
        self.assertEqual(
            repr(ListTag([IntTag(-5), IntTag(-5)])),
            "ListTag([IntTag(-5), IntTag(-5)], 3)",
        )
        self.assertEqual(repr(ListTag([IntTag(5)])), "ListTag([IntTag(5)], 3)")
        self.assertEqual(
            repr(ListTag([IntTag(5), IntTag(5)])),
            "ListTag([IntTag(5), IntTag(5)], 3)",
        )
        self.assertEqual(repr(ListTag([LongTag(-5)])), "ListTag([LongTag(-5)], 4)")
        self.assertEqual(
            repr(ListTag([LongTag(-5), LongTag(-5)])),
            "ListTag([LongTag(-5), LongTag(-5)], 4)",
        )
        self.assertEqual(repr(ListTag([LongTag(5)])), "ListTag([LongTag(5)], 4)")
        self.assertEqual(
            repr(ListTag([LongTag(5), LongTag(5)])),
            "ListTag([LongTag(5), LongTag(5)], 4)",
        )
        self.assertEqual(repr(ListTag([FloatTag(-5)])), "ListTag([FloatTag(-5.0)], 5)")
        self.assertEqual(
            repr(ListTag([FloatTag(-5), FloatTag(-5)])),
            "ListTag([FloatTag(-5.0), FloatTag(-5.0)], 5)",
        )
        self.assertEqual(repr(ListTag([FloatTag(5)])), "ListTag([FloatTag(5.0)], 5)")
        self.assertEqual(
            repr(ListTag([FloatTag(5), FloatTag(5)])),
            "ListTag([FloatTag(5.0), FloatTag(5.0)], 5)",
        )
        self.assertEqual(
            repr(ListTag([DoubleTag(-5)])), "ListTag([DoubleTag(-5.0)], 6)"
        )
        self.assertEqual(
            repr(ListTag([DoubleTag(-5), DoubleTag(-5)])),
            "ListTag([DoubleTag(-5.0), DoubleTag(-5.0)], 6)",
        )
        self.assertEqual(repr(ListTag([DoubleTag(5)])), "ListTag([DoubleTag(5.0)], 6)")
        self.assertEqual(
            repr(ListTag([DoubleTag(5), DoubleTag(5)])),
            "ListTag([DoubleTag(5.0), DoubleTag(5.0)], 6)",
        )
        self.assertEqual(
            repr(ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
            "ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])], 7)",
        )
        self.assertEqual(
            repr(
                ListTag(
                    [
                        ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]), ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])], 7)",
        )
        self.assertEqual(
            repr(ListTag([StringTag("value")])), 'ListTag([StringTag("value")], 8)'
        )
        self.assertEqual(
            repr(ListTag([StringTag("value"), StringTag("value")])),
            'ListTag([StringTag("value"), StringTag("value")], 8)',
        )
        self.assertEqual(repr(ListTag([ListTag([])])), "ListTag([ListTag([], 1)], 9)")
        self.assertEqual(
            repr(ListTag([ListTag([]), ListTag([])])),
            "ListTag([ListTag([], 1), ListTag([], 1)], 9)",
        )
        self.assertEqual(
            repr(ListTag([CompoundTag({})])), "ListTag([CompoundTag({})], 10)"
        )
        self.assertEqual(
            repr(ListTag([CompoundTag({}), CompoundTag({})])),
            "ListTag([CompoundTag({}), CompoundTag({})], 10)",
        )
        self.assertEqual(
            repr(ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
            "ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3])], 11)",
        )
        self.assertEqual(
            repr(
                ListTag(
                    [
                        IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3]), IntArrayTag([-3, -2, -1, 0, 1, 2, 3])], 11)",
        )
        self.assertEqual(
            repr(ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
            "ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3])], 12)",
        )
        self.assertEqual(
            repr(
                ListTag(
                    [
                        LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3]), LongArrayTag([-3, -2, -1, 0, 1, 2, 3])], 12)",
        )

    def test_repr_compound(self):
        self.assertEqual(
            repr(CompoundTag({"key": ByteTag(-5)})),
            "CompoundTag({'key': ByteTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": ByteTag(-5), "a": ByteTag(-5)})),
            "CompoundTag({'b': ByteTag(-5), 'a': ByteTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": ByteTag(5)})),
            "CompoundTag({'key': ByteTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": ByteTag(5), "a": ByteTag(5)})),
            "CompoundTag({'b': ByteTag(5), 'a': ByteTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": ShortTag(-5)})),
            "CompoundTag({'key': ShortTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": ShortTag(-5), "a": ShortTag(-5)})),
            "CompoundTag({'b': ShortTag(-5), 'a': ShortTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": ShortTag(5)})),
            "CompoundTag({'key': ShortTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": ShortTag(5), "a": ShortTag(5)})),
            "CompoundTag({'b': ShortTag(5), 'a': ShortTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": IntTag(-5)})),
            "CompoundTag({'key': IntTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": IntTag(-5), "a": IntTag(-5)})),
            "CompoundTag({'b': IntTag(-5), 'a': IntTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": IntTag(5)})), "CompoundTag({'key': IntTag(5)})"
        )
        self.assertEqual(
            repr(CompoundTag({"b": IntTag(5), "a": IntTag(5)})),
            "CompoundTag({'b': IntTag(5), 'a': IntTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": LongTag(-5)})),
            "CompoundTag({'key': LongTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": LongTag(-5), "a": LongTag(-5)})),
            "CompoundTag({'b': LongTag(-5), 'a': LongTag(-5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": LongTag(5)})),
            "CompoundTag({'key': LongTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": LongTag(5), "a": LongTag(5)})),
            "CompoundTag({'b': LongTag(5), 'a': LongTag(5)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": FloatTag(-5)})),
            "CompoundTag({'key': FloatTag(-5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": FloatTag(-5), "a": FloatTag(-5)})),
            "CompoundTag({'b': FloatTag(-5.0), 'a': FloatTag(-5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": FloatTag(5)})),
            "CompoundTag({'key': FloatTag(5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": FloatTag(5), "a": FloatTag(5)})),
            "CompoundTag({'b': FloatTag(5.0), 'a': FloatTag(5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": DoubleTag(-5)})),
            "CompoundTag({'key': DoubleTag(-5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": DoubleTag(-5), "a": DoubleTag(-5)})),
            "CompoundTag({'b': DoubleTag(-5.0), 'a': DoubleTag(-5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": DoubleTag(5)})),
            "CompoundTag({'key': DoubleTag(5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": DoubleTag(5), "a": DoubleTag(5)})),
            "CompoundTag({'b': DoubleTag(5.0), 'a': DoubleTag(5.0)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])})),
            "CompoundTag({'key': ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                CompoundTag(
                    {
                        "b": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        "a": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "CompoundTag({'b': ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]), 'a': ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": StringTag("value")})),
            "CompoundTag({'key': StringTag(\"value\")})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": StringTag("value"), "a": StringTag("value")})),
            "CompoundTag({'b': StringTag(\"value\"), 'a': StringTag(\"value\")})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": ListTag([])})),
            "CompoundTag({'key': ListTag([], 1)})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": ListTag([]), "a": ListTag([])})),
            "CompoundTag({'b': ListTag([], 1), 'a': ListTag([], 1)})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": CompoundTag({})})),
            "CompoundTag({'key': CompoundTag({})})",
        )
        self.assertEqual(
            repr(CompoundTag({"b": CompoundTag({}), "a": CompoundTag({})})),
            "CompoundTag({'b': CompoundTag({}), 'a': CompoundTag({})})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": IntArrayTag([-3, -2, -1, 0, 1, 2, 3])})),
            "CompoundTag({'key': IntArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                CompoundTag(
                    {
                        "b": IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        "a": IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "CompoundTag({'b': IntArrayTag([-3, -2, -1, 0, 1, 2, 3]), 'a': IntArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(CompoundTag({"key": LongArrayTag([-3, -2, -1, 0, 1, 2, 3])})),
            "CompoundTag({'key': LongArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                CompoundTag(
                    {
                        "b": LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        "a": LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "CompoundTag({'b': LongArrayTag([-3, -2, -1, 0, 1, 2, 3]), 'a': LongArrayTag([-3, -2, -1, 0, 1, 2, 3])})",
        )


if __name__ == "__main__":
    unittest.main()
