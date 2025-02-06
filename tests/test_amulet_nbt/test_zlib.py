from unittest import TestCase
import zlib
import gzip
import os

from tests.test_amulet_nbt.test_zlib_ import (
    decompress_zlib_gzip,
    compress_zlib,
    compress_gzip,
)


class ZlibTest(TestCase):
    def test_zlib_compress(self) -> None:
        src = os.urandom(10_000_000)
        compressed = compress_zlib(src)
        self.assertEqual(src, zlib.decompress(compressed))

    def test_zlib_decompress(self) -> None:
        src = os.urandom(10_000_000)
        compressed = zlib.compress(src)
        self.assertEqual(src, decompress_zlib_gzip(compressed))

    def test_gzip_compress(self) -> None:
        src = os.urandom(10_000_000)
        compressed = compress_gzip(src)
        self.assertEqual(src, gzip.decompress(compressed))

    def test_gzip_decompress(self) -> None:
        src = os.urandom(10_000_000)
        compressed = gzip.compress(src)
        self.assertEqual(src, decompress_zlib_gzip(compressed))
