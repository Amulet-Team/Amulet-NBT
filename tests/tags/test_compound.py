import unittest
import itertools
import copy
import pickle

from amulet_nbt import (
    __major__,
    AbstractBaseTag,
    AbstractBaseMutableTag,
    AbstractBaseNumericTag,
    AbstractBaseArrayTag,
    CompoundTag,
    ByteTag,
    StringTag,
)

from tests.tags.abstract_base_tag import AbstractBaseTagTest, Tags


class TestCompound(AbstractBaseTagTest.AbstractBaseTagTest):
    def test_constructor(self):
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                CompoundTag({"key": cls()})
                CompoundTag(key=cls())
                CompoundTag((("key", cls()),))

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

    def test_equal(self):
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for ground in ({"key": cls1()}, CompoundTag({"key": cls1()})):
                for other in (
                    CompoundTag({"key": cls2()}),
                    CompoundTag(key=cls1()),
                    CompoundTag((("key", cls1()),)),
                ):
                    with self.subTest(cls1=cls1, cls2=cls2, ground=ground, other=other):
                        if cls1 is cls2 and (
                            isinstance(ground, CompoundTag) or __major__ <= 2
                        ):
                            self.assertEqual(ground, other)
                        elif __major__ <= 2 and (
                            (
                                issubclass(cls1, AbstractBaseNumericTag)
                                and issubclass(cls2, AbstractBaseNumericTag)
                            )
                            or (
                                issubclass(cls1, AbstractBaseArrayTag)
                                and issubclass(cls2, AbstractBaseArrayTag)
                            )
                        ):
                            self.assertEqual(ground, other)
                        else:
                            self.assertNotEqual(ground, other)

        c = CompoundTag()
        for tag_cls, tag_name in Tags:
            c[tag_name] = tag_cls()

        self.assertEqual(
            c,
            CompoundTag({tag_name: tag_cls() for tag_cls, tag_name in Tags}),
        )

    def test_instance(self):
        self.assertIsInstance(CompoundTag(), AbstractBaseTag)
        self.assertIsInstance(CompoundTag(), AbstractBaseMutableTag)
        self.assertIsInstance(CompoundTag(), CompoundTag)

    def test_py_data(self):
        tag = CompoundTag()
        self.assertIsInstance(tag.py_dict, dict)
        self.assertEqual(tag.py_dict, {})

        tag = CompoundTag(byte=ByteTag())
        self.assertEqual({"byte": ByteTag()}, tag.py_dict)

        self.assertIsNot(tag.py_dict, tag.py_dict)

    def test_fromkeys(self):
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

    def test_clear(self):
        c = CompoundTag({tag_name: tag_cls() for tag_cls, tag_name in Tags})
        c.clear()
        self.assertEqual(c, CompoundTag({}))

    def test_contains(self):
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

    def test_getitem(self):
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

    def test_get(self):
        value = StringTag("test")
        c = CompoundTag(key=value)
        self.assertIs(value, c.get("key"))
        self.assertIs(None, c.get("key2"))
        self.assertIs(value, c.get("key3", value))

    def test_get_typed(self):
        for cls, tag_name in Tags:
            tag = cls()
            comp = CompoundTag(key=tag)
            with self.subTest(cls=cls):
                self.assertIs(tag, getattr(comp, f"get_{tag_name}")("key"))
                self.assertIs(tag, getattr(comp, f"get_{tag_name}")("key", cls()))
                with self.assertRaises(KeyError):
                    getattr(comp, f"get_{tag_name}")("key2")
                self.assertIs(tag, getattr(comp, f"get_{tag_name}")("key2", tag))
            for cls2, tag_name2 in Tags:
                if cls is cls2:
                    continue
                with self.subTest(cls=cls, cls2=cls2):
                    with self.assertRaises(TypeError):
                        getattr(comp, f"get_{tag_name2}")("key")

    def test_pop(self):
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

    def test_setitem(self):
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

    def test_setdefault(self):
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

    def test_setdefault_typed(self):
        for (cls, _), (cls2, tag_name) in itertools.product(Tags, repeat=2):
            with self.subTest(cls=cls, cls2=cls2):
                tag = cls()
                tag2 = cls2()
                comp = CompoundTag(key=tag, key1=tag)
                if cls is cls2:
                    # get the key without overwriting it
                    self.assertIs(tag, getattr(comp, f"setdefault_{tag_name}")("key"))
                    self.assertIs(
                        tag, getattr(comp, f"setdefault_{tag_name}")("key", tag2)
                    )
                else:
                    self.assertIsInstance(
                        getattr(comp, f"setdefault_{tag_name}")("key"), cls2
                    )
                    self.assertIs(
                        tag2, getattr(comp, f"setdefault_{tag_name}")("key1", tag2)
                    )
                # populate a key that does not exist
                self.assertIsInstance(
                    getattr(comp, f"setdefault_{tag_name}")("key2"), cls2
                )
                self.assertIs(
                    tag2, getattr(comp, f"setdefault_{tag_name}")("key3", tag2)
                )

    def test_delitem(self):
        c = CompoundTag(key1=StringTag("val1"), key2=StringTag("val2"))
        del c["key1"]
        self.assertEqual(CompoundTag(key2=StringTag("val2")), c)

    def test_update(self):
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

    def test_iter(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        it = iter(c)
        self.assertEqual(next(it), "key1")
        self.assertEqual(next(it), "key2")
        self.assertEqual(next(it), "key3")
        with self.assertRaises(StopIteration):
            next(it)

        self.assertIsInstance(list(c), list)
        self.assertEqual(list(d), list(c))
        self.assertIsInstance(dict(c), dict)
        self.assertEqual(dict(d), dict(c))

    def test_keys(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(d.keys(), c.keys())

    def test_values(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(list(d.values()), list(c.values()))

    def test_items(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(d.items(), c.items())

    def test_copy(self):
        with self.subTest("Shallow Copy"):
            tag = CompoundTag(key=CompoundTag())
            tag2 = copy.copy(tag)
            tag.get_compound("key")["key2"] = ByteTag()
            self.assertEqual(tag.get_compound("key"), tag2.get_compound("key"))

        with self.subTest("Deep Copy"):
            tag = CompoundTag(key=CompoundTag())
            tag2 = copy.deepcopy(tag)
            tag.get_compound("key")["key2"] = ByteTag()
            self.assertNotEqual(tag.get_compound("key"), tag2.get_compound("key"))

    def test_pickle(self):
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = CompoundTag(key=cls())
                dump = pickle.dumps(tag)
                tag2 = pickle.loads(dump)
                self.assertEqual(tag, tag2)

    def test_hash(self):
        with self.assertRaises(TypeError):
            hash(CompoundTag())

    def test_repr(self):
        self.assertEqual("CompoundTag({})", repr(CompoundTag()))
        self.assertEqual(
            "CompoundTag({'key': ByteTag(0)})", repr(CompoundTag(key=ByteTag()))
        )
        self.assertEqual(
            "CompoundTag({'key': StringTag(\"\")})",
            repr(CompoundTag(key=StringTag())),
        )

    def test_len(self):
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


if __name__ == "__main__":
    unittest.main()
