import os
import unittest
import amulet_nbt

TESTS_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(TESTS_DIR, "src")


class FileNBTTests(unittest.TestCase):
    def setUp(self):
        self.maxDiff = None

        def _open_snbt(path_):
            if os.path.isfile(path_):
                with open(path_, encoding="utf-8") as f_:
                    snbt = f_.read()
            else:
                snbt = path_
            return amulet_nbt.NBTFile(amulet_nbt.from_snbt(snbt))

        self._groups = (
            (
                "big_endian_compressed_nbt",
                lambda path_: amulet_nbt.load(
                    path_, compressed=True, little_endian=False
                ),
                lambda obj_: obj_.save_to(compressed=True, little_endian=False),
            ),
            (
                "big_endian_nbt",
                lambda path_: amulet_nbt.load(
                    path_, compressed=False, little_endian=False
                ),
                lambda obj_: obj_.save_to(compressed=False, little_endian=False),
            ),
            (
                "little_endian_nbt",
                lambda path_: amulet_nbt.load(
                    path_, compressed=False, little_endian=True
                ),
                lambda obj_: obj_.save_to(compressed=False, little_endian=True),
            ),
            (
                "snbt",
                _open_snbt,
                lambda obj_: obj_.value.to_snbt("    "),
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
                self.assertIsInstance(data, amulet_nbt.NBTFile)
                self.assertIsInstance(data.value, amulet_nbt.TAG_Compound)
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


if __name__ == "__main__":
    unittest.main()
