#include <pybind11/pybind11.h>

#include <amulet/pybind11_extensions/compatibility.hpp>
#include <amulet/pybind11_extensions/py_module.hpp>

namespace py = pybind11;
namespace pyext = Amulet::pybind11_extensions;

void init_test_zlib(py::module);

void init_module(py::module m){
    auto amulet_nbt = py::module::import("amulet.nbt");

    pyext::init_compiler_config(m);
    pyext::check_compatibility(amulet_nbt, m);

    init_test_zlib(m);
}

PYBIND11_MODULE(_test_amulet_nbt, m) {
    py::options options;
    options.disable_function_signatures();
    m.def("init", &init_module, py::doc("init(arg0: types.ModuleType) -> None"));
    options.enable_function_signatures();
}
