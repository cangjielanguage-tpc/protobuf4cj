// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var arr: RoArray<Int64> = RoArray<Int64>.move(Array<Int64>([5, 6, 7, 8]))

    if(arr.isEmpty()) {
        println(-1)
        return -1
    }

    return 0
}

