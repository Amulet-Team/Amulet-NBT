#include <stdexcept>
#include <limits>
#include <array>
#include <variant>
#include <vector>
#include <string>
#include <algorithm>
#include <memory>
#include <cstdint>
#include <bit>

#include <pybind11/pybind11.h>
#include <pybind11/pytypes.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/wrapper.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/eq.hpp>
#include <amulet_nbt/tag/copy.hpp>

namespace py = pybind11;

void ListTag_extend(AmuletNBT::ListTagPtr tag, py::object value){
    // The caller must ensure value is not tag
    auto it = py::iter(value);
    while (it != py::iterator::sentinel()){
        AmuletNBT::WrapperNode node = py::cast<AmuletNBT::WrapperNode>(*it);

        switch(node.index()){
            #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
            case ID:\
                AmuletNBT::ListTag_append<TAG_STORAGE>(*tag, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(node).tag);\
                break;
            case 0:
                throw py::type_error("Cannot append null TagNode");
            FOR_EACH_LIST_TAG(CASE)
            #undef CASE
        }
        ++it;
    }
}

template <typename tagT>
void ListTag_set_slice(AmuletNBT::ListTagPtr self, const py::slice &slice, std::vector<tagT>& vec){
    if (self->index() == variant_index<AmuletNBT::ListTag, std::vector<tagT>>()){
        // Tag type matches
        std::vector<tagT>& list_tag = std::get<std::vector<tagT>>(*self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(list_tag.size(), &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (vec.size() == slice_length){
            // Size matches. Overwrite.
            for (auto& tag: vec){
                list_tag[start] = tag;
                start += step;
            }
        } else if (step == 1) {
            // Erase the region and insert the new region
            list_tag.erase(
                list_tag.begin() + start,
                list_tag.begin() + stop
            );
            list_tag.insert(
                list_tag.begin() + start,
                vec.begin(),
                vec.end()
            );
        } else {
            throw std::invalid_argument(
                "attempt to assign sequence of size " +
                std::to_string(vec.size()) +
                " to extended slice of size " +
                std::to_string(slice_length)
            );
        }
    } else {
        // Tag type does not match
        size_t size = ListTag_size(*self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(size, &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (size == slice_length){
            // Overwriting all values
            if (step == -1){
                // Reverse the element order
                std::reverse(vec.begin(), vec.end());
            } else if (step != 1){
                throw std::invalid_argument(
                    "When overwriting values in a ListTag the types must match or all tags must be overwritten."
                );
            }
            self->emplace<std::vector<tagT>>(vec);
        } else {
            throw py::type_error("NBT ListTag item mismatch.");
        }
    }
}

template <typename tagT>
void ListTag_del_slice(std::vector<tagT>& self, const py::slice &slice){
    Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
    if (!slice.compute(self.size(), &start, &stop, &step, &slice_length)) {
        throw py::error_already_set();
    }
    if (step == 1){
        self.erase(
            self.begin() + start,
            self.begin() + stop
        );
    } else if (step < 0) {
        for (Py_ssize_t i = 0; i < slice_length; i++){
            self.erase(self.begin() + (start + step * i));
        }
    } else if (step > 0) {
        // erase values back to front
        for (Py_ssize_t i = 0; i < slice_length; i++){
            self.erase(self.begin() + (start + step * (slice_length - 1 - i)));
        }
    } else {
        throw std::invalid_argument("slice step cannot be zero");
    }
}


void init_list(py::module& m) {
    py::class_<AmuletNBT::ListTagIterator, std::shared_ptr<AmuletNBT::ListTagIterator>> ListTagIterator(m, "ListTagIterator");
        ListTagIterator.def(
            "__next__",
            [](AmuletNBT::ListTagIterator& self){
                if (self.has_next()){
                    return AmuletNBT::wrap_node(self.next());
                }
                throw py::stop_iteration("");
            }
        );
        ListTagIterator.def(
            "__iter__",
            [](AmuletNBT::ListTagIterator& self){
                return self;
            }
        );

    py::class_<AmuletNBT::ListTagWrapper, AmuletNBT::AbstractBaseMutableTag> ListTag(m, "ListTag",
        "A Python wrapper around a C++ vector.\n"
        "\n"
        "All contained data must be of the same NBT data type."
    );
        ListTag.def_property_readonly_static("tag_id", [](py::object) {return 9;});
        ListTag.def(
            py::init([](py::object value, std::uint8_t element_tag_id) {
                AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>();
                switch(element_tag_id){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: tag->emplace<LIST_TAG>(); break;
                    FOR_EACH_LIST_TAG2(CASE)
                    default:
                        throw std::invalid_argument("element_tag_id must be in the range 0-12");
                    #undef CASE
                }
                ListTag_extend(tag, value);
                return AmuletNBT::ListTagWrapper(tag);
            }),
            py::arg("value") = py::tuple(), py::arg("element_tag_id") = 1,
            py::doc("__init__(self: amulet_nbt.ListTag, value: typing.Iterable[amulet_nbt.ByteTag] | typing.Iterable[amulet_nbt.ShortTag] | typing.Iterable[amulet_nbt.IntTag] | typing.Iterable[amulet_nbt.LongTag] | typing.Iterable[amulet_nbt.FloatTag] | typing.Iterable[amulet_nbt.DoubleTag] | typing.Iterable[amulet_nbt.ByteArrayTag] | typing.Iterable[amulet_nbt.StringTag] | typing.Iterable[amulet_nbt.ListTag] | typing.Iterable[amulet_nbt.CompoundTag] | typing.Iterable[amulet_nbt.IntArrayTag] | typing.Iterable[amulet_nbt.LongArrayTag] = (), element_tag_id = 1) -> None")
        );
        ListTag.attr("__class_getitem__") = PyClassMethod_New(
            py::cpp_function([](const py::type &cls, const py::args &args){return cls;}).ptr()
        );
        auto py_getter = [](const AmuletNBT::ListTagWrapper& self){
            py::list list;
            switch(self.tag->index()){
                #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        {\
                            LIST_TAG& tag = std::get<LIST_TAG>(*self.tag);\
                            for (size_t i = 0; i < tag.size(); i++){\
                                list.append(\
                                    AmuletNBT::TagWrapper<TAG_STORAGE>(tag[i])\
                                );\
                            };\
                            break;\
                        }
                FOR_EACH_LIST_TAG(CASE)
                #undef CASE
            }
            return list;
        };
        ListTag.def_property_readonly(
            "py_list",
            py_getter,
            py::doc(
                "A python list representation of the class.\n"
                "\n"
                "The returned list is a shallow copy of the class, meaning changes will not mirror the instance.\n"
                "Use the public API to modify the internal data.\n"
            )
        );
        ListTag.def_property_readonly(
            "py_data",
            py_getter,
            py::doc(
                "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
                "\n"
                "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
                "This is here for convenience to get a python representation under the same property name.\n"
            )
        );
        ListTag.def(
            "__repr__",
            [](const AmuletNBT::ListTagWrapper& self){
                std::string out;
                out += "ListTag([";

                switch(self.tag->index()){
                    case 0:
                        break;
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        {\
                            LIST_TAG& list_tag = std::get<LIST_TAG>(*self.tag);\
                            for (size_t i = 0; i < list_tag.size(); i++){\
                                if (i != 0){out += ", ";}\
                                out += py::repr(py::cast(AmuletNBT::TagWrapper<TAG_STORAGE>(list_tag[i])));\
                            }\
                        };\
                        break;
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }

                out += "], ";
                out += std::to_string(self.tag->index());
                out += ")";
                return out;
            }
        );
        ListTag.def(
            "__str__",
            [](const AmuletNBT::ListTagWrapper& self){
                return py::str(py::list(py::cast(self)));
            }
        );
        ListTag.def(
            py::pickle(
                [](const AmuletNBT::ListTagWrapper& self){
                    return py::bytes(AmuletNBT::write_nbt("", self.tag, std::endian::big, AmuletNBT::utf8_to_mutf8));
                },
                [](py::bytes state){
                    return AmuletNBT::ListTagWrapper(
                        std::get<AmuletNBT::ListTagPtr>(
                            AmuletNBT::read_nbt(state, std::endian::big, AmuletNBT::mutf8_to_utf8).tag_node
                        )
                    );
                }
            )
        );
        ListTag.def(
            "__copy__",
            [](const AmuletNBT::ListTagWrapper& self){
                return AmuletNBT::ListTagWrapper(NBTTag_copy<AmuletNBT::ListTag>(*self.tag));
            }
        );
        ListTag.def(
            "__deepcopy__",
            [](const AmuletNBT::ListTagWrapper& self, py::dict){
                return AmuletNBT::ListTagWrapper(AmuletNBT::NBTTag_deep_copy_list(*self.tag));
            },
            py::arg("memo")
        );
        ListTag.def(
            "__eq__",
            [](const AmuletNBT::ListTagWrapper& self, const AmuletNBT::ListTagWrapper& other){
                return AmuletNBT::NBTTag_eq(self.tag, other.tag);
            },
            py::is_operator()
        );
        ListTag.def(
            "__len__",
            [](const AmuletNBT::ListTagWrapper& self){
                return AmuletNBT::ListTag_size(*self.tag);
            }
        );
        ListTag.def(
            "__bool__",
            [](const AmuletNBT::ListTagWrapper& self){
                return AmuletNBT::ListTag_size(*self.tag) != 0;
            }
        );
        ListTag.def_property_readonly(
            "element_tag_id",
            [](const AmuletNBT::ListTagWrapper& self){
                return self.tag->index();
            }
        );
        const std::array<py::object, 13> NBTClasses = {
            py::none(),
            m.attr("ByteTag"),
            m.attr("ShortTag"),
            m.attr("IntTag"),
            m.attr("LongTag"),
            m.attr("FloatTag"),
            m.attr("DoubleTag"),
            m.attr("ByteArrayTag"),
            m.attr("StringTag"),
            ListTag,
            m.attr("CompoundTag"),
            m.attr("IntArrayTag"),
            m.attr("LongArrayTag"),
        };
        ListTag.def_property_readonly(
            "element_class",
            [NBTClasses](const AmuletNBT::ListTagWrapper& self){
                return NBTClasses[self.tag->index()];
            }
        );
        ListTag.def(
            "__getitem__",
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t item){
                return AmuletNBT::wrap_node(AmuletNBT::ListTag_get_node<Py_ssize_t>(*self.tag, item));
            }
        );
        ListTag.def(
            "__getitem__",
            [](const AmuletNBT::ListTagWrapper& self, const py::slice& slice) {
                py::list out;
                Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
                if (!slice.compute(ListTag_size(*self.tag), &start, &stop, &step, &slice_length)) {
                    throw py::error_already_set();
                }
                for (Py_ssize_t i = 0; i < slice_length; ++i) {
                    out.append(AmuletNBT::wrap_node(AmuletNBT::ListTag_get_node<Py_ssize_t>(*self.tag, start)));
                    start += step;
                }
                return out;
            });
        ListTag.def(
            "__iter__",
            [](const AmuletNBT::ListTagWrapper& self) {
                return AmuletNBT::ListTagIterator(self.tag, 0, 1);
            }
        );
        ListTag.def(
            "__reversed__",
            [](const AmuletNBT::ListTagWrapper& self) {
                return AmuletNBT::ListTagIterator(self.tag, ListTag_size(*self.tag) - 1, -1);
            }
        );
        ListTag.def(
            "__contains__",
            [](const AmuletNBT::ListTagWrapper& self, AmuletNBT::WrapperNode item){
                if (item.index() == 0) {
                    throw py::type_error("item cannot be None.");
                }
                if (item.index() != self.tag->index()){
                    return false;
                }
                switch(item.index()){
                    case 0:
                        throw py::type_error("item cannot be None.");
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        {\
                            TAG_STORAGE item_tag = std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(item).tag;\
                            LIST_TAG& list_tag = std::get<LIST_TAG>(*self.tag);\
                            for (TAG_STORAGE tag: list_tag){\
                                if (AmuletNBT::NBTTag_eq(tag, item_tag)){\
                                    return true;\
                                }\
                            }\
                            return false;\
                        }\
                        break;
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                    default:
                        return false;
                }
            }
        );
        ListTag.def(
            "index",
            [](const AmuletNBT::ListTagWrapper& self, AmuletNBT::WrapperNode tag, Py_ssize_t start, Py_ssize_t stop) -> size_t {
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        return AmuletNBT::ListTag_index<TAG_STORAGE, Py_ssize_t>(*self.tag, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag, start, stop);
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                    default:
                        throw py::type_error("tag cannot be None");
                }
            },
            py::arg("tag"), py::arg("start") = 0, py::arg("stop") = std::numeric_limits<Py_ssize_t>::max()
        );
        ListTag.def(
            "count",
            [](const AmuletNBT::ListTagWrapper& self, AmuletNBT::WrapperNode tag) -> size_t {
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        return AmuletNBT::ListTag_count<TAG_STORAGE>(*self.tag, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag);
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                    default:
                        throw py::type_error("Null TagNode is invalid.");
                }
            }
        );
        ListTag.def(
            "__setitem__",
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t index, AmuletNBT::WrapperNode tag){
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        AmuletNBT::ListTag_set<TAG_STORAGE, Py_ssize_t>(*self.tag, index, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag);\
                        break;
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                    default:
                        throw py::type_error("Invalid tag to set.");
                }
            }
        );
        ListTag.def(
            "__setitem__",
            [](const AmuletNBT::ListTagWrapper& self, const py::slice &slice, py::object values){
                // Cast values to a list to get a consistent format
                auto list = py::list(values);
                if (list){
                    // If the value has items in it
                    // Switch based on the type of the first element
                    AmuletNBT::WrapperNode first = list[0].cast<AmuletNBT::WrapperNode>();
                    switch(first.index()){
                        #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                        case ID:{\
                            /* Cast to C++ objects. Also validate that they are all the same type. */\
                            std::vector<TAG_STORAGE> vec;\
                            vec.push_back(std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(first).tag);\
                            for (size_t i = 1; i < list.size(); i++){\
                                AmuletNBT::WrapperNode tag = list[i].cast<AmuletNBT::WrapperNode>();\
                                vec.push_back(std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag);\
                            }\
                            ListTag_set_slice<TAG_STORAGE>(self.tag, slice, vec);\
                            break;\
                        }
                        FOR_EACH_LIST_TAG(CASE)
                        #undef CASE
                        default:
                            throw py::type_error("Cannot set a null tag.");
                    }
                } else {
                    // The value is empty
                    // empty the slice
                    switch(self.tag->index()){
                        #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                        case ID:{\
                            auto vec = std::vector<TAG_STORAGE>();\
                            ListTag_set_slice<TAG_STORAGE>(self.tag, slice, vec);\
                            break;\
                        }
                        FOR_EACH_LIST_TAG(CASE)
                        #undef CASE
                    }
                }
            }
        );
        ListTag.def(
            "__delitem__",
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t item){
                AmuletNBT::ListTag_del<Py_ssize_t>(*self.tag, item);
            }
        );
        ListTag.def(
            "__delitem__",
            [](const AmuletNBT::ListTagWrapper& self, const py::slice &slice){
                switch(self.tag->index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:{\
                        ListTag_del_slice<TAG_STORAGE>(std::get<std::vector<TAG_STORAGE>>(*self.tag), slice);\
                        break;\
                    }
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }
            }
        );
        ListTag.def(
            "insert",
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t index, AmuletNBT::WrapperNode tag){
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        AmuletNBT::ListTag_insert<TAG_STORAGE, Py_ssize_t>(*self.tag, index, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag);\
                        break;
                    case 0:
                        throw py::type_error("Cannot insert null TagNode");
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }
            }
        );
        ListTag.def(
            "append",
            [](const AmuletNBT::ListTagWrapper& self, AmuletNBT::WrapperNode tag){
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: AmuletNBT::ListTag_append<TAG_STORAGE>(*self.tag, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag); break;
                    case 0:
                        throw py::type_error("Cannot append null TagNode");
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }
            }
        );
        ListTag.def(
            "clear",
            [](const AmuletNBT::ListTagWrapper& self){
                switch(self.tag->index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: std::get<LIST_TAG>(*self.tag).clear(); break;
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }
            }
        );
        ListTag.def(
            "reverse",
            [](const AmuletNBT::ListTagWrapper& self){
                switch(self.tag->index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: {LIST_TAG& tag = std::get<LIST_TAG>(*self.tag); std::reverse(tag.begin(), tag.end());}; break;
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                }
            }
        );
        ListTag.def(
            "extend",
            [](const AmuletNBT::ListTagWrapper& self, py::object value){
                ListTag_extend(self.tag, py::list(value));
            }
        );
        ListTag.def(
            "pop",
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t item){
                return AmuletNBT::wrap_node(ListTag_pop<Py_ssize_t>(*self.tag, item));
            },
            py::arg("item") = -1
        );
        ListTag.def(
            "remove",
            [](const AmuletNBT::ListTagWrapper& self, AmuletNBT::WrapperNode tag){
                switch(tag.index()){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
                    case ID:\
                        {\
                        size_t index = AmuletNBT::ListTag_index<TAG_STORAGE, Py_ssize_t>(*self.tag, std::get<AmuletNBT::TagWrapper<TAG_STORAGE>>(tag).tag);\
                        std::vector<TAG_STORAGE>& list_tag = std::get<std::vector<TAG_STORAGE>>(*self.tag);\
                        list_tag.erase(list_tag.begin() + index);\
                        break;\
                        }
                    FOR_EACH_LIST_TAG(CASE)
                    #undef CASE
                    default:
                        throw py::type_error("tag cannot be None");
                }
            }
        );
        ListTag.def(
            "__iadd__",
            [](const AmuletNBT::ListTagWrapper& self, py::object value){
                ListTag_extend(self.tag, py::list(value));
                return self;
            }
        );
        ListTag.def(
            "copy",
            [](const AmuletNBT::ListTagWrapper& self){
                AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>();

                return AmuletNBT::ListTagWrapper(tag);
            }
        );
        #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
        ListTag.def(\
            "get_" TAG_NAME,\
            [](const AmuletNBT::ListTagWrapper& self, Py_ssize_t index){\
                if (self.tag->index() != variant_index<AmuletNBT::ListTag, std::vector<TAG_STORAGE>>()){\
                    throw pybind11::type_error("ListTag elements are not "#TAG);\
                }\
                return AmuletNBT::wrap_node(AmuletNBT::ListTag_get<TAG_STORAGE, Py_ssize_t>(*self.tag, index));\
            },\
            py::doc(\
                "Get the tag at index if it is a "#TAG".\n"\
                "\n"\
                ":param index: The index to get\n"\
                ":return: The "#TAG".\n"\
                ":raises: IndexError if the index is outside the list.\n"\
                ":raises: TypeError if the stored type is not a "#TAG\
            )\
        );
        FOR_EACH_LIST_TAG(CASE)
        #undef CASE
}
