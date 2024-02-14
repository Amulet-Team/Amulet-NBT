from abc import ABC, abstractmethod
import faulthandler

faulthandler.enable()

from .test_abc import AbstractBaseImmutableTagTestCase


class AbstractBaseNumericTagTestCase(AbstractBaseImmutableTagTestCase, ABC):
    @abstractmethod
    def test_int(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_float(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_bool(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def test_numerical_operators(self) -> None:
        raise NotImplementedError
