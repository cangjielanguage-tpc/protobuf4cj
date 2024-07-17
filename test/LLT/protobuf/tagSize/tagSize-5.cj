// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let tag: UInt32 = 43554432
    let num = tagSize(tag)

    if(num != 5) {
        return -1
    }

    return 0
}
