import unittest
from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestCompound(base_type_test.BaseTypeTest):
    this_types = (TAG_Compound,)

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
            self.assertEqual(TAG_Compound({t.__name__: t()}), {t.__name__: t()})
            self.assertEqual(TAG_Compound(test=t()), {"test": t()})

        TAG_Compound({"key": TAG_Int()})
        with self.assertRaises(TypeError):
            TAG_Compound({0: TAG_Int()})
        with self.assertRaises(TypeError):
            TAG_Compound({None: TAG_Int()})
        with self.assertRaises(TypeError):
            TAG_Compound({"key": None})

        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                TAG_Compound({not_nbt.__class__.__name__: not_nbt})
            if not isinstance(not_nbt, str):
                with self.assertRaises(TypeError, msg=repr(not_nbt)):
                    TAG_Compound({not_nbt: TAG_Int()})

        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c1 = TAG_Compound(d)
        c2 = TAG_Compound(c1)
        self.assertEqual(d, c1)
        self.assertEqual(d, c2)
        self.assertIsNot(c1, c2)

    def test_equal(self):
        c = TAG_Compound()
        c["key"] = TAG_Int()
        for tag in (int,) + self.numerical_types:
            self.assertEqual(c, {"key": tag()})
            self.assertNotEqual(c, {"key": tag(5)})
            self.assertFalse(c.strict_equals({"key": tag()}))
        for tag in self.numerical_types:
            if tag is TAG_Int:
                self.assertTrue(c.strict_equals(TAG_Compound({"key": tag()})))
            else:
                self.assertFalse(c.strict_equals(TAG_Compound({"key": tag()})))

    def test_clear(self):
        c = TAG_Compound(self.full_dict)
        self.assertEqual(c, self.full_dict)
        c.clear()
        self.assertEqual(c, {})

    def test_fromkeys(self):
        c = TAG_Compound.fromkeys(("a", "b"), TAG_String("test"))
        self.assertEqual(
            c, TAG_Compound({"a": TAG_String("test"), "b": TAG_String("test")})
        )
        self.assertIsInstance(c, TAG_Compound)
        with self.assertRaises(TypeError):
            TAG_Compound.fromkeys((1, 2), TAG_String("test"))
        with self.assertRaises(TypeError):
            TAG_Compound.fromkeys((None, None), TAG_String("test"))
        with self.assertRaises(TypeError):
            TAG_Compound.fromkeys(("a", "b"), None)

    def test_get(self):
        c = TAG_Compound()
        value = c["key"] = TAG_String("test")
        self.assertIs(c.get("key"), value)
        self.assertIs(c.get("key2"), None)
        self.assertIs(c.get("key3", value), value)

    def test_iter(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        for i, t in enumerate(c):
            self.assertEqual(list(d)[i], t)
        self.assertEqual(list(d), list(c))
        self.assertIsInstance(list(c), list)
        self.assertEqual(dict(d), dict(c))
        self.assertIsInstance(dict(c), dict)

    def test_keys(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        self.assertEqual(d.keys(), c.keys())

    def test_values(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        self.assertEqual(list(d.values()), list(c.values()))

    def test_items(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        self.assertEqual(d.items(), c.items())

    def test_pop(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        self.assertEqual(c.pop("key1"), TAG_String("val1"))
        self.assertEqual(
            c,
            {
                "key2": TAG_String("val2"),
                "key3": TAG_String("val3"),
            },
        )
        with self.assertRaises(KeyError):
            c.pop("key1")
        self.assertIs(c.pop("key1", None), None)
        self.assertEqual(c.pop("key1", TAG_String("val1")), TAG_String("val1"))

    def test_setdefault(self):
        c = TAG_Compound(
            {
                "key1": TAG_String("val1"),
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
        c.setdefault("key1", TAG_String("val2"))
        self.assertEqual(c["key1"], "val1")
        c.setdefault("key2", TAG_String("val2"))
        self.assertEqual(c["key2"], "val2")

    def test_update(self):
        c = TAG_Compound()
        with self.assertRaises(TypeError):
            c.update({None: TAG_String("val")})
        with self.assertRaises(TypeError):
            c.update({"key": None})
        with self.assertRaises(TypeError):
            c.update(None)
        with self.assertRaises(TypeError):
            c.update(key=None)

        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c.update(d)
        self.assertEqual(c, d)

        c.update({"key4": TAG_String("val4")})
        self.assertEqual(
            c,
            {
                "key1": TAG_String("val1"),
                "key2": TAG_String("val2"),
                "key3": TAG_String("val3"),
                "key4": TAG_String("val4"),
            },
        )
        c.update(key5=TAG_String("val5"))
        self.assertEqual(
            c,
            {
                "key1": TAG_String("val1"),
                "key2": TAG_String("val2"),
                "key3": TAG_String("val3"),
                "key4": TAG_String("val4"),
                "key5": TAG_String("val5"),
            },
        )
        c.update({"key6": TAG_String("val6")}, key7=TAG_String("val7"))
        self.assertEqual(
            c,
            {
                "key1": TAG_String("val1"),
                "key2": TAG_String("val2"),
                "key3": TAG_String("val3"),
                "key4": TAG_String("val4"),
                "key5": TAG_String("val5"),
                "key6": TAG_String("val6"),
                "key7": TAG_String("val7"),
            },
        )
        d = {
            "key1": TAG_String("val8"),
            "key2": TAG_String("val9"),
            "key3": TAG_String("val10"),
            "key4": TAG_String("val11"),
            "key5": TAG_String("val12"),
            "key6": TAG_String("val13"),
            "key7": TAG_String("val14"),
        }
        c.update(d)
        self.assertEqual(c, d)

    def test_contains(self):
        c = TAG_Compound(
            {
                "key1": TAG_String("val1"),
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
        c = TAG_Compound(
            {
                "key1": TAG_String("val1"),
                "key2": TAG_String("val2"),
            }
        )
        del c["key1"]
        self.assertEqual(
            c,
            {
                "key2": TAG_String("val2"),
            },
        )

    def test_getitem(self):
        c = TAG_Compound(
            {
                "key1": TAG_String("val1"),
                "key2": TAG_String("val2"),
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
        c = TAG_Compound()
        c["key"] = TAG_String("val")
        self.assertEqual(c, {"key": "val"})

        for not_nbt in self.not_nbt:
            # keys must be strings
            if not isinstance(not_nbt, str):
                with self.assertRaises(TypeError):
                    c[not_nbt] = TAG_String("val")
            # vals must be nbt objects
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                c[not_nbt.__class__.__name__] = not_nbt

    def test_len(self):
        self.assertEqual(
            len(
                TAG_Compound(
                    {
                        "key1": TAG_String("val1"),
                        "key2": TAG_String("val2"),
                        "key3": TAG_String("val3"),
                    }
                )
            ),
            3,
        )

    def test_reversed(self):
        d = {
            "key1": TAG_String("val1"),
            "key2": TAG_String("val2"),
            "key3": TAG_String("val3"),
        }
        c = TAG_Compound(d)
        self.assertEqual(
            list(reversed(d)),
            list(reversed(c)),
        )

    def test_hash(self):
        with self.assertRaises(TypeError):
            hash(TAG_Compound())


if __name__ == "__main__":
    unittest.main()
