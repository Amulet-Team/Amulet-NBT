import copy
import pickle
import itertools
import unittest
import faulthandler
import numpy

faulthandler.enable()

from .test_numeric import AbstractBaseNumericTagTestCase
from amulet_nbt import AbstractBaseTag, AbstractBaseImmutableTag, AbstractBaseNumericTag, AbstractBaseIntTag, ByteTag, ShortTag, IntTag, LongTag, load as load_nbt


class IntTagTestCase(AbstractBaseNumericTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        for int_cls in self.int_types:
            with self.subTest(int_cls=int_cls):
                int_cls()
                int_cls(5)
                int_cls(-5)
                int_cls(5.0)
                int_cls(-5.0)
                with self.assertRaises(TypeError):
                    int_cls(None)

                # overflow
                self.assertEqual(ByteTag(-2 ** 7), ByteTag(2 ** 7))
                self.assertEqual(ShortTag(-2 ** 15), ShortTag(2 ** 15))
                self.assertEqual(IntTag(-2 ** 31), IntTag(2 ** 31))
                self.assertEqual(LongTag(-2 ** 63), LongTag(2 ** 63))

                # underflow
                self.assertEqual(ByteTag(2 ** 7 - 1), ByteTag(-2 ** 7 - 1))
                self.assertEqual(ShortTag(2 ** 15 - 1), ShortTag(-2 ** 15 - 1))
                self.assertEqual(IntTag(2 ** 31 - 1), IntTag(-2 ** 31 - 1))
                self.assertEqual(LongTag(2 ** 63 - 1), LongTag(-2 ** 63 - 1))

        for cls in self.nbt_types:
            tag = cls()
            try:
                int(tag)
            except:
                pass
            else:
                for int_cls in self.int_types:
                    with self.subTest(cls=cls, int_cls=int_cls):
                        int_cls(tag)

        for obj in self.not_nbt:
            try:
                int(obj)
            except:
                pass
            else:
                for int_cls in self.int_types:
                    with self.subTest(obj=obj, int_cls=int_cls):
                        int_cls(obj)

    def test_numpy_constructor(self):
        for int_cls in self.int_types:
            with self.subTest(int_cls=int_cls):
                self.assertEqual(int_cls(0), int_cls(numpy.uint8(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.int8(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.uint16(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.int16(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.uint32(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.int32(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.uint64(0)))
                self.assertEqual(int_cls(0), int_cls(numpy.int64(0)))

                self.assertEqual(int_cls(-1), int_cls(numpy.int8(-1)))
                self.assertEqual(int_cls(-1), int_cls(numpy.int16(-1)))
                self.assertEqual(int_cls(-1), int_cls(numpy.int32(-1)))
                self.assertEqual(int_cls(-1), int_cls(numpy.int64(-1)))

        # Overflow
        self.assertEqual(ByteTag(-2**7), ByteTag(numpy.uint64(2**7)))
        self.assertEqual(ShortTag(-2**15), ShortTag(numpy.uint64(2**15)))
        self.assertEqual(IntTag(-2**31), IntTag(numpy.uint64(2**31)))
        self.assertEqual(LongTag(-2**63), LongTag(numpy.uint64(2**63)))

    def test_equal(self) -> None:
        for cls1 in self.int_types:
            for cls2 in self.int_types:
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
        for cls in self.int_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(cls().py_int, int)
                self.assertEqual(cls().py_int, 0)
                self.assertEqual(cls(5).py_int, 5)
                self.assertEqual(cls(5.5).py_int, 5)

    def test_repr(self) -> None:
        for cls in self.int_types:
            for v in (-5, 0, 5):
                with self.subTest(cls=cls, v=v):
                    self.assertEqual(f"{cls.__name__}({v})", repr(cls(v)))

    def test_str(self) -> None:
        pass

    def test_pickle(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_pickled = pickle.dumps(tag)
                tag_2 = pickle.loads(tag_pickled)
                self.assertIsNot(tag, tag_2)
                self.assertEqual(tag, tag_2)
                self.assertEqual(tag.py_int, tag_2.py_int)

    def test_copy(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_copy = copy.copy(tag)
                self.assertIsNot(tag, tag_copy)
                self.assertEqual(tag, tag_copy)
                self.assertEqual(tag.py_int, tag_copy.py_int)

    def test_deepcopy(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_deepcopy = copy.deepcopy(tag)
                self.assertIsNot(tag, tag_deepcopy)
                self.assertEqual(tag, tag_deepcopy)
                self.assertEqual(tag.py_int, tag_deepcopy.py_int)

    def test_hash(self) -> None:
        for cls1, cls2 in itertools.product(self.int_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(hash(cls1()), hash(cls2()))
                else:
                    self.assertNotEqual(hash(cls1()), hash(cls2()))

    def test_instance(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                tag = cls()
                self.assertIsInstance(tag, AbstractBaseTag)
                self.assertIsInstance(tag, AbstractBaseImmutableTag)
                self.assertIsInstance(tag, AbstractBaseNumericTag)
                self.assertIsInstance(tag, AbstractBaseIntTag)
                self.assertIsInstance(tag, cls)

    def test_int(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                self.assertEqual(5, int(cls(5)))
                self.assertEqual(-5, int(cls(-5)))

    def test_float(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                self.assertEqual(5.0, float(cls(5.0)))
                self.assertEqual(-5.0, float(cls(-5.0)))

    def test_bool(self) -> None:
        for cls in self.int_types:
            with self.subTest(cls=cls):
                self.assertTrue(cls(5))
                self.assertTrue(cls(1))
                self.assertFalse(cls(0))
                self.assertTrue(cls(-1))
                self.assertTrue(cls(-5))

    def test_numerical_operators(self) -> None:
        for cls1, cls2 in itertools.product(self.int_types, repeat=2):
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

        for cls in self.int_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(int(cls(5.5)), int)
                self.assertEqual(5, int(cls(5.5)))

                self.assertIsInstance(float(cls(5.5)), float)
                self.assertEqual(5, float(cls(5.5)))

                self.assertIsInstance(bool(cls(5.5)), bool)
                self.assertEqual(False, bool(cls(0)))
                self.assertEqual(True, bool(cls(5.5)))

    def test_to_nbt(self):
        self.assertEqual(
            b"\x01\x00\x00\x05",
            ByteTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x01\x00\x00\x05",
            ByteTag(5).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x02\x00\x00\x00\x05",
            ShortTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x02\x00\x00\x05\x00",
            ShortTag(5).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x03\x00\x00\x00\x00\x00\x05",
            IntTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x03\x00\x00\x05\x00\x00\x00",
            IntTag(5).to_nbt(compressed=False, little_endian=True),
        )
        self.assertEqual(
            b"\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05",
            LongTag(5).to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x04\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00",
            LongTag(5).to_nbt(compressed=False, little_endian=True),
        )

    def test_from_nbt(self):
        self.assertEqual(
            ByteTag(5),
            load_nbt(b"\x01\x00\x00\x05", little_endian=False).byte,
        )
        self.assertEqual(
            ByteTag(5),
            load_nbt(b"\x01\x00\x00\x05", little_endian=True).byte,
        )
        self.assertEqual(
            ShortTag(5),
            load_nbt(b"\x02\x00\x00\x00\x05", little_endian=False).short,
        )
        self.assertEqual(
            ShortTag(5),
            load_nbt(b"\x02\x00\x00\x05\x00", little_endian=True).short,
        )
        self.assertEqual(
            IntTag(5),
            load_nbt(b"\x03\x00\x00\x00\x00\x00\x05", little_endian=False).int,
        )
        self.assertEqual(
            IntTag(5),
            load_nbt(b"\x03\x00\x00\x05\x00\x00\x00", little_endian=True).int,
        )
        self.assertEqual(
            LongTag(5),
            load_nbt(
                b"\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05", little_endian=False
            ).long,
        )
        self.assertEqual(
            LongTag(5),
            load_nbt(
                b"\x04\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00", little_endian=True
            ).long,
        )


if __name__ == "__main__":
    unittest.main()
