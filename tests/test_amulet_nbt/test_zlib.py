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
    def test_zlib(self) -> None:
        src = os.urandom(10_000_000)
        cpp_compressed = compress_zlib(src)
        py_decompressed = zlib.decompress(cpp_compressed)
        self.assertEqual(src, py_decompressed)
        cpp_decompressed = decompress_zlib_gzip(cpp_compressed)
        self.assertEqual(src, cpp_decompressed)

    def test_gzip(self) -> None:
        src = os.urandom(10_000_000)
        cpp_compressed = compress_gzip(src)
        py_decompressed = gzip.decompress(cpp_compressed)
        self.assertEqual(src, py_decompressed)
        cpp_decompressed = decompress_zlib_gzip(cpp_compressed)
        self.assertEqual(src, cpp_decompressed)
