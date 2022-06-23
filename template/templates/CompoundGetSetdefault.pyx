{{py:
try:
    py_tag_cls_name
except:
    py_tag_cls_name = tag_cls_name
}}
    cpdef {{tag_cls_name}} get_{{tag_name}}(self, str key, {{tag_cls_name}} default=None):
        """Get the tag stored in key if it is a {{tag_cls_name}}.
    
        :param key: The key to get
        :param default: The value to return if the key does not exist or the type is wrong. If not defined errors are raised.
        :return: The {{tag_cls_name}}.
        :raises: KeyError if the key does not exist
        :raises: TypeError if the stored type is not a {{tag_cls_name}}
        """
        if key not in self:
            if default is None:
                raise KeyError(key)
            else:
                return default

        tag = self[key]
        if isinstance(tag, {{tag_cls_name}}):
            return tag
        elif default is None:
            raise TypeError(f"Expected tag to be of type {{tag_cls_name}} but got {type(tag)}")
        else:
            return default

    cpdef {{tag_cls_name}} setdefault_{{tag_name}}(self, str key, {{tag_cls_name}} default=None):
        """Populate key if not defined or value is not {{tag_cls_name}}. Return the value stored.
    
        If default is a {{tag_cls_name}} then it will be stored under key else a default instance will be created.
        :param key: The key to populate and get
        :param default: The default value to use
        :return: The {{tag_cls_name}} stored in key
        :raises: TypeError if the input types are incorrect
        """
        val = self[key] if key in self else None
        if not isinstance(val, {{tag_cls_name}}):
            val = self[key] = {{py_tag_cls_name}}() if default is None else default
        return val
