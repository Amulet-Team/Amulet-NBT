import unittest
from string import ascii_lowercase, ascii_uppercase, digits

from tests.binary_data import binary_data_tuple
import amulet_nbt
from amulet_nbt import (
    BaseTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
    SNBTParseError,
)


class SNBTTests(unittest.TestCase):
    def test_write(self):
        for data in binary_data_tuple:
            self.assertEqual(
                data.nbt_file.value.to_snbt(), data.snbt, msg=str(data.nbt_file)
            )

    def _is_same(self, ground: BaseTag, *test: str):
        for snbt in test:
            nbt = amulet_nbt.from_snbt(snbt)
            self.assertTrue(ground.strict_equals(nbt), msg=f"{repr(ground)} != {snbt}")
        self.assertEqual(ground.to_snbt(), test[0])

    def test_byte(self):
        self._is_same(TAG_Byte(0), "0b", "0B", "false", "False")
        self._is_same(TAG_Byte(1), "1b", "1B", "true", "True")
        self._is_same(TAG_Byte(5), "5b", "5B")
        self._is_same(TAG_Byte(-5), "-5b", "-5B")

    def test_short(self):
        self._is_same(TAG_Short(5), "5s", "5S")
        self._is_same(TAG_Short(-5), "-5s", "-5S")

    def test_int(self):
        self._is_same(TAG_Int(5), "5", "5")
        self._is_same(TAG_Int(-5), "-5", "-5")

    def test_long(self):
        self._is_same(TAG_Long(5), "5L", "5l")
        self._is_same(TAG_Long(-5), "-5L", "-5l")

    def test_float(self):
        self._is_same(TAG_Float(5), "5.0f", "5.0F", "5f", "5F", "5.f", "5.F")
        self._is_same(TAG_Float(-5), "-5.0f", "-5.0F", "-5f", "-5F", "-5.f", "-5.F")

    def test_double(self):
        self._is_same(TAG_Double(5), "5.0d", "5.0D", "5.0", "5d", "5D", "5.d", "5.D")
        self._is_same(
            TAG_Double(-5), "-5.0d", "-5.0D", "-5.0", "-5d", "-5D", "-5.d", "-5.D"
        )

    def test_string(self):
        self._is_same(
            TAG_String(""),
            '""',
            "''",
        )
        self._is_same(
            TAG_String(ascii_lowercase),
            f'"{ascii_lowercase}"',
            f"'{ascii_lowercase}'",
            ascii_lowercase,
        )
        self._is_same(
            TAG_String(ascii_uppercase),
            f'"{ascii_uppercase}"',
            f"'{ascii_uppercase}'",
            ascii_uppercase,
        )
        self._is_same(TAG_String(digits), f'"{digits}"', f"'{digits}'")
        self._is_same(
            TAG_String(digits + ascii_lowercase),
            f'"{digits + ascii_lowercase}"',
            f"'{digits + ascii_lowercase}'",
            digits + ascii_lowercase,
        )
        self._is_same(
            TAG_String(ascii_lowercase + digits),
            f'"{ascii_lowercase + digits}"',
            f"'{ascii_lowercase + digits}'",
            ascii_lowercase + digits,
        )
        self._is_same(
            TAG_String(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            f'"{ascii_uppercase + ascii_lowercase + digits + "._+-"}"',
            f"'{ascii_uppercase + ascii_lowercase + digits + '._+-'}'",
            ascii_uppercase + ascii_lowercase + digits + "._+-",
        )
        self._is_same(
            TAG_String('a"b'),
            '"a\\"b"',
            "'a\"b'",
        )

    def test_byte_array(self):
        self._is_same(
            TAG_Byte_Array(),
            "[B;]",
        )
        self._is_same(
            TAG_Byte_Array([-5, 5]),
            "[B;-5B, 5B]",
            "[B;-5b, 5b]",
        )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt(
                "[B;-5, 5]",
            )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt(
                "[B;-5.0B, 5.0B]",
            )

    def test_int_array(self):
        self._is_same(
            TAG_Int_Array(),
            "[I;]",
        )
        self._is_same(
            TAG_Int_Array([-5, 5]),
            "[I;-5, 5]",
        )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt(
                "[I;-5.0, 5.0]",
            )

    def test_long_array(self):
        self._is_same(
            TAG_Long_Array(),
            "[L;]",
        )
        self._is_same(
            TAG_Long_Array([-5, 5]),
            "[L;-5L, 5L]",
            "[L;-5l, 5l]",
        )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt(
                "[L;-5, 5]",
            )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt(
                "[L;-5.0L, 5.0L]",
            )

    def test_list(self):
        self._is_same(TAG_List(), "[]")
        self._is_same(TAG_List([TAG_Int(5)]), "[5]", "[5,]", "[  5  ]" "[  5  ,  ]")
        self._is_same(
            TAG_List([TAG_Int(5), TAG_Int(-5)]),
            "[5, -5]",
            "[5, -5, ]",
            "[5,-5]",
            "[5,-5,]",
            "[  5  ,  -5  ]" "[  5  ,  -5  ,  ]",
        )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("[")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("]")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("[,]")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("[,1]")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("[1 1]")

    def test_compound(self):
        self._is_same(TAG_Compound(), "{}")
        self._is_same(
            TAG_Compound({"1": TAG_Int(5)}),
            "{1: 5}",
            '{"1": 5}',
            "{'1': 5}",
            "{  '1'  :  5  }",
        )
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("{")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("}")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("{a:}")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("{a 5}")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("{a:5, b:}")
        with self.assertRaises(SNBTParseError):
            amulet_nbt.from_snbt("{a:5 b:6}")


if __name__ == "__main__":
    unittest.main()
