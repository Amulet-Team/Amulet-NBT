import unittest
import itertools
import copy
import pickle
from typing import List, Tuple

from amulet_nbt import (
    __major__,
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    AbstractBaseNumericTag,
    AbstractBaseFloatTag,
    FloatTag,
    DoubleTag,
    StringTag,
    from_snbt,
    load as load_nbt,
)

from tests.tags.abstract_base_tag import TestWrapper


class TestFloat(TestWrapper.AbstractBaseTagTest):
    def test_constructor(self):
        for float_cls in self.float_types:
            with self.subTest(float_cls=float_cls):
                float_cls()
                float_cls(5)
                float_cls(-5)
                float_cls(5.0)
                float_cls(-5.0)
                with self.assertRaises(TypeError):
                    float_cls(None)

        for cls in self.nbt_types:
            tag = cls()
            try:
                float(tag)
            except:
                pass
            else:
                for float_cls in self.float_types:
                    with self.subTest(cls=cls, float_cls=float_cls):
                        float_cls(tag)

        for obj in self.not_nbt:
            try:
                float(obj)
            except:
                pass
            else:
                for float_cls in self.float_types:
                    with self.subTest(obj=obj, float_cls=float_cls):
                        float_cls(obj)

    def test_equal(self):
        for cls1 in self.float_types:
            for cls2 in self.float_types:
                with self.subTest(cls1=cls1, cls2=cls2):
                    if cls1 is cls2 or __major__ <= 2:
                        self.assertEqual(cls1(), cls2())
                        self.assertEqual(cls1(), cls2(0))
                        self.assertNotEqual(cls1(5), cls2(10))
                    else:
                        self.assertNotEqual(cls1(), cls2())
                        self.assertNotEqual(cls1(), cls2(0))

            if __major__ <= 2:
                self.assertEqual(cls1(), 0)
                self.assertEqual(0, cls1())
            else:
                self.assertNotEqual(cls1(), 0)
                self.assertNotEqual(0, cls1())

    def test_py_data(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(cls().py_float, float)
                self.assertEqual(cls().py_float, 0.0)
                self.assertEqual(cls(5).py_float, 5.0)
                self.assertEqual(cls(5.5).py_float, 5.5)

    def test_copy(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_copy = copy.copy(tag)
                self.assertIsNot(tag, tag_copy)
                self.assertEqual(tag, tag_copy)
                self.assertEqual(tag.py_float, tag_copy.py_float)

                tag_deepcopy = copy.deepcopy(tag)
                self.assertIsNot(tag_deepcopy, tag_copy)
                self.assertEqual(tag_deepcopy, tag_copy)
                self.assertEqual(tag_deepcopy.py_float, tag_copy.py_float)

    def test_pickle(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_pickled = pickle.dumps(tag)
                tag_2 = pickle.loads(tag_pickled)
                self.assertIsNot(tag, tag_2)
                self.assertEqual(tag, tag_2)
                self.assertEqual(tag.py_float, tag_2.py_float)

    def test_instance(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()
                self.assertIsInstance(tag, AbstractBaseTag)
                self.assertIsInstance(tag, AbstractBaseImmutableTag)
                self.assertIsInstance(tag, AbstractBaseNumericTag)
                self.assertIsInstance(tag, AbstractBaseFloatTag)
                self.assertIsInstance(tag, cls)

    def test_hash(self):
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(hash(cls1()), hash(cls2()))
                else:
                    self.assertNotEqual(hash(cls1()), hash(cls2()))

    def test_repr(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertEqual(f"{cls.__name__}(0.0)", repr(cls()))
                self.assertEqual(f"{cls.__name__}(5.5)", repr(cls(5.5)))
                self.assertEqual(f"{cls.__name__}(-5.5)", repr(cls(-5.5)))

    def test_to_snbt(self):
        with self.subTest():
            self.assertEqual("-5.0f", FloatTag(-5).to_snbt())
            self.assertEqual("0.0f", FloatTag(0).to_snbt())
            self.assertEqual("5.0f", FloatTag(5).to_snbt())

        with self.subTest():
            self.assertEqual("-5.0d", DoubleTag(-5).to_snbt())
            self.assertEqual("0.0d", DoubleTag(0).to_snbt())
            self.assertEqual("5.0d", DoubleTag(5).to_snbt())

    def test_from_snbt(self):
        float_data: List[Tuple[AbstractBaseTag, str]] = [
            # FloatTag Normal
            # no decimal
            (FloatTag(-5), "-5f"),
            (FloatTag(-5), "-5F"),
            (FloatTag(5), "5f"),
            (FloatTag(5), "5F"),
            (FloatTag(5), "+5f"),
            (FloatTag(5), "+5F"),
            # leading decimal only
            (FloatTag(-5), "-5.f"),
            (FloatTag(-5), "-5.F"),
            (FloatTag(5), "5.f"),
            (FloatTag(5), "5.F"),
            (FloatTag(5), "+5.f"),
            (FloatTag(5), "+5.F"),
            # full decimal
            (FloatTag(-5), "-5.0f"),
            (FloatTag(-5), "-5.0F"),
            (FloatTag(5), "5.0f"),
            (FloatTag(5), "5.0F"),
            (FloatTag(5), "+5.0f"),
            (FloatTag(5), "+5.0F"),
            # trailing decimal only
            (FloatTag(-0), "-.0f"),
            (FloatTag(-0), "-.0F"),
            (FloatTag(0), ".0f"),
            (FloatTag(0), ".0F"),
            (FloatTag(0), "+.0f"),
            (FloatTag(0), "+.0F"),
            # FloatTag Positive Standard Form
            # no decimal
            (FloatTag(-500), "-5e2f"),
            (FloatTag(-500), "-5e2F"),
            (FloatTag(500), "5e2f"),
            (FloatTag(500), "5e2F"),
            (FloatTag(500), "+5e2f"),
            (FloatTag(500), "+5e2F"),
            (FloatTag(-500), "-5E2f"),
            (FloatTag(-500), "-5E2F"),
            (FloatTag(500), "5E2f"),
            (FloatTag(500), "5E2F"),
            (FloatTag(500), "+5E2f"),
            (FloatTag(500), "+5E2F"),
            # leading decimal only
            (FloatTag(-500), "-5.e2f"),
            (FloatTag(-500), "-5.e2F"),
            (FloatTag(500), "5.e2f"),
            (FloatTag(500), "5.e2F"),
            (FloatTag(500), "+5.e2f"),
            (FloatTag(500), "+5.e2F"),
            (FloatTag(-500), "-5.E2f"),
            (FloatTag(-500), "-5.E2F"),
            (FloatTag(500), "5.E2f"),
            (FloatTag(500), "5.E2F"),
            (FloatTag(500), "+5.E2f"),
            (FloatTag(500), "+5.E2F"),
            # full decimal
            (FloatTag(-500), "-5.0e2f"),
            (FloatTag(-500), "-5.0e2F"),
            (FloatTag(500), "5.0e2f"),
            (FloatTag(500), "5.0e2F"),
            (FloatTag(500), "+5.0e2f"),
            (FloatTag(500), "+5.0e2F"),
            (FloatTag(-500), "-5.0E2f"),
            (FloatTag(-500), "-5.0E2F"),
            (FloatTag(500), "5.0E2f"),
            (FloatTag(500), "5.0E2F"),
            (FloatTag(500), "+5.0E2f"),
            (FloatTag(500), "+5.0E2F"),
            # trailing decimal only
            (FloatTag(-0), "-.0e2f"),
            (FloatTag(-0), "-.0e2F"),
            (FloatTag(0), ".0e2f"),
            (FloatTag(0), ".0e2F"),
            (FloatTag(0), "+.0e2f"),
            (FloatTag(0), "+.0e2F"),
            (FloatTag(-0), "-.0E2f"),
            (FloatTag(-0), "-.0E2F"),
            (FloatTag(0), ".0E2f"),
            (FloatTag(0), ".0E2F"),
            (FloatTag(0), "+.0E2f"),
            (FloatTag(0), "+.0E2F"),
            # FloatTag Negative Standard Form
            # no decimal
            (FloatTag(-0.05), "-5e-2f"),
            (FloatTag(-0.05), "-5e-2F"),
            (FloatTag(0.05), "5e-2f"),
            (FloatTag(0.05), "5e-2F"),
            (FloatTag(0.05), "+5e-2f"),
            (FloatTag(0.05), "+5e-2F"),
            (FloatTag(-0.05), "-5E-2f"),
            (FloatTag(-0.05), "-5E-2F"),
            (FloatTag(0.05), "5E-2f"),
            (FloatTag(0.05), "5E-2F"),
            (FloatTag(0.05), "+5E-2f"),
            (FloatTag(0.05), "+5E-2F"),
            # leading decimal only
            (FloatTag(-0.05), "-5.e-2f"),
            (FloatTag(-0.05), "-5.e-2F"),
            (FloatTag(0.05), "5.e-2f"),
            (FloatTag(0.05), "5.e-2F"),
            (FloatTag(0.05), "+5.e-2f"),
            (FloatTag(0.05), "+5.e-2F"),
            (FloatTag(-0.05), "-5.E-2f"),
            (FloatTag(-0.05), "-5.E-2F"),
            (FloatTag(0.05), "5.E-2f"),
            (FloatTag(0.05), "5.E-2F"),
            (FloatTag(0.05), "+5.E-2f"),
            (FloatTag(0.05), "+5.E-2F"),
            # full decimal
            (FloatTag(-0.05), "-5.0e-2f"),
            (FloatTag(-0.05), "-5.0e-2F"),
            (FloatTag(0.05), "5.0e-2f"),
            (FloatTag(0.05), "5.0e-2F"),
            (FloatTag(0.05), "+5.0e-2f"),
            (FloatTag(0.05), "+5.0e-2F"),
            (FloatTag(-0.05), "-5.0E-2f"),
            (FloatTag(-0.05), "-5.0E-2F"),
            (FloatTag(0.05), "5.0E-2f"),
            (FloatTag(0.05), "5.0E-2F"),
            (FloatTag(0.05), "+5.0E-2f"),
            (FloatTag(0.05), "+5.0E-2F"),
            # trailing decimal only
            (FloatTag(-0), "-.0e-2f"),
            (FloatTag(-0), "-.0e-2F"),
            (FloatTag(0), ".0e-2f"),
            (FloatTag(0), ".0e-2F"),
            (FloatTag(0), "+.0e-2f"),
            (FloatTag(0), "+.0e-2F"),
            (FloatTag(-0), "-.0E-2f"),
            (FloatTag(-0), "-.0E-2F"),
            (FloatTag(0), ".0E-2f"),
            (FloatTag(0), ".0E-2F"),
            (FloatTag(0), "+.0E-2f"),
            (FloatTag(0), "+.0E-2F"),
            # DoubleTag Normal
            # no decimal
            (DoubleTag(-5), "-5d"),
            (DoubleTag(-5), "-5D"),
            (DoubleTag(5), "5d"),
            (DoubleTag(5), "5D"),
            (DoubleTag(5), "+5d"),
            (DoubleTag(5), "+5D"),
            # leading decimal only
            (DoubleTag(-5), "-5."),
            (DoubleTag(-5), "-5.d"),
            (DoubleTag(-5), "-5.D"),
            (DoubleTag(5), "5."),
            (DoubleTag(5), "5.d"),
            (DoubleTag(5), "5.D"),
            (DoubleTag(5), "+5."),
            (DoubleTag(5), "+5.d"),
            (DoubleTag(5), "+5.D"),
            # full decimal
            (DoubleTag(-5), "-5.0"),
            (DoubleTag(-5), "-5.0d"),
            (DoubleTag(-5), "-5.0D"),
            (DoubleTag(5), "5.0"),
            (DoubleTag(5), "5.0d"),
            (DoubleTag(5), "5.0D"),
            (DoubleTag(5), "+5.0"),
            (DoubleTag(5), "+5.0d"),
            (DoubleTag(5), "+5.0D"),
            # trailing decimal only
            (DoubleTag(-0), "-.0"),
            (DoubleTag(-0), "-.0d"),
            (DoubleTag(-0), "-.0D"),
            (DoubleTag(0), ".0"),
            (DoubleTag(0), ".0d"),
            (DoubleTag(0), ".0D"),
            (DoubleTag(0), "+.0"),
            (DoubleTag(0), "+.0d"),
            (DoubleTag(0), "+.0D"),
            # DoubleTag Positive Standard Form
            # no decimal
            (StringTag("-5e2"), "-5e2"),
            (DoubleTag(-500), "-5e2d"),
            (DoubleTag(-500), "-5e2D"),
            (StringTag("5e2"), "5e2"),
            (DoubleTag(500), "5e2d"),
            (DoubleTag(500), "5e2D"),
            (StringTag("+5e2"), "+5e2"),
            (DoubleTag(500), "+5e2d"),
            (DoubleTag(500), "+5e2D"),
            (StringTag("-5E2"), "-5E2"),
            (DoubleTag(-500), "-5E2d"),
            (DoubleTag(-500), "-5E2D"),
            (StringTag("5E2"), "5E2"),
            (DoubleTag(500), "5E2d"),
            (DoubleTag(500), "5E2D"),
            (StringTag("+5E2"), "+5E2"),
            (DoubleTag(500), "+5E2d"),
            (DoubleTag(500), "+5E2D"),
            # leading decimal only
            (DoubleTag(-500), "-5.e2"),
            (DoubleTag(-500), "-5.e2d"),
            (DoubleTag(-500), "-5.e2D"),
            (DoubleTag(500), "5.e2"),
            (DoubleTag(500), "5.e2d"),
            (DoubleTag(500), "5.e2D"),
            (DoubleTag(500), "+5.e2"),
            (DoubleTag(500), "+5.e2d"),
            (DoubleTag(500), "+5.e2D"),
            (DoubleTag(-500), "-5.E2"),
            (DoubleTag(-500), "-5.E2d"),
            (DoubleTag(-500), "-5.E2D"),
            (DoubleTag(500), "5.E2"),
            (DoubleTag(500), "5.E2d"),
            (DoubleTag(500), "5.E2D"),
            (DoubleTag(500), "+5.E2"),
            (DoubleTag(500), "+5.E2d"),
            (DoubleTag(500), "+5.E2D"),
            # full decimal
            (DoubleTag(-500), "-5.0e2"),
            (DoubleTag(-500), "-5.0e2d"),
            (DoubleTag(-500), "-5.0e2D"),
            (DoubleTag(500), "5.0e2"),
            (DoubleTag(500), "5.0e2d"),
            (DoubleTag(500), "5.0e2D"),
            (DoubleTag(500), "+5.0e2"),
            (DoubleTag(500), "+5.0e2d"),
            (DoubleTag(500), "+5.0e2D"),
            (DoubleTag(-500), "-5.0E2"),
            (DoubleTag(-500), "-5.0E2d"),
            (DoubleTag(-500), "-5.0E2D"),
            (DoubleTag(500), "5.0E2"),
            (DoubleTag(500), "5.0E2d"),
            (DoubleTag(500), "5.0E2D"),
            (DoubleTag(500), "+5.0E2"),
            (DoubleTag(500), "+5.0E2d"),
            (DoubleTag(500), "+5.0E2D"),
            # trailing decimal only
            (DoubleTag(-0), "-.0e2"),
            (DoubleTag(-0), "-.0e2d"),
            (DoubleTag(-0), "-.0e2D"),
            (DoubleTag(0), ".0e2"),
            (DoubleTag(0), ".0e2d"),
            (DoubleTag(0), ".0e2D"),
            (DoubleTag(0), "+.0e2"),
            (DoubleTag(0), "+.0e2d"),
            (DoubleTag(0), "+.0e2D"),
            (DoubleTag(-0), "-.0E2"),
            (DoubleTag(-0), "-.0E2d"),
            (DoubleTag(-0), "-.0E2D"),
            (DoubleTag(0), ".0E2"),
            (DoubleTag(0), ".0E2d"),
            (DoubleTag(0), ".0E2D"),
            (DoubleTag(0), "+.0E2"),
            (DoubleTag(0), "+.0E2d"),
            (DoubleTag(0), "+.0E2D"),
            # DoubleTag Negative Standard Form
            # no decimal
            (StringTag("-5e-2"), "-5e-2"),
            (DoubleTag(-0.05), "-5e-2d"),
            (DoubleTag(-0.05), "-5e-2D"),
            (StringTag("5e-2"), "5e-2"),
            (DoubleTag(0.05), "5e-2d"),
            (DoubleTag(0.05), "5e-2D"),
            (StringTag("+5e-2"), "+5e-2"),
            (DoubleTag(0.05), "+5e-2d"),
            (DoubleTag(0.05), "+5e-2D"),
            (StringTag("-5E-2"), "-5E-2"),
            (DoubleTag(-0.05), "-5E-2d"),
            (DoubleTag(-0.05), "-5E-2D"),
            (StringTag("5E-2"), "5E-2"),
            (DoubleTag(0.05), "5E-2d"),
            (DoubleTag(0.05), "5E-2D"),
            (StringTag("+5E-2"), "+5E-2"),
            (DoubleTag(0.05), "+5E-2d"),
            (DoubleTag(0.05), "+5E-2D"),
            # leading decimal only
            (DoubleTag(-0.05), "-5.e-2"),
            (DoubleTag(-0.05), "-5.e-2d"),
            (DoubleTag(-0.05), "-5.e-2D"),
            (DoubleTag(0.05), "5.e-2"),
            (DoubleTag(0.05), "5.e-2d"),
            (DoubleTag(0.05), "5.e-2D"),
            (DoubleTag(0.05), "+5.e-2"),
            (DoubleTag(0.05), "+5.e-2d"),
            (DoubleTag(0.05), "+5.e-2D"),
            (DoubleTag(-0.05), "-5.E-2"),
            (DoubleTag(-0.05), "-5.E-2d"),
            (DoubleTag(-0.05), "-5.E-2D"),
            (DoubleTag(0.05), "5.E-2"),
            (DoubleTag(0.05), "5.E-2d"),
            (DoubleTag(0.05), "5.E-2D"),
            (DoubleTag(0.05), "+5.E-2"),
            (DoubleTag(0.05), "+5.E-2d"),
            (DoubleTag(0.05), "+5.E-2D"),
            # full decimal
            (DoubleTag(-0.05), "-5.0e-2"),
            (DoubleTag(-0.05), "-5.0e-2d"),
            (DoubleTag(-0.05), "-5.0e-2D"),
            (DoubleTag(0.05), "5.0e-2"),
            (DoubleTag(0.05), "5.0e-2d"),
            (DoubleTag(0.05), "5.0e-2D"),
            (DoubleTag(0.05), "+5.0e-2"),
            (DoubleTag(0.05), "+5.0e-2d"),
            (DoubleTag(0.05), "+5.0e-2D"),
            (DoubleTag(-0.05), "-5.0E-2"),
            (DoubleTag(-0.05), "-5.0E-2d"),
            (DoubleTag(-0.05), "-5.0E-2D"),
            (DoubleTag(0.05), "5.0E-2"),
            (DoubleTag(0.05), "5.0E-2d"),
            (DoubleTag(0.05), "5.0E-2D"),
            (DoubleTag(0.05), "+5.0E-2"),
            (DoubleTag(0.05), "+5.0E-2d"),
            (DoubleTag(0.05), "+5.0E-2D"),
            # trailing decimal only
            (DoubleTag(-0), "-.0e-2"),
            (DoubleTag(-0), "-.0e-2d"),
            (DoubleTag(-0), "-.0e-2D"),
            (DoubleTag(0), ".0e-2"),
            (DoubleTag(0), ".0e-2d"),
            (DoubleTag(0), ".0e-2D"),
            (DoubleTag(0), "+.0e-2"),
            (DoubleTag(0), "+.0e-2d"),
            (DoubleTag(0), "+.0e-2D"),
            (DoubleTag(-0), "-.0E-2"),
            (DoubleTag(-0), "-.0E-2d"),
            (DoubleTag(-0), "-.0E-2D"),
            (DoubleTag(0), ".0E-2"),
            (DoubleTag(0), ".0E-2d"),
            (DoubleTag(0), ".0E-2D"),
            (DoubleTag(0), "+.0E-2"),
            (DoubleTag(0), "+.0E-2d"),
            (DoubleTag(0), "+.0E-2D"),
        ]

        for tag, snbt in float_data:
            with self.subTest(snbt):
                self.assertStrictEqual(tag, from_snbt(snbt))

    def test_to_nbt(self):
        self.assertEqual(
            b"\x05\x00\x00\x40\xa0\x00\x00",
            FloatTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x05\x00\x00\x00\x00\xa0\x40",
            FloatTag(5).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x06\x00\x00\x40\x14\x00\x00\x00\x00\x00\x00",
            DoubleTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x06\x00\x00\x00\x00\x00\x00\x00\x00\x14\x40",
            DoubleTag(5).to_nbt(compressed=False, little_endian=True),
        )

    def test_from_nbt(self):
        self.assertStrictEqual(
            FloatTag(5),
            load_nbt(b"\x05\x00\x00\x40\xa0\x00\x00", little_endian=False).float,
        )
        self.assertStrictEqual(
            FloatTag(5),
            load_nbt(b"\x05\x00\x00\x00\x00\xa0\x40", little_endian=True).float,
        )
        self.assertStrictEqual(
            DoubleTag(5),
            load_nbt(
                b"\x06\x00\x00\x40\x14\x00\x00\x00\x00\x00\x00", little_endian=False
            ).double,
        )
        self.assertStrictEqual(
            DoubleTag(5),
            load_nbt(
                b"\x06\x00\x00\x00\x00\x00\x00\x00\x00\x14\x40", little_endian=True
            ).double,
        )

    def test_numerical_operators(self):
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2 or __major__ <= 2:
                    self.assertTrue(cls1(5) < cls2(10))
                    self.assertFalse(cls1(5) < cls2(5))
                    self.assertFalse(cls1(5) < cls2(0))

                    self.assertTrue(cls1(5) <= cls2(10))
                    self.assertTrue(cls1(5) <= cls2(5))
                    self.assertFalse(cls1(5) <= cls2(0))

                    self.assertFalse(cls1(5) > cls2(10))
                    self.assertFalse(cls1(5) > cls2(5))
                    self.assertTrue(cls1(5) > cls2(0))

                    self.assertFalse(cls1(5) >= cls2(10))
                    self.assertTrue(cls1(5) >= cls2(5))
                    self.assertTrue(cls1(5) >= cls2(0))
                else:
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) < cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) < cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) < cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) <= cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) <= cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) <= cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) > cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) > cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) > cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) >= cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) >= cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) >= cls2(0))

        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(int(cls(5.5)), int)
                self.assertEqual(5, int(cls(5.5)))

                self.assertIsInstance(float(cls(5.5)), float)
                self.assertEqual(5.5, float(cls(5.5)))

                self.assertIsInstance(bool(cls(5.5)), bool)
                self.assertEqual(False, bool(cls(0)))
                self.assertEqual(True, bool(cls(5.5)))


if __name__ == "__main__":
    unittest.main()