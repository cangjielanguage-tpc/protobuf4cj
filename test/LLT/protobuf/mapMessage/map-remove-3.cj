// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapMessage<Int64, String> = MapMessage<Int64, String>()
    map.put(10, "10")
    map.put(20, "20")
    map.put(30, "30")

    let keys: ArrayList<Int64> = ArrayList<Int64>([10, 20])
    let res = map.removeAll(keys)

    if(map.isEmpty()) {
        println(-1)
        return -1
    }

    return 0
}

