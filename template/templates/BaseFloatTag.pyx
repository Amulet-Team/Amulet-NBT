{{py:from template import include, gen_wrapper}}
{{gen_wrapper(
    "value_",
    float,
    [
        "as_integer_ratio",
        "conjugate",
        "hex",
        "imag",
        "is_integer",
        "real",
    ]
)}}
{{include("BaseNumericTag.pyx", cls_name=cls_name)}}