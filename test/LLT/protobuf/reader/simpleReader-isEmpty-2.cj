// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let arr: Array<UInt8> = Array<UInt8>([1, 2, 3])
    let bytes: BytesSlice = BytesSlice(arr)
    var reader = SimpleReader(bytes)

    let flag: Bool = reader.isEmpty()
    if(flag) {
        println(-1)
        return -1
    }

    return 0
}


