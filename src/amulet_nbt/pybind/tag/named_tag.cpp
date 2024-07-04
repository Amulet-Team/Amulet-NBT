#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/tag/wrapper.hpp>
#include <amulet_nbt/tag/eq.hpp>

namespace py = pybind11;


namespace AmuletPy {
    class NamedTagIterator {
        private:
            py::object named_tag;
            size_t index;
        public:
            NamedTagIterator(py::object named_tag): named_tag(named_tag), index(0){}
            py::object next(){
                switch(index){
                    case 0:
                        index++;
                        return named_tag.attr("name");
                    case 1:
                        index++;
                        return named_tag.attr("tag");
                    default:
                        throw pybind11::stop_iteration("");
                }
            }
    };
}


void init_named_tag(py::module& m) {
    py::class_<AmuletPy::NamedTagIterator> NamedTagIterator(m, "NamedTagIterator");
        NamedTagIterator.def(
            "__next__",
            &AmuletPy::NamedTagIterator::next
        );
        NamedTagIterator.def(
            "__iter__",
            [](AmuletPy::NamedTagIterator& self){
                return self;
            }
        );

    py::class_<Amulet::NamedTag> NamedTag(m, "NamedTag");
        NamedTag.def(
            py::init([](Amulet::WrapperNode tag, std::string name) {
                if (tag.index() == 0){
                    return Amulet::NamedTag(name, std::make_shared<Amulet::CompoundTag>());
                } else {
                    return Amulet::NamedTag(name, Amulet::unwrap_node(tag));
                }
            }),
            py::arg("tag") = py::none(), py::arg("name") = ""
        );
        NamedTag.def_property(
            "name",
            [](const Amulet::NamedTag& self) -> py::object {
                try {
                    return py::str(self.name);
                } catch (py::error_already_set&){
                    return py::bytes(self.name);
                }
            },
            [](Amulet::NamedTag& self, std::string name){
                self.name = name;
            }
        );
        NamedTag.def_property(
            "tag",
            [](const Amulet::NamedTag& self){
                return Amulet::wrap_node(self.tag_node);
            },
            [](Amulet::NamedTag& self, Amulet::WrapperNode tag){
                if (tag.index() == 0){
                    throw std::invalid_argument("tag cannot be None");
                }
                self.tag_node = Amulet::unwrap_node(tag);
            }
        );
        NamedTag.def(
            "__repr__",
            [](const Amulet::NamedTag& self){
                std::string out;
                out += "NamedTag(";
                try {
                    out += py::repr(py::str(self.name));
                } catch (py::error_already_set&){
                    out += py::repr(py::bytes(self.name));
                }
                out += ", ";
                out += py::repr(py::cast(Amulet::wrap_node(self.tag_node)));
                out += ")";
                return out;
            }
        );
        NamedTag.def(
            "__eq__",
            [](const Amulet::NamedTag& self, const Amulet::NamedTag& other){
                return self.name == other.name && Amulet::NBTTag_eq(self.tag_node, other.tag_node);
            },
            py::is_operator()
        );
        NamedTag.def(
            "__getitem__",
            [](const Amulet::NamedTag& self, Py_ssize_t item) -> py::object {
                if (item < 0){
                    item += 2;
                }
                switch (item){
                    case 0:
                        return py::cast(self).attr("name");
                    case 1:
                        return py::cast(self).attr("tag");
                    default:
                        throw std::out_of_range("Index out of range");
                }
            }
        );
        NamedTag.def(
            "__iter__",
            [](const Amulet::NamedTag& self){
                return AmuletPy::NamedTagIterator(py::cast(self));
            }
        );

        #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
        NamedTag.def_property_readonly(\
            TAG_NAME,\
            [](const Amulet::NamedTag& self){\
                if (self.tag_node.index() != ID){\
                    throw pybind11::type_error("tag_node is not a "#TAG);\
                }\
                return Amulet::TagWrapper<TAG_STORAGE>(std::get<TAG_STORAGE>(self.tag_node));\
            },\
            py::doc(\
                "Get the tag if it is a "#TAG".\n"\
                "\n"\
                ":return: The "#TAG".\n"\
                ":raises: TypeError if the stored type is not a "#TAG\
            )\
        );\

        FOR_EACH_LIST_TAG(CASE)
        #undef CASE
}
