// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let tag: UInt32 = 265000
    let num = tagSize(tag)

    if(num != 4) {
        return -1
    }

    return 0
}

