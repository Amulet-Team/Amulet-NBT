#include <stdexcept>
#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/wrapper.hpp>


#define PyArray(CLSNAME, ELEMENTCLS, BITCOUNT, TAGID)\
    py::class_<Amulet::CLSNAME##Wrapper, Amulet::AbstractBaseArrayTag> CLSNAME(m, #CLSNAME, py::buffer_protocol(),\
        "This class stores a fixed size signed "#BITCOUNT" bit vector."\
    );\
    CLSNAME.def(\
        py::init([](py::object value) {\
            /* Is there a better way to do this? */\
            auto v = value.cast<std::vector<Amulet::ELEMENTCLS>> ();\
            Amulet::CLSNAME tag(v.begin(), v.end());\
            std::shared_ptr<Amulet::CLSNAME> tag_ptr = std::make_shared<Amulet::CLSNAME>(tag);\
            return Amulet::CLSNAME##Wrapper(tag_ptr);\
        }),\
        py::arg("value"),\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: collections.abc.Iterable[typing.SupportsInt]) -> None")\
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
            return asarray(self)[item];\
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
    py::object asarray = py::module_::import("numpy").attr("asarray");
    PyArray(ByteArrayTag, ByteTag, 8, 7)
    PyArray(IntArrayTag, IntTag, 32, 11)
    PyArray(LongArrayTag, LongTag, 64, 12)
};
