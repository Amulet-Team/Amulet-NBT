#include <pybind11/pybind11.h>

#include <pybind11_extensions/compatibility.hpp>
#include <pybind11_extensions/py_module.hpp>

namespace py = pybind11;

void init_test_zlib(py::module);

void init_module(py::module m){
    auto amulet_nbt = py::module::import("amulet.nbt");

    pybind11_extensions::init_compiler_config(m);
    pybind11_extensions::check_compatibility(amulet_nbt, m);

    init_test_zlib(m);
}

PYBIND11_MODULE(_test_amulet_nbt, m) {
    py::options options;
    options.disable_function_signatures();
    m.def("init", &init_module, py::doc("init(arg0: types.ModuleType) -> None"));
    options.enable_function_signatures();
}
