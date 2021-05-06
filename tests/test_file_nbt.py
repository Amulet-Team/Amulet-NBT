import os
import unittest

import amulet_nbt.amulet_nbt_py as pynbt

try:
    import amulet_nbt.amulet_cy_nbt as cynbt
except (ImportError, ModuleNotFoundError) as e:
    cynbt = None

TESTS_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(TESTS_DIR, "data")


class AbstractNBTTest:
    class FileNBTTests(unittest.TestCase):
        def _setUp(self, nbt_library):
            self.maxDiff = None
            self.nbt = nbt_library

            def _open_snbt(path_):
                if os.path.isfile(path_):
                    with open(path_, encoding="utf-8") as f_:
                        snbt = f_.read()
                else:
                    snbt = path_
                return self.nbt.NBTFile(self.nbt.from_snbt(snbt))

            self._groups = (
                (
                    "big_endian_compressed_nbt",
                    lambda path_: self.nbt.load(
                        path_, compressed=True, little_endian=False
                    ),
                    lambda obj_: obj_.save_to(compressed=True, little_endian=False),
                ),
                (
                    "big_endian_nbt",
                    lambda path_: self.nbt.load(
                        path_, compressed=False, little_endian=False
                    ),
                    lambda obj_: obj_.save_to(compressed=False, little_endian=False),
                ),
                (
                    "little_endian_nbt",
                    lambda path_: self.nbt.load(
                        path_, compressed=False, little_endian=True
                    ),
                    lambda obj_: obj_.save_to(compressed=False, little_endian=True),
                ),
                (
                    "snbt",
                    _open_snbt,
                    lambda obj_: obj_.value.to_snbt(indent_chr="    "),
                ),
            )

        def test_load_nbt(self):
            # read in all the data
            group_data = {}
            for group1, load1, _ in self._groups:
                for path1 in os.listdir(os.path.join(DATA_DIR, group1)):
                    name = os.path.splitext(path1)[0]
                    try:
                        data = load1(os.path.join(DATA_DIR, group1, path1))
                    except Exception as e_:
                        print(group1, path1)
                        raise e_
                    self.assertIsInstance(data, self.nbt.NBTFile)
                    self.assertIsInstance(data.value, self.nbt.TAG_Compound)
                    group_data.setdefault(name, {})[group1] = data

            # compare to all the other loaded data
            for name, name_data in group_data.items():
                for group1, _, _ in self._groups:
                    for group2, _, _ in self._groups:
                        if group1 == "snbt" or group2 == "snbt":
                            self.assertEqual(
                                name_data[group1].value,
                                name_data[group2].value,
                                f"{group1} {group2} {name}",
                            )
                        else:
                            self.assertEqual(
                                name_data[group1],
                                name_data[group2],
                                f"{group1} {group2} {name}",
                            )

            for name, name_data in group_data.items():
                for group1, load, save in self._groups:
                    data = name_data[group1]
                    self.assertEqual(data, load(save(data)), f"{group1} {name}")


@unittest.skipUnless(cynbt, "Cythonized library not available")
class CythonNBTTest(AbstractNBTTest.FileNBTTests):
    def setUp(self):
        self._setUp(cynbt)


class PythonNBTTest(AbstractNBTTest.FileNBTTests):
    def setUp(self):
        self._setUp(pynbt)


@unittest.skipUnless(cynbt, "Cythonized library not available")
class CrossCompatabilityTest(unittest.TestCase):
    def setUp(self):
        self.cy_level_root_tag = cynbt.load(
            os.path.join(DATA_DIR, "big_endian_compressed_nbt", "J1_13_level.nbt")
        )
        self.py_level_root_tag = pynbt.load(
            os.path.join(DATA_DIR, "big_endian_compressed_nbt", "J1_13_level.nbt")
        )

    def test_cross_saving_and_loading(self):

        cy_data = self.cy_level_root_tag.save_to()

        cy_to_py_root_tag = pynbt.load(cy_data)

        self.assertEqual(self.py_level_root_tag, cy_to_py_root_tag)

        py_data = self.py_level_root_tag.save_to()

        py_to_cy_root_tag = cynbt.load(py_data)

        self.assertEqual(self.cy_level_root_tag, py_to_cy_root_tag)

    def test_cross_to_snbt(self):
        self.assertEqual(
            self.cy_level_root_tag.to_snbt(), self.py_level_root_tag.to_snbt()
        )

    def test_cross_repr(self):
        self.maxDiff = None
        self.assertEqual(repr(self.cy_level_root_tag), repr(self.py_level_root_tag))


if __name__ == "__main__":
    unittest.main()
