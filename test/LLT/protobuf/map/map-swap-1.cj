// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapField<Int64, String> = MapField<Int64, String>()

    var map2: MapField<Int64, String> = MapField<Int64, String>()
    map2.put(30, "30")
    map2.put(40, "40")

    map.swap(map2)

    if(map.isEmpty()) {
        println(-1)
        return -1
    }

    return 0
}

