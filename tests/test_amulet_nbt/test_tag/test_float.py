import copy
import pickle
import itertools
import unittest
import faulthandler
import struct

faulthandler.enable()

from .test_numeric import AbstractBaseNumericTagTestCase
from amulet_nbt import AbstractBaseTag, AbstractBaseImmutableTag, AbstractBaseNumericTag, AbstractBaseFloatTag, FloatTag, DoubleTag, load as load_nbt


ToSNBTData: list[tuple[float, str, str]] = [
    (float("-inf"), "-Infinityf", "-Infinityd"),
    (-9999999999999999, "-1e+16f", "-1e+16d"),
    (-99999999, "-1e+08f", "-99999999d"),
    (-9999, "-9999f", "-9999d"),
    (-99, "-99f", "-99d"),
    (-9, "-9f", "-9d"),
    (1, "1f", "1d"),
    (0.1, "0.1f", "0.1d"),
    (0.01, "0.01f", "0.01d"),
    (0.001, "0.001f", "0.001d"),
    (0.00001, "1e-05f", "1e-05d"),
    (0.000000001, "1e-09f", "1e-09d"),
    (0.00000000000000001, "1e-17f", "1e-17d"),
    (float("-0"), "-0f", "-0d"),
    (float("+0"), "0f", "0d"),
    (-0.00000000000000001, "-1e-17f", "-1e-17d"),
    (-0.000000001, "-1e-09f", "-1e-09d"),
    (-0.00001, "-1e-05f", "-1e-05d"),
    (-0.001, "-0.001f", "-0.001d"),
    (-0.01, "-0.01f", "-0.01d"),
    (-0.1, "-0.1f", "-0.1d"),
    (-1, "-1f", "-1d"),
    (9, "9f", "9d"),
    (99, "99f", "99d"),
    (9999, "9999f", "9999d"),
    (99999999, "1e+08f", "99999999d"),
    (9999999999999999, "1e+16f", "1e+16d"),
    (float("inf"), "Infinityf", "Infinityd"),
    (struct.unpack(">d", b"\x7f\xf0\x00\x00\x00\x00\x00\x01")[0], "NaNf", "NaNd"),  # signaling NaN
    (struct.unpack(">d", b"\x7f\xf8\x00\x00\x00\x00\x00\x00")[0], "NaNf", "NaNd"),  # quiet NaN
]

# -1.00000003E16f
# -1e+16f


class FloatTagTestCase(AbstractBaseNumericTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
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

    def test_equal(self) -> None:
        for cls1 in self.float_types:
            for cls2 in self.float_types:
                with self.subTest(cls1=cls1, cls2=cls2):
                    if cls1 is cls2:
                        self.assertEqual(cls1(), cls2())
                        self.assertEqual(cls1(), cls2(0))
                        self.assertNotEqual(cls1(5), cls2(10))
                    else:
                        self.assertNotEqual(cls1(), cls2())
                        self.assertNotEqual(cls1(), cls2(0))

            self.assertNotEqual(cls1(), 0)
            self.assertNotEqual(0, cls1())

    def test_py_data(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(cls().py_float, float)
                self.assertEqual(cls().py_float, 0.0)
                self.assertEqual(cls(5).py_float, 5.0)
                self.assertEqual(cls(5.5).py_float, 5.5)

    def test_repr(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertEqual(f"{cls.__name__}(0.0)", repr(cls()))
                self.assertEqual(f"{cls.__name__}(5.5)", repr(cls(5.5)))
                self.assertEqual(f"{cls.__name__}(-5.5)", repr(cls(-5.5)))

    def test_str(self) -> None:
        pass

    def test_pickle(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_pickled = pickle.dumps(tag)
                tag_2 = pickle.loads(tag_pickled)
                self.assertIsNot(tag, tag_2)
                self.assertEqual(tag, tag_2)
                self.assertEqual(tag.py_float, tag_2.py_float)

    def test_copy(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_copy = copy.copy(tag)
                self.assertIsNot(tag, tag_copy)
                self.assertEqual(tag, tag_copy)
                self.assertEqual(tag.py_float, tag_copy.py_float)

    def test_deepcopy(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_deepcopy = copy.deepcopy(tag)
                self.assertIsNot(tag, tag_deepcopy)
                self.assertEqual(tag, tag_deepcopy)
                self.assertEqual(tag.py_float, tag_deepcopy.py_float)

    def test_hash(self) -> None:
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(hash(cls1()), hash(cls2()))
                else:
                    self.assertNotEqual(hash(cls1()), hash(cls2()))

    def test_instance(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()
                self.assertIsInstance(tag, AbstractBaseTag)
                self.assertIsInstance(tag, AbstractBaseImmutableTag)
                self.assertIsInstance(tag, AbstractBaseNumericTag)
                self.assertIsInstance(tag, AbstractBaseFloatTag)
                self.assertIsInstance(tag, cls)

    def test_int(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertEqual(5, int(cls(5.5)))
                self.assertEqual(-5, int(cls(-5.5)))

    def test_float(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertEqual(5.5, float(cls(5.5)))
                self.assertEqual(-5.5, float(cls(-5.5)))

    def test_bool(self) -> None:
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertTrue(cls(5.5))
                self.assertTrue(cls(5))
                self.assertTrue(cls(1))
                self.assertTrue(cls(0.01))
                self.assertFalse(cls(0.0))
                self.assertTrue(cls(-0.01))
                self.assertTrue(cls(-1))
                self.assertTrue(cls(-5))
                self.assertTrue(cls(-5.5))

    def test_numerical_operators(self) -> None:
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
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

    def test_to_nbt(self) -> None:
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

    def test_from_nbt(self) -> None:
        self.assertEqual(
            FloatTag(5),
            load_nbt(b"\x05\x00\x00\x40\xa0\x00\x00", little_endian=False).float,
        )
        self.assertEqual(
            FloatTag(5),
            load_nbt(b"\x05\x00\x00\x00\x00\xa0\x40", little_endian=True).float,
        )
        self.assertEqual(
            DoubleTag(5),
            load_nbt(
                b"\x06\x00\x00\x40\x14\x00\x00\x00\x00\x00\x00", little_endian=False
            ).double,
        )
        self.assertEqual(
            DoubleTag(5),
            load_nbt(
                b"\x06\x00\x00\x00\x00\x00\x00\x00\x00\x14\x40", little_endian=True
            ).double,
        )

    def test_to_snbt(self) -> None:
        for py_float, float_snbt, double_snbt in ToSNBTData:
            for py_cls, snbt in ((FloatTag, float_snbt), (DoubleTag, double_snbt)):
                with self.subTest(snbt):
                    self.assertEqual(snbt, py_cls(py_float).to_snbt())
                    self.assertEqual(snbt, py_cls(py_float).to_snbt("\t"))


if __name__ == "__main__":
    unittest.main()
