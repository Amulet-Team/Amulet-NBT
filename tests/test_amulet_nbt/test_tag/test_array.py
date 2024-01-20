from unittest import TestCase
from .test_abc import AbstractBaseMutableTagTestCase


class AbstractBaseArrayTagTestCase(AbstractBaseMutableTagTestCase, TestCase):
    pass


class ByteArrayTagTestCase(AbstractBaseArrayTagTestCase, TestCase):
    pass


class IntArrayTagTestCase(AbstractBaseArrayTagTestCase, TestCase):
    pass


class LongArrayTagTestCase(AbstractBaseArrayTagTestCase, TestCase):
    pass
