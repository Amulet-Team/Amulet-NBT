import copy
import pickle
import itertools
import unittest
import faulthandler

faulthandler.enable()

from .test_abc import AbstractBaseMutableTagTestCase
from amulet_nbt import AbstractBaseTag, AbstractBaseMutableTag, ByteTag, ShortTag, IntTag, LongTag, FloatTag, DoubleTag, StringTag, ByteArrayTag, ListTag, CompoundTag, IntArrayTag, LongArrayTag, load as load_nbt, NBTFormatError


def is_iterable(obj):
    try:
        iter(obj)
    except TypeError:
        return False
    return True


class ListTagTestCase(AbstractBaseMutableTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                # empty
                ListTag()

                # from iterable
                ListTag([])
                ListTag([cls()])
                ListTag([cls(), cls(), cls()])
                ListTag((cls(), cls(), cls()))
                ListTag(iter((cls(), cls(), cls())))

                # from list tag
                ListTag(ListTag())
                ListTag(ListTag([cls()]))
                ListTag(ListTag([cls(), cls(), cls()]))
                ListTag(ListTag((cls(), cls(), cls())))

                self.assertEqual(cls.tag_id, ListTag([cls()]).list_data_type)

                with self.assertRaises(TypeError):
                    ListTag(None)

            for cls2 in self.nbt_types:
                if cls is not cls2:
                    with self.subTest(cls=cls, cls2=cls2), self.assertRaises(TypeError):
                        ListTag([cls(), cls2()])

        for val in self.not_nbt:
            if not is_iterable(val) or len(val):
                with self.subTest(val=val), self.assertRaises(TypeError):
                    ListTag(val)

    def test_equal(self) -> None:
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                i1 = cls1()
                i2 = cls2()
                if i1 == i2:
                    self.assertEqual(ListTag([i1]), ListTag([i2]))
                    self.assertEqual(ListTag([i1, i1]), ListTag([i2, i2]))
                else:
                    self.assertNotEqual(ListTag([i1]), ListTag([i2]))
                    self.assertNotEqual(ListTag([i1, i1]), ListTag([i2, i2]))

        # empty lists should always be equal regardless of the data type specified
        for i1, i2 in itertools.product(range(1, 13), repeat=2):
            with self.subTest(i1=i1, i2=i2):
                self.assertEqual(
                    ListTag([], list_data_type=i1), ListTag([], list_data_type=i2)
                )

    def test_py_data(self) -> None:
        tag = ListTag()
        self.assertIsInstance(tag.py_list, list)
        self.assertEqual(tag.py_list, [])

        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = ListTag([cls()])
                self.assertEqual([cls()], tag.py_list)

                self.assertIsNot(tag.py_list, tag.py_list)

    def test_repr(self) -> None:
        # empty list
        self.assertEqual("ListTag([], 1)", repr(ListTag()))

        # byte tag list
        self.assertEqual("ListTag([ByteTag(0)], 1)", repr(ListTag([ByteTag()])))
        self.assertEqual("ListTag([ByteTag(-5)], 1)", repr(ListTag([ByteTag(-5)])))
        self.assertEqual(
            "ListTag([ByteTag(-5), ByteTag(-5)], 1)",
            repr(ListTag([ByteTag(-5), ByteTag(-5)])),
        )
        self.assertEqual(
            "ListTag([ByteTag(5)], 1)",
            repr(ListTag([ByteTag(5)])),
        )
        self.assertEqual(
            "ListTag([ByteTag(5), ByteTag(5)], 1)",
            repr(ListTag([ByteTag(5), ByteTag(5)])),
        )

        # short tag list
        self.assertEqual("ListTag([ShortTag(0)], 2)", repr(ListTag([ShortTag()])))
        self.assertEqual(
            "ListTag([ShortTag(-5)], 2)",
            repr(ListTag([ShortTag(-5)])),
        )
        self.assertEqual(
            "ListTag([ShortTag(-5), ShortTag(-5)], 2)",
            repr(ListTag([ShortTag(-5), ShortTag(-5)])),
        )
        self.assertEqual(
            "ListTag([ShortTag(5)], 2)",
            repr(ListTag([ShortTag(5)])),
        )
        self.assertEqual(
            "ListTag([ShortTag(5), ShortTag(5)], 2)",
            repr(ListTag([ShortTag(5), ShortTag(5)])),
        )

        # int tag list
        self.assertEqual("ListTag([IntTag(0)], 3)", repr(ListTag([IntTag()])))
        self.assertEqual(
            "ListTag([IntTag(-5)], 3)",
            repr(ListTag([IntTag(-5)])),
        )
        self.assertEqual(
            "ListTag([IntTag(-5), IntTag(-5)], 3)",
            repr(ListTag([IntTag(-5), IntTag(-5)])),
        )
        self.assertEqual(
            "ListTag([IntTag(5)], 3)",
            repr(ListTag([IntTag(5)])),
        )
        self.assertEqual(
            "ListTag([IntTag(5), IntTag(5)], 3)",
            repr(ListTag([IntTag(5), IntTag(5)])),
        )

        # long tag list
        self.assertEqual("ListTag([LongTag(0)], 4)", repr(ListTag([LongTag()])))
        self.assertEqual(
            "ListTag([LongTag(-5)], 4)",
            repr(ListTag([LongTag(-5)])),
        )
        self.assertEqual(
            "ListTag([LongTag(-5), LongTag(-5)], 4)",
            repr(ListTag([LongTag(-5), LongTag(-5)])),
        )
        self.assertEqual(
            "ListTag([LongTag(5)], 4)",
            repr(ListTag([LongTag(5)])),
        )
        self.assertEqual(
            "ListTag([LongTag(5), LongTag(5)], 4)",
            repr(ListTag([LongTag(5), LongTag(5)])),
        )

        # float tag list
        self.assertEqual("ListTag([FloatTag(0.0)], 5)", repr(ListTag([FloatTag()])))
        self.assertEqual(
            "ListTag([FloatTag(-5.0)], 5)",
            repr(ListTag([FloatTag(-5)])),
        )
        self.assertEqual(
            "ListTag([FloatTag(-5.0), FloatTag(-5.0)], 5)",
            repr(ListTag([FloatTag(-5), FloatTag(-5)])),
        )
        self.assertEqual(
            "ListTag([FloatTag(5.0)], 5)",
            repr(ListTag([FloatTag(5)])),
        )
        self.assertEqual(
            "ListTag([FloatTag(5.0), FloatTag(5.0)], 5)",
            repr(ListTag([FloatTag(5), FloatTag(5)])),
        )

        # double tag list
        self.assertEqual("ListTag([DoubleTag(0.0)], 6)", repr(ListTag([DoubleTag()])))
        self.assertEqual(
            "ListTag([DoubleTag(-5.0)], 6)",
            repr(ListTag([DoubleTag(-5)])),
        )
        self.assertEqual(
            "ListTag([DoubleTag(-5.0), DoubleTag(-5.0)], 6)",
            repr(ListTag([DoubleTag(-5), DoubleTag(-5)])),
        )
        self.assertEqual(
            "ListTag([DoubleTag(5.0)], 6)",
            repr(ListTag([DoubleTag(5)])),
        )
        self.assertEqual(
            "ListTag([DoubleTag(5.0), DoubleTag(5.0)], 6)",
            repr(ListTag([DoubleTag(5), DoubleTag(5)])),
        )

        # byte array tag list
        self.assertEqual(
            "ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])], 7)",
            repr(ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
        )
        self.assertEqual(
            "ListTag([ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]), ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])], 7)",
            repr(
                ListTag(
                    [
                        ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
        )

        # string tag list
        self.assertEqual(
            'ListTag([StringTag("value")], 8)',
            repr(ListTag([StringTag("value")])),
        )
        self.assertEqual(
            'ListTag([StringTag("value"), StringTag("value")], 8)',
            repr(ListTag([StringTag("value"), StringTag("value")])),
        )

        # list tag list
        self.assertEqual(
            "ListTag([ListTag([], 1)], 9)",
            repr(ListTag([ListTag([])])),
        )
        self.assertEqual(
            "ListTag([ListTag([], 1), ListTag([], 1)], 9)",
            repr(ListTag([ListTag([]), ListTag([])])),
        )

        # compound tag list
        self.assertEqual(
            "ListTag([CompoundTag({})], 10)",
            repr(ListTag([CompoundTag({})])),
        )
        self.assertEqual(
            "ListTag([CompoundTag({}), CompoundTag({})], 10)",
            repr(ListTag([CompoundTag({}), CompoundTag({})])),
        )

        # int array tag list
        self.assertEqual(
            "ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3])], 11)",
            repr(ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
        )
        self.assertEqual(
            "ListTag([IntArrayTag([-3, -2, -1, 0, 1, 2, 3]), IntArrayTag([-3, -2, -1, 0, 1, 2, 3])], 11)",
            repr(
                ListTag(
                    [
                        IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
        )

        # long array tag list
        self.assertEqual(
            "ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3])], 12)",
            repr(ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3])])),
        )
        self.assertEqual(
            "ListTag([LongArrayTag([-3, -2, -1, 0, 1, 2, 3]), LongArrayTag([-3, -2, -1, 0, 1, 2, 3])], 12)",
            repr(
                ListTag(
                    [
                        LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                        LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
        )

    def test_str(self) -> None:
        pass

    def test_pickle(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = ListTag([cls()])
                dump = pickle.dumps(tag)
                tag2 = pickle.loads(dump)
                self.assertEqual(tag, tag2)
                self.assertEqual(tag.list_data_type, tag2.list_data_type)

    def test_copy(self) -> None:
        for cls in self.nbt_types:
            with self.subTest("copy append", cls=cls):
                tag = ListTag([])
                tag2 = copy.copy(tag)

                self.assertEqual(tag.list_data_type, tag2.list_data_type)

                # check the root data is copied
                self.assertIsNot(tag, tag2)
                tag.append(cls())
                self.assertNotEqual(tag, tag2)

        for cls in self.nbt_types:
            with self.subTest("copy append child", cls=cls):
                tag = ListTag([ListTag()])
                tag2 = copy.copy(tag)
                self.assertEqual(tag, tag2)
                tag[0].append(ListTag())
                self.assertEqual(tag, tag2)

        # Make sure the mutable children are not copied
        tag = ListTag([ListTag()])
        tag2 = copy.copy(tag)
        tag[0].append(ByteTag())
        self.assertEqual(tag, tag2)
        self.assertEqual(ByteTag(), tag2[0][0])

        tag = ListTag([CompoundTag()])
        tag2 = copy.copy(tag)
        tag[0]["key"] = ByteTag()
        self.assertEqual(tag, tag2)
        self.assertEqual(ByteTag(), tag2[0]["key"])

        tag = ListTag([ByteArrayTag([1, 2, 3])])
        tag2 = copy.copy(tag)
        tag[0][0] = 10
        self.assertEqual(tag, tag2)
        self.assertEqual(10, tag2[0][0])

        tag = ListTag([IntArrayTag([1, 2, 3])])
        tag2 = copy.copy(tag)
        tag[0][0] = 10
        self.assertEqual(tag, tag2)
        self.assertEqual(10, tag2[0][0])

        tag = ListTag([LongArrayTag([1, 2, 3])])
        tag2 = copy.copy(tag)
        tag[0][0] = 10
        self.assertEqual(tag, tag2)
        self.assertEqual(10, tag2[0][0])

    def test_deepcopy(self) -> None:
        for cls in self.nbt_types:
            with self.subTest("deepcopy append", cls=cls):
                tag = ListTag([])
                tag2 = copy.deepcopy(tag)

                self.assertEqual(tag.list_data_type, tag2.list_data_type)

                # check the root data is copied
                self.assertIsNot(tag, tag2)
                tag.append(cls())
                self.assertNotEqual(tag, tag2)

        for cls in self.nbt_types:
            with self.subTest("deepcopy append child", cls=cls):
                tag = ListTag([ListTag()])
                tag2 = copy.deepcopy(tag)
                self.assertEqual(tag, tag2)
                tag[0].append(ListTag())
                self.assertNotEqual(tag, tag2)

        # Make sure the mutable children are not copied
        tag = ListTag([ListTag()])
        tag2 = copy.deepcopy(tag)
        tag[0].append(ByteTag())
        self.assertNotEqual(tag, tag2)
        self.assertEqual(ListTag(), tag2[0])

        tag = ListTag([CompoundTag()])
        tag2 = copy.deepcopy(tag)
        tag[0]["key"] = ByteTag()
        self.assertNotEqual(tag, tag2)
        self.assertEqual(CompoundTag(), tag2[0])

        tag = ListTag([ByteArrayTag([1, 2, 3])])
        tag2 = copy.deepcopy(tag)
        tag[0][0] = 10
        self.assertNotEqual(tag, tag2)
        self.assertEqual(1, tag2[0][0])

        tag = ListTag([IntArrayTag([1, 2, 3])])
        tag2 = copy.deepcopy(tag)
        tag[0][0] = 10
        self.assertNotEqual(tag, tag2)
        self.assertEqual(1, tag2[0][0])

        tag = ListTag([LongArrayTag([1, 2, 3])])
        tag2 = copy.deepcopy(tag)
        tag[0][0] = 10
        self.assertNotEqual(tag, tag2)
        self.assertEqual(1, tag2[0][0])

    def test_hash(self) -> None:
        with self.assertRaises(TypeError):
            hash(ListTag())

    def test_instance(self) -> None:
        self.assertIsInstance(ListTag(), AbstractBaseTag)
        self.assertIsInstance(ListTag(), AbstractBaseMutableTag)
        self.assertIsInstance(ListTag(), ListTag)

    def test_getitem(self) -> None:
        a, b, c = StringTag("val1"), StringTag("val2"), StringTag("val3")
        tag = ListTag([a, b, c])

        with self.subTest("getitem int"):
            self.assertEqual(a, tag[0])
            self.assertEqual(b, tag[1])
            self.assertEqual(c, tag[2])
            with self.assertRaises(IndexError):
                tag[3]

        with self.subTest("getitem slice"):
            self.assertIsInstance(tag[:2], list)
            self.assertEqual([a, b], tag[:2])
            self.assertEqual([], tag[5:])

    def test_setitem(self) -> None:
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest("Overwrite only value", cls1=cls1, cls2=cls2):
                # TODO: I feel like this should work with different types because you are replacing the only value
                if cls1 is cls2:
                    tag = ListTag([cls1()])
                    tag[0] = cls2()
                    self.assertEqual(ListTag([cls2()]), tag)
                    self.assertEqual(cls2.tag_id, tag.list_data_type)

            with self.subTest("Overwrite one value of many", cls1=cls1, cls2=cls2):
                a, b, c = cls1(), cls1(), cls1()
                tag = ListTag([a, b, c])
                if cls1 is cls2:
                    d = tag[1] = cls2()
                    self.assertEqual(a, tag[0])
                    self.assertEqual(d, tag[1])
                    self.assertEqual(c, tag[2])
                else:
                    with self.assertRaises(TypeError):
                        tag[1] = cls2()
                self.assertEqual(cls1.tag_id, tag.list_data_type)

            with self.subTest("Overwrite full slice", cls1=cls1, cls2=cls2):
                # TODO: I feel like this should work with different types because you are replacing all the values
                if cls1 is cls2:
                    a, b, c = cls1(), cls1(), cls1()
                    tag = ListTag([a, b, c])
                    d = cls2()
                    tag[:] = [d]
                    self.assertEqual(1, len(tag))
                    self.assertEqual(d, tag[0])
                    self.assertEqual(cls2.tag_id, tag.list_data_type)

            with self.subTest("Overwrite partial slice", cls1=cls1, cls2=cls2):
                a, b, c = cls1(), cls1(), cls1()
                tag = ListTag([a, b, c])
                if cls1 is cls2:
                    d, e = cls2(), cls2()
                    tag[1:] = [d, e]
                    self.assertEqual(3, len(tag))
                    self.assertEqual(a, tag[0])
                    self.assertEqual(d, tag[1])
                    self.assertEqual(e, tag[2])
                else:
                    with self.assertRaises(TypeError):
                        tag[1:] = [cls2(), cls2()]
                self.assertEqual(cls1.tag_id, tag.list_data_type)

            with self.subTest("Overwrite stepped slice", cls1=cls1, cls2=cls2):
                a, b, c = cls1(), cls1(), cls1()
                tag = ListTag([a, b, c])
                if cls1 is cls2:
                    d, e = cls2(), cls2()
                    tag[::2] = [d, e]
                    self.assertEqual(3, len(tag))
                    self.assertEqual(d, tag[0])
                    self.assertEqual(b, tag[1])
                    self.assertEqual(e, tag[2])
                else:
                    with self.assertRaises(TypeError):
                        tag[::2] = [cls2(), cls2()]
                self.assertEqual(cls1.tag_id, tag.list_data_type)

            with self.subTest("Overwrite slice (expand)", cls1=cls1, cls2=cls2):
                a, b, c = cls1(), cls1(), cls1()
                tag = ListTag([a, b, c])
                if cls1 is cls2:
                    d, e, f = cls2(), cls2(), cls2()
                    tag[1:] = [d, e, f]
                    self.assertEqual(4, len(tag))
                    self.assertEqual(a, tag[0])
                    self.assertEqual(d, tag[1])
                    self.assertEqual(e, tag[2])
                    self.assertEqual(f, tag[3])
                else:
                    with self.assertRaises(TypeError):
                        tag[1:] = [cls2(), cls2(), cls2()]
                self.assertEqual(cls1.tag_id, tag.list_data_type)

            with self.subTest("Overwrite slice (contract)", cls1=cls1, cls2=cls2):
                a, b, c = cls1(), cls1(), cls1()
                tag = ListTag([a, b, c])
                if cls1 is cls2:
                    d = cls2()
                    tag[1:] = [d]
                    self.assertEqual(2, len(tag))
                    self.assertEqual(a, tag[0])
                    self.assertEqual(d, tag[1])
                else:
                    with self.assertRaises(TypeError):
                        tag[1:] = [cls2()]
                self.assertEqual(cls1.tag_id, tag.list_data_type)

    def test_delitem(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        del tag[:2]
        self.assertEqual(tag, ListTag([StringTag("val3")]))
        del tag[0]
        self.assertEqual(tag, ListTag())

    def test_len(self) -> None:
        tag = StringTag("val")
        for i in range(10):
            with self.subTest(i=i):
                self.assertEqual(i, len(ListTag([tag] * i)))

    def test_insert(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val3"), StringTag("val4")])
        tag.insert(1, StringTag("val2"))
        self.assertEqual(
            ListTag(
                [
                    StringTag("val1"),
                    StringTag("val2"),
                    StringTag("val3"),
                    StringTag("val4"),
                ]
            ),
            tag,
        )

        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = ListTag()
                tag.insert(0, cls())
                self.assertEqual(ListTag([cls()]), tag)
                self.assertEqual(cls.tag_id, tag.list_data_type)

        for obj in self.not_nbt:
            with self.subTest(val=obj), self.assertRaises(TypeError):
                tag.insert(1, obj)

    def test_contains(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        self.assertIn(StringTag("val1"), tag)
        self.assertNotIn(StringTag("val4"), tag)
        for not_nbt in self.not_nbt:
            self.assertNotIn(not_nbt, tag)
        for tag_cls1 in self.nbt_types:
            tag = ListTag([tag_cls1()])
            for tag_cls2 in self.nbt_types:
                with self.subTest(cls=tag_cls1, cls2=tag_cls2):
                    if tag_cls1 is tag_cls2:
                        self.assertIn(tag_cls2(), tag)
                    else:
                        self.assertNotIn(tag_cls2(), tag)

    def test_iter(self) -> None:
        a = StringTag("val1")
        b = StringTag("val2")
        c = StringTag("val3")
        tag = ListTag([a, b, c])
        it = iter(tag)
        self.assertEqual(a, next(it))
        self.assertEqual(b, next(it))
        self.assertEqual(c, next(it))
        with self.assertRaises(StopIteration):
            next(it)

    def test_reversed(self) -> None:
        pass

    def test_reverse(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])

        # reverse (create new)
        l2 = reversed(tag)
        self.assertEqual(
            ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")]), tag
        )
        self.assertEqual(
            ListTag([StringTag("val3"), StringTag("val2"), StringTag("val1")]),
            ListTag(l2),
        )

        # reverse (inplace)
        tag.reverse()
        self.assertEqual(
            tag, ListTag([StringTag("val3"), StringTag("val2"), StringTag("val1")])
        )

    def test_index(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        self.assertEqual(1, tag.index(StringTag("val2")))
        with self.assertRaises(ValueError):
            tag.index(StringTag("val3"))

        for obj in self.not_nbt:
            with self.subTest(val=obj), self.assertRaises(ValueError):
                tag.index(obj)

        tag = ListTag([ByteTag(1), ByteTag(2), ByteTag(3)])
        with self.assertRaises(ValueError):
            tag.index(ShortTag(2))
        with self.assertRaises(ValueError):
            tag.index(True)

    def test_count(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        self.assertEqual(1, tag.count(StringTag("val1")))
        self.assertEqual(2, tag.count(StringTag("val2")))
        for obj in self.not_nbt:
            with self.subTest(val=obj):
                self.assertEqual(0, tag.count(obj))

    def test_append(self) -> None:
        for cls1 in self.nbt_types:
            with self.subTest(cls1=cls1):
                tag = ListTag()
                tag.append(cls1())
                self.assertEqual(ListTag([cls1()]), tag)
                self.assertEqual(cls1.tag_id, tag.list_data_type)

            for cls2 in self.nbt_types:
                with self.subTest(cls1=cls1, cls2=cls2):
                    tag = ListTag([cls2()])
                    if cls2 is cls2:
                        tag.append(cls2())
                    else:
                        with self.assertRaises(TypeError):
                            tag.append(cls2())
        tag = ListTag()
        for obj in self.not_nbt:
            with self.subTest(val=obj), self.assertRaises(TypeError):
                tag.append(obj)

    def test_extend(self) -> None:
        tag = ListTag()
        tag.extend([StringTag("val1"), StringTag("val2")])
        tag.extend([StringTag("val2")])
        self.assertEqual(
            tag, ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        )

        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = ListTag()
                tag.extend([cls()])
                self.assertEqual(cls.tag_id, tag.list_data_type)

        for obj in self.not_nbt:
            with self.subTest(val=obj):
                if obj not in ([], {}, set()):
                    with self.assertRaises(TypeError):
                        tag.extend(obj)
                with self.assertRaises(TypeError):
                    tag.extend([obj])

    def test_pop(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])

        self.assertEqual(tag.pop(), StringTag("val3"))
        self.assertEqual(ListTag([StringTag("val1"), StringTag("val2")]), tag)

        self.assertEqual(StringTag("val1"), tag.pop(0))
        self.assertEqual(ListTag([StringTag("val2")]), tag)

        for obj in self.not_nbt:
            if not isinstance(obj, int):
                with self.subTest(val=obj), self.assertRaises(TypeError):
                    tag.pop(obj)

    def test_remove(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        tag.remove(StringTag("val3"))
        self.assertEqual(tag, ListTag([StringTag("val1"), StringTag("val2")]))
        tag.remove(StringTag("val1"))
        self.assertEqual(tag, ListTag([StringTag("val2")]))

        for obj in self.not_nbt:
            with self.subTest(val=obj), self.assertRaises(ValueError):
                tag.remove(obj)

    def test_iadd(self) -> None:
        tag_ = tag = ListTag()
        tag += [StringTag("val1")]
        self.assertEqual(tag_, tag)
        self.assertIsInstance(tag, ListTag)
        self.assertEqual(
            ListTag([StringTag("val1")]),
            tag,
        )
        tag += ListTag([StringTag("val2"), StringTag("val3")])
        self.assertEqual(tag_, tag)
        self.assertIsInstance(tag, ListTag)
        self.assertEqual(
            ListTag(
                [
                    StringTag("val1"),
                    StringTag("val2"),
                    StringTag("val3"),
                ]
            ),
            tag,
        )

        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                tag = ListTag()
                tag += [cls1()]
                self.assertEqual(cls1.tag_id, tag.list_data_type)
                if cls1 is cls2:
                    tag += [cls2()]
                    tag += ListTag([cls2()])
                else:
                    with self.assertRaises(TypeError):
                        tag += [cls2()]
                    with self.assertRaises(TypeError):
                        tag += ListTag([cls2()])
                self.assertEqual(cls1.tag_id, tag.list_data_type)

        tag = ListTag()
        for obj in self.not_nbt:
            with self.subTest(val=obj):
                if not is_iterable(obj) or len(obj):
                    with self.assertRaises(TypeError):
                        tag += obj
                with self.assertRaises(TypeError):
                    tag += [obj]

    def test_clear(self) -> None:
        tag = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        tag.clear()
        self.assertEqual(ListTag(), tag)

    def test_to_nbt(self):
        self.assertEqual(
            b"\x09\x00\x00\x00\x00\x00\x00\x00",
            ListTag(list_data_type=0).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x09\x00\x00\x00\x00\x00\x00\x00",
            ListTag(list_data_type=0).to_nbt(compressed=False, little_endian=True),
        )

        self.assertEqual(
            b"\x09\x00\x00\x01\x00\x00\x00\x03\xFF\x00\x01",
            ListTag([ByteTag(-1), ByteTag(0), ByteTag(1)]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x09\x00\x00\x01\x03\x00\x00\x00\xFF\x00\x01",
            ListTag([ByteTag(-1), ByteTag(0), ByteTag(1)]).to_nbt(
                compressed=False, little_endian=True
            ),
        )

        self.assertEqual(
            b"\x09\x00\x00\x02\x00\x00\x00\x03\xFF\xFF\x00\x00\x00\x01",
            ListTag([ShortTag(-1), ShortTag(0), ShortTag(1)]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x09\x00\x00\x02\x03\x00\x00\x00\xFF\xFF\x00\x00\x01\x00",
            ListTag([ShortTag(-1), ShortTag(0), ShortTag(1)]).to_nbt(
                compressed=False, little_endian=True
            ),
        )

        self.assertEqual(
            b"\x09\x00\x00\x03\x00\x00\x00\x03\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x01",
            ListTag([IntTag(-1), IntTag(0), IntTag(1)]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x09\x00\x00\x03\x03\x00\x00\x00\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x01\x00\x00\x00",
            ListTag([IntTag(-1), IntTag(0), IntTag(1)]).to_nbt(
                compressed=False, little_endian=True
            ),
        )

        self.assertEqual(
            b"\x09\x00\x00\x04\x00\x00\x00\x03\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01",
            ListTag([LongTag(-1), LongTag(0), LongTag(1)]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x09\x00\x00\x04\x03\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00",
            ListTag([LongTag(-1), LongTag(0), LongTag(1)]).to_nbt(
                compressed=False, little_endian=True
            ),
        )

    def test_from_nbt(self):
        self.assertEqual(
            ListTag([], 1), load_nbt(b"\x09\x00\x00\x01\xFF\xFF\xFF\xFF").list
        )

        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09")
        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09\x00\x00")
        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09\x00\x00\x00")
        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09\x00\x00\x00\x00")
        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09\x00\x00\x00\x00\x00")
        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x09\x00\x00\x00\x00\x00\x00")


if __name__ == '__main__':
    unittest.main()
