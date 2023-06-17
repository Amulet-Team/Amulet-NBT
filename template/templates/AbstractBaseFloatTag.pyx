{{py:from template import include}}
{{include("AbstractBaseNumericTag.pyx", **locals())}}

    @property
    def py_float({{cls_name}} self) -> float:
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.value_