import copy
import pickle
import unittest
import faulthandler
from string import ascii_lowercase, ascii_uppercase, digits

faulthandler.enable()

from .test_abc import AbstractBaseImmutableTagTestCase

from amulet_nbt import (
    StringTag,
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    utf8_escape_encoding,
    load as load_nbt,
    NBTFormatError,
    from_snbt,
    SNBTParseError,
)


class StringTagTestCase(AbstractBaseImmutableTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        StringTag("value")
        StringTag(StringTag("value"))
        StringTag(b"\xFF")

    def test_equal(self) -> None:
        self.assertEqual(StringTag("value"), StringTag("value"))
        self.assertNotEqual(StringTag("value"), StringTag("value2"))
        self.assertEqual(StringTag(StringTag("value")), StringTag("value"))
        self.assertEqual(StringTag("value"), StringTag(StringTag("value")))

    def test_py_data(self) -> None:
        self.assertIsInstance(StringTag("value").py_str, str)
        self.assertIsInstance(StringTag("value").py_bytes, bytes)
        self.assertEqual("value", StringTag("value").py_str)
        self.assertEqual("None", StringTag(None).py_str)

        with self.assertRaises(UnicodeDecodeError):
            StringTag(b"\xFF").py_str

        self.assertEqual(b"value", StringTag("value").py_bytes)

    def test_repr(self) -> None:
        self.assertEqual('StringTag("")', repr(StringTag()))
        self.assertEqual('StringTag("value")', repr(StringTag("value")))
        self.assertEqual('StringTag("quote\\"value")', repr(StringTag('quote"value')))
        self.assertEqual('StringTag("quote\'value")', repr(StringTag("quote'value")))

    def test_str(self) -> None:
        self.assertEqual("hello world", str(StringTag("hello world")))

    def test_pickle(self) -> None:
        tag = StringTag("value")

        tag_pickled = pickle.dumps(tag)
        tag_2 = pickle.loads(tag_pickled)
        self.assertIsNot(tag, tag_2)
        self.assertEqual(tag, tag_2)
        self.assertEqual(tag.py_str, tag_2.py_str)

    def test_copy(self) -> None:
        tag = StringTag("value")

        tag_copy = copy.copy(tag)
        self.assertIsNot(tag, tag_copy)
        self.assertEqual(tag, tag_copy)
        self.assertEqual(tag.py_str, tag_copy.py_str)

    def test_deepcopy(self) -> None:
        tag = StringTag("value")

        tag_deepcopy = copy.deepcopy(tag)
        self.assertIsNot(tag, tag_deepcopy)
        self.assertEqual(tag, tag_deepcopy)
        self.assertEqual(tag.py_str, tag_deepcopy.py_str)

    def test_hash(self) -> None:
        self.assertEqual(hash(StringTag("value")), hash(StringTag("value")))
        self.assertNotEqual(hash(StringTag("value")), hash(StringTag("value2")))

    def test_instance(self) -> None:
        self.assertIsInstance(StringTag(), AbstractBaseTag)
        self.assertIsInstance(StringTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(StringTag(), StringTag)

    def test_comp(self) -> None:
        self.assertFalse(StringTag("val1") < StringTag("val0"))
        self.assertFalse(StringTag("val1") < StringTag("val1"))
        self.assertTrue(StringTag("val1") < StringTag("val2"))

        self.assertFalse(StringTag("val1") <= StringTag("val0"))
        self.assertTrue(StringTag("val1") <= StringTag("val1"))
        self.assertTrue(StringTag("val1") <= StringTag("val2"))

        self.assertTrue(StringTag("val1") > StringTag("val0"))
        self.assertFalse(StringTag("val1") > StringTag("val1"))
        self.assertFalse(StringTag("val1") > StringTag("val2"))

        self.assertTrue(StringTag("val1") >= StringTag("val0"))
        self.assertTrue(StringTag("val1") >= StringTag("val1"))
        self.assertFalse(StringTag("val1") >= StringTag("val2"))

    def test_to_nbt(self):
        self.assertEqual(
            b"\x08\x00\x00\x00\x00",
            StringTag().to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x08\x00\x00\x00\x00",
            StringTag().to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x08\x00\x00\x00\x04test",
            StringTag("test").to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00test",
            StringTag("test").to_nbt(compressed=False, little_endian=True),
        )
        # default string encoder is the Java Modified UTF-8 encoder
        self.assertEqual(
            b"\x08\x00\x00\x00\x06\xed\xa0\xbc\xed\xbf\xb9",
            StringTag("🏹").to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xf0\x9f\x8f\xb9",
            StringTag("🏹").to_nbt(
                compressed=False,
                little_endian=True,
                string_encoding=utf8_escape_encoding,
            ),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
            StringTag("␛xff␛xfe␛xfd␛xfc").to_nbt(
                compressed=False,
                little_endian=True,
                string_encoding=utf8_escape_encoding,
            ),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
            StringTag("␛xFF␛xFE␛xFD␛xFC").to_nbt(
                compressed=False,
                little_endian=True,
                string_encoding=utf8_escape_encoding,
            ),
        )

        # Test writing long strings
        self.assertEqual(
            b"\x08\x00\x00\xff\xff" + b"a" * 65535,
            StringTag("a" * 65535).to_nbt(compressed=False),
        )

        with self.assertRaises(OverflowError):
            StringTag("a" * 65536).to_nbt(compressed=False)

    def test_from_nbt(self):
        self.assertEqual(
            StringTag(),
            load_nbt(
                b"\x08\x00\x00\x00\x00", compressed=False, little_endian=False
            ).string,
        )
        self.assertEqual(
            StringTag(),
            load_nbt(
                b"\x08\x00\x00\x00\x00", compressed=False, little_endian=True
            ).string,
        )
        self.assertEqual(
            StringTag("test"),
            load_nbt(
                b"\x08\x00\x00\x00\x04test", compressed=False, little_endian=False
            ).string,
        )
        self.assertEqual(
            StringTag("test"),
            load_nbt(
                b"\x08\x00\x00\x04\x00test", compressed=False, little_endian=True
            ).string,
        )
        self.assertEqual(
            StringTag("🏹"),
            load_nbt(
                b"\x08\x00\x00\x00\x06\xed\xa0\xbc\xed\xbf\xb9",
                compressed=False,
                little_endian=False,
            ).string,
        )
        self.assertEqual(
            StringTag("🏹"),
            load_nbt(
                b"\x08\x00\x00\x04\x00\xf0\x9f\x8f\xb9",
                compressed=False,
                little_endian=True,
                string_encoding=utf8_escape_encoding,
            ).string,
        )
        # test invalid utf-8 string
        self.assertEqual(
            StringTag("␛xff␛xfe␛xfd␛xfc"),
            load_nbt(
                b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
                compressed=False,
                little_endian=True,
                string_encoding=utf8_escape_encoding,
            ).string,
        )

        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x08\x00\x00\x00\x05abcd")

    def test_to_snbt(self):
        self.assertEqual('""', StringTag().to_snbt())
        self.assertEqual('"value"', StringTag("value").to_snbt())
        self.assertEqual('"quote\\"value"', StringTag('quote"value').to_snbt())
        self.assertEqual('"quote\'value"', StringTag("quote'value").to_snbt())

    def test_from_snbt(self):
        self.assertEqual(StringTag(), from_snbt("''"))
        self.assertEqual(StringTag(), from_snbt('""'))

        self.assertEqual(StringTag('a"b'), from_snbt('"a\\"b"'))
        self.assertEqual(StringTag('a"b'), from_snbt("'a\"b'"))

        self.assertEqual(StringTag(ascii_lowercase), from_snbt(ascii_lowercase))
        self.assertEqual(StringTag(ascii_lowercase), from_snbt(f"'{ascii_lowercase}'"))
        self.assertEqual(StringTag(ascii_lowercase), from_snbt(f'"{ascii_lowercase}"'))

        self.assertEqual(StringTag(ascii_uppercase), from_snbt(ascii_uppercase))
        self.assertEqual(StringTag(ascii_uppercase), from_snbt(f"'{ascii_uppercase}'"))
        self.assertEqual(StringTag(ascii_uppercase), from_snbt(f'"{ascii_uppercase}"'))

        self.assertEqual(StringTag(digits), from_snbt(f"'{digits}'"))
        self.assertEqual(StringTag(digits), from_snbt(f'"{digits}"'))

        self.assertEqual(
            StringTag(digits + ascii_lowercase), from_snbt(digits + ascii_lowercase)
        )
        self.assertEqual(
            StringTag(digits + ascii_lowercase),
            from_snbt(f"'{digits + ascii_lowercase}'"),
        )
        self.assertEqual(
            StringTag(digits + ascii_lowercase),
            from_snbt(f'"{digits + ascii_lowercase}"'),
        )

        self.assertEqual(
            StringTag(ascii_lowercase + digits), from_snbt(ascii_lowercase + digits)
        )
        self.assertEqual(
            StringTag(ascii_lowercase + digits),
            from_snbt(f"'{ascii_lowercase + digits}'"),
        )
        self.assertEqual(
            StringTag(ascii_lowercase + digits),
            from_snbt(f'"{ascii_lowercase + digits}"'),
        )

        self.assertEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(ascii_uppercase + ascii_lowercase + digits + "._+-"),
        )
        self.assertEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(f"'{ascii_uppercase + ascii_lowercase + digits + '._+-'}'"),
        )
        self.assertEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(f'"{ascii_uppercase + ascii_lowercase + digits + "._+-"}"'),
        )

        with self.assertRaises(SNBTParseError):
            from_snbt("")


if __name__ == "__main__":
    unittest.main()
