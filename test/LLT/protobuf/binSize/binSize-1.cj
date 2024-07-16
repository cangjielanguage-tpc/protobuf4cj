// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var n: BytesSlice = BytesSlice(5, item: 98)
    let num = binSize(n)

    if(num != 6) {
        return -1
    }

    return 0
}

