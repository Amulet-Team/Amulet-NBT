    @property
    def {{tag_name}}(self) -> {{tag_cls_name}}:
        """Get the tag if it is a {{tag_cls_name}}.

        :return: The {{tag_cls_name}}.
        :raises: TypeError if the stored type is not a {{tag_cls_name}}
        """
        cdef {{tag_cls_name}} tag = self.tag
        return tag
