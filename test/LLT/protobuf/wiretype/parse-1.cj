// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    try {
        let wt: WireType = WireType.parse(6)
    } catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return -1
}
