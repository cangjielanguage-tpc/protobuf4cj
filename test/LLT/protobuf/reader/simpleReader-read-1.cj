// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let arr: Array<UInt8> = Array<UInt8>([1, 2, 3])
    let bytes: BytesSlice = BytesSlice(arr)
    var reader = SimpleReader(bytes)

    let num: UInt8 = reader.read()
    if(num < 0) {
        println(-1)
        return -1
    }

    return 0
}


