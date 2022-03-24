{{py:from template import include}}
{{include("BaseTag.pyx", cls_name=cls_name)}}

    @property
    def py_data({{cls_name}} self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)