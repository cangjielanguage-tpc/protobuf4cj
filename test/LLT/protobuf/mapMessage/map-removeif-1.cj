// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapMessage<Int64, String> = MapMessage<Int64, String>()
    map.put(30, "30")

    let res = map.removeIf(predicate)

    if(!map.isEmpty()) {
        println(-1)
        return -1
    }

    return 0
}

func predicate(k: Int64, v: String): Bool {
    return k == 30
}

