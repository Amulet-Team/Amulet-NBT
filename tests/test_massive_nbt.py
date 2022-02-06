import unittest
import numpy
import os
import amulet_nbt


class MassiveNBTTests(unittest.TestCase):
    def test_api(self):
        compound = amulet_nbt.CompoundTag()
        nbt_file = amulet_nbt.NBTFile(compound, name="hello")

        # the nbt objects with no inputs
        compound["emptyByte"] = amulet_nbt.ByteTag()
        compound["emptyShort"] = amulet_nbt.ShortTag()
        compound["emptyInt"] = amulet_nbt.IntTag()
        compound["emptyLong"] = amulet_nbt.LongTag()
        compound["emptyFloat"] = amulet_nbt.FloatTag()
        compound["emptyDouble"] = amulet_nbt.DoubleTag()
        compound["emptyByteArray"] = amulet_nbt.ByteArrayTag()
        compound["emptyString"] = amulet_nbt.StringTag()
        compound["emptyList"] = amulet_nbt.ListTag()
        compound["emptyCompound"] = amulet_nbt.CompoundTag()
        compound["emptyIntArray"] = amulet_nbt.IntArrayTag()
        compound["emptyLongArray"] = amulet_nbt.LongArrayTag()

        # the nbt objects with zero or empty inputs (pure python only)
        compound["zeroByte"] = amulet_nbt.ByteTag(0)
        compound["zeroShort"] = amulet_nbt.ShortTag(0)
        compound["zeroInt"] = amulet_nbt.IntTag(0)
        compound["zeroLong"] = amulet_nbt.LongTag(0)
        compound["zeroFloat"] = amulet_nbt.FloatTag(0)
        compound["zeroDouble"] = amulet_nbt.DoubleTag(0)
        compound["zeroByteArray"] = amulet_nbt.ByteArrayTag([])
        compound["zeroString"] = amulet_nbt.StringTag("")
        compound["zeroList"] = amulet_nbt.ListTag([])
        compound["zeroCompound"] = amulet_nbt.CompoundTag({})
        compound["zeroIntArray"] = amulet_nbt.IntArrayTag([])
        compound["zeroLongArray"] = amulet_nbt.LongArrayTag([])

        # empty inputs but numpy arrays for the array types
        compound["zeroNumpyByteArray"] = amulet_nbt.ByteArrayTag(numpy.array([]))
        compound["zeroNumpyIntArray"] = amulet_nbt.IntArrayTag(numpy.array([]))
        compound["zeroNumpyLongArray"] = amulet_nbt.LongArrayTag(numpy.array([]))

        # test the array types with some python data
        compound["listByteArray"] = amulet_nbt.ByteArrayTag(
            [i for i in range(-128, 127)]
        )
        compound["listIntArray"] = amulet_nbt.IntArrayTag([i for i in range(-400, 400)])
        compound["listLongArray"] = amulet_nbt.LongArrayTag(
            [i for i in range(-400, 400)]
        )

        # test the array types with numpy data of varying dtypes
        compound["numpyDtypeTestByteArray"] = amulet_nbt.ByteArrayTag(
            numpy.array([i for i in range(-128, 127)], dtype=int)
        )
        compound["numpyDtypeuTestByteArray"] = amulet_nbt.ByteArrayTag(
            numpy.array([i for i in range(-128, 127)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestIntArray"] = amulet_nbt.IntArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestIntArray"] = amulet_nbt.IntArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestLongArray"] = amulet_nbt.LongArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestLongArray"] = amulet_nbt.LongArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )

        compound["numpyDtypedTestByteArray"] = amulet_nbt.ByteArrayTag(
            numpy.array([i for i in range(-128, 127)])
        )
        compound["numpyDtypedTestIntArray"] = amulet_nbt.IntArrayTag(
            numpy.array([i for i in range(-400, 400)])
        )
        compound["numpyDtypedTestLongArray"] = amulet_nbt.LongArrayTag(
            numpy.array([i for i in range(-400, 400)])
        )

        # test the extremes of the array types
        # byte array tested above
        compound["numpyExtremeTestIntArray"] = amulet_nbt.IntArrayTag(
            numpy.array([-(2 ** 31), (2 ** 31) - 1], dtype=int)
        )
        compound["numpyExtremeTestLongArray"] = amulet_nbt.LongArrayTag(
            numpy.array([-(2 ** 63), (2 ** 63) - 1], dtype="q")
        )

        compound["minByte"] = amulet_nbt.ByteTag(-128)
        compound["minShort"] = amulet_nbt.ShortTag(-(2 ** 15))
        compound["minInt"] = amulet_nbt.IntTag(-(2 ** 31))
        compound["minLong"] = amulet_nbt.LongTag(-(2 ** 63))

        compound["maxByte"] = amulet_nbt.ByteTag(127)
        compound["maxShort"] = amulet_nbt.ShortTag(2 ** 15 - 1)
        compound["maxInt"] = amulet_nbt.IntTag(2 ** 31 - 1)
        compound["maxLong"] = amulet_nbt.LongTag(2 ** 63 - 1)

        # these should either overflow when setting or error when saving. Test each and if it errors just comment it out
        compound["overflowByte"] = amulet_nbt.ByteTag(300)
        compound["underflowByte"] = amulet_nbt.ByteTag(-300)
        compound["overflowShort"] = amulet_nbt.ShortTag(2 ** 16)
        compound["underflowShort"] = amulet_nbt.ShortTag(-(2 ** 16))
        compound["overflowInt"] = amulet_nbt.IntTag(2 ** 32)
        compound["underflowInt"] = amulet_nbt.IntTag(-(2 ** 32))
        compound["overflowLong"] = amulet_nbt.LongTag(2 ** 64)
        compound["underflowLong"] = amulet_nbt.LongTag(-(2 ** 64))

        # compound['overflowByteArray'] = amulet_nbt.ByteArrayTag([-129, 128])
        # compound['overflowIntArray'] = amulet_nbt.IntArrayTag([-2**31-1, 2**31])
        # compound['overflowLongArray'] = amulet_nbt.LongArrayTag([-2**63-1, 2**63])

        # compound['overflowNumpyByteArray'] = amulet_nbt.ByteArrayTag(numpy.array([-129, 128]))
        # compound['overflowNumpyIntArray'] = amulet_nbt.IntArrayTag(numpy.array([-2**31-1, 2**31]))
        # compound['overflowNumpyLongArray'] = amulet_nbt.LongArrayTag(numpy.array([-2**63-1, 2**63]))

        # save then load back up and check the data matches

        os.makedirs("temp", exist_ok=True)
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian.nbt"),
            compressed=False,
        )
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt"),
            compressed=True,
        )
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            compressed=False,
            little_endian=True,
        )

        test_be = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_big_endian.nbt")
        )
        test_be_compressed = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt")
        )
        test_le = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            little_endian=True,
        )

        self.assertEqual(test_be, nbt_file)
        self.assertEqual(test_be_compressed, nbt_file)
        self.assertEqual(test_le, nbt_file)


if __name__ == "__main__":
    unittest.main()
