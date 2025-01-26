#include "benchmark_cuda.h"

#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <pybind11/stl.h>

PYBIND11_MODULE(benchmark, m) { m.def("perftest", &perftest, "performance test"); }