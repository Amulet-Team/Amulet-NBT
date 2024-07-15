#include <stdexcept>
#include <vector>
#include <memory>
#include <string>
#include <bit>
#include <variant>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>
#include <pybind11/numpy.h>

#include <amulet_nbt/tag/wrapper.hpp>
#include <amulet_nbt/tag/copy.hpp>

namespace py = pybind11;


#define PyArray(CLSNAME, ELEMENTCLS, BITCOUNT, TAGID)\
    py::class_<Amulet::CLSNAME##Wrapper, Amulet::AbstractBaseArrayTag> CLSNAME(m, #CLSNAME, py::buffer_protocol(),\
        "This class stores a fixed size signed "#BITCOUNT" bit vector."\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([asarray, dtype](py::object value) {\
            /* Is there a better way to do this? */\
            py::array arr = asarray(value, dtype("int"#BITCOUNT)).attr("ravel")().cast<py::array>();\
            std::vector<Amulet::ELEMENTCLS> v = arr.cast<std::vector<Amulet::ELEMENTCLS>> ();\
            std::shared_ptr<Amulet::CLSNAME> tag_ptr = std::make_shared<Amulet::CLSNAME>(v.begin(), v.end());\
            return Amulet::CLSNAME##Wrapper(tag_ptr);\
        }),\
        py::arg("value") = py::tuple(),\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: collections.abc.Iterable[typing.SupportsInt] = ()) -> None")\
    );\
    CLSNAME.def_buffer(\
        [](Amulet::CLSNAME##Wrapper& self) -> py::buffer_info {\
            return py::buffer_info(\
                self.tag->data(),\
                sizeof(Amulet::ELEMENTCLS),\
                py::format_descriptor<Amulet::ELEMENTCLS>::format(),\
                1,\
                {self.tag->size()},\
                {sizeof(Amulet::ELEMENTCLS)}\
            );\
        }\
    );\
    CLSNAME.def_property_readonly(\
        "np_array",\
        [asarray](const Amulet::CLSNAME##Wrapper& self){\
            return asarray(self);\
        },\
        py::doc(\
            "A numpy array holding the same internal data.\n"\
            "\n"\
            "Changes to the array will also modify the internal state."\
        )\
    );\
    CLSNAME.def_property_readonly(\
        "py_data",\
        [asarray](const Amulet::CLSNAME##Wrapper& self){\
            return asarray(self);\
        },\
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
            std::string out = #CLSNAME "([";\
            for (size_t i = 0; i < self.tag->size(); i++){\
                if (i){\
                    out += ", ";\
                };\
                out += std::to_string((*self.tag)[i]);\
            };\
            out += "])";\
            return out;\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            std::string out = "[";\
            for (size_t i = 0; i < self.tag->size(); i++){\
                if (i){\
                    out += ", ";\
                };\
                out += std::to_string((*self.tag)[i]);\
            };\
            out += "]";\
            return out;\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const Amulet::CLSNAME##Wrapper& self){\
                return py::bytes(Amulet::write_nbt("", self.tag, std::endian::big, Amulet::utf8_to_mutf8));\
            },\
            [](py::bytes state){\
                return Amulet::CLSNAME##Wrapper(\
                    std::get<Amulet::CLSNAME##Ptr>(\
                        Amulet::read_nbt(state, std::endian::big, Amulet::mutf8_to_utf8).tag_node\
                    )\
                );\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return Amulet::CLSNAME##Wrapper(NBTTag_copy<Amulet::CLSNAME>(*self.tag));\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const Amulet::CLSNAME##Wrapper& self, py::dict){\
            return Amulet::CLSNAME##Wrapper(Amulet::NBTTag_copy<Amulet::CLSNAME>(*self.tag));\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const Amulet::CLSNAME##Wrapper& self, const Amulet::CLSNAME##Wrapper& other){\
            return *self.tag == *other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__len__",\
        [](const Amulet::CLSNAME##Wrapper& self){\
            return self.tag->size();\
        }\
    );\
    CLSNAME.def(\
        "__iter__",\
        [](const Amulet::CLSNAME##Wrapper& self) {return py::make_iterator(self.tag->begin(), self.tag->end());},\
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);\
    CLSNAME.def(\
        "__reversed__",\
        [](const Amulet::CLSNAME##Wrapper& self) {return py::make_iterator(self.tag->rbegin(), self.tag->rend());},\
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);\
    CLSNAME.def(\
        "__getitem__",\
        [asarray](const Amulet::CLSNAME##Wrapper& self, py::object item){\
            return asarray(self).attr("__getitem__")(item);\
        }\
    );\
    CLSNAME.def(\
        "__setitem__",\
        [asarray](const Amulet::CLSNAME##Wrapper& self, py::object item, py::object value){\
            asarray(self)[item] = value;\
        }\
    );\
    CLSNAME.def(\
        "__contains__",\
        [asarray](const Amulet::CLSNAME##Wrapper& self, py::object value){\
            asarray(self).contains(value);\
        }\
    );


void init_array(py::module& m) {
    py::object asarray = py::module::import("numpy").attr("asarray");
    py::object dtype = py::module::import("numpy").attr("dtype");
    PyArray(ByteArrayTag, ByteTag, 8, 7)
    PyArray(IntArrayTag, IntTag, 32, 11)
    PyArray(LongArrayTag, LongTag, 64, 12)
};
