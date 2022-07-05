import unittest
import numpy
import os
from amulet_nbt import (
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    NamedTag,
    load,
)


class MassiveNBTTests(unittest.TestCase):
    def test_api(self):
        compound = CompoundTag()
        named_compound = NamedTag(compound, name="hello")

        # the nbt objects with no inputs
        compound["emptyByte"] = ByteTag()
        compound["emptyShort"] = ShortTag()
        compound["emptyInt"] = IntTag()
        compound["emptyLong"] = LongTag()
        compound["emptyFloat"] = FloatTag()
        compound["emptyDouble"] = DoubleTag()
        compound["emptyByteArray"] = ByteArrayTag()
        compound["emptyString"] = StringTag()
        compound["emptyList"] = ListTag()
        compound["emptyCompound"] = CompoundTag()
        compound["emptyIntArray"] = IntArrayTag()
        compound["emptyLongArray"] = LongArrayTag()

        # the nbt objects with zero or empty inputs (pure python only)
        compound["zeroByte"] = ByteTag(0)
        compound["zeroShort"] = ShortTag(0)
        compound["zeroInt"] = IntTag(0)
        compound["zeroLong"] = LongTag(0)
        compound["zeroFloat"] = FloatTag(0)
        compound["zeroDouble"] = DoubleTag(0)
        compound["zeroByteArray"] = ByteArrayTag([])
        compound["zeroString"] = StringTag("")
        compound["zeroList"] = ListTag([])
        compound["zeroCompound"] = CompoundTag({})
        compound["zeroIntArray"] = IntArrayTag([])
        compound["zeroLongArray"] = LongArrayTag([])

        # empty inputs but numpy arrays for the array types
        compound["zeroNumpyByteArray"] = ByteArrayTag(numpy.array([]))
        compound["zeroNumpyIntArray"] = IntArrayTag(numpy.array([]))
        compound["zeroNumpyLongArray"] = LongArrayTag(numpy.array([]))

        # test the array types with some python data
        compound["listByteArray"] = ByteArrayTag([i for i in range(-128, 127)])
        compound["listIntArray"] = IntArrayTag([i for i in range(-400, 400)])
        compound["listLongArray"] = LongArrayTag([i for i in range(-400, 400)])

        # test the array types with numpy data of varying dtypes
        compound["numpyDtypeTestByteArray"] = ByteArrayTag(
            numpy.array([i for i in range(-128, 127)], dtype=int)
        )
        compound["numpyDtypeuTestByteArray"] = ByteArrayTag(
            numpy.array([i for i in range(-128, 127)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestIntArray"] = IntArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestIntArray"] = IntArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestLongArray"] = LongArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestLongArray"] = LongArrayTag(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )

        compound["numpyDtypedTestByteArray"] = ByteArrayTag(
            numpy.array([i for i in range(-128, 127)])
        )
        compound["numpyDtypedTestIntArray"] = IntArrayTag(
            numpy.array([i for i in range(-400, 400)])
        )
        compound["numpyDtypedTestLongArray"] = LongArrayTag(
            numpy.array([i for i in range(-400, 400)])
        )

        # test the extremes of the array types
        # byte array tested above
        compound["numpyExtremeTestIntArray"] = IntArrayTag(
            numpy.array([-(2**31), (2**31) - 1], dtype=int)
        )
        compound["numpyExtremeTestLongArray"] = LongArrayTag(
            numpy.array([-(2**63), (2**63) - 1], dtype="q")
        )

        compound["minByte"] = ByteTag(-128)
        compound["minShort"] = ShortTag(-(2**15))
        compound["minInt"] = IntTag(-(2**31))
        compound["minLong"] = LongTag(-(2**63))

        compound["maxByte"] = ByteTag(127)
        compound["maxShort"] = ShortTag(2**15 - 1)
        compound["maxInt"] = IntTag(2**31 - 1)
        compound["maxLong"] = LongTag(2**63 - 1)

        # these should either overflow when setting or error when saving. Test each and if it errors just comment it out
        compound["overflowByte"] = ByteTag(300)
        compound["underflowByte"] = ByteTag(-300)
        compound["overflowShort"] = ShortTag(2**16)
        compound["underflowShort"] = ShortTag(-(2**16))
        compound["overflowInt"] = IntTag(2**32)
        compound["underflowInt"] = IntTag(-(2**32))
        compound["overflowLong"] = LongTag(2**64)
        compound["underflowLong"] = LongTag(-(2**64))

        # compound['overflowByteArray'] = ByteArrayTag([-129, 128])
        # compound['overflowIntArray'] = IntArrayTag([-2**31-1, 2**31])
        # compound['overflowLongArray'] = LongArrayTag([-2**63-1, 2**63])

        # compound['overflowNumpyByteArray'] = ByteArrayTag(numpy.array([-129, 128]))
        # compound['overflowNumpyIntArray'] = IntArrayTag(numpy.array([-2**31-1, 2**31]))
        # compound['overflowNumpyLongArray'] = LongArrayTag(numpy.array([-2**63-1, 2**63]))

        # save then load back up and check the data matches

        os.makedirs("temp", exist_ok=True)
        named_compound.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian.nbt"),
            compressed=False,
        )
        named_compound.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt"),
            compressed=True,
        )
        named_compound.save_to(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            compressed=False,
            little_endian=True,
        )

        test_be = load(os.path.join("temp", "massive_nbt_test_big_endian.nbt"))
        test_be_compressed = load(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt")
        )
        test_le = load(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            little_endian=True,
        )

        self.assertEqual(test_be, named_compound)
        self.assertEqual(test_be_compressed, named_compound)
        self.assertEqual(test_le, named_compound)


if __name__ == "__main__":
    unittest.main()
