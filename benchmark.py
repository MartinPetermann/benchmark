import benchmark

from optparse import OptionParser

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option(
        "-g",
        "--gpu",
        action="store_true",
        dest="gpu",
        default=False,
        help="using GPU",
    )
    parser.add_option(
        "-b",
        "--tblocks",
        type="int",
        dest="tblocks",
        default=-1,
        help="number of thread blocks",
    )
    parser.add_option(
        "-t",
        "--threads",
        type="int",
        dest="threads",
        default=-1,
        help="number of threads per thread block",
    )
    parser.add_option(
        "-f",
        "--float",
        action="store_true",
        dest="float",
        default=False,
        help="using float instead of 32bit integer",
    )

    (options, args) = parser.parse_args()

    if options.gpu == False and (options.tblocks != -1 or options.threads != -1):
        print("The number of thread blocks or threads only apply to GPU.")
    if options.gpu == True and options.tblocks == -1:
        options.tblocks = 1
    if options.gpu == True and options.threads == -1:
        options.threads = 1

    duration = benchmark.perftest(
        options.gpu, not options.float, options.tblocks, options.threads
    )
    if options.gpu == True:
        print(
            "GPU {:<10} ({:>3} thread block(s), each {:>3} thread(s)): {}s".format(
                ("float" if options.float else "u_int32_t"),
                options.tblocks,
                options.threads,
                duration,
            )
        )
    else:
        print(
            "CPU {:<10}:                                                {}s".format(
                ("float" if options.float else "u_int32_t"), duration
            )
        )
