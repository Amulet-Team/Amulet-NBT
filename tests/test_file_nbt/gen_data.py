import glob
import os
import amulet_nbt

datas = {
    "big_endian_nbt": (False),
    "little_endian_nbt": (),
    "snbt": (),
}


def main():
    data_dir = os.path.join(os.path.dirname(__file__), "src")
    input_dir = os.path.join(data_dir, "big_endian_compressed_nbt")

    for path in glob.glob(os.path.join(input_dir, "*.nbt")):
        fname = os.path.splitext(os.path.basename(path))[0]
        nbt = amulet_nbt.load(path)
        nbt.save_to(
            os.path.join(data_dir, "big_endian_nbt", fname + ".nbt"),
            compressed=False,
            little_endian=False,
        )
        nbt.save_to(
            os.path.join(data_dir, "little_endian_nbt", fname + ".nbt"),
            compressed=False,
            little_endian=True,
        )
        with open(
            os.path.join(data_dir, "snbt", fname + ".snbt"), "w", encoding="utf-8"
        ) as f:
            f.write(nbt.to_snbt("    "))


if __name__ == "__main__":
    main()
