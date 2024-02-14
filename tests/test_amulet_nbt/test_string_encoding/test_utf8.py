import unittest
from amulet_nbt import mutf8_encoding, utf8_encoding


class TestUTF(unittest.TestCase):
    def test_range(self):
        """For every valid UTF-8 character try encoding and decoding."""
        for i in range(1114112):
            c = chr(i)
            try:
                utf8 = c.encode()
            except Exception:
                pass
            else:
                self.assertEqual(utf8_encoding.encode(utf8), utf8)
                self.assertEqual(utf8_encoding.decode(utf8), utf8)
                mutf8 = mutf8_encoding.encode(utf8)
                if 0 < i < 65536:
                    self.assertEqual(mutf8, utf8)
                else:
                    self.assertEqual(utf8, mutf8_encoding.decode(mutf8))

    def test_powers(self):
        for v, mutf8_true_bin in (
            (0, [0b11000000, 0b10000000]),
            (1, [0b00000001]),
            (2, [0b00000010]),
            (4, [0b00000100]),
            (8, [0b00001000]),
            (16, [0b00010000]),
            (32, [0b00100000]),
            (64, [0b01000000]),
            (128, [0b11000010, 0b10000000]),
            (256, [0b11000100, 0b10000000]),
            (512, [0b11001000, 0b10000000]),
            (1024, [0b11010000, 0b10000000]),
            (2048, [0b11100000, 0b10100000, 0b10000000]),
            (4096, [0b11100001, 0b10000000, 0b10000000]),
            (8192, [0b11100010, 0b10000000, 0b10000000]),
            (16384, [0b11100100, 0b10000000, 0b10000000]),
            (32768, [0b11101000, 0b10000000, 0b10000000]),
            (
                65536,
                [
                    0b11101101,
                    0b10100000,
                    0b10000000,
                    0b11101101,
                    0b10110000,
                    0b10000000,
                ],
            ),
            (
                131072,
                [
                    0b11101101,
                    0b10100001,
                    0b10000000,
                    0b11101101,
                    0b10110000,
                    0b10000000,
                ],
            ),
            (
                262144,
                [
                    0b11101101,
                    0b10100011,
                    0b10000000,
                    0b11101101,
                    0b10110000,
                    0b10000000,
                ],
            ),
            (
                524288,
                [
                    0b11101101,
                    0b10100111,
                    0b10000000,
                    0b11101101,
                    0b10110000,
                    0b10000000,
                ],
            ),
            (
                1048576,
                [
                    0b11101101,
                    0b10101111,
                    0b10000000,
                    0b11101101,
                    0b10110000,
                    0b10000000,
                ],
            ),
        ):
            mutf8_true = bytes(mutf8_true_bin)
            with self.subTest(f"Character {v}"):
                utf8 = chr(v).encode()
                self.assertEqual(mutf8_encoding.encode(utf8), mutf8_true)
                self.assertEqual(mutf8_encoding.decode(mutf8_true), utf8)


if __name__ == "__main__":
    unittest.main()
