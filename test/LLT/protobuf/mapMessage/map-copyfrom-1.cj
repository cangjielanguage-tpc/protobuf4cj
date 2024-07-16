// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapMessage<Int64, String> = MapMessage<Int64, String>()
    map.put(10, "10")
    map.put(20, "20")

    var map2: MapMessage<Int64, String> = MapMessage<Int64, String>()
    map2.put(30, "30")
    map2.put(40, "40")

    map.copyFrom(map2)

    let res = map.contains(40)

    if(!res) {
        println(-1)
        return -1
    }

    return 0
}

