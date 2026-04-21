#include <pybind11/pybind11.h>

namespace py = pybind11;

void init_binary_nbt(py::module);

void init_test_amulet_nbt(py::module m){
    init_binary_nbt(m);
}
