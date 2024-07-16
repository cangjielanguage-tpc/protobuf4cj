// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var n: String ="1234567890abc"
    let num = binSize(n)

    if(num != 14) {
        return -1
    }

    return 0
}

