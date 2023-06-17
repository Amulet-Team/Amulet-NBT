{{py:from template import include}}
{{include("AbstractBaseNumericTag.pyx", **locals())}}

    @property
    def py_int({{cls_name}} self) -> int:
        """
        A python int representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.value_