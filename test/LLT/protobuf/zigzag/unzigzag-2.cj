// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: UInt64 = 0
    let num = unzigzag(val)

    if(num != 0) {
        return -1
    }

    return 0
}

