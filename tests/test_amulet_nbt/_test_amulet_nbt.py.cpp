#include <pybind11/pybind11.h>

#include <amulet/pybind11_extensions/compatibility.hpp>

namespace py = pybind11;
namespace pyext = Amulet::pybind11_extensions;

void init_test_amulet_nbt(py::module);

static void _init_test_amulet_nbt(py::module m){
    pyext::init_compiler_config(m);
    pyext::check_compatibility(py::module::import("amulet.nbt"), m);
    init_test_amulet_nbt(m);
}

PYBIND11_MODULE(_test_amulet_nbt, m) {
    m.def("init", &_init_test_amulet_nbt, py::arg("m"));
}
