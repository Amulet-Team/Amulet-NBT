import unittest
from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseIntTag,
    BaseFloatTag,
    BaseArrayTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestList(base_type_test.BaseTypeTest):
    this_types = (TAG_List,)

    @property
    def values(self):
        return (
            ([],)
            + tuple([cls()] for cls in self.nbt_types)
            + tuple([cls(), cls()] for cls in self.nbt_types)
        )

    def test_init(self):
        self._test_init(list, [], (str,))

    def test_equal(self):
        for tag_cls in self.nbt_types:
            lval = [tag_cls() for _ in range(5)]
            self.assertEqual(TAG_List(lval), lval)
            self.assertEqual(TAG_List(lval), TAG_List(lval))
        for tag_cls1 in self.nbt_types:
            for tag_cls2 in self.nbt_types:
                tag1 = TAG_List([tag_cls1() for _ in range(5)])
                tag2 = TAG_List([tag_cls2() for _ in range(5)])
                if (
                    (tag_cls1 is tag_cls2)
                    or (
                        issubclass(tag_cls1, BaseNumericTag)
                        and issubclass(tag_cls2, BaseNumericTag)
                    )
                    or (
                        issubclass(tag_cls1, (BaseArrayTag, TAG_List))
                        and issubclass(tag_cls2, (BaseArrayTag, TAG_List))
                    )
                ):
                    self.assertEqual(tag1, tag2)
                else:
                    self.assertNotEqual(tag1, tag2)

                if tag_cls1 is tag_cls2:
                    self.assertTrue(tag1.strict_equals(tag2))
                else:
                    self.assertFalse(tag1.strict_equals(tag2))

        # make sure numerical lists are equal to arrays
        num_list = [-3, -2, -1, 0, 1, 2, 3]
        for array_tag_cls in self.array_types:
            for num_tag_cls in self.numerical_types:
                self.assertEqual(
                    TAG_List([num_tag_cls(i) for i in num_list]),
                    array_tag_cls(num_list),
                )
                self.assertEqual(
                    array_tag_cls(num_list),
                    TAG_List([num_tag_cls(i) for i in num_list]),
                )
                self.assertNotEqual(
                    TAG_List([num_tag_cls(i) for i in reversed(num_list)]),
                    array_tag_cls(num_list),
                )
                self.assertNotEqual(
                    array_tag_cls(num_list),
                    TAG_List([num_tag_cls(i) for i in reversed(num_list)]),
                )

    def test_list(self):
        # initialisation with and appending not nbt objects
        tag_list = TAG_List()
        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                TAG_List([not_nbt])
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                tag_list.append(not_nbt)

        # initialisation with different nbt objects
        for nbt_type1 in self.nbt_types:
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    TAG_List([nbt_type1(), nbt_type2()])
                else:
                    with self.assertRaises(TypeError):
                        TAG_List([nbt_type1(), nbt_type2()]),

        # adding different nbt objects
        for nbt_type1 in self.nbt_types:
            tag_list = TAG_List([nbt_type1()])
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    tag_list.append(nbt_type2())
                else:
                    with self.assertRaises(TypeError):
                        tag_list.append(nbt_type2())

    def test_append(self):
        for dtype in self.nbt_types:
            l = TAG_List()
            l.append(dtype())
            self.assertEqual(l, [dtype()])
        for dtype1 in self.nbt_types:
            for dtype2 in self.nbt_types:
                l = TAG_List([dtype1()])
                if dtype1 is dtype2:
                    l.append(dtype2())
                else:
                    with self.assertRaises(TypeError):
                        l.append(dtype2())
        l = TAG_List()
        for obj in self.not_nbt:
            with self.assertRaises(TypeError):
                l.append(obj)

    def test_clear(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        l.clear()
        self.assertEqual(l, [])

    def test_count(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val2")])
        self.assertEqual(l.count(TAG_String("val1")), 1)
        self.assertEqual(l.count(TAG_String("val2")), 2)
        for obj in self.not_nbt:
            self.assertEqual(l.count(obj), 0)

    def test_extend(self):
        l = TAG_List()
        for obj in self.not_nbt:
            if obj not in ([], {}, set()):
                with self.assertRaises(TypeError, msg=obj):
                    l.extend(obj)
            with self.assertRaises(TypeError, msg=obj):
                l.extend([obj])
        l.extend([TAG_String("val1"), TAG_String("val2")])
        l.extend([TAG_String("val2")])
        self.assertEqual(
            l, [TAG_String("val1"), TAG_String("val2"), TAG_String("val2")]
        )

    def test_index(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val2")])
        self.assertEqual(l.index(TAG_String("val2")), 1)
        with self.assertRaises(ValueError):
            l.index(TAG_String("val3"))

    def test_insert(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        l.insert(1, TAG_String("val2"))
        for obj in self.not_nbt:
            with self.assertRaises(TypeError):
                l.insert(1, obj)

    def test_pop(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        self.assertEqual(l.pop(), TAG_String("val3"))
        self.assertEqual(l, [TAG_String("val1"), TAG_String("val2")])
        self.assertEqual(l.pop(0), TAG_String("val1"))
        self.assertEqual(l, [TAG_String("val2")])

    def test_remove(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        l.remove(TAG_String("val3"))
        self.assertEqual(l, [TAG_String("val1"), TAG_String("val2")])
        l.remove(TAG_String("val1"))
        self.assertEqual(l, [TAG_String("val2")])

    def test_reverse(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        l.reverse()
        self.assertEqual(
            l, [TAG_String("val3"), TAG_String("val2"), TAG_String("val1")]
        )

    def test_sort(self):
        l = TAG_List([TAG_String("val3"), TAG_String("val2"), TAG_String("val1")])
        l.sort()
        self.assertEqual(
            l, [TAG_String("val1"), TAG_String("val2"), TAG_String("val3")]
        )

    def test_add(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        pyl = l + [TAG_String("val4")]
        self.assertIsInstance(pyl, list)
        self.assertEqual(
            pyl,
            [
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val3"),
                TAG_String("val4"),
            ],
        )
        pyl = l + [TAG_String("val5")]
        self.assertIsInstance(pyl, list)
        self.assertEqual(
            pyl,
            [
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val3"),
                TAG_String("val5"),
            ],
        )

        self.assertIsInstance(l, TAG_List)
        self.assertEqual(
            l, [TAG_String("val1"), TAG_String("val2"), TAG_String("val3")]
        )

        l += [TAG_String("val4")]
        self.assertIsInstance(l, TAG_List)
        self.assertEqual(
            l,
            [
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val3"),
                TAG_String("val4"),
            ],
        )

        for tag_cls1 in self.nbt_types:
            for tag_cls2 in self.nbt_types:
                l = TAG_List([tag_cls1()])
                if tag_cls1 is tag_cls2:
                    l += [tag_cls2()]
                else:
                    with self.assertRaises(TypeError):
                        l += [tag_cls2()]

    def test_contains(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        self.assertIn(TAG_String("val1"), l)
        self.assertNotIn(TAG_String("val4"), l)
        for not_nbt in self.not_nbt:
            self.assertNotIn(not_nbt, l)
        for tag_cls1 in self.nbt_types:
            tag = TAG_List([tag_cls1()])
            for tag_cls2 in self.nbt_types:
                if tag_cls1 is tag_cls2:
                    self.assertIn(tag_cls2(), tag)
                else:
                    self.assertNotIn(tag_cls2(), tag)

    def test_del(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        del l[:2]
        self.assertEqual(l, [TAG_String("val3")])
        del l[0]
        self.assertEqual(l, [])

    def test_getitem(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        self.assertEqual(l[:2], [TAG_String("val1"), TAG_String("val2")])
        self.assertEqual(l[5:], [])
        self.assertEqual(l[2], TAG_String("val3"))

    def test_setitem(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        l[1] = TAG_String("val4")
        self.assertEqual(
            l, [TAG_String("val1"), TAG_String("val4"), TAG_String("val3")]
        )
        l[:] = [TAG_String("val5"), TAG_String("val6"), TAG_String("val7")]
        self.assertEqual(
            l, [TAG_String("val5"), TAG_String("val6"), TAG_String("val7")]
        )
        l[3:] = [TAG_String("val8")]
        self.assertEqual(
            l,
            [
                TAG_String("val5"),
                TAG_String("val6"),
                TAG_String("val7"),
                TAG_String("val8"),
            ],
        )

    def test_mul(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2")])
        self.assertEqual(
            l * 3,
            [
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val1"),
                TAG_String("val2"),
            ],
        )
        self.assertEqual(l, [TAG_String("val1"), TAG_String("val2")])
        l *= 3
        self.assertIsInstance(l, TAG_List)
        self.assertEqual(
            l,
            [
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val1"),
                TAG_String("val2"),
                TAG_String("val1"),
                TAG_String("val2"),
            ],
        )

    def test_iter(self):
        l = TAG_List([TAG_String("val1"), TAG_String("val2"), TAG_String("val3")])
        it = iter(l)
        self.assertEqual(next(it), TAG_String("val1"))
        self.assertEqual(next(it), TAG_String("val2"))
        self.assertEqual(next(it), TAG_String("val3"))
        with self.assertRaises(StopIteration):
            next(it)


if __name__ == "__main__":
    unittest.main()
