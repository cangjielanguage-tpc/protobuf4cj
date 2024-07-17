// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var reader = SimpleReader()

    let flag: Bool = reader.isEmpty()
    if(!flag) {
        println(-1)
        return -1
    }

    return 0
}

