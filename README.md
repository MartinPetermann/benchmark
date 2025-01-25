# benchmark

## requirements
* C++ compiler, e.g. g++ (sudo apt install g++) 
* Cuda (nvcc compiler necessary)
* pybind11 (pip3 install pybind11)
* gnu make (sudo apt install make)
* Cuda should be installed in ```/usr/local/cuda``` and required libraries in ```/usr/local/cuda/lib64``` and header files in ```/usr/local/cuda/include```

## build
To build the code run the ```make``` command, e.g.: 
```
$ make
/usr/local/cuda/bin/nvcc -Xcompiler -fPIC -x cu benchmark_cuda.cu -c -o benchmark_cuda.o
g++ -O3 -Wall -std=c++11 -D LINUX -fPIC -fvisibility=hidden -I/usr/include/python3.8 -I/home/martin/.local/lib/python3.8/site-packages/pybind11/include -I/usr/include/postgresql -I/usr/local/cuda/include -I. -D CUDA   -c -o benchmark.o benchmark.cpp
g++ -shared benchmark_cuda.o benchmark.o -o benchmark.cpython-38-aarch64-linux-gnu.so -L/usr/lib/aarch64-linux-gnu -L/usr/local/cuda/lib64 -lcudart
```

## usage
The code computes prime numbers and sums them up. It can be chosen if the code is executes on CPU or on GPU. For GPU the number of thread blocks or threads can be specified. The same code is executed in all threads. Finally the duration of the computation is shown.

help:
```
$ python3 benchmark.py -h
Usage: benchmark.py [options]

Options:
  -h, --help            show this help message and exit
  -g, --gpu             using GPU
  -b TBLOCKS, --tblocks=TBLOCKS
                        number of thread blocks
  -t THREADS, --threads=THREADS
                        number of threads per thread block
  -f, --float           using float instead of 32bit integer
```

example run:
```
$ python3 benchmark.py --g -b 2 -t 2
GPU  u_int32_t (2 thread block(s), each 2 thread(s)): 20.405000s
```
