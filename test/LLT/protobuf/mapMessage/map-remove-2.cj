// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var map: MapMessage<Int64, String> = MapMessage<Int64, String>()
    map.put(10, "10")
    map.put(20, "20")

    let res = map.remove(30)
    match (res) {
        case Some(m) =>
            println(-1)
            return -1
        case None => ()
    }

    return 0
}

