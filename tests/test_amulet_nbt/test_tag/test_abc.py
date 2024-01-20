from unittest import TestCase
from abc import ABC, abstractmethod


class AbstractBaseTestCase(ABC):
    pass
    # @abstractmethod
    # def test_constructor(self):
    #     raise NotImplementedError


class AbstractBaseTagTestCase(AbstractBaseTestCase):
    pass


class AbstractBaseImmutableTagTestCase(AbstractBaseTagTestCase):
    pass


class AbstractBaseMutableTagTestCase(AbstractBaseTagTestCase):
    pass


class CreateAbstractTestCase(TestCase):
    pass
