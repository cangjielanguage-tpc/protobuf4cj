// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: UInt64 = 54359738368
    let num = varintSize(val)

    if(num != 6) {
        return -1
    }

    return 0
}

