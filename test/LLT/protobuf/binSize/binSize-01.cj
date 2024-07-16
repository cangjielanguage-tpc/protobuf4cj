// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var bs: BytesSlice = BytesSlice(10, item: 98)
    var n: BytesString = BytesString.Bytes(bs)
    let num = binSize(n)

    if(num != 11) {
        return -1
    }

    return 0
}

