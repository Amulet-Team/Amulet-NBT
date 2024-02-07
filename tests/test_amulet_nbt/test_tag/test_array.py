import copy
import pickle
import itertools
import unittest
import faulthandler
import numpy

faulthandler.enable()

from .test_abc import AbstractBaseMutableTagTestCase

from amulet_nbt import AbstractBaseTag, AbstractBaseMutableTag, AbstractBaseArrayTag, ByteArrayTag, IntArrayTag, LongArrayTag


class ArrayTagTestCase(AbstractBaseMutableTagTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                cls()
                cls([1, 2, 3])
                cls(numpy.array([1, 2, 3]))
                with self.assertRaises(TypeError):
                    cls(None)
                with self.assertRaises(ValueError):
                    cls("test")

            for cls2 in self.array_types:
                with self.subTest(cls=cls, cls2=cls2):
                    cls(cls2([1, 2, 3]))

    def test_equal(self) -> None:
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for arg1, arg2 in itertools.product(([], [1, 2, 3], [4, 5, 6]), repeat=2):
                with self.subTest(cls1=cls1, cls2=cls2, arg1=arg1, arg2=arg2):
                    a = cls1(arg1)
                    b = cls2(arg2)
                    if arg1 == arg2 and cls1 is cls2:
                        self.assertEqual(a, b)
                    else:
                        self.assertNotEqual(a, b)

    def test_py_data(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                inst = cls([1, 2, 3])
                arr = inst.np_array
                self.assertIsInstance(arr, numpy.ndarray)

                # should keep the same buffer
                arr[1] = 10
                self.assertEqual(10, inst[1])

    def test_repr(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                self.assertEqual(f"{cls.__name__}([])", repr(cls()))
                self.assertEqual(
                    f"{cls.__name__}([-3, -2, -1, 0, 1, 2, 3])",
                    repr(cls([-3, -2, -1, 0, 1, 2, 3])),
                )

    def test_str(self) -> None:
        pass

    def test_pickle(self) -> None:
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for arg1, arg2 in itertools.product(([], [1, 2, 3], [4, 5, 6]), repeat=2):
                with self.subTest(cls1=cls1, cls2=cls2, arg1=arg1, arg2=arg2):
                    a = cls1(arg1)
                    dump = pickle.dumps(cls2(arg2))
                    b = pickle.loads(dump)
                    if arg1 == arg2 and cls1 is cls2:
                        self.assertEqual(a, b)
                    else:
                        self.assertNotEqual(a, b)

    def test_copy(self) -> None:
        for cls in self.array_types:
            inst = cls([1, 2, 3])
            inst2 = copy.copy(inst)
            self.assertEqual(inst, inst2)
            inst[1] = 10
            self.assertEqual(2, inst2[1])

    def test_deepcopy(self) -> None:
        for cls in self.array_types:
            inst = cls([1, 2, 3])
            inst2 = copy.deepcopy(inst)
            self.assertEqual(inst, inst2)
            inst[1] = 10
            self.assertEqual(2, inst2[1])

    def test_hash(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                with self.assertRaises(TypeError):
                    hash(cls())
                with self.assertRaises(TypeError):
                    hash(cls([1, 2, 3]))

    def test_instance(self) -> None:
        for cls in self.array_types:
            for parent in (
                AbstractBaseTag,
                AbstractBaseMutableTag,
                AbstractBaseArrayTag,
                cls,
            ):
                with self.subTest(cls=cls, parent=parent):
                    self.assertIsInstance(cls(), parent)

    def test_len(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                self.assertEqual(0, len(cls()))
                self.assertEqual(3, len(cls([1, 2, 3])))

    def test_set_get_item(self) -> None:
        for cls in self.array_types:
            with self.subTest("Get and set index", cls=cls):
                inst = cls([1, 2, 3])
                self.assertIsInstance(inst[0], numpy.signedinteger)
                self.assertEqual(1, inst[0])
                self.assertEqual(2, inst[1])
                self.assertEqual(3, inst[2])
                inst[1] = 10
                self.assertEqual(1, inst[0])
                self.assertEqual(10, inst[1])
                self.assertEqual(3, inst[2])

            with self.subTest("Get and set slice", cls=cls):
                inst = cls([1, 2, 3])
                self.assertIsInstance(inst[:], numpy.ndarray)
                numpy.testing.assert_array_equal([1, 2, 3], inst[:])
                numpy.testing.assert_array_equal([1, 3], inst[::2])
                inst[::2] = [4, 5]
                self.assertIsInstance(inst[:], numpy.ndarray)
                numpy.testing.assert_array_equal([4, 2, 5], inst[:])
                numpy.testing.assert_array_equal([4, 5], inst[::2])

    def test_asarray(self) -> None:
        for cls in self.array_types:
            with self.subTest(cls=cls):
                numpy.testing.assert_array_equal([], numpy.asarray(cls()))
                numpy.testing.assert_array_equal(
                    [-3, -2, -1, 0, 1, 2, 3],
                    numpy.asarray(cls([-3, -2, -1, 0, 1, 2, 3])),
                )

    def test_to_nbt(self):
        self.assertEqual(
            b"\x07\x00\x00\x00\x00\x00\x00",
            ByteArrayTag().to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x07\x00\x00\x00\x00\x00\x07\xFD\xFE\xFF\x00\x01\x02\x03",
            ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x07\x00\x00\x07\x00\x00\x00\xFD\xFE\xFF\x00\x01\x02\x03",
            ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=True
            ),
        )
        self.assertEqual(
            b"\x0B\x00\x00\x00\x00\x00\x00",
            IntArrayTag().to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0B\x00\x00\x00\x00\x00\x07\xFF\xFF\xFF\xFD\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x03",
            IntArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x0B\x00\x00\x07\x00\x00\x00\xFD\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x03\x00\x00\x00",
            IntArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=True
            ),
        )
        self.assertEqual(
            b"\x0C\x00\x00\x00\x00\x00\x00",
            LongArrayTag().to_nbt(compressed=False, little_endian=False),
        )
        self.assertEqual(
            b"\x0C\x00\x00\x00\x00\x00\x07\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x03",
            LongArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=False
            ),
        )
        self.assertEqual(
            b"\x0C\x00\x00\x07\x00\x00\x00\xFD\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00",
            LongArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_nbt(
                compressed=False, little_endian=True
            ),
        )


if __name__ == "__main__":
    unittest.main()
