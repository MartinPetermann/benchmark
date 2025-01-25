.PHONY: clean

SUFFIX := $(shell python-config --extension-suffix)
LIB := benchmark$(SUFFIX)

INC := $(shell python -m pybind11 --includes) -I$(shell pg_config --includedir) -I/usr/local/cuda/include -I.
LDFLAGS := -L$(shell pg_config --libdir)
NVCC := $(shell which nvcc 2>/dev/null)

CXXFLAGS := -O3 -Wall -std=c++11 -D LINUX -fPIC -fvisibility=hidden $(INC) -D CUDA
SO_SRC_FILES += benchmark_cuda.cu benchmark.cpp
LDLIBS += -lcudart
LDFLAGS += -L/usr/local/cuda/lib64

objfiles = $(patsubst %.cu,%.o, $(patsubst %.cpp,%.o, $(1)))

all: $(LIB)

benchmark_cuda.o: benchmark_cuda.cu
	$(NVCC) -Xcompiler -fPIC -x cu $< -c -o $@

$(LIB): $(call objfiles, $(SO_SRC_FILES))
	$(CXX) -shared $^ -o $@ $(LDFLAGS) $(LDLIBS)  

clean:
	rm -f $(LIB) $(call objfiles, $(SO_SRC_FILES)) 