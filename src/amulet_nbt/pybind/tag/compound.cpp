#include <amulet_nbt/tag/wrapper.hpp>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

namespace py = pybind11;

void init_compound(py::module& m) {
    py::class_<Amulet::CompoundTagWrapper, Amulet::AbstractBaseMutableTag> CompoundTag(m, "CompoundTag");
        CompoundTag.def_property_readonly_static("tag_id", [](py::object) {return 10;});
}
