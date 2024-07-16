// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let val: UInt32 = 10000
    let num = unzigzag(val)

    if(num != 5000) {
        return -1
    }

    return 0
}

