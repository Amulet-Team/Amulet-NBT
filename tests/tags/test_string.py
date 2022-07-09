import unittest
import copy
import pickle
from string import ascii_lowercase, ascii_uppercase, digits

from amulet_nbt import (
    __major__,
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    StringTag,
    from_snbt,
    SNBTParseError,
    utf8_escape_encoder,
    utf8_escape_decoder,
    load as load_nbt,
    NBTFormatError,
)

from tests.tags.abstract_base_tag import TestWrapper


class TestString(TestWrapper.AbstractBaseTagTest):
    def test_constructor(self):
        StringTag("value")
        StringTag(StringTag("value"))

    def test_equal(self):
        self.assertEqual(StringTag("value"), StringTag("value"))
        self.assertNotEqual(StringTag("value"), StringTag("value2"))
        self.assertEqual(StringTag(StringTag("value")), StringTag("value"))
        self.assertEqual(StringTag("value"), StringTag(StringTag("value")))
        if __major__ <= 2:
            self.assertEqual("value", StringTag("value"))
            self.assertEqual(StringTag("value"), "value")

    def test_py_data(self):
        self.assertIsNot(StringTag("value").py_str, str)
        self.assertEqual("value", StringTag("value").py_str)
        self.assertEqual("None", StringTag(None).py_str)

    def test_copy(self):
        tag = StringTag("value")

        tag_copy = copy.copy(tag)
        self.assertIsNot(tag, tag_copy)
        self.assertEqual(tag, tag_copy)
        self.assertEqual(tag.py_str, tag_copy.py_str)

        tag_deepcopy = copy.deepcopy(tag)
        self.assertIsNot(tag, tag_deepcopy)
        self.assertEqual(tag, tag_deepcopy)
        self.assertEqual(tag.py_str, tag_deepcopy.py_str)

    def test_pickle(self):
        tag = StringTag("value")

        tag_pickled = pickle.dumps(tag)
        tag_2 = pickle.loads(tag_pickled)
        self.assertIsNot(tag, tag_2)
        self.assertEqual(tag, tag_2)
        self.assertEqual(tag.py_str, tag_2.py_str)

    def test_instance(self):
        self.assertIsInstance(StringTag(), AbstractBaseTag)
        self.assertIsInstance(StringTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(StringTag(), StringTag)

    def test_hash(self):
        self.assertEqual(hash(StringTag("value")), hash(StringTag("value")))
        self.assertNotEqual(hash(StringTag("value")), hash(StringTag("value2")))

    def test_repr(self):
        self.assertEqual('StringTag("")', repr(StringTag()))
        self.assertEqual('StringTag("value")', repr(StringTag("value")))
        self.assertEqual('StringTag("quote\\"value")', repr(StringTag('quote"value')))
        self.assertEqual('StringTag("quote\'value")', repr(StringTag("quote'value")))

    def test_to_snbt(self):
        self.assertEqual('""', StringTag().to_snbt())
        self.assertEqual('"value"', StringTag("value").to_snbt())
        self.assertEqual('"quote\\"value"', StringTag('quote"value').to_snbt())
        self.assertEqual('"quote\'value"', StringTag("quote'value").to_snbt())

    def test_from_snbt(self):
        self.assertStrictEqual(StringTag(), from_snbt("''"))
        self.assertStrictEqual(StringTag(), from_snbt('""'))

        self.assertStrictEqual(StringTag('a"b'), from_snbt('"a\\"b"'))
        self.assertStrictEqual(StringTag('a"b'), from_snbt("'a\"b'"))

        self.assertStrictEqual(StringTag(ascii_lowercase), from_snbt(ascii_lowercase))
        self.assertStrictEqual(
            StringTag(ascii_lowercase), from_snbt(f"'{ascii_lowercase}'")
        )
        self.assertStrictEqual(
            StringTag(ascii_lowercase), from_snbt(f'"{ascii_lowercase}"')
        )

        self.assertStrictEqual(StringTag(ascii_uppercase), from_snbt(ascii_uppercase))
        self.assertStrictEqual(
            StringTag(ascii_uppercase), from_snbt(f"'{ascii_uppercase}'")
        )
        self.assertStrictEqual(
            StringTag(ascii_uppercase), from_snbt(f'"{ascii_uppercase}"')
        )

        self.assertStrictEqual(StringTag(digits), from_snbt(f"'{digits}'"))
        self.assertStrictEqual(StringTag(digits), from_snbt(f'"{digits}"'))

        self.assertStrictEqual(
            StringTag(digits + ascii_lowercase), from_snbt(digits + ascii_lowercase)
        )
        self.assertStrictEqual(
            StringTag(digits + ascii_lowercase),
            from_snbt(f"'{digits + ascii_lowercase}'"),
        )
        self.assertStrictEqual(
            StringTag(digits + ascii_lowercase),
            from_snbt(f'"{digits + ascii_lowercase}"'),
        )

        self.assertStrictEqual(
            StringTag(ascii_lowercase + digits), from_snbt(ascii_lowercase + digits)
        )
        self.assertStrictEqual(
            StringTag(ascii_lowercase + digits),
            from_snbt(f"'{ascii_lowercase + digits}'"),
        )
        self.assertStrictEqual(
            StringTag(ascii_lowercase + digits),
            from_snbt(f'"{ascii_lowercase + digits}"'),
        )

        self.assertStrictEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(ascii_uppercase + ascii_lowercase + digits + "._+-"),
        )
        self.assertStrictEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(f"'{ascii_uppercase + ascii_lowercase + digits + '._+-'}'"),
        )
        self.assertStrictEqual(
            StringTag(ascii_uppercase + ascii_lowercase + digits + "._+-"),
            from_snbt(f'"{ascii_uppercase + ascii_lowercase + digits + "._+-"}"'),
        )

        with self.assertRaises(SNBTParseError):
            from_snbt("")

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
            b"\x08\x00\x00\x00\x06\xed\xa1\xbc\xed\xbf\xb9",
            StringTag("🏹").to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xf0\x9f\x8f\xb9",
            StringTag("🏹").to_nbt(
                compressed=False, little_endian=True, string_encoder=utf8_escape_encoder
            ),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
            StringTag("␛xff␛xfe␛xfd␛xfc").to_nbt(
                compressed=False, little_endian=True, string_encoder=utf8_escape_encoder
            ),
        )
        self.assertEqual(
            b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
            StringTag("␛xFF␛xFE␛xFD␛xFC").to_nbt(
                compressed=False, little_endian=True, string_encoder=utf8_escape_encoder
            ),
        )

    def test_from_nbt(self):
        self.assertStrictEqual(
            StringTag(),
            load_nbt(
                b"\x08\x00\x00\x00\x00", compressed=False, little_endian=False
            ).string,
        )
        self.assertStrictEqual(
            StringTag(),
            load_nbt(
                b"\x08\x00\x00\x00\x00", compressed=False, little_endian=True
            ).string,
        )
        self.assertStrictEqual(
            StringTag("test"),
            load_nbt(
                b"\x08\x00\x00\x00\x04test", compressed=False, little_endian=False
            ).string,
        )
        self.assertStrictEqual(
            StringTag("test"),
            load_nbt(
                b"\x08\x00\x00\x04\x00test", compressed=False, little_endian=True
            ).string,
        )
        self.assertStrictEqual(
            StringTag("🏹"),
            load_nbt(
                b"\x08\x00\x00\x00\x06\xed\xa1\xbc\xed\xbf\xb9",
                compressed=False,
                little_endian=False,
            ).string,
        )
        self.assertStrictEqual(
            StringTag("🏹"),
            load_nbt(
                b"\x08\x00\x00\x04\x00\xf0\x9f\x8f\xb9",
                compressed=False,
                little_endian=True,
                string_decoder=utf8_escape_decoder,
            ).string,
        )
        # test invalid utf-8 string
        self.assertStrictEqual(
            StringTag("␛xff␛xfe␛xfd␛xfc"),
            load_nbt(
                b"\x08\x00\x00\x04\x00\xff\xfe\xfd\xfc",
                compressed=False,
                little_endian=True,
                string_decoder=utf8_escape_decoder,
            ).string,
        )

        with self.assertRaises(NBTFormatError):
            load_nbt(b"\x08\x00\x00\x00\x05abcd")

    def test_comp(self):
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


if __name__ == "__main__":
    unittest.main()
