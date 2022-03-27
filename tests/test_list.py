import unittest
from tests import base_type_test

from amulet_nbt import (
    BaseNumericTag,
    BaseArrayTag,
    StringTag,
    ListTag,
)


class TestList(base_type_test.BaseTypeTest):
    this_types = (ListTag,)

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
            self.assertEqual(ListTag(lval), ListTag(lval))
        for tag_cls1 in self.nbt_types:
            for tag_cls2 in self.nbt_types:
                tag1 = ListTag([tag_cls1() for _ in range(5)])
                tag2 = ListTag([tag_cls2() for _ in range(5)])
                if tag_cls1 is tag_cls2:
                    self.assertEqual(tag1, tag2)
                else:
                    self.assertNotEqual(tag1, tag2)

    def test_list(self):
        # initialisation with and appending not nbt objects
        tag_list = ListTag()
        for not_nbt in self.not_nbt:
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                ListTag([not_nbt])
            with self.assertRaises(TypeError, msg=repr(not_nbt)):
                tag_list.append(not_nbt)

        # initialisation with different nbt objects
        for nbt_type1 in self.nbt_types:
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    ListTag([nbt_type1(), nbt_type2()])
                else:
                    with self.assertRaises(TypeError):
                        ListTag([nbt_type1(), nbt_type2()]),

        # adding different nbt objects
        for nbt_type1 in self.nbt_types:
            tag_list = ListTag([nbt_type1()])
            for nbt_type2 in self.nbt_types:
                if nbt_type1 is nbt_type2:
                    tag_list.append(nbt_type2())
                else:
                    with self.assertRaises(TypeError):
                        tag_list.append(nbt_type2())

    def test_append(self):
        for dtype in self.nbt_types:
            l = ListTag()
            l.append(dtype())
            self.assertEqual(l, ListTag([dtype()]))
        for dtype1 in self.nbt_types:
            for dtype2 in self.nbt_types:
                l = ListTag([dtype1()])
                if dtype1 is dtype2:
                    l.append(dtype2())
                else:
                    with self.assertRaises(TypeError):
                        l.append(dtype2())
        l = ListTag()
        for obj in self.not_nbt:
            with self.assertRaises(TypeError):
                l.append(obj)

    def test_clear(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l.clear()
        self.assertEqual(l, ListTag())

    def test_count(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        self.assertEqual(l.count(StringTag("val1")), 1)
        self.assertEqual(l.count(StringTag("val2")), 2)
        for obj in self.not_nbt:
            self.assertEqual(l.count(obj), 0)

    def test_extend(self):
        l = ListTag()
        for obj in self.not_nbt:
            if obj not in ([], {}, set()):
                with self.assertRaises(TypeError, msg=obj):
                    l.extend(obj)
            with self.assertRaises(TypeError, msg=obj):
                l.extend([obj])
        l.extend([StringTag("val1"), StringTag("val2")])
        l.extend([StringTag("val2")])
        self.assertEqual(
            l, ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        )

    def test_index(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val2")])
        self.assertEqual(l.index(StringTag("val2")), 1)
        with self.assertRaises(ValueError):
            l.index(StringTag("val3"))

    def test_insert(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l.insert(1, StringTag("val2"))
        for obj in self.not_nbt:
            with self.assertRaises(TypeError):
                l.insert(1, obj)

    def test_pop(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        self.assertEqual(l.pop(), StringTag("val3"))
        self.assertEqual(l, ListTag([StringTag("val1"), StringTag("val2")]))
        self.assertEqual(l.pop(0), StringTag("val1"))
        self.assertEqual(l, ListTag([StringTag("val2")]))

    def test_remove(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l.remove(StringTag("val3"))
        self.assertEqual(l, ListTag([StringTag("val1"), StringTag("val2")]))
        l.remove(StringTag("val1"))
        self.assertEqual(l, ListTag([StringTag("val2")]))

    def test_reverse(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l.reverse()
        self.assertEqual(
            l, ListTag([StringTag("val3"), StringTag("val2"), StringTag("val1")])
        )

    def test_iadd(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l += [StringTag("val4")]
        self.assertIsInstance(l, ListTag)
        self.assertEqual(
            ListTag(
                [
                    StringTag("val1"),
                    StringTag("val2"),
                    StringTag("val3"),
                    StringTag("val4"),
                ]
            ),
            l,
        )
        l += ListTag([StringTag("val5")])
        self.assertIsInstance(l, ListTag)
        self.assertEqual(
            ListTag(
                [
                    StringTag("val1"),
                    StringTag("val2"),
                    StringTag("val3"),
                    StringTag("val4"),
                    StringTag("val5"),
                ]
            ),
            l,
        )

    def test_contains(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        self.assertIn(StringTag("val1"), l)
        self.assertNotIn(StringTag("val4"), l)
        for not_nbt in self.not_nbt:
            self.assertNotIn(not_nbt, l)
        for tag_cls1 in self.nbt_types:
            tag = ListTag([tag_cls1()])
            for tag_cls2 in self.nbt_types:
                if tag_cls1 is tag_cls2:
                    self.assertIn(tag_cls2(), tag)
                else:
                    self.assertNotIn(tag_cls2(), tag)

    def test_del(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        del l[:2]
        self.assertEqual(l, ListTag([StringTag("val3")]))
        del l[0]
        self.assertEqual(l, ListTag())

    def test_getitem(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        self.assertEqual(l[:2], [StringTag("val1"), StringTag("val2")])
        self.assertEqual(l[5:], [])
        self.assertEqual(l[2], StringTag("val3"))

    def test_setitem(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        l[1] = StringTag("val4")
        self.assertEqual(
            l, ListTag([StringTag("val1"), StringTag("val4"), StringTag("val3")])
        )
        l[:] = [StringTag("val5"), StringTag("val6"), StringTag("val7")]
        self.assertEqual(
            l, ListTag([StringTag("val5"), StringTag("val6"), StringTag("val7")])
        )
        l[3:] = [StringTag("val8")]
        self.assertEqual(
            l,
            ListTag(
                [
                    StringTag("val5"),
                    StringTag("val6"),
                    StringTag("val7"),
                    StringTag("val8"),
                ]
            ),
        )

    def test_iter(self):
        l = ListTag([StringTag("val1"), StringTag("val2"), StringTag("val3")])
        it = iter(l)
        self.assertEqual(next(it), StringTag("val1"))
        self.assertEqual(next(it), StringTag("val2"))
        self.assertEqual(next(it), StringTag("val3"))
        with self.assertRaises(StopIteration):
            next(it)


if __name__ == "__main__":
    unittest.main()
