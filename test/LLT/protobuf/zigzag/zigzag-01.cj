// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: Int32 = 10000
    let num = zigzag(val)

    if(num != 20000) {
        return -1
    }

    return 0
}

