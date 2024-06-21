#include <amulet_nbt/common.hpp>

void init_abc(py::module&);
void init_int(py::module&);
void init_float(py::module&);
void init_string(py::module&);
void init_array(py::module&);


PYBIND11_MODULE(_nbt, m) {
    init_abc(m);
    init_int(m);
    init_float(m);
    init_string(m);
    init_array(m);
}
