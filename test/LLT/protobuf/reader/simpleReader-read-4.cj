// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let arr: Array<UInt8> = Array<UInt8>([1, 2, 3, 4, 5, 6])
    let bytes: BytesSlice = BytesSlice(arr)
    var reader = SimpleReader(bytes)

    try {
        let num: Int64 = reader.read(10).getRawArray().size
    } catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return 0
}


