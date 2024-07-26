#include <string>
#include <fstream>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>
#include <amulet_nbt/pybind/serialisation.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;


#define PyInt(NATIVE, CLSNAME, BYTEWIDTH, BITPOW, SIGNBIT, MAGBITS, TAGID)\
    py::class_<AmuletNBT::CLSNAME, AmuletNBT::AbstractBaseIntTag> CLSNAME(m, #CLSNAME,\
        "A "#BYTEWIDTH" byte integer class.\n"\
        "\n"\
        "Can Store numbers between -(2^"#BITPOW") and (2^"#BITPOW" - 1)"\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([PyIntCls](py::object py_value) {\
            /* cast to a python int */\
            py::object py_int = PyIntCls(py_value);\
            /* get the magnitude bits */\
            NATIVE value = py_int.attr("__and__")(py::cast(MAGBITS)).cast<NATIVE>();\
            /* get the sign bits */\
            if (py_int.attr("__and__")(py::cast(SIGNBIT)).cast<bool>()){value -= SIGNBIT;}\
            return AmuletNBT::CLSNAME(value);\
        }),\
        py::arg("value") = 0,\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: typing.SupportsInt) -> None")\
    );\
    CLSNAME.def_property_readonly(\
        "py_int",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        },\
        py::doc(\
            "A python int representation of the class.\n"\
            "\n"\
            "The returned data is immutable so changes will not mirror the instance."\
        )\
    );\
    CLSNAME.def_property_readonly(\
        "py_data",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        },\
        py::doc(\
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name.\n"\
        )\
    );\
    SerialiseTag(CLSNAME)\
    CLSNAME.def(\
        "__repr__",\
        [](const AmuletNBT::CLSNAME& self){\
            return #CLSNAME "(" + std::to_string(static_cast<NATIVE>(self)) + ")";\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const AmuletNBT::CLSNAME& self){\
            return std::to_string(static_cast<NATIVE>(self));\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const AmuletNBT::CLSNAME& self) -> NATIVE{\
                return self;\
            },\
            [](NATIVE state){\
                return AmuletNBT::CLSNAME(state);\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const AmuletNBT::CLSNAME& self){\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const AmuletNBT::CLSNAME& self, py::dict){\
            return self;\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__hash__",\
        [](const AmuletNBT::CLSNAME& self){\
            return py::hash(py::make_tuple(TAGID, static_cast<NATIVE>(self)));\
        }\
    );\
    CLSNAME.def(\
        "__int__",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__float__",\
        [](const AmuletNBT::CLSNAME& self) -> py::float_ {\
            return py::cast(static_cast<NATIVE>(self));\
        }\
    );\
    CLSNAME.def(\
        "__bool__",\
        [](const AmuletNBT::CLSNAME& self){\
            return self != 0;\
        }\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self == other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__ge__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self >= other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__gt__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self > other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__le__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self <= other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__lt__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self < other;\
        },\
        py::is_operator()\
    );


void init_int(py::module& m) {
    py::object PyIntCls = py::module::import("builtins").attr("int");
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");
    py::object compress = py::module::import("gzip").attr("compress");
    PyInt(std::int8_t, ByteTag, 1, 7, 0x80, 0x7F, 1)
    PyInt(std::int16_t, ShortTag, 2, 15, 0x8000, 0x7FFF, 2)
    PyInt(std::int32_t, IntTag, 4, 31, 0x80000000, 0x7FFFFFFF, 3)
    PyInt(std::int64_t, LongTag, 8, 63, 0x8000000000000000, 0x7FFFFFFFFFFFFFFF, 4)
};
