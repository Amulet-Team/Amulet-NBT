{{py:from template import include}}
{{include("BaseTag.pyx", cls_name=cls_name)}}

    def __hash__({{cls_name}} self):
        return hash((self.tag_id, self.value_))

    @property
    def py_data({{cls_name}} self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_