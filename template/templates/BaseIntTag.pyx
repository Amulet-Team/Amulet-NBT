{{py:from template import include, gen_wrapper}}
{{gen_wrapper(
    "value_",
    int,
    [
        # "as_integer_ratio",  # added in 3.8
        "bit_length",
        "denominator",
        "imag",
        "numerator",
        "real",
        "to_bytes",
    ]
)}}
    if sys.version_info >= (3, 8):
        def as_integer_ratio(self):
            return self.value_.as_integer_ratio()
        as_integer_ratio.__doc__ = int.as_integer_ratio.__doc__

    def conjugate(self):
        return self.value_.conjugate()
    conjugate.__doc__ = int.conjugate.__doc__

{{include("BaseNumericTag.pyx", cls_name=cls_name)}}

    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        bint signed = False
    ) -> {{cls_name}}:
        return {{cls_name}}(int.from_bytes(bytes, byteorder, signed))

    def __and__({{cls_name}} self, other):
        return self.value_ & other

    def __rand__({{cls_name}} self, other):
        return other & self.value_

    def __iand__({{cls_name}} self, other):
        res = self & other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __xor__({{cls_name}} self, other):
        return self.value_ ^ other

    def __rxor__({{cls_name}} self, other):
        return other ^ self.value_

    def __ixor__({{cls_name}} self, other):
        res = self ^ other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __or__({{cls_name}} self, other):
        return self.value_ | other

    def __ror__({{cls_name}} self, other):
        return other | self.value_

    def __ior__({{cls_name}} self, other):
        res = self | other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __lshift__({{cls_name}} self, other):
        return self.value_ << other

    def __rlshift__({{cls_name}} self, other):
        return other << self.value_

    def __ilshift__({{cls_name}} self, other):
        res = self << other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __rshift__({{cls_name}} self, other):
        return self.value_ >> other

    def __rrshift__({{cls_name}} self, other):
        return other >> self.value_

    def __irshift__({{cls_name}} self, other):
        res = self >> other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __invert__({{cls_name}} self):
        return self.value_.__invert__()

    def __index__({{cls_name}} self) -> int:
        return self.value_.__index__()