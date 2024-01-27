from abc import ABC, abstractmethod
import faulthandler
faulthandler.enable()

from .test_abc import AbstractBaseImmutableTagTestCase


class AbstractBaseNumericTagTestCase(AbstractBaseImmutableTagTestCase, ABC):
    @abstractmethod
    def test_int(self):
        raise NotImplementedError

    @abstractmethod
    def test_float(self):
        raise NotImplementedError

    @abstractmethod
    def test_bool(self):
        raise NotImplementedError

    @abstractmethod
    def test_numerical_operators(self):
        raise NotImplementedError
