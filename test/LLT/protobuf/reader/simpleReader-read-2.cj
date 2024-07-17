// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    let bytes: BytesSlice = BytesSlice()
    var reader = SimpleReader(bytes)

    try {
        let num: UInt8 = reader.read()
    } catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return 0
}


