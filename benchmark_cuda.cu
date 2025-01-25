#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <chrono>

#include "benchmark_cuda.h"

template <class T> __global__ void test_gpu(T limit)

{
    T    sum = 0;
    bool prime;

    const u_int32_t a = blockIdx.x;
    const u_int32_t b = threadIdx.x;

    for (T i = 2; i < limit; i++) {
        prime = true;
        for (T j = 2; j * j <= i; j++) {
            for (T k = 2; j * k <= i; k++) {
                if (j * k == i) {
                    prime = false;
                    break;
                }
            }
            if (prime == false) {
                break;
            }
        }
        if (prime == true) {
            sum += i;
        }
    }
    sum += (a + b);
}

template <class T> void test_cpu(T limit)

{
    T    sum = 0;
    bool prime;

    for (T i = 2; i < limit; i++) {
        prime = true;
        for (T j = 2; j * j <= i; j++) {
            for (T k = 2; j * k <= i; k++) {
                if (j * k == i) {
                    prime = false;
                    break;
                }
            }
            if (prime == false) {
                break;
            }
        }
        if (prime == true) {
            sum += i;
        }
    }
}

class Timer {
private:
    std::chrono::time_point<std::chrono::system_clock> start_time;

public:
    void   start() { start_time = std::chrono::system_clock::now(); }
    double stop()
    {
        return (double)std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now()
                                                                             - start_time)
                   .count()
               / 1000;
    }
};

#define LIMIT 20000


void perftest(bool gpu, bool integer, int thread_blocks, int threads)
{
    Timer t;
    t.start();
    if (gpu) {
        if (integer) {
            test_gpu<u_int32_t><<<thread_blocks, threads>>>(LIMIT);
        } else {
            test_gpu<float><<<thread_blocks, threads>>>(LIMIT);
        }
        cudaDeviceSynchronize();
        printf("GPU %10s (%d thread block(s), each %d thread(s)): %fs\n", (integer ? "u_int32_t" : "float"), thread_blocks, threads, t.stop());
    } else {
        if (integer) {
            test_cpu<u_int32_t>(LIMIT);
        } else {
            test_cpu<float>(LIMIT);
        }
        printf("CPU %10s:                                       %fs\n", (integer ? "u_int32_t" : "float"), t.stop());
    }
}


