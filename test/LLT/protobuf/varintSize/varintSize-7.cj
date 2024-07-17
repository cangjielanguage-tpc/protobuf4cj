// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: UInt64 = 5398046511104
    let num = varintSize(val)

    if(num != 7) {
        return -1
    }

    return 0
}

