// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapField<Int64, String> = MapField<Int64, String>()

    if(!map.isEmpty()) {
        println(-1)
        return -1
    }

    let arr = ArrayList<(Int64, String)>([(10, "10"), (20, "20"), (30, "30")])
    map.putAll(arr)

    if(map.isEmpty()) {
        println(-1)
        return -1
    }

    return 0
}

