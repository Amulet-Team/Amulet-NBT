from typing import Sequence
from inspect import signature, ismethod, Parameter
import warnings


Type = type(int)
WrapperDescriptor = type(int.__eq__)
MethodDescriptor = type(int.__floor__)
GetSetDescriptor = type(int.real)
BuiltInFunctionOrMethod = type(int.from_bytes)


def get_clean_docstring(obj, indent=1):
    warnings.warn("get_clean_docstring is depreciated", DeprecationWarning)
    indent_chr = "    " * indent
    return "\n".join(f"{indent_chr}{line}" for line in get_docstring(obj))


def _trim_docstring(docstring):
    if not docstring:
        return [""]
    # Convert tabs to spaces (following the normal Python rules)
    # and split into a list of lines:
    lines = docstring.expandtabs().splitlines()
    # Determine minimum indentation (first line doesn't count):
    indent = 2**30
    for line in lines[1:]:
        stripped = line.lstrip()
        if stripped:
            indent = min(indent, len(line) - len(stripped))
    # Remove indentation (first line is special):
    trimmed = [lines[0].strip()]
    if indent < 2**30:
        for line in lines[1:]:
            trimmed.append(line[indent:].rstrip())
    # Strip off trailing and leading blank lines:
    while trimmed and not trimmed[-1]:
        trimmed.pop()
    while trimmed and not trimmed[0]:
        trimmed.pop(0)
    return trimmed


def get_docstring(obj):
    docstring_list = _trim_docstring(obj.__doc__)
    if len(docstring_list) > 1:
        docstring = ['    """']
        for line in docstring_list:
            docstring.append(f"    {line}")
        docstring.append('    """')
    else:
        docstring = [f'    """{docstring_list[0]}"""']
    return docstring


def gen_wrapper(
    wrapped_name: str, wrapped_dtype, attrs: Sequence[str] = None, indent=4
):
    """
    Generate wrapper methods for a given type.

    :param wrapped_name: The attribute name of the wrapped data.
    :param wrapped_dtype: The dtype to generate the wrapper for.
    :param attrs: The attributes to generate wrappers for.
    :param indent: The indent to add before each line
    :return:
    """
    code = []
    if attrs is None:
        attrs = [
            attr
            for attr in dir(wrapped_dtype)
            if not attr.startswith("__") and not attr.endswith("__")
        ]
    for attr_name in attrs:
        attr = getattr(wrapped_dtype, attr_name)
        if ismethod(attr) or isinstance(attr, (MethodDescriptor, WrapperDescriptor)):
            try:
                sig = signature(attr)
                function_inputs = ", ".join(
                    f"object {arg}" if arg.startswith("signed") else arg
                    for arg in str(sig)[1:-1].split(", ")
                    if arg != "/"
                )
                arg_list = []
                for index, arg in enumerate(sig.parameters.values()):
                    if index == 0 and arg.name == "self":
                        continue
                    elif arg.kind == Parameter.POSITIONAL_ONLY:
                        arg_list.append(arg.name)
                    elif arg.kind == Parameter.POSITIONAL_OR_KEYWORD:
                        arg_list.append(f"{arg.name}")
                    elif arg.kind == Parameter.VAR_POSITIONAL:
                        arg_list.append(f"*{arg.name}")
                    elif arg.kind == Parameter.KEYWORD_ONLY:
                        arg_list.append(f"{arg.name}={arg.name}")
                    elif arg.kind == Parameter.VAR_KEYWORD:
                        arg_list.append(f"**{arg.name}")
                args = ", ".join(arg_list)
            except (ValueError, TypeError):
                function_inputs = "self, *args, **kwargs"
                args = "*args, **kwargs"

            code.extend(
                (
                    f"def {attr_name}({function_inputs}):",
                    f"    return self.{wrapped_name}.{attr_name}({args})",
                    f"{attr_name}.__doc__ = {wrapped_dtype.__name__}.{attr_name}.__doc__",
                    f"",
                )
            )
        elif isinstance(attr, GetSetDescriptor):
            code.extend(
                (
                    f"@property",
                    f"def {attr_name}(self):",
                    *get_docstring(attr),
                    f"    return self.{wrapped_name}.{attr_name}",
                    # f"{attr_name}.__doc__ = {wrapped_dtype.__name__}.{attr_name}.__doc__",  # https://github.com/cython/cython/issues/4466
                    f"",
                )
            )
        elif isinstance(attr, (str, Type)):
            pass
        elif isinstance(attr, BuiltInFunctionOrMethod):
            print(f"Built in method {attr_name} is not inspectable")
        else:
            print(f"skipped {attr_name} {attr}")
    return indent * " " + f'\n{indent*" "}'.join(code)
