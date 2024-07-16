// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var arr: RoArray<Int64> = RoArray<Int64>()

    if(arr.size != 0) {
        println(-1)
        return -1
    }

    return 0
}

