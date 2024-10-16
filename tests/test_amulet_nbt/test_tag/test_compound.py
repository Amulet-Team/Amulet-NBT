import copy
import pickle
import itertools
import unittest
import faulthandler
from contextlib import contextmanager

faulthandler.enable()

from .test_abc import AbstractBaseMutableTagTestCase, TagNameMap

from amulet_nbt import (
    AbstractBaseTag,
    AbstractBaseMutableTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTag,
    CompoundTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    read_snbt,
    read_nbt,
)


class CompoundTagTestCase(AbstractBaseMutableTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                # empty
                CompoundTag()

                # from dictionary
                CompoundTag({"key": cls()})
                CompoundTag(key=cls())
                CompoundTag((("key", cls()),))

                # from compound tag
                CompoundTag(CompoundTag())
                CompoundTag(CompoundTag({"key": cls()}))
                CompoundTag(CompoundTag(key=cls()))
                CompoundTag(CompoundTag((("key", cls()),)))

                with self.assertRaises(TypeError):
                    CompoundTag(None)

            for key in (None, 0, cls()):
                with self.subTest("Key test", cls=cls, key=key):
                    with self.assertRaises(TypeError):
                        CompoundTag({key: cls()})
                    with self.assertRaises(TypeError):
                        CompoundTag(((key, cls()),))

            for val in (None, 0, "val"):
                with self.subTest("Value test", cls=cls, val=val):
                    with self.assertRaises(TypeError):
                        CompoundTag({"key": val})
                    with self.assertRaises(TypeError):
                        CompoundTag(key=val)
                    with self.assertRaises(TypeError):
                        CompoundTag((("key", val),))

    def test_equal(self) -> None:
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for ground in ({"key": cls1()}, CompoundTag({"key": cls1()})):
                for other in (
                    CompoundTag({"key": cls2()}),
                    CompoundTag(key=cls2()),
                    CompoundTag((("key", cls2()),)),
                ):
                    with self.subTest(cls1=cls1, cls2=cls2, ground=ground, other=other):
                        if cls1 is cls2 and (isinstance(ground, CompoundTag)):
                            self.assertEqual(ground, other)
                        else:
                            self.assertNotEqual(ground, other)

        c = CompoundTag()
        for tag_cls in self.nbt_types:
            c[TagNameMap[tag_cls]] = tag_cls()

        self.assertEqual(
            c,
            CompoundTag({TagNameMap[tag_cls]: tag_cls() for tag_cls in self.nbt_types}),
        )

        self.assertNotEqual(
            CompoundTag({"1": ByteTag(1), "2": ByteTag(2)}),
            CompoundTag({"1": ByteTag(1), "2": ByteTag(3)}),
        )
        self.assertNotEqual(
            CompoundTag({"1": ByteTag(1), "2": ByteTag(2)}),
            CompoundTag({"1": ByteTag(3), "2": ByteTag(2)}),
        )

    def test_py_data(self) -> None:
        tag = CompoundTag()
        self.assertIsInstance(tag.py_dict, dict)
        self.assertEqual(tag.py_dict, {})

        tag = CompoundTag(byte=ByteTag())
        self.assertEqual({"byte": ByteTag()}, tag.py_dict)

        self.assertIsNot(tag.py_dict, tag.py_dict)

    def test_repr(self) -> None:
        for tag in (
            CompoundTag(),
            CompoundTag({"key": ByteTag(-5)}),
            CompoundTag({"b": ByteTag(-5), "a": ByteTag(-5)}),
            CompoundTag({"key": ByteTag(5)}),
            CompoundTag({"b": ByteTag(5), "a": ByteTag(5)}),
            CompoundTag({"key": ShortTag(-5)}),
            CompoundTag({"b": ShortTag(-5), "a": ShortTag(-5)}),
            CompoundTag({"key": ShortTag(5)}),
            CompoundTag({"b": ShortTag(5), "a": ShortTag(5)}),
            CompoundTag({"key": IntTag(-5)}),
            CompoundTag({"b": IntTag(-5), "a": IntTag(-5)}),
            CompoundTag({"key": IntTag(5)}),
            CompoundTag({"b": IntTag(5), "a": IntTag(5)}),
            CompoundTag({"key": LongTag(-5)}),
            CompoundTag({"b": LongTag(-5), "a": LongTag(-5)}),
            CompoundTag({"key": LongTag(5)}),
            CompoundTag({"b": LongTag(5), "a": LongTag(5)}),
            CompoundTag({"key": FloatTag(-5)}),
            CompoundTag({"b": FloatTag(-5), "a": FloatTag(-5)}),
            CompoundTag({"key": FloatTag(5)}),
            CompoundTag({"b": FloatTag(5), "a": FloatTag(5)}),
            CompoundTag({"key": DoubleTag(-5)}),
            CompoundTag({"b": DoubleTag(-5), "a": DoubleTag(-5)}),
            CompoundTag({"key": DoubleTag(5)}),
            CompoundTag({"b": DoubleTag(5), "a": DoubleTag(5)}),
            CompoundTag({"key": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3])}),
            CompoundTag(
                {
                    "b": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    "a": ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                }
            ),
            CompoundTag({"key": StringTag("value")}),
            CompoundTag({"b": StringTag("value"), "a": StringTag("value")}),
            CompoundTag({"key": ListTag([])}),
            CompoundTag({"b": ListTag([]), "a": ListTag([])}),
            CompoundTag({"key": CompoundTag({})}),
            CompoundTag({"b": CompoundTag({}), "a": CompoundTag({})}),
            CompoundTag({"key": IntArrayTag([-3, -2, -1, 0, 1, 2, 3])}),
            CompoundTag(
                {
                    "b": IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    "a": IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                }
            ),
            CompoundTag({"key": LongArrayTag([-3, -2, -1, 0, 1, 2, 3])}),
            CompoundTag(
                {
                    "b": LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                    "a": LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                }
            ),
        ):
            self.assertEqual(tag, eval(repr(tag)))

    def test_str(self) -> None:
        # undefined
        pass

    def test_pickle(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = CompoundTag(key=cls())
                dump = pickle.dumps(tag)
                tag2 = pickle.loads(dump)
                self.assertEqual(tag, tag2)

    def test_copy(self) -> None:
        tag = CompoundTag(
            {
                "byte": ByteTag(1),
                "short": ShortTag(1),
                "int": IntTag(1),
                "long": LongTag(1),
                "float": FloatTag(1),
                "double": DoubleTag(1),
                "byte_array": ByteArrayTag([1, 2, 3]),
                "string": StringTag("hello world"),
                "list": ListTag(),
                "compound": CompoundTag(),
                "int_array": IntArrayTag([1, 2, 3]),
                "long_array": LongArrayTag([1, 2, 3]),
            }
        )
        tag2 = copy.copy(tag)

        # check the root data is copied
        self.assertIsNot(tag, tag2)
        self.assertEqual(tag, tag2)

        # Check if modifying the data makes it not equal
        tag["key"] = CompoundTag()
        self.assertNotEqual(tag, tag2)

        # Ensure they each have their own data
        tag["byte"] = ByteTag(2)
        tag["short"] = ShortTag(2)
        tag["int"] = IntTag(2)
        tag["long"] = LongTag(2)
        tag["float"] = FloatTag(2)
        tag["double"] = DoubleTag(2)
        tag["byte_array"] = ByteArrayTag([4, 5, 6])
        tag["string"] = StringTag("hello world2")
        tag["list"] = ListTag([ByteTag(1)])
        tag["compound"] = CompoundTag({"test": ByteTag(1)})
        tag["int_array"] = IntArrayTag([4, 5, 6])
        tag["long_array"] = LongArrayTag([4, 5, 6])

        self.assertEqual(ByteTag(1), tag2["byte"])
        self.assertEqual(ShortTag(1), tag2["short"])
        self.assertEqual(IntTag(1), tag2["int"])
        self.assertEqual(LongTag(1), tag2["long"])
        self.assertEqual(FloatTag(1), tag2["float"])
        self.assertEqual(DoubleTag(1), tag2["double"])
        self.assertEqual(ByteArrayTag([1, 2, 3]), tag2["byte_array"])
        self.assertEqual(StringTag("hello world"), tag2["string"])
        self.assertEqual(ListTag(), tag2["list"])
        self.assertEqual(CompoundTag(), tag2["compound"])
        self.assertEqual(IntArrayTag([1, 2, 3]), tag2["int_array"])
        self.assertEqual(LongArrayTag([1, 2, 3]), tag2["long_array"])

        # Make sure the contained data is shared
        tag = CompoundTag(
            {
                "byte_array": ByteArrayTag([1, 2, 3]),
                "list": ListTag(),
                "compound": CompoundTag(),
                "int_array": IntArrayTag([1, 2, 3]),
                "long_array": LongArrayTag([1, 2, 3]),
            }
        )
        tag2 = copy.copy(tag)

        tag["list"].append(ByteTag())
        self.assertEqual(ListTag([ByteTag()]), tag2["list"])
        tag["compound"]["key"] = ByteTag()
        self.assertEqual(CompoundTag({"key": ByteTag()}), tag2["compound"])
        tag["byte_array"][0] = 10
        self.assertEqual(ByteArrayTag([10, 2, 3]), tag2["byte_array"])
        tag["int_array"][0] = 10
        self.assertEqual(IntArrayTag([10, 2, 3]), tag2["int_array"])
        tag["long_array"][0] = 10
        self.assertEqual(LongArrayTag([10, 2, 3]), tag2["long_array"])

    def test_deepcopy(self) -> None:
        tag = CompoundTag(
            {
                "byte": ByteTag(1),
                "short": ShortTag(1),
                "int": IntTag(1),
                "long": LongTag(1),
                "float": FloatTag(1),
                "double": DoubleTag(1),
                "byte_array": ByteArrayTag([1, 2, 3]),
                "string": StringTag("hello world"),
                "list": ListTag(),
                "compound": CompoundTag(),
                "int_array": IntArrayTag([1, 2, 3]),
                "long_array": LongArrayTag([1, 2, 3]),
            }
        )
        tag2 = copy.deepcopy(tag)

        # check the root data is copied
        self.assertIsNot(tag, tag2)
        self.assertEqual(tag, tag2)

        # Check if modifying the data makes it not equal
        tag["key"] = CompoundTag()
        self.assertNotEqual(tag, tag2)

        # Ensure they each have their own data
        tag["byte"] = ByteTag(2)
        tag["short"] = ShortTag(2)
        tag["int"] = IntTag(2)
        tag["long"] = LongTag(2)
        tag["float"] = FloatTag(2)
        tag["double"] = DoubleTag(2)
        tag["byte_array"] = ByteArrayTag([4, 5, 6])
        tag["string"] = StringTag("hello world2")
        tag["list"] = ListTag([ByteTag(1)])
        tag["compound"] = CompoundTag({"test": ByteTag(1)})
        tag["int_array"] = IntArrayTag([4, 5, 6])
        tag["long_array"] = LongArrayTag([4, 5, 6])

        self.assertEqual(ByteTag(1), tag2["byte"])
        self.assertEqual(ShortTag(1), tag2["short"])
        self.assertEqual(IntTag(1), tag2["int"])
        self.assertEqual(LongTag(1), tag2["long"])
        self.assertEqual(FloatTag(1), tag2["float"])
        self.assertEqual(DoubleTag(1), tag2["double"])
        self.assertEqual(ByteArrayTag([1, 2, 3]), tag2["byte_array"])
        self.assertEqual(StringTag("hello world"), tag2["string"])
        self.assertEqual(ListTag(), tag2["list"])
        self.assertEqual(CompoundTag(), tag2["compound"])
        self.assertEqual(IntArrayTag([1, 2, 3]), tag2["int_array"])
        self.assertEqual(LongArrayTag([1, 2, 3]), tag2["long_array"])

        # Make sure the contained data is not shared
        tag = CompoundTag(
            {
                "byte_array": ByteArrayTag([1, 2, 3]),
                "list": ListTag(),
                "compound": CompoundTag(),
                "int_array": IntArrayTag([1, 2, 3]),
                "long_array": LongArrayTag([1, 2, 3]),
            }
        )
        tag2 = copy.deepcopy(tag)

        tag["list"].append(ByteTag())
        self.assertEqual(ListTag(), tag2["list"])
        tag["compound"]["key"] = ByteTag()
        self.assertEqual(CompoundTag(), tag2["compound"])
        tag["byte_array"][0] = 10
        self.assertEqual(ByteArrayTag([1, 2, 3]), tag2["byte_array"])
        tag["int_array"][0] = 10
        self.assertEqual(IntArrayTag([1, 2, 3]), tag2["int_array"])
        tag["long_array"][0] = 10
        self.assertEqual(LongArrayTag([1, 2, 3]), tag2["long_array"])

    def test_hash(self) -> None:
        with self.assertRaises(TypeError):
            hash(CompoundTag())

    def test_instance(self) -> None:
        self.assertIsInstance(CompoundTag(), AbstractBaseTag)
        self.assertIsInstance(CompoundTag(), AbstractBaseMutableTag)
        self.assertIsInstance(CompoundTag(), CompoundTag)

    def test_fromkeys(self) -> None:
        tag = CompoundTag.fromkeys(("a", "b"), StringTag("test"))
        self.assertIsInstance(tag, CompoundTag)
        self.assertEqual(
            CompoundTag({"a": StringTag("test"), "b": StringTag("test")}), tag
        )
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys((1, 2), StringTag("test"))
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys((None, None), StringTag("test"))
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys(("a", "b"), None)

    def test_clear(self) -> None:
        c = CompoundTag({TagNameMap[tag_cls]: tag_cls() for tag_cls in self.nbt_types})
        c.clear()
        self.assertEqual(c, CompoundTag({}))

    def test_contains(self) -> None:
        c = CompoundTag({"key1": StringTag("val1")})
        self.assertIn("key1", c)
        self.assertNotIn("key2", c)
        for not_nbt in self.not_nbt:
            with self.subTest(key=not_nbt):
                if isinstance(not_nbt, str):
                    self.assertNotIn(not_nbt, c)
                else:
                    with self.assertRaises(TypeError, msg=not_nbt):
                        not_nbt in c

    def test_getitem(self) -> None:
        c = CompoundTag(
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
            }
        )
        self.assertEqual(c["key1"], StringTag("val1"))
        self.assertEqual(c["key2"], StringTag("val2"))

        for not_nbt in self.not_nbt:
            with self.subTest(key=not_nbt):
                # keys must be strings
                if isinstance(not_nbt, str):
                    with self.assertRaises(KeyError):
                        c[not_nbt]
                else:
                    with self.assertRaises(TypeError):
                        c[not_nbt]

    def test_get(self) -> None:
        value = StringTag("test")
        c = CompoundTag(key=value)
        self.assertEqual(value, c.get("key"))
        self.assertIs(None, c.get("key2"))
        self.assertEqual(value, c.get("key3", value))

    def test_get_typed(self) -> None:
        for cls in self.nbt_types:
            tag_name = TagNameMap[cls]
            tag = cls()
            comp = CompoundTag(key=tag)
            with self.subTest(cls=cls):
                self.assertEqual(tag, getattr(comp, f"get_{tag_name}")("key"))
                self.assertEqual(None, getattr(comp, f"get_{tag_name}")("key2"))
                self.assertEqual(tag, getattr(comp, f"get_{tag_name}")("key", tag))
                self.assertEqual(tag, getattr(comp, f"get_{tag_name}")("key2", tag))
                self.assertEqual(
                    tag, getattr(comp, f"get_{tag_name}")("key", raise_errors=True)
                )
                with self.assertRaises(KeyError):
                    getattr(comp, f"get_{tag_name}")("key2", raise_errors=True)
                self.assertEqual(
                    tag, getattr(comp, f"get_{tag_name}")("key", tag, raise_errors=True)
                )
                with self.assertRaises(KeyError):
                    getattr(comp, f"get_{tag_name}")("key2", tag, raise_errors=True)
            for cls2 in self.nbt_types:
                tag_name2 = TagNameMap[cls2]
                tag2 = cls2()
                if cls is cls2:
                    continue

                with self.assertRaises(TypeError):
                    getattr(comp, f"get_{tag_name}")("key", tag2)
                self.assertEqual(None, getattr(comp, f"get_{tag_name2}")("key"))
                self.assertEqual(None, getattr(comp, f"get_{tag_name2}")("key2"))
                self.assertEqual(tag2, getattr(comp, f"get_{tag_name2}")("key", tag2))
                self.assertEqual(tag2, getattr(comp, f"get_{tag_name2}")("key2", tag2))
                with self.assertRaises(TypeError):
                    getattr(comp, f"get_{tag_name2}")("key", raise_errors=True)
                with self.assertRaises(KeyError):
                    getattr(comp, f"get_{tag_name2}")("key2", raise_errors=True)
                with self.assertRaises(TypeError):
                    getattr(comp, f"get_{tag_name2}")("key", tag2, raise_errors=True)
                with self.assertRaises(KeyError):
                    getattr(comp, f"get_{tag_name2}")("key2", tag2, raise_errors=True)

    def test_pop(self) -> None:
        tag = CompoundTag(
            key1=StringTag("val1"),
            key2=StringTag("val2"),
            key3=StringTag("val3"),
        )
        self.assertEqual(StringTag("val1"), tag.pop("key1"))
        self.assertEqual(
            CompoundTag(
                key2=StringTag("val2"),
                key3=StringTag("val3"),
            ),
            tag,
        )
        with self.assertRaises(KeyError):
            tag.pop("key1")
        self.assertIs(None, tag.pop("key1", None))
        self.assertEqual(StringTag("val1"), tag.pop("key1", StringTag("val1")))

    def test_pop_typed(self) -> None:
        @contextmanager
        def compound_manager(pops: bool):
            comp_ = CompoundTag(key=tag)
            yield comp_
            if pops:
                self.assertNotIn("key", comp_)
            else:
                self.assertIn("key", comp_)

        for cls in self.nbt_types:
            tag_name = TagNameMap[cls]
            tag = cls()
            with self.subTest(cls=cls):
                with compound_manager(True) as comp:
                    self.assertEqual(tag, getattr(comp, f"pop_{tag_name}")("key"))
                with compound_manager(False) as comp:
                    self.assertEqual(None, getattr(comp, f"pop_{tag_name}")("key2"))
                with compound_manager(True) as comp:
                    self.assertEqual(tag, getattr(comp, f"pop_{tag_name}")("key", tag))
                with compound_manager(False) as comp:
                    self.assertEqual(tag, getattr(comp, f"pop_{tag_name}")("key2", tag))
                with compound_manager(True) as comp:
                    self.assertEqual(
                        tag, getattr(comp, f"pop_{tag_name}")("key", raise_errors=True)
                    )
                with compound_manager(False) as comp, self.assertRaises(KeyError):
                    getattr(comp, f"pop_{tag_name}")("key2", raise_errors=True)
                with compound_manager(True) as comp:
                    self.assertEqual(
                        tag,
                        getattr(comp, f"pop_{tag_name}")("key", tag, raise_errors=True),
                    )
                with compound_manager(False) as comp, self.assertRaises(KeyError):
                    getattr(comp, f"pop_{tag_name}")("key2", tag, raise_errors=True)
            for cls2 in self.nbt_types:
                tag_name2 = TagNameMap[cls2]
                tag2 = cls2()
                if cls is cls2:
                    continue

                with compound_manager(False) as comp, self.assertRaises(TypeError):
                    getattr(comp, f"pop_{tag_name}")("key", tag2)
                with compound_manager(False) as comp:
                    self.assertEqual(None, getattr(comp, f"pop_{tag_name2}")("key"))
                with compound_manager(False) as comp:
                    self.assertEqual(None, getattr(comp, f"pop_{tag_name2}")("key2"))
                with compound_manager(False) as comp:
                    self.assertEqual(
                        tag2, getattr(comp, f"pop_{tag_name2}")("key", tag2)
                    )
                with compound_manager(False) as comp:
                    self.assertEqual(
                        tag2, getattr(comp, f"pop_{tag_name2}")("key2", tag2)
                    )
                with compound_manager(False) as comp, self.assertRaises(TypeError):
                    getattr(comp, f"pop_{tag_name2}")("key", raise_errors=True)
                with compound_manager(False) as comp, self.assertRaises(KeyError):
                    getattr(comp, f"pop_{tag_name2}")("key2", raise_errors=True)
                with compound_manager(False) as comp, self.assertRaises(TypeError):
                    getattr(comp, f"pop_{tag_name2}")("key", tag2, raise_errors=True)
                with compound_manager(False) as comp, self.assertRaises(KeyError):
                    getattr(comp, f"pop_{tag_name2}")("key2", tag2, raise_errors=True)

    def test_setitem(self) -> None:
        tag = CompoundTag()
        tag["key"] = StringTag("val")
        self.assertEqual(CompoundTag({"key": StringTag("val")}), tag)

        for not_nbt in self.not_nbt:
            with self.subTest(not_nbt=not_nbt):
                # keys must be strings
                if not isinstance(not_nbt, str):
                    with self.assertRaises(TypeError):
                        tag[not_nbt] = StringTag("val")
                # vals must be nbt objects
                with self.assertRaises(TypeError, msg=repr(not_nbt)):
                    tag[not_nbt.__class__.__name__] = not_nbt

    def test_setdefault(self) -> None:
        c = CompoundTag(key1=StringTag("val1"))

        # invalid keys
        with self.assertRaises(TypeError):
            c.setdefault(None, StringTag("val1"))
        with self.assertRaises(TypeError):
            c.setdefault(StringTag("key2"), StringTag("val1"))

        # invalid values
        with self.assertRaises(TypeError):
            c.setdefault("key2")
        with self.assertRaises(TypeError):
            c.setdefault("key2", None)
        with self.assertRaises(TypeError):
            c.setdefault("key2", "val1")

        self.assertEqual(StringTag("val1"), c.setdefault("key1"))
        self.assertEqual(StringTag("val1"), c.setdefault("key1", StringTag("val2")))
        self.assertEqual(StringTag("val1"), c["key1"])
        self.assertEqual(StringTag("val2"), c.setdefault("key2", StringTag("val2")))
        self.assertEqual(StringTag("val2"), c["key2"])

    def test_setdefault_typed(self) -> None:
        for cls, cls2 in itertools.product(self.nbt_types, repeat=2):
            tag_name = TagNameMap[cls2]
            with self.subTest(cls=cls, cls2=cls2):
                tag = cls()
                tag2 = cls2()
                comp = CompoundTag(key=tag, key1=tag)
                if cls is cls2:
                    # get the key without overwriting it
                    self.assertEqual(
                        tag, getattr(comp, f"setdefault_{tag_name}")("key")
                    )
                    self.assertEqual(
                        tag, getattr(comp, f"setdefault_{tag_name}")("key", tag2)
                    )
                else:
                    self.assertIsInstance(
                        getattr(comp, f"setdefault_{tag_name}")("key"), cls2
                    )
                    self.assertEqual(
                        tag2, getattr(comp, f"setdefault_{tag_name}")("key1", tag2)
                    )
                # populate a key that does not exist
                self.assertIsInstance(
                    getattr(comp, f"setdefault_{tag_name}")("key2"), cls2
                )
                self.assertEqual(
                    tag2, getattr(comp, f"setdefault_{tag_name}")("key3", tag2)
                )

    def test_delitem(self) -> None:
        c = CompoundTag(key1=StringTag("val1"), key2=StringTag("val2"))
        del c["key1"]
        self.assertEqual(CompoundTag(key2=StringTag("val2")), c)

    def test_update(self) -> None:
        c = CompoundTag()
        with self.assertRaises(TypeError):
            c.update({None: StringTag("val")})
        with self.assertRaises(TypeError):
            c.update({"key": None})
        with self.assertRaises(TypeError):
            c.update(None)
        with self.assertRaises(TypeError):
            c.update(key=None)

        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c.update(d)
        self.assertEqual(CompoundTag(d), c)

        c.update({"key4": StringTag("val4")})
        self.assertEqual(
            CompoundTag(
                {
                    "key1": StringTag("val1"),
                    "key2": StringTag("val2"),
                    "key3": StringTag("val3"),
                    "key4": StringTag("val4"),
                }
            ),
            c,
        )
        c.update(key5=StringTag("val5"))
        self.assertEqual(
            CompoundTag(
                {
                    "key1": StringTag("val1"),
                    "key2": StringTag("val2"),
                    "key3": StringTag("val3"),
                    "key4": StringTag("val4"),
                    "key5": StringTag("val5"),
                }
            ),
            c,
        )
        c.update({"key6": StringTag("val6")}, key7=StringTag("val7"))
        self.assertEqual(
            CompoundTag(
                {
                    "key1": StringTag("val1"),
                    "key2": StringTag("val2"),
                    "key3": StringTag("val3"),
                    "key4": StringTag("val4"),
                    "key5": StringTag("val5"),
                    "key6": StringTag("val6"),
                    "key7": StringTag("val7"),
                }
            ),
            c,
        )
        d = CompoundTag(
            {
                "key1": StringTag("val8"),
                "key2": StringTag("val9"),
                "key3": StringTag("val10"),
                "key4": StringTag("val11"),
                "key5": StringTag("val12"),
                "key6": StringTag("val13"),
                "key7": StringTag("val14"),
            }
        )
        c.update(d)
        self.assertEqual(CompoundTag(d), c)

    def test_iter(self) -> None:
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        keys = set()
        it = iter(c)
        keys.add(next(it))
        keys.add(next(it))
        keys.add(next(it))
        with self.assertRaises(StopIteration):
            next(it)

        self.assertEqual({"key1", "key2", "key3"}, keys)

        self.assertIsInstance(list(c), list)
        self.assertEqual({"key1", "key2", "key3"}, set(c))
        self.assertIsInstance(dict(c), dict)
        self.assertEqual(dict(d), dict(c))

    def test_keys(self) -> None:
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(d.keys(), c.keys())

    def test_values(self) -> None:
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(set(d.values()), set(c.values()))

    def test_items(self) -> None:
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(d.items(), c.items())

    def test_len(self) -> None:
        self.assertEqual(
            3,
            len(
                CompoundTag(
                    {
                        "key1": StringTag("val1"),
                        "key2": StringTag("val2"),
                        "key3": StringTag("val3"),
                    }
                )
            ),
        )

    def test_to_nbt(self) -> None:
        self.assertEqual(
            b"\x0A\x00\x00\x00",
            CompoundTag().to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x00",
            CompoundTag().to_nbt(compressed=False, little_endian=True),
        )

        self.assertEqual(
            b"\x0A\x00\x00\x01\x00\x04byte\x05\x00",
            CompoundTag(byte=ByteTag(5)).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x01\x04\x00byte\x05\x00",
            CompoundTag(byte=ByteTag(5)).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x02\x00\x05short\x00\x05\x00",
            CompoundTag(short=ShortTag(5)).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x02\x05\x00short\x05\x00\x00",
            CompoundTag(short=ShortTag(5)).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x03\x00\x03int\x00\x00\x00\x05\x00",
            CompoundTag(int=IntTag(5)).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x03\x03\x00int\x05\x00\x00\x00\x00",
            CompoundTag(int=IntTag(5)).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x04\x00\x04long\x00\x00\x00\x00\x00\x00\x00\x05\x00",
            CompoundTag(long=LongTag(5)).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0A\x00\x00\x04\x04\x00long\x05\x00\x00\x00\x00\x00\x00\x00\x00",
            CompoundTag(long=LongTag(5)).to_nbt(compressed=False, little_endian=True),
        )

    def test_from_nbt(self) -> None:
        self.assertEqual(
            CompoundTag(byte=ByteTag(5)),
            read_nbt(b"\x0A\x00\x00\x01\x00\x04byte\x05\x00").compound,
        )
        self.assertEqual(
            CompoundTag(byte=ByteTag(5)),
            read_nbt(
                b"\x0A\x00\x00\x01\x04\x00byte\x05\x00", little_endian=True
            ).compound,
        )
        self.assertEqual(
            CompoundTag(short=ShortTag(5)),
            read_nbt(b"\x0A\x00\x00\x02\x00\x05short\x00\x05\x00").compound,
        )
        self.assertEqual(
            CompoundTag(short=ShortTag(5)),
            read_nbt(
                b"\x0A\x00\x00\x02\x05\x00short\x05\x00\x00", little_endian=True
            ).compound,
        )
        self.assertEqual(
            CompoundTag(int=IntTag(5)),
            read_nbt(b"\x0A\x00\x00\x03\x00\x03int\x00\x00\x00\x05\x00").compound,
        )
        self.assertEqual(
            CompoundTag(int=IntTag(5)),
            read_nbt(
                b"\x0A\x00\x00\x03\x03\x00int\x05\x00\x00\x00\x00", little_endian=True
            ).compound,
        )
        self.assertEqual(
            CompoundTag(long=LongTag(5)),
            read_nbt(
                b"\x0A\x00\x00\x04\x00\x04long\x00\x00\x00\x00\x00\x00\x00\x05\x00"
            ).compound,
        )
        self.assertEqual(
            CompoundTag(long=LongTag(5)),
            read_nbt(
                b"\x0A\x00\x00\x04\x04\x00long\x05\x00\x00\x00\x00\x00\x00\x00\x00",
                little_endian=True,
            ).compound,
        )

        with self.assertRaises(IndexError):
            read_nbt(b"\x0A")
        with self.assertRaises(IndexError):
            read_nbt(b"\x0A\x00\x00")

    def test_to_snbt(self) -> None:
        full_compound = CompoundTag(
            byte=ByteTag(),
            short=ShortTag(),
            int=IntTag(),
            long=LongTag(),
            float=FloatTag(),
            double=DoubleTag(),
            string=StringTag(),
            list=ListTag(),
            compound=CompoundTag(),
            byte_array=ByteArrayTag(),
            int_array=IntArrayTag(),
            long_array=LongArrayTag(),
        )

        self.assertEqual("{}", CompoundTag().to_snbt())
        self.assertEqual("{key: 0b}", CompoundTag(key=ByteTag()).to_snbt())
        self.assertEqual("{key: 0s}", CompoundTag(key=ShortTag()).to_snbt())
        self.assertEqual("{key: 0}", CompoundTag(key=IntTag()).to_snbt())
        self.assertEqual("{key: 0L}", CompoundTag(key=LongTag()).to_snbt())
        self.assertEqual("{key: 0f}", CompoundTag(key=FloatTag()).to_snbt())
        self.assertEqual("{key: 0d}", CompoundTag(key=DoubleTag()).to_snbt())
        self.assertEqual('{key: ""}', CompoundTag(key=StringTag()).to_snbt())
        self.assertEqual("{key: []}", CompoundTag(key=ListTag()).to_snbt())
        self.assertEqual("{key: {}}", CompoundTag(key=CompoundTag()).to_snbt())
        self.assertEqual("{key: [B;]}", CompoundTag(key=ByteArrayTag()).to_snbt())
        self.assertEqual("{key: [I;]}", CompoundTag(key=IntArrayTag()).to_snbt())
        self.assertEqual("{key: [L;]}", CompoundTag(key=LongArrayTag()).to_snbt())
        self.assertEqual(
            '{byte: 0b, byte_array: [B;], compound: {}, double: 0d, float: 0f, int: 0, int_array: [I;], list: [], long: 0L, long_array: [L;], short: 0s, string: ""}',
            full_compound.to_snbt(),
        )
        self.assertEqual(
            '{byte: 0b, byte_array: [B;], compound: {}, double: 0d, float: 0f, int: 0, int_array: [I;], list: [], long: 0L, long_array: [L;], short: 0s, string: ""}',
            full_compound.to_snbt(None),
        )
        self.assertEqual(
            "{\n"
            " byte: 0b,\n"
            " byte_array: [B;],\n"
            " compound: {},\n"
            " double: 0d,\n"
            " float: 0f,\n"
            " int: 0,\n"
            " int_array: [I;],\n"
            " list: [],\n"
            " long: 0L,\n"
            " long_array: [L;],\n"
            " short: 0s,\n"
            ' string: ""\n'
            "}",
            full_compound.to_snbt(" "),
        )
        self.assertEqual(
            "{\n"
            "    byte: 0b,\n"
            "    byte_array: [B;],\n"
            "    compound: {},\n"
            "    double: 0d,\n"
            "    float: 0f,\n"
            "    int: 0,\n"
            "    int_array: [I;],\n"
            "    list: [],\n"
            "    long: 0L,\n"
            "    long_array: [L;],\n"
            "    short: 0s,\n"
            '    string: ""\n'
            "}",
            full_compound.to_snbt(4),
        )
        self.assertEqual(
            "{\n"
            "\tbyte: 0b,\n"
            "\tbyte_array: [B;],\n"
            "\tcompound: {},\n"
            "\tdouble: 0d,\n"
            "\tfloat: 0f,\n"
            "\tint: 0,\n"
            "\tint_array: [I;],\n"
            "\tlist: [],\n"
            "\tlong: 0L,\n"
            "\tlong_array: [L;],\n"
            "\tshort: 0s,\n"
            '\tstring: ""\n'
            "}",
            full_compound.to_snbt("\t"),
        )

    def test_from_snbt(self) -> None:
        self.assertEqual(CompoundTag(), read_snbt("{}"))

        with self.subTest("Formatting"):
            self.assertEqual(CompoundTag({"1": IntTag(5)}), read_snbt("{1: 5}"))
            self.assertEqual(CompoundTag({"1": IntTag(5)}), read_snbt('{"1": 5}'))
            self.assertEqual(CompoundTag({"1": IntTag(5)}), read_snbt("{'1': 5}"))
            self.assertEqual(
                CompoundTag({"1": IntTag(5)}), read_snbt("{  '1'  :  5  }")
            )
            self.assertEqual(
                CompoundTag({"1": IntTag(5)}), read_snbt("\n{ \n '1' \n : \n 5 \n }\n")
            )

        with self.assertRaises(IndexError):
            read_snbt("{")
        with self.assertRaises(ValueError):
            read_snbt("}")
        with self.assertRaises(ValueError):
            read_snbt("{a:}")
        with self.assertRaises(ValueError):
            read_snbt("{a 5}")
        with self.assertRaises(ValueError):
            read_snbt("{a:5, b:}")
        with self.assertRaises(ValueError):
            read_snbt("{a:5 b:6}")


if __name__ == "__main__":
    unittest.main()
