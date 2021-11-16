from typing import Union
import unittest
from tests import base_type_test
import operator

from amulet_nbt import (
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_String,
)

AnyStr = Union[str, TAG_String]


class TestString(base_type_test.BaseTypeTest):
    values = ("", "test", "value", "value" * 500)
    num_values = (-5, 0, 1, 5)
    this_types = (TAG_String,)

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
        for dtype1 in (str, TAG_String):
            for dtype2 in (str, TAG_String):
                # add
                self._test_op2(
                    dtype1("val1"), dtype2("val2"), operator.add, str, "val1val2"
                )
                # iadd
                self._test_op2(
                    dtype1("val1"), dtype2("val2"), operator.iadd, dtype1, "val1val2"
                )

    def test_contains(self):
        self.assertIn("test", TAG_String("hitesthi"))

    def test_eq(self):
        for dtype1 in (str, TAG_String):
            for dtype2 in (str, TAG_String):
                self.assertEqual(dtype1("val1"), dtype2("val1"))
                self.assertNotEqual(dtype1("val1"), dtype2("Val1"))
                self.assertNotEqual(dtype1("val1"), dtype2("val2"))

    def test_comp(self):
        for dtype1 in (str, TAG_String):
            for dtype2 in (str, TAG_String):
                self.assertLess(dtype1("val1"), dtype2("val2"))
                self.assertLessEqual(dtype1("val1"), dtype2("val2"))
                self.assertLessEqual(dtype1("val1"), dtype2("val1"))

                self.assertGreater(dtype1("val2"), dtype2("val1"))
                self.assertGreaterEqual(dtype1("val2"), dtype2("val1"))
                self.assertGreaterEqual(dtype1("val1"), dtype2("val1"))

    def test_getitem(self):
        self.assertEqual("e", TAG_String("test")[1])
        self.assertEqual("es", TAG_String("test")[1:3])

    def test_iter(self):
        it = iter(TAG_String("test"))
        self.assertEqual("t", next(it))
        self.assertEqual("e", next(it))
        self.assertEqual("s", next(it))
        self.assertEqual("t", next(it))
        with self.assertRaises(StopIteration):
            next(it)

    def test_len(self):
        self.assertEqual(4, len(TAG_String("test")))

    def test_mul(self):
        for num_cls in (int, TAG_Byte, TAG_Short, TAG_Int, TAG_Long):
            for num_val in self.num_values:
                self._test_op2(
                    num_cls(num_val),
                    TAG_String("val1"),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    TAG_String("val1"),
                    num_cls(num_val),
                    operator.mul,
                    str,
                    "val1" * num_val,
                )

                self._test_op2(
                    num_cls(num_val),
                    TAG_String("val1"),
                    operator.imul,
                    str,
                    "val1" * num_val,
                )
                self._test_op2(
                    TAG_String("val1"),
                    num_cls(num_val),
                    operator.imul,
                    TAG_String,
                    "val1" * num_val,
                )

    def test_str(self):
        self.assertStrictEqual(str, "test", str(TAG_String("test")))

    def test_capitalize(self):
        self.assertStrictEqual(
            str, "Test sentence", TAG_String("test sentence").capitalize()
        )

    def test_casefold(self):
        self.assertStrictEqual(str, "tesst", TAG_String("TEßT").casefold())

    def test_center(self):
        self.assertStrictEqual(str, "___test__", TAG_String("test").center(9, "_"))
        # self.assertStrictEqual(
        #     str, "___test__", TAG_String("test").center(9, TAG_String("_"))
        # )
        self.assertStrictEqual(str, "   test  ", TAG_String("test").center(9))

    def test_count(self):
        self.assertStrictEqual(int, 5, TAG_String("test" * 5).count("test"))
        # self.assertStrictEqual(int, 5, TAG_String("test" * 5).count(TAG_String("test")))

    def test_encode(self):
        self.assertStrictEqual(bytes, b"test", TAG_String("test").encode("utf-8"))

    def test_endswith(self):
        self.assertTrue(TAG_String("test").endswith("st"))
        # self.assertTrue(TAG_String("test").endswith(TAG_String("st")))
        self.assertFalse(TAG_String("test").endswith("te"))
        # self.assertFalse(TAG_String("test").endswith(TAG_String("te")))

    def test_expandtabs(self):
        self.assertStrictEqual(
            str, "    t   e   s   t", TAG_String("\tt\te\ts\tt").expandtabs(4)
        )

    def test_find(self):
        self.assertStrictEqual(int, 4, TAG_String("val1val2val3val2val4").find("val2"))
        # self.assertStrictEqual(
        #     int, 4, TAG_String("val1val2val3val2val4").find(TAG_String("val2"))
        # )
        self.assertStrictEqual(int, -1, TAG_String("val1val2val3val2val4").find("val5"))
        # self.assertStrictEqual(
        #     int, -1, TAG_String("val1val2val3val2val4").find(TAG_String("val5"))
        # )

    def test_rfind(self):
        self.assertStrictEqual(
            int, 12, TAG_String("val1val2val3val2val4").rfind("val2")
        )
        # self.assertStrictEqual(
        #     int, 12, TAG_String("val1val2val3val2val4").rfind(TAG_String("val2"))
        # )
        self.assertStrictEqual(
            int, -1, TAG_String("val1val2val3val2val4").rfind("val5")
        )
        # self.assertStrictEqual(
        #     int, -1, TAG_String("val1val2val3val2val4").rfind(TAG_String("val5"))
        # )

    def test_index(self):
        self.assertStrictEqual(int, 4, TAG_String("val1val2val3val2val4").index("val2"))
        # self.assertStrictEqual(
        #     int, 4, TAG_String("val1val2val3val2val4").index(TAG_String("val2"))
        # )
        with self.assertRaises(ValueError):
            TAG_String("val1val2val3val2val4").index("val5")
        # with self.assertRaises(ValueError):
        #     TAG_String("val1val2val3val2val4").index(TAG_String("val5"))

    def test_rindex(self):
        self.assertStrictEqual(
            int, 12, TAG_String("val1val2val3val2val4").rindex("val2")
        )
        # self.assertStrictEqual(
        #     int, 12, TAG_String("val1val2val3val2val4").rindex(TAG_String("val2"))
        # )
        with self.assertRaises(ValueError):
            TAG_String("val1val2val3val2val4").rindex("val5")
        # with self.assertRaises(ValueError):
        #     TAG_String("val1val2val3val2val4").rindex(TAG_String("val5"))

    def test_format(self):
        for dtype1 in (str, TAG_String):
            for dtype2 in (str, TAG_String):
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
        self.assertFalse(TAG_String("").isalnum())
        self.assertTrue(TAG_String("test1").isalnum())
        self.assertFalse(TAG_String("test1-").isalnum())

    def test_isalpha(self):
        self.assertFalse(TAG_String("").isalpha())
        self.assertTrue(TAG_String("test").isalpha())
        self.assertFalse(TAG_String("test1").isalpha())

    def test_isascii(self):
        self.assertTrue(TAG_String("").isascii())
        self.assertTrue(TAG_String("test123").isascii())
        self.assertFalse(TAG_String("test123💩").isascii())

    def test_int(self):
        self.assertStrictEqual(int, 50, int(TAG_String("50")))
        self.assertStrictEqual(int, 50, int(TAG_String("٥٠")))  # arabic for 50

        with self.assertRaises(ValueError):
            int(TAG_String("test"))

    def test_isdecimal(self):
        self.assertFalse(TAG_String("").isdecimal())
        self.assertTrue(TAG_String("123456789").isdecimal())
        self.assertFalse(TAG_String("test").isdecimal())

    def test_isdigit(self):
        self.assertFalse(TAG_String("").isdigit())
        self.assertTrue(TAG_String("123456789⁰¹²³⁴⁵⁶⁷⁸⁹").isdigit())
        self.assertFalse(TAG_String("test").isdigit())

    def test_isnumeric(self):
        self.assertFalse(TAG_String("").isnumeric())
        self.assertTrue(TAG_String("123456789⁰¹²³⁴⁵⁶⁷⁸⁹ⅠⅡⅢⅣⅤ").isnumeric())
        self.assertFalse(TAG_String("test").isnumeric())

    def test_is_x(self):
        for i in range(0x110000):
            c = chr(i)
            try:
                int(c)
            except:
                pass
            else:
                self.assertEqual(int(c), int(TAG_String(c)))
            self.assertEqual(c.isdecimal(), TAG_String(c).isdecimal())
            self.assertEqual(c.isdigit(), TAG_String(c).isdigit())
            self.assertEqual(c.isdigit(), TAG_String(c).isdigit())
            self.assertEqual(c.isprintable(), TAG_String(c).isprintable())

    def test_isidentifier(self):
        self.assertTrue(TAG_String("test").isidentifier())
        self.assertTrue(TAG_String("test1").isidentifier())
        self.assertTrue(TAG_String("test_test").isidentifier())
        self.assertFalse(TAG_String("1test").isidentifier())

    def test_islower(self):
        self.assertTrue(TAG_String("test").islower())
        self.assertFalse(TAG_String("TEST").islower())

    def test_isupper(self):
        self.assertFalse(TAG_String("test").isupper())
        self.assertTrue(TAG_String("TEST").isupper())

    def test_isspace(self):
        self.assertTrue(TAG_String(" \t\r\n").isspace())
        self.assertFalse(TAG_String("TEST").isspace())

    def test_istitle(self):
        self.assertTrue(TAG_String("Test").istitle())
        self.assertFalse(TAG_String("test").istitle())
        self.assertFalse(TAG_String("TEST").istitle())

    def test_join(self):
        self.assertStrictEqual(str, "a,b", TAG_String(",").join(["a", "b"]))
        self.assertStrictEqual(
            str, "a,b", TAG_String(",").join([TAG_String("a"), TAG_String("b")])
        )

    def test_ljust(self):
        self.assertEqual("test   ", TAG_String("test").ljust(7))
        self.assertEqual("test___", TAG_String("test").ljust(7, "_"))
        # self.assertEqual("test___", TAG_String("test").ljust(7, TAG_String("_")))

    def test_rjust(self):
        self.assertEqual("   test", TAG_String("test").rjust(7))
        self.assertEqual("___test", TAG_String("test").rjust(7, "_"))
        # self.assertEqual("___test", TAG_String("test").rjust(7, TAG_String("_")))

    def test_lower(self):
        self.assertStrictEqual(str, "test", TAG_String("TEST").lower())

    def test_lstrip(self):
        self.assertStrictEqual(
            str, "test \t\r\n", TAG_String(" \t\r\ntest \t\r\n").lstrip()
        )
        self.assertStrictEqual(str, "test__", TAG_String("__test__").lstrip("_"))
        # self.assertStrictEqual(
        #     str, "test__", TAG_String("__test__").lstrip(TAG_String("_"))
        # )

    def test_rstrip(self):
        self.assertStrictEqual(
            str, " \t\r\ntest", TAG_String(" \t\r\ntest \t\r\n").rstrip()
        )
        self.assertStrictEqual(str, "__test", TAG_String("__test__").rstrip("_"))
        # self.assertStrictEqual(
        #     str, "__test", TAG_String("__test__").rstrip(TAG_String("_"))
        # )

    def test_strip(self):
        self.assertStrictEqual(str, "test", TAG_String(" \t\r\ntest \t\r\n").strip())
        self.assertStrictEqual(str, "test", TAG_String("__test__").strip("_"))
        # self.assertStrictEqual(
        #     str, "test", TAG_String("__test__").strip(TAG_String("_"))
        # )

    def test_translate(self):
        t = TAG_String.maketrans("abc", "xyz")
        self.assertStrictEqual(
            str, "testxyztest", TAG_String("testabctest").translate(t)
        )
        t = TAG_String.maketrans({"a": "x", "b": "y", "c": "z"})
        self.assertStrictEqual(
            str, "testxyztest", TAG_String("testabctest").translate(t)
        )

    def test_partition(self):
        a, b, c = TAG_String("testabctestabctest").partition("abc")
        self.assertStrictEqual(str, "test", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "testabctest", c)
        a, b, c = TAG_String("testabctestabctest").partition(TAG_String("abc"))
        self.assertStrictEqual(str, "test", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "testabctest", c)

    def test_rpartition(self):
        a, b, c = TAG_String("testabctestabctest").rpartition("abc")
        self.assertStrictEqual(str, "testabctest", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "test", c)
        a, b, c = TAG_String("testabctestabctest").rpartition(TAG_String("abc"))
        self.assertStrictEqual(str, "testabctest", a)
        self.assertStrictEqual(str, "abc", b)
        self.assertStrictEqual(str, "test", c)

    def test_split(self):
        self.assertStrictEqual(
            list,
            ["test", "test", "test"],
            TAG_String("testabctestabctest").split("abc"),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "test", "test"],
        #     TAG_String("testabctestabctest").split(TAG_String("abc")),
        # )
        self.assertStrictEqual(
            list,
            ["test", "testabctest"],
            TAG_String("testabctestabctest").split("abc", 1),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "testabctest"],
        #     TAG_String("testabctestabctest").split(TAG_String("abc"), 1),
        # )

    def test_rsplit(self):
        self.assertStrictEqual(
            list,
            ["test", "test", "test"],
            TAG_String("testabctestabctest").rsplit("abc"),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["test", "test", "test"],
        #     TAG_String("testabctestabctest").rsplit(TAG_String("abc")),
        # )
        self.assertStrictEqual(
            list,
            ["testabctest", "test"],
            TAG_String("testabctestabctest").rsplit("abc", 1),
        )
        # self.assertStrictEqual(
        #     list,
        #     ["testabctest", "test"],
        #     TAG_String("testabctestabctest").rsplit(TAG_String("abc"), 1),
        # )

    def test_splitlines(self):
        self.assertStrictEqual(
            list,
            ["ab c", "", "de fg", "kl"],
            TAG_String("ab c\n\nde fg\rkl\r\n").splitlines(),
        )
        self.assertStrictEqual(
            list,
            ["ab c\n", "\n", "de fg\r", "kl\r\n"],
            TAG_String("ab c\n\nde fg\rkl\r\n").splitlines(keepends=True),
        )

    def test_removeprefix(self):
        self.assertStrictEqual(str, "Hook", TAG_String("TestHook").removeprefix("Test"))
        # self.assertStrictEqual(
        #     str, "Hook", TAG_String("TestHook").removeprefix(TAG_String("Test"))
        # )
        self.assertStrictEqual(
            str,
            "BaseTestCase",
            TAG_String("BaseTestCase").removeprefix("Test"),
        )
        # self.assertStrictEqual(
        #     str,
        #     "BaseTestCase",
        #     TAG_String("BaseTestCase").removeprefix(TAG_String("Test")),
        # )

    def test_removesuffix(self):
        self.assertStrictEqual(str, "Test", TAG_String("TestHook").removesuffix("Hook"))
        # self.assertStrictEqual(
        #     str, "Test", TAG_String("TestHook").removesuffix(TAG_String("Test"))
        # )
        self.assertStrictEqual(
            str, "BaseTestCase", TAG_String("BaseTestCase").removesuffix("Test")
        )
        # self.assertStrictEqual(
        #     str,
        #     "BaseTestCase",
        #     TAG_String("BaseTestCase").removesuffix(TAG_String("Test")),
        # )

    def test_replace(self):
        self.assertStrictEqual(
            str,
            "testxyztestxyztest",
            TAG_String("testabctestabctest").replace("abc", "xyz"),
        )
        # self.assertStrictEqual(
        #     str,
        #     "testxyztestxyztest",
        #     TAG_String("testabctestabctest").replace(
        #         TAG_String("abc"), TAG_String("xyz")
        #     ),
        # )
        self.assertStrictEqual(
            str,
            "testxyztestabctest",
            TAG_String("testabctestabctest").replace("abc", "xyz", 1),
        )
        # self.assertStrictEqual(
        #     str,
        #     "testxyztestabctest",
        #     TAG_String("testabctestabctest").replace(
        #         TAG_String("abc"), TAG_String("xyz"), 1
        #     ),
        # )

    def test_startswith(self):
        self.assertTrue(TAG_String("test").startswith("te"))
        # self.assertTrue(TAG_String("test").startswith(TAG_String("te")))
        self.assertFalse(TAG_String("test").startswith("st"))
        # self.assertFalse(TAG_String("test").startswith(TAG_String("st")))

    def test_swapcase(self):
        self.assertStrictEqual(str, "tEsT", TAG_String("TeSt").swapcase())

    def test_title(self):
        self.assertStrictEqual(
            str, "One Two Three", TAG_String("one two three").title()
        )

    def test_upper(self):
        self.assertStrictEqual(str, "TEST", TAG_String("test").upper())

    def test_zfill(self):
        self.assertStrictEqual(str, "00000test", TAG_String("test").zfill(9))


if __name__ == "__main__":
    unittest.main()
