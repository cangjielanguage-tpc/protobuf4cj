package protoc

from std import collection.*

main() {
    let inbuf = ArrayList<UInt8>()
    stdin(inbuf)

    let outbuf = ArrayList<UInt8>()
    cj_generator(inbuf, outbuf)

    stdout(outbuf)
}