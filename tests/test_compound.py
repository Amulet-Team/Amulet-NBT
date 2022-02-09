import sys
import unittest
from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
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
)


class TestCompound(base_type_test.BaseTypeTest):
    this_types = (CompoundTag,)

    @property
    def values(self):
        return (
            ({},)
            + tuple({"name": cls()} for cls in self.nbt_types)
            + tuple({"name1": cls(), "name2": cls()} for cls in self.nbt_types)
            + (self.full_dict,)
        )

    @property
    def full_dict(self):
        return {cls.__name__: cls() for cls in self.nbt_types}

    def test_init(self):
        self._test_init(dict, {})

        for t in self.nbt_types:
            self.assertEqual(CompoundTag({t.__name__: t()}), {t.__name__: t()})
            self.assertEqual(CompoundTag(test=t()), {"test": t()})

        CompoundTag({"key": IntTag()})
        with self.assertRaises(TypeError):
            CompoundTag({0: IntTag()})
        with self.assertRaises(TypeError):
            CompoundTag({None: IntTag()})
        with self.assertRaises(TypeError):
            CompoundTag({"key": None})

        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                CompoundTag({not_nbt.__class__.__name__: not_nbt})
            if not isinstance(not_nbt, str):
                with self.assertRaises(TypeError, msg=repr(not_nbt)):
                    CompoundTag({not_nbt: IntTag()})

        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c1 = CompoundTag(d)
        c2 = CompoundTag(c1)
        self.assertEqual(d, c1)
        self.assertEqual(d, c2)
        self.assertIsNot(c1, c2)

    def test_equal(self):
        c = CompoundTag()
        c["key"] = IntTag()
        for tag in (int,) + self.numerical_types:
            self.assertEqual(c, {"key": tag()})
            self.assertNotEqual(c, {"key": tag(5)})
            self.assertFalse(c.strict_equals({"key": tag()}))
        for tag in self.numerical_types:
            if tag is IntTag:
                self.assertTrue(c.strict_equals(CompoundTag({"key": tag()})))
            else:
                self.assertFalse(c.strict_equals(CompoundTag({"key": tag()})))

    def test_clear(self):
        c = CompoundTag(self.full_dict)
        self.assertEqual(c, self.full_dict)
        c.clear()
        self.assertEqual(c, {})

    def test_fromkeys(self):
        c = CompoundTag.fromkeys(("a", "b"), StringTag("test"))
        self.assertEqual(
            c, CompoundTag({"a": StringTag("test"), "b": StringTag("test")})
        )
        self.assertIsInstance(c, CompoundTag)
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys((1, 2), StringTag("test"))
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys((None, None), StringTag("test"))
        with self.assertRaises(TypeError):
            CompoundTag.fromkeys(("a", "b"), None)

    def test_get(self):
        c = CompoundTag()
        value = c["key"] = StringTag("test")
        self.assertIs(c.get("key"), value)
        self.assertIs(c.get("key2"), None)
        self.assertIs(c.get("key3", value), value)

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

        self.assertEqual(list(d), list(c))
        self.assertIsInstance(list(c), list)
        self.assertEqual(dict(d), dict(c))
        self.assertIsInstance(dict(c), dict)

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

    def test_pop(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(c.pop("key1"), StringTag("val1"))
        self.assertEqual(
            c,
            {
                "key2": StringTag("val2"),
                "key3": StringTag("val3"),
            },
        )
        with self.assertRaises(KeyError):
            c.pop("key1")
        self.assertIs(c.pop("key1", None), None)
        self.assertEqual(c.pop("key1", StringTag("val1")), StringTag("val1"))

    def test_setdefault(self):
        c = CompoundTag(
            {
                "key1": StringTag("val1"),
            }
        )
        with self.assertRaises(Exception):
            c.setdefault("key1")
        with self.assertRaises(TypeError):
            c.setdefault(None, "val1")
        with self.assertRaises(TypeError):
            c.setdefault("key1", None)
        with self.assertRaises(TypeError):
            c.setdefault("key1", "val1")
        self.assertEqual(c.setdefault("key1", StringTag("val2")), "val1")
        self.assertEqual(c["key1"], "val1")
        self.assertEqual(c.setdefault("key2", StringTag("val2")), "val2")
        self.assertEqual(c["key2"], "val2")

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
        self.assertEqual(c, d)

        c.update({"key4": StringTag("val4")})
        self.assertEqual(
            c,
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
                "key3": StringTag("val3"),
                "key4": StringTag("val4"),
            },
        )
        c.update(key5=StringTag("val5"))
        self.assertEqual(
            c,
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
                "key3": StringTag("val3"),
                "key4": StringTag("val4"),
                "key5": StringTag("val5"),
            },
        )
        c.update({"key6": StringTag("val6")}, key7=StringTag("val7"))
        self.assertEqual(
            c,
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
                "key3": StringTag("val3"),
                "key4": StringTag("val4"),
                "key5": StringTag("val5"),
                "key6": StringTag("val6"),
                "key7": StringTag("val7"),
            },
        )
        d = {
            "key1": StringTag("val8"),
            "key2": StringTag("val9"),
            "key3": StringTag("val10"),
            "key4": StringTag("val11"),
            "key5": StringTag("val12"),
            "key6": StringTag("val13"),
            "key7": StringTag("val14"),
        }
        c.update(d)
        self.assertEqual(c, d)

    def test_contains(self):
        c = CompoundTag(
            {
                "key1": StringTag("val1"),
            }
        )
        self.assertIn("key1", c)
        self.assertNotIn("key2", c)
        for not_nbt in self.not_nbt:
            if isinstance(not_nbt, (list, dict, set)):
                with self.assertRaises(TypeError, msg=not_nbt):
                    not_nbt in c
            else:
                self.assertNotIn(not_nbt, c)

    def test_delitem(self):
        c = CompoundTag(
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
            }
        )
        del c["key1"]
        self.assertEqual(
            c,
            {
                "key2": StringTag("val2"),
            },
        )

    def test_getitem(self):
        c = CompoundTag(
            {
                "key1": StringTag("val1"),
                "key2": StringTag("val2"),
            }
        )
        self.assertEqual(c["key1"], "val1")
        self.assertEqual(c["key2"], "val2")

        for not_nbt in self.not_nbt:
            # keys must be strings
            if isinstance(not_nbt, str):
                with self.assertRaises(KeyError):
                    c[not_nbt]
            else:
                with self.assertRaises(TypeError):
                    c[not_nbt]

    def test_setitem(self):
        c = CompoundTag()
        c["key"] = StringTag("val")
        self.assertEqual(c, {"key": "val"})

        for not_nbt in self.not_nbt:
            # keys must be strings
            if not isinstance(not_nbt, str):
                with self.assertRaises(TypeError):
                    c[not_nbt] = StringTag("val")
            # vals must be nbt objects
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                c[not_nbt.__class__.__name__] = not_nbt

    def test_len(self):
        self.assertEqual(
            len(
                CompoundTag(
                    {
                        "key1": StringTag("val1"),
                        "key2": StringTag("val2"),
                        "key3": StringTag("val3"),
                    }
                )
            ),
            3,
        )

    @unittest.skipUnless(sys.version_info >= (3, 8), "dicts are ")
    def test_reversed(self):
        d = {
            "key1": StringTag("val1"),
            "key2": StringTag("val2"),
            "key3": StringTag("val3"),
        }
        c = CompoundTag(d)
        self.assertEqual(
            list(reversed(d)),
            list(reversed(c)),
        )

    def test_hash(self):
        with self.assertRaises(TypeError):
            hash(CompoundTag())


if __name__ == "__main__":
    unittest.main()
