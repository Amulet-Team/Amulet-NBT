{{py:from template import include}}
{{include("BaseTag.pyx", cls_name=cls_name)}}

    @property
    def py_data({{cls_name}} self):
        """
        The python representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.value_

    def __hash__({{cls_name}} self):
        return hash((self.tag_id, self.value_))

    def __ge__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented