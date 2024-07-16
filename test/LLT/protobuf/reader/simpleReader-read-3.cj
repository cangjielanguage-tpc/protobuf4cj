// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let arr: Array<UInt8> = Array<UInt8>([1, 2, 3, 4, 5, 6])
    let bytes: BytesSlice = BytesSlice(arr)
    var reader = SimpleReader(bytes)

    let num: Int64 = reader.read(5).getRawArray().size
    if (num <= 0) {
        println(-1)
        return -1
    }

    return 0
}


