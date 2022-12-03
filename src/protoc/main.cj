package protoc

from std import collection.*

main() {
    let input = ArrayList<UInt8>()
    stdin(input)

    let output = cj_generator(input)
    stdout(output)
}