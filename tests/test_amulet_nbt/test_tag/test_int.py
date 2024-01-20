from unittest import TestCase
from .test_numeric import AbstractBaseNumericTagTestCase


class AbstractBaseIntTagTestCase(AbstractBaseNumericTagTestCase):
    pass


class ByteTagTestCase(AbstractBaseIntTagTestCase, TestCase):
    pass


class ShortTagTestCase(AbstractBaseIntTagTestCase, TestCase):
    pass


class IntTagTestCase(AbstractBaseIntTagTestCase, TestCase):
    pass


class LongTagTestCase(AbstractBaseIntTagTestCase, TestCase):
    pass
