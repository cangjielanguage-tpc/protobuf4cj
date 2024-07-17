// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var n: BytesString = BytesString.String("123456789")
    let num = binSize(n)

    if(num != 10) {
        return -1
    }

    return 0
}

