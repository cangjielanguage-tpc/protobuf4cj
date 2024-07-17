// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: Int32 = -1
    let num = zigzag(val)

    try {
        let num = zigzag(val)
    } catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return -1
}

