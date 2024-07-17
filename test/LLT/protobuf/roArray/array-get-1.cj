// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var arr: RoArray<Int64> = RoArray<Int64>(10, item: 8)

    let res = arr.get(2)
    match (res) {
        case Some(m) => ()
        case None =>
            println(-1)
            return -1
    }

    return 0
}

