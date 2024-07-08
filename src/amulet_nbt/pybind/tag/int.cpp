#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/wrapper.hpp>

namespace py = pybind11;


#define PyInt(CLSNAME, BYTEWIDTH, BITPOW, TAGID)\
    py::class_<Amulet::CLSNAME##Wrapper, Amulet::AbstractBaseIntTag> CLSNAME(m, #CLSNAME,\
        "A "#BYTEWIDTH" byte integer class.\n"\
        "\n"\
        "Can Store numbers between -(2^"#BITPOW") and (2^"#BITPOW" - 1)"\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([](py::object value) {\
            return Amulet::CLSNAME##Wrapper(py::int_(value).cast<Amulet::CLSNAME>());\
        }),\
        py::arg("value") = 0,\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: typing.SupportsInt) -> None")\
    );\
    CLSNAME.def_readonly(\
        "py_int",\
        &Amulet::CLSNAME##Wrapper::tag,\
        py::doc(\
            "A python int representation of the class.\n"\
            "\n"\
            "The returned data is immutable so changes will not mirror the instance."\
        )\
    );\
    CLSNAME.def_readonly(\
        "py_data",\
        &Amulet::CLSNAME##Wrapper::tag,\
        py::doc(\
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name.\n"\
        )\
    );\
    CLSNAME.def(\
        "__repr__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return #CLSNAME "(" + std::to_string(self.tag) + ")";\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return std::to_string(self.tag);\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const Amulet::CLSNAME##Wrapper& self){\
                return self.tag;\
            },\
            [](Amulet::CLSNAME state){\
                return Amulet::CLSNAME##Wrapper(state);\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const Amulet::CLSNAME##Wrapper& self, py::dict){\
            return self;\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__hash__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return py::hash(py::make_tuple(TAGID, self.tag));\
        }\
    );\
    CLSNAME.def(\
        "__int__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return self.tag;\
        }\
    );\
    CLSNAME.def(\
        "__float__",\
        [](const Amulet::CLSNAME##Wrapper& self) -> py::float_ {\
            return py::cast(self.tag);\
        }\
    );\
    CLSNAME.def(\
        "__bool__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return self.tag != 0;\
        }\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return self.tag == other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__ge__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return self.tag >= other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__gt__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return self.tag > other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__le__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return self.tag <= other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__lt__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return self.tag < other.tag;\
        },\
        py::is_operator()\
    );


void init_int(py::module& m) {
    PyInt(ByteTag, 1, 7, 1)
    PyInt(ShortTag, 2, 15, 2)
    PyInt(IntTag, 4, 31, 3)
    PyInt(LongTag, 8, 63, 4)
};
