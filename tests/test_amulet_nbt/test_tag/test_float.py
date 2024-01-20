from unittest import TestCase
from .test_numeric import AbstractBaseNumericTagTestCase


class AbstractBaseFloatTagTestCase(AbstractBaseNumericTagTestCase):
    pass


class FloatTagTestCase(AbstractBaseFloatTagTestCase, TestCase):
    def test_float(self):
        pass


class DoubleTagTestCase(AbstractBaseFloatTagTestCase, TestCase):
    pass
