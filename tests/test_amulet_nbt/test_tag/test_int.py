import copy
import pickle
import itertools
import unittest
import faulthandler

faulthandler.enable()

from .test_numeric import AbstractBaseNumericTagTestCase
from amulet_nbt import AbstractBaseTag, AbstractBaseImmutableTag, AbstractBaseNumericTag, AbstractBaseIntTag


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


if __name__ == "__main__":
    unittest.main()
