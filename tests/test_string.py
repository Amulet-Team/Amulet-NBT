import sys
from typing import Union
import unittest
from tests import base_type_test
import operator

from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    StringTag,
)

AnyStr = Union[str, StringTag]


class TestString(base_type_test.BaseTypeTest):
    values = ("", "test", "value", "value" * 500)
    num_values = (-5, 0, 1, 5)
    this_types = (StringTag,)

    def test_init(self):
        self._test_init(str, "")

    def _test_op2(self, val1, val2, op, res_cls, res_val):
        res = op(val1, val2)
        self.assertIsInstance(res, res_cls, msg=f"{op}, {repr(val1)}, {repr(val2)}")
        self.assertEqual(res_val, res)

    def assertStrictEqual(self, expected_type, expected_value, test):
        self.assertIsInstance(test, expected_type)
        self.assertEqual(expected_value, test)

    def test_add(self):
        for dtype1 in (str, StringTag):
            for dtype2 in (str, StringTag):
                # add
                self._test_op2(
                    dtype1("val1"), dtype2("val2"), operator.add, str, "val1val2"
                )
                # iadd
                self._test_op2(
                    dtype1("val1"), dtype2("val2"), operator.iadd, dtype1, "val1val2"
                )

    def test_contains(self):
        self.assertIn("test", StringTag("hitesthi"))

    def test_eq(self):
        for dtype1 in (str, StringTag):
            for dtype2 in (str, StringTag):
                self.assertEqual(dtype1("val1"), dtype2("val1"))
                self.assertNotEqual(dtype1("val1"), dtype2("Val1"))
                self.assertNotEqual(dtype1("val1"), dtype2("val2"))

    def test_comp(self):
        for dtype1 in (str, StringTag):
            for dtype2 in (str, StringTag):
                self.assertLess(dtype1("val1"), dtype2("val2"))
                self.assertLessEqual(dtype1("val1"), dtype2("val2"))
                self.assertLessEqual(dtype1("val1"), dtype2("val1"))

                self.assertGreater(dtype1("val2"), dtype2("val1"))
                self.assertGreaterEqual(dtype1("val2"), dtype2("val1"))
                self.assertGreaterEqual(dtype1("val1"), dtype2("val1"))

    def test_getitem(self):
        self.assertEqual("e", StringTag("test")[1])
        self.assertEqual("es", StringTag("test")[1:3])

    def test_iter(self):
        it = iter(StringTag("test"))
        self.assertEqual("t", next(it))
        self.assertEqual("e", next(it))
        self.assertEqual("s", next(it))
        self.assertEqual("t", next(it))
        with self.assertRaises(StopIteration):
            next(it)

    def test_len(self):
        self.assertEqual(4, len(StringTag("test")))

    def test_mul(self):
        for num_cls in (int, ByteTag, ShortTag, IntTag, LongTag):
            for num_val in self.num_values:
                self._test_op2(
                    num_cls(num_val),
                    StringTag("val1"),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    StringTag("val1"),
                    num_cls(num_val),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )

                self._test_op2(
                    num_cls(num_val),
                    StringTag("val1"),
                    operator.imul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    StringTag("val1"),
                    num_cls(num_val),
                    operator.imul,
                    StringTag,
                    "val1" * num_val,
                )

    def test_str(self):
        self.assertStrictEqual(str, "test", str(StringTag("test")))

    def test_capitalize(self):
        self.assertStrictEqual(
            str, "Test sentence", StringTag("test sentence").capitalize()
        )

    def test_casefold(self):
        self.assertStrictEqual(str, "tesst", StringTag("TEßT").casefold())

    def test_center(self):
        self.assertStrictEqual(str, "___test__", StringTag("test").center(9, "_"))
        # self.assertStrictEqual(
        #     str, "___test__", StringTag("test").center(9, StringTag("_"))
        # )
        self.assertStrictEqual(str, "   test  ", StringTag("test").center(9))

    def test_count(self):
        self.assertStrictEqual(int, 5, StringTag("test" * 5).count("test"))
        # self.assertStrictEqual(int, 5, StringTag("test" * 5).count(StringTag("test")))

    def test_encode(self):
        self.assertStrictEqual(bytes, b"test", StringTag("test").encode("utf-8"))

    def test_endswith(self):
        self.assertTrue(StringTag("test").endswith("st"))
        # self.assertTrue(StringTag("test").endswith(StringTag("st")))
        self.assertFalse(StringTag("test").endswith("te"))
        # self.assertFalse(StringTag("test").endswith(StringTag("te")))

    def test_expandtabs(self):
        self.assertStrictEqual(
            str, "    t   e   s   t", StringTag("\tt\te\ts\tt").expandtabs(4)
        )

    def test_find(self):
        self.assertStrictEqual(int, 4, StringTag("val1val2val3val2val4").find("val2"))
        # self.assertStrictEqual(
        #     int, 4, StringTag("val1val2val3val2val4").find(StringTag("val2"))
        # )
        self.assertStrictEqual(int, -1, StringTag("val1val2val3val2val4").find("val5"))
        # self.assertStrictEqual(
        #     int, -1, StringTag("val1val2val3val2val4").find(StringTag("val5"))
        # )

    def test_rfind(self):
        self.assertStrictEqual(int, 12, StringTag("val1val2val3val2val4").rfind("val2"))
        # self.assertStrictEqual(
        #     int, 12, StringTag("val1val2val3val2val4").rfind(StringTag("val2"))
        # )
        self.assertStrictEqual(int, -1, StringTag("val1val2val3val2val4").rfind("val5"))
        # self.assertStrictEqual(
        #     int, -1, StringTag("val1val2val3val2val4").rfind(StringTag("val5"))
        # )

    def test_index(self):
        self.assertStrictEqual(int, 4, StringTag("val1val2val3val2val4").index("val2"))
        # self.assertStrictEqual(
        #     int, 4, StringTag("val1val2val3val2val4").index(StringTag("val2"))
        # )
        with self.assertRaises(ValueError):
            StringTag("val1val2val3val2val4").index("val5")
        # with self.assertRaises(ValueError):
        #     StringTag("val1val2val3val2val4").index(StringTag("val5"))

    def test_rindex(self):
        self.assertStrictEqual(
            int, 12, StringTag("val1val2val3val2val4").rindex("val2")
        )
        # self.assertStrictEqual(
        #     int, 12, StringTag("val1val2val3val2val4").rindex(StringTag("val2"))
        # )
        with self.assertRaises(ValueError):
            StringTag("val1val2val3val2val4").rindex("val5")
        # with self.assertRaises(ValueError):
        #     StringTag("val1val2val3val2val4").rindex(StringTag("val5"))

    def test_format(self):
        for dtype1 in (str, StringTag):
            for dtype2 in (str, StringTag):
                self.assertStrictEqual(str, "TEST", dtype1("T%sT") % dtype2("ES"))
                self.assertStrictEqual(str, "TEST", dtype1("T{}T").format(dtype2("ES")))
                self.assertStrictEqual(
                    str,
                    "TEST2",
                    dtype1("T{a}T{b}").format(a=dtype2("ES"), b=dtype2("2")),
                )
                self.assertStrictEqual(
                    str,
                    "TEST2",
                    dtype1("T{a}T{b}").format_map(
                        {"a": dtype2("ES"), "b": dtype2("2")}
                    ),
                )

    def test_isalnum(self):
        self.assertFalse(StringTag("").isalnum())
        self.assertTrue(StringTag("test1").isalnum())
        self.assertFalse(StringTag("test1-").isalnum())

    def test_isalpha(self):
        self.assertFalse(StringTag("").isalpha())
        self.assertTrue(StringTag("test").isalpha())
        self.assertFalse(StringTag("test1").isalpha())

    def test_isascii(self):
        self.assertTrue(StringTag("").isascii())
        self.assertTrue(StringTag("test123").isascii())
        self.assertFalse(StringTag("test123💩").isascii())

    def test_int(self):
        self.assertStrictEqual(int, 50, int(StringTag("50")))
        self.assertStrictEqual(int, 50, int(StringTag("٥٠")))  # arabic for 50

        with self.assertRaises(ValueError):
            int(StringTag("test"))

    def test_isdecimal(self):
        self.assertFalse(StringTag("").isdecimal())
        self.assertTrue(StringTag("123456789").isdecimal())
        self.assertFalse(StringTag("test").isdecimal())

    def test_isdigit(self):
        self.assertFalse(StringTag("").isdigit())
        self.assertTrue(StringTag("123456789⁰¹²³⁴⁵⁶⁷⁸⁹").isdigit())
        self.assertFalse(StringTag("test").isdigit())

    def test_isnumeric(self):
        self.assertFalse(StringTag("").isnumeric())
        self.assertTrue(StringTag("123456789⁰¹²³⁴⁵⁶⁷⁸⁹ⅠⅡⅢⅣⅤ").isnumeric())
        self.assertFalse(StringTag("test").isnumeric())

    def test_is_x(self):
        for i in range(0x110000):
            c = chr(i)
            try:
                int(c)
            except:
                pass
            else:
                self.assertEqual(int(c), int(StringTag(c)))
            self.assertEqual(c.isdecimal(), StringTag(c).isdecimal())
            self.assertEqual(c.isdigit(), StringTag(c).isdigit())
            self.assertEqual(c.isdigit(), StringTag(c).isdigit())
            self.assertEqual(c.isprintable(), StringTag(c).isprintable())

    def test_isidentifier(self):
        self.assertTrue(StringTag("test").isidentifier())
        self.assertTrue(StringTag("test1").isidentifier())
        self.assertTrue(StringTag("test_test").isidentifier())
        self.assertFalse(StringTag("1test").isidentifier())

    def test_islower(self):
        self.assertTrue(StringTag("test").islower())
        self.assertFalse(StringTag("TEST").islower())

    def test_isupper(self):
        self.assertFalse(StringTag("test").isupper())
        self.assertTrue(StringTag("TEST").isupper())

    def test_isspace(self):
        self.assertTrue(StringTag(" \t\r\n").isspace())
        self.assertFalse(StringTag("TEST").isspace())

    def test_istitle(self):
        self.assertTrue(StringTag("Test").istitle())
        self.assertFalse(StringTag("test").istitle())
        self.assertFalse(StringTag("TEST").istitle())

    def test_join(self):
        self.assertStrictEqual(str, "a,b", StringTag(",").join(["a", "b"]))
        self.assertStrictEqual(
            str, "a,b", StringTag(",").join([StringTag("a"), StringTag("b")])
        )

    def test_ljust(self):
        self.assertEqual("test   ", StringTag("test").ljust(7))
        self.assertEqual("test___", StringTag("test").ljust(7, "_"))
        # self.assertEqual("test___", StringTag("test").ljust(7, StringTag("_")))

    def test_rjust(self):
        self.assertEqual("   test", StringTag("test").rjust(7))
        self.assertEqual("___test", StringTag("test").rjust(7, "_"))
        # self.assertEqual("___test", StringTag("test").rjust(7, StringTag("_")))

    def test_lower(self):
        self.assertStrictEqual(str, "test", StringTag("TEST").lower())

    def test_lstrip(self):
        self.assertStrictEqual(
            str, "test \t\r\n", StringTag(" \t\r\ntest \t\r\n").lstrip()
        )
        self.assertStrictEqual(str, "test__", StringTag("__test__").lstrip("_"))
        # self.assertStrictEqual(
        #     str, "test__", StringTag("__test__").lstrip(StringTag("_"))
        # )

    def test_rstrip(self):
        self.assertStrictEqual(
            str, " \t\r\ntest", StringTag(" \t\r\ntest \t\r\n").rstrip()
        )
        self.assertStrictEqual(str, "__test", StringTag("__test__").rstrip("_"))
        # self.assertStrictEqual(
        #     str, "__test", StringTag("__test__").rstrip(StringTag("_"))
        # )

    def test_strip(self):
        self.assertStrictEqual(str, "test", StringTag(" \t\r\ntest \t\r\n").strip())
        self.assertStrictEqual(str, "test", StringTag("__test__").strip("_"))
        # self.assertStrictEqual(
        #     str, "test", StringTag("__test__").strip(StringTag("_"))
        # )

    def test_translate(self):
        t = StringTag.maketrans("abc", "xyz")
        self.assertStrictEqual(
            str, "testxyztest", StringTag("testabctest").translate(t)
        )
        t = StringTag.maketrans({"a": "x", "b": "y", "c": "z"})
        self.assertStrictEqual(
            str, "testxyztest", StringTag("testabctest").translate(t)
        )

    def test_partition(self):
        a, b, c = StringTag("testabctestabctest").partition("abc")
        self.assertStrictEqual(str, "test", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "testabctest", c)
        a, b, c = StringTag("testabctestabctest").partition(StringTag("abc"))
        self.assertStrictEqual(str, "test", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "testabctest", c)

    def test_rpartition(self):
        a, b, c = StringTag("testabctestabctest").rpartition("abc")
        self.assertStrictEqual(str, "testabctest", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "test", c)
        a, b, c = StringTag("testabctestabctest").rpartition(StringTag("abc"))
        self.assertStrictEqual(str, "testabctest", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "test", c)

    def test_split(self):
        self.assertStrictEqual(
            list,
            ["test", "test", "test"],
            StringTag("testabctestabctest").split("abc"),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "test", "test"],
        #     StringTag("testabctestabctest").split(StringTag("abc")),
        # )
        self.assertStrictEqual(
            list,
            ["test", "testabctest"],
            StringTag("testabctestabctest").split("abc", 1),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "testabctest"],
        #     StringTag("testabctestabctest").split(StringTag("abc"), 1),
        # )

    def test_rsplit(self):
        self.assertStrictEqual(
            list,
            ["test", "test", "test"],
            StringTag("testabctestabctest").rsplit("abc"),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "test", "test"],
        #     StringTag("testabctestabctest").rsplit(StringTag("abc")),
        # )
        self.assertStrictEqual(
            list,
            ["testabctest", "test"],
            StringTag("testabctestabctest").rsplit("abc", 1),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["testabctest", "test"],
        #     StringTag("testabctestabctest").rsplit(StringTag("abc"), 1),
        # )

    def test_splitlines(self):
        self.assertStrictEqual(
            list,
            ["ab c", "", "de fg", "kl"],
            StringTag("ab c\n\nde fg\rkl\r\n").splitlines(),
        )
        self.assertStrictEqual(
            list,
            ["ab c\n", "\n", "de fg\r", "kl\r\n"],
            StringTag("ab c\n\nde fg\rkl\r\n").splitlines(keepends=True),
        )

    @unittest.skipUnless(
        sys.version_info >= (3, 9), "removeprefix only exists in python 3.9+"
    )
    def test_removeprefix(self):
        self.assertStrictEqual(str, "Hook", StringTag("TestHook").removeprefix("Test"))
        # self.assertStrictEqual(
        #     str, "Hook", StringTag("TestHook").removeprefix(StringTag("Test"))
        # )
        self.assertStrictEqual(
            str,
            "BaseTestCase",
            StringTag("BaseTestCase").removeprefix("Test"),
        )
        # self.assertStrictEqual(
        #     str,
        #     "BaseTestCase",
        #     StringTag("BaseTestCase").removeprefix(StringTag("Test")),
        # )

    @unittest.skipUnless(
        sys.version_info >= (3, 9), "removesuffix only exists in python 3.9+"
    )
    def test_removesuffix(self):
        self.assertStrictEqual(str, "Test", StringTag("TestHook").removesuffix("Hook"))
        # self.assertStrictEqual(
        #     str, "Test", StringTag("TestHook").removesuffix(StringTag("Test"))
        # )
        self.assertStrictEqual(
            str, "BaseTestCase", StringTag("BaseTestCase").removesuffix("Test")
        )
        # self.assertStrictEqual(
        #     str,
        #     "BaseTestCase",
        #     StringTag("BaseTestCase").removesuffix(StringTag("Test")),
        # )

    def test_replace(self):
        self.assertStrictEqual(
            str,
            "testxyztestxyztest",
            StringTag("testabctestabctest").replace("abc", "xyz"),
        )
        # self.assertStrictEqual(
        #     str,
        #     "testxyztestxyztest",
        #     StringTag("testabctestabctest").replace(
        #         StringTag("abc"), StringTag("xyz")
        #     ),
        # )
        self.assertStrictEqual(
            str,
            "testxyztestabctest",
            StringTag("testabctestabctest").replace("abc", "xyz", 1),
        )
        # self.assertStrictEqual(
        #     str,
        #     "testxyztestabctest",
        #     StringTag("testabctestabctest").replace(
        #         StringTag("abc"), StringTag("xyz"), 1
        #     ),
        # )

    def test_startswith(self):
        self.assertTrue(StringTag("test").startswith("te"))
        # self.assertTrue(StringTag("test").startswith(StringTag("te")))
        self.assertFalse(StringTag("test").startswith("st"))
        # self.assertFalse(StringTag("test").startswith(StringTag("st")))

    def test_swapcase(self):
        self.assertStrictEqual(str, "tEsT", StringTag("TeSt").swapcase())

    def test_title(self):
        self.assertStrictEqual(str, "One Two Three", StringTag("one two three").title())

    def test_upper(self):
        self.assertStrictEqual(str, "TEST", StringTag("test").upper())

    def test_zfill(self):
        self.assertStrictEqual(str, "00000test", StringTag("test").zfill(9))


if __name__ == "__main__":
    unittest.main()
