// DEPENDENCE: ../build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let wt: WireType = WireType.VARINT

    let str: String = wt.toString()
    println(str)
    if(str.isEmpty()) {
        return -1
    }

    return 0
}
