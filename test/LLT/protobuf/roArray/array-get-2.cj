// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var arr: RoArray<Int64> = RoArray<Int64>(10, item: 8)

    let res = arr.get(20)
    match (res) {
        case Some(m) =>
            println(-1)
            return -1
        case None => ()
    }

    return 0
}

