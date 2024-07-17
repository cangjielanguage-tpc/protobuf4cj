// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let tag: UInt32 = 1
    let num = tagSize(tag)

    if(num != 1) {
        return -1
    }

    return 0
}

