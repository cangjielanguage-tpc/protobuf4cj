// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapField<Int64, String> = MapField<Int64, String>()
    map.put(10, "10")
    map.put(20, "20")

    try {
        let res = map[30]
    } catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return 0
}

