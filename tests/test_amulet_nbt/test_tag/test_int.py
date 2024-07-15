import copy
import pickle
import itertools
import unittest
import faulthandler
import numpy

faulthandler.enable()

from .test_numeric import AbstractBaseNumericTagTestCase
from amulet_nbt import (
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    AbstractBaseNumericTag,
    AbstractBaseIntTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    read_nbt,
    StringTag,
    read_snbt,
)


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
                    int_cls(None)  # type: ignore

                RangeByte = 2**8
                RangeShort = 2**16
                RangeInt = 2**32
                RangeLong = 2**64

                MinByte = -(2**7)
                MinShort = -(2**15)
                MinInt = -(2**31)
                MinLong = -(2**63)

                UnderflowByte = MinByte - 1
                UnderflowShort = MinShort - 1
                UnderflowInt = MinInt - 1
                UnderflowLong = MinLong - 1

                MaxByte = 2**7 - 1
                MaxShort = 2**15 - 1
                MaxInt = 2**31 - 1
                MaxLong = 2**63 - 1

                OverflowByte = MaxByte + 1
                OverflowShort = MaxShort + 1
                OverflowInt = MaxInt + 1
                OverflowLong = MaxLong + 1

                # upper bound
                self.assertEqual(MaxByte, int(ByteTag(MaxByte + 0 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(MaxByte + 1 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(MaxByte + 2 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(MaxByte + 3 * RangeByte)))
                self.assertEqual(MaxShort, int(ShortTag(MaxShort + 0 * RangeShort)))
                self.assertEqual(MaxShort, int(ShortTag(MaxShort + 1 * RangeShort)))
                self.assertEqual(MaxShort, int(ShortTag(MaxShort + 2 * RangeShort)))
                self.assertEqual(MaxShort, int(ShortTag(MaxShort + 3 * RangeShort)))
                self.assertEqual(MaxInt, int(IntTag(MaxInt + 0 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(MaxInt + 1 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(MaxInt + 2 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(MaxInt + 3 * RangeInt)))
                self.assertEqual(MaxLong, int(LongTag(MaxLong + 0 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(MaxLong + 1 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(MaxLong + 2 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(MaxLong + 3 * RangeLong)))

                # overflow
                self.assertEqual(MinByte, int(ByteTag(OverflowByte + 1 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(OverflowByte + 2 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(OverflowByte + 3 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(OverflowByte + 4 * RangeByte)))
                self.assertEqual(
                    MinShort, int(ShortTag(OverflowShort + 1 * RangeShort))
                )
                self.assertEqual(
                    MinShort, int(ShortTag(OverflowShort + 2 * RangeShort))
                )
                self.assertEqual(
                    MinShort, int(ShortTag(OverflowShort + 3 * RangeShort))
                )
                self.assertEqual(
                    MinShort, int(ShortTag(OverflowShort + 4 * RangeShort))
                )
                self.assertEqual(MinInt, int(IntTag(OverflowInt + 1 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(OverflowInt + 2 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(OverflowInt + 3 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(OverflowInt + 4 * RangeInt)))
                self.assertEqual(MinLong, int(LongTag(OverflowLong + 1 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(OverflowLong + 2 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(OverflowLong + 3 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(OverflowLong + 4 * RangeLong)))

                # lower bound
                self.assertEqual(MinByte, int(ByteTag(MinByte - 1 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(MinByte - 2 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(MinByte - 3 * RangeByte)))
                self.assertEqual(MinByte, int(ByteTag(MinByte - 4 * RangeByte)))
                self.assertEqual(MinShort, int(ShortTag(MinShort - 1 * RangeShort)))
                self.assertEqual(MinShort, int(ShortTag(MinShort - 2 * RangeShort)))
                self.assertEqual(MinShort, int(ShortTag(MinShort - 3 * RangeShort)))
                self.assertEqual(MinShort, int(ShortTag(MinShort - 4 * RangeShort)))
                self.assertEqual(MinInt, int(IntTag(MinInt - 1 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(MinInt - 2 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(MinInt - 3 * RangeInt)))
                self.assertEqual(MinInt, int(IntTag(MinInt - 4 * RangeInt)))
                self.assertEqual(MinLong, int(LongTag(MinLong - 1 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(MinLong - 2 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(MinLong - 3 * RangeLong)))
                self.assertEqual(MinLong, int(LongTag(MinLong - 4 * RangeLong)))

                # underflow
                self.assertEqual(MaxByte, int(ByteTag(UnderflowByte - 1 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(UnderflowByte - 2 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(UnderflowByte - 3 * RangeByte)))
                self.assertEqual(MaxByte, int(ByteTag(UnderflowByte - 4 * RangeByte)))
                self.assertEqual(
                    MaxShort, int(ShortTag(UnderflowShort - 1 * RangeShort))
                )
                self.assertEqual(
                    MaxShort, int(ShortTag(UnderflowShort - 2 * RangeShort))
                )
                self.assertEqual(
                    MaxShort, int(ShortTag(UnderflowShort - 3 * RangeShort))
                )
                self.assertEqual(
                    MaxShort, int(ShortTag(UnderflowShort - 4 * RangeShort))
                )
                self.assertEqual(MaxInt, int(IntTag(UnderflowInt - 1 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(UnderflowInt - 2 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(UnderflowInt - 3 * RangeInt)))
                self.assertEqual(MaxInt, int(IntTag(UnderflowInt - 4 * RangeInt)))
                self.assertEqual(MaxLong, int(LongTag(UnderflowLong - 1 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(UnderflowLong - 2 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(UnderflowLong - 3 * RangeLong)))
                self.assertEqual(MaxLong, int(LongTag(UnderflowLong - 4 * RangeLong)))

                # 0
                self.assertEqual(0, int(ByteTag(0 + 1 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 - 1 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 + 2 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 - 2 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 + 3 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 - 3 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 + 4 * RangeByte)))
                self.assertEqual(0, int(ByteTag(0 - 4 * RangeByte)))
                self.assertEqual(0, int(ShortTag(0 + 1 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 - 1 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 + 2 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 - 2 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 + 3 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 - 3 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 + 4 * RangeShort)))
                self.assertEqual(0, int(ShortTag(0 - 4 * RangeShort)))
                self.assertEqual(0, int(IntTag(0 + 1 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 - 1 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 + 2 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 - 2 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 + 3 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 - 3 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 + 4 * RangeInt)))
                self.assertEqual(0, int(IntTag(0 - 4 * RangeInt)))
                self.assertEqual(0, int(LongTag(0 + 1 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 - 1 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 + 2 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 - 2 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 + 3 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 - 3 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 + 4 * RangeLong)))
                self.assertEqual(0, int(LongTag(0 - 4 * RangeLong)))

                # -1
                self.assertEqual(-1, int(ByteTag(-1 + 1 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 - 1 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 + 2 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 - 2 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 + 3 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 - 3 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 + 4 * RangeByte)))
                self.assertEqual(-1, int(ByteTag(-1 - 4 * RangeByte)))
                self.assertEqual(-1, int(ShortTag(-1 + 1 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 - 1 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 + 2 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 - 2 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 + 3 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 - 3 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 + 4 * RangeShort)))
                self.assertEqual(-1, int(ShortTag(-1 - 4 * RangeShort)))
                self.assertEqual(-1, int(IntTag(-1 + 1 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 - 1 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 + 2 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 - 2 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 + 3 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 - 3 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 + 4 * RangeInt)))
                self.assertEqual(-1, int(IntTag(-1 - 4 * RangeInt)))
                self.assertEqual(-1, int(LongTag(-1 + 1 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 - 1 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 + 2 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 - 2 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 + 3 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 - 3 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 + 4 * RangeLong)))
                self.assertEqual(-1, int(LongTag(-1 - 4 * RangeLong)))

        for cls in self.nbt_types:
            tag = cls()
            try:
                int(tag)  # type: ignore
            except:
                pass
            else:
                for int_cls in self.int_types:
                    with self.subTest(cls=cls, int_cls=int_cls):
                        int_cls(tag)  # type: ignore

        for obj in self.not_nbt:
            try:
                int(obj)
            except:
                pass
            else:
                for int_cls in self.int_types:
                    with self.subTest(obj=obj, int_cls=int_cls):
                        int_cls(obj)

    def test_numpy_constructor(self) -> None:
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
        self.assertEqual(ByteTag(-(2**7)), ByteTag(numpy.uint64(2**7)))
        self.assertEqual(ShortTag(-(2**15)), ShortTag(numpy.uint64(2**15)))
        self.assertEqual(IntTag(-(2**31)), IntTag(numpy.uint64(2**31)))
        self.assertEqual(LongTag(-(2**63)), LongTag(numpy.uint64(2**63)))

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
        self.assertEqual("5", str(ByteTag(5)))
        self.assertEqual("5", str(ShortTag(5)))
        self.assertEqual("5", str(IntTag(5)))
        self.assertEqual("5", str(LongTag(5)))

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

    def test_to_nbt(self) -> None:
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

    def test_from_nbt(self) -> None:
        self.assertEqual(
            ByteTag(5),
            read_nbt(b"\x01\x00\x00\x05", little_endian=False).byte,
        )
        self.assertEqual(
            ByteTag(5),
            read_nbt(b"\x01\x00\x00\x05", little_endian=True).byte,
        )
        self.assertEqual(
            ShortTag(5),
            read_nbt(b"\x02\x00\x00\x00\x05", little_endian=False).short,
        )
        self.assertEqual(
            ShortTag(5),
            read_nbt(b"\x02\x00\x00\x05\x00", little_endian=True).short,
        )
        self.assertEqual(
            IntTag(5),
            read_nbt(b"\x03\x00\x00\x00\x00\x00\x05", little_endian=False).int,
        )
        self.assertEqual(
            IntTag(5),
            read_nbt(b"\x03\x00\x00\x05\x00\x00\x00", little_endian=True).int,
        )
        self.assertEqual(
            LongTag(5),
            read_nbt(
                b"\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05", little_endian=False
            ).long,
        )
        self.assertEqual(
            LongTag(5),
            read_nbt(
                b"\x04\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00", little_endian=True
            ).long,
        )

    def test_to_snbt(self) -> None:
        with self.subTest():
            self.assertEqual("-5b", ByteTag(-5).to_snbt())
            self.assertEqual("0b", ByteTag(0).to_snbt())
            self.assertEqual("5b", ByteTag(5).to_snbt())

        with self.subTest():
            self.assertEqual("-5s", ShortTag(-5).to_snbt())
            self.assertEqual("0s", ShortTag(0).to_snbt())
            self.assertEqual("5s", ShortTag(5).to_snbt())

        with self.subTest():
            self.assertEqual("-5", IntTag(-5).to_snbt())
            self.assertEqual("0", IntTag(0).to_snbt())
            self.assertEqual("5", IntTag(5).to_snbt())

        with self.subTest():
            self.assertEqual("-5L", LongTag(-5).to_snbt())
            self.assertEqual("0L", LongTag(0).to_snbt())
            self.assertEqual("5L", LongTag(5).to_snbt())

    def test_from_snbt(self) -> None:
        with self.subTest():
            self.assertEqual(ByteTag(-5), read_snbt("-5b"))
            self.assertEqual(ByteTag(-5), read_snbt("-5B"))
            self.assertEqual(ByteTag(0), read_snbt("0b"))
            self.assertEqual(ByteTag(0), read_snbt("0B"))
            self.assertEqual(ByteTag(0), read_snbt("+0b"))
            self.assertEqual(ByteTag(0), read_snbt("+0B"))
            self.assertEqual(ByteTag(0), read_snbt("false"))
            self.assertEqual(ByteTag(0), read_snbt("False"))
            self.assertEqual(ByteTag(1), read_snbt("true"))
            self.assertEqual(ByteTag(1), read_snbt("True"))
            self.assertEqual(ByteTag(5), read_snbt("5b"))
            self.assertEqual(ByteTag(5), read_snbt("5B"))
            self.assertEqual(ByteTag(5), read_snbt("+5b"))
            self.assertEqual(ByteTag(5), read_snbt("+5B"))

        with self.subTest():
            self.assertEqual(ShortTag(-5), read_snbt("-5s"))
            self.assertEqual(ShortTag(-5), read_snbt("-5S"))
            self.assertEqual(ShortTag(0), read_snbt("0s"))
            self.assertEqual(ShortTag(0), read_snbt("0S"))
            self.assertEqual(ShortTag(0), read_snbt("+0s"))
            self.assertEqual(ShortTag(0), read_snbt("+0S"))
            self.assertEqual(ShortTag(5), read_snbt("5s"))
            self.assertEqual(ShortTag(5), read_snbt("5S"))
            self.assertEqual(ShortTag(5), read_snbt("+5s"))
            self.assertEqual(ShortTag(5), read_snbt("+5S"))

        with self.subTest():
            self.assertEqual(IntTag(-5), read_snbt("-5"))
            self.assertEqual(IntTag(0), read_snbt("0"))
            self.assertEqual(IntTag(0), read_snbt("+0"))
            self.assertEqual(IntTag(5), read_snbt("5"))
            self.assertEqual(IntTag(5), read_snbt("+5"))

            self.assertEqual(StringTag("-5i"), read_snbt("-5i"))
            self.assertEqual(StringTag("-5I"), read_snbt("-5I"))
            self.assertEqual(StringTag("5i"), read_snbt("5i"))
            self.assertEqual(StringTag("5I"), read_snbt("5I"))
            self.assertEqual(StringTag("+5i"), read_snbt("+5i"))
            self.assertEqual(StringTag("+5I"), read_snbt("+5I"))

        with self.subTest():
            self.assertEqual(LongTag(-5), read_snbt("-5l"))
            self.assertEqual(LongTag(-5), read_snbt("-5L"))
            self.assertEqual(LongTag(0), read_snbt("0l"))
            self.assertEqual(LongTag(0), read_snbt("0L"))
            self.assertEqual(LongTag(0), read_snbt("+0l"))
            self.assertEqual(LongTag(0), read_snbt("+0L"))
            self.assertEqual(LongTag(5), read_snbt("5l"))
            self.assertEqual(LongTag(5), read_snbt("5L"))
            self.assertEqual(LongTag(5), read_snbt("+5l"))
            self.assertEqual(LongTag(5), read_snbt("+5L"))


if __name__ == "__main__":
    unittest.main()
