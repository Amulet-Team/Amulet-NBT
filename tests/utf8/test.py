import unittest
from amulet_nbt._utf8 import mutf8_to_utf8, utf8_to_mutf8, utf8_to_utf8


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
                self.assertEqual(utf8_to_utf8(utf8), utf8)
                mutf8 = utf8_to_mutf8(utf8)
                if 0 < i < 65536:
                    self.assertEqual(mutf8, utf8)
                else:
                    self.assertEqual(utf8, mutf8_to_utf8(mutf8))

    def test_powers(self):
        for v, mutf8_true in (
            (0, b"\xC0\x80"),
            (1, b"\x01"),
            (2, b"\x02"),
            (4, b"\x04"),
            (8, b"\x08"),
            (16, b"\x10"),
            (32, b"\x20"),
            (64, b"\x40"),
            (128, b"\xc2\x80"),
            (256, b"\xc4\x80"),
            (512, b"\xc8\x80"),
            (1024, b"\xd0\x80"),
            (2048, b"\xe0\xa0\x80"),
            (4096, b"\xe1\x80\x80"),
            (8192, b"\xe2\x80\x80"),
            (16384, b"\xe4\x80\x80"),
            (32768, b"\xe8\x80\x80"),
            (65536, b"\xed\xa0\x80\xed\xb0\x80"),
            (131072, b"\xed\xa1\x80\xed\xb0\x80"),
            (262144, b"\xed\xa3\x80\xed\xb0\x80"),
            (524288, b"\xed\xa7\x80\xed\xb0\x80"),
            (1048576, b"\xed\xaf\x80\xed\xb0\x80"),
        ):
            with self.subTest(f"Character {v}"):
                utf8 = chr(v).encode()
                self.assertEqual(utf8_to_mutf8(utf8), mutf8_true)
                self.assertEqual(mutf8_to_utf8(mutf8_true), utf8)


if __name__ == "__main__":
    unittest.main()
