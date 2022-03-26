{{py:from template import include}}
{{include("BaseImmutableTag.pyx", cls_name=cls_name)}}

    def __repr__({{cls_name}} self):
        return f"{self.__class__.__name__}({self.value_})"

    def __int__({{cls_name}} self):
        return self.value_.__int__()

    def __float__({{cls_name}} self):
        return self.value_.__float__()

    def __bool__({{cls_name}} self):
        return self.value_.__bool__()