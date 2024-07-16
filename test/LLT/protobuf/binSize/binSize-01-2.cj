// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var n: GrpcErrorMessage = GrpcErrorMessage()
    n.code = 10
    n.msg = "123"
    var n2: MessageLite = n
    let num = binSize(n2)

    if(num != 8) {
        return -1
    }

    return 0
}


public class GrpcErrorMessage <: MessageLite {

    private var p_code = UInt32(0)
    private var p_msg = Pb3String()

    public init() {
        m_innerInit()
    }
    public init(code: UInt32, msg: String) {
        this.p_code = code
        this.p_msg.set(msg)
    }

    public mut prop code: UInt32 { get() { p_code } set(i_vtmp) { p_code = i_vtmp; markDirty() } }

    public mut prop msg: String { get() { p_msg.get() } set(i_vtmp) { p_msg.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (p_code != 0) { i_tmp += 1 + varintSize(p_code) }
        if (!p_msg.isEmpty()) { i_tmp += 1 + binSize(p_msg.data) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_code == 0 && p_msg.isEmpty()
    }

    protected func m_clear(): Unit {
        p_code = 0
        p_msg.clear()
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_code = src.parseUInt32()
                case 2 => p_msg.unpack(src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_code != 0) { out.append(8); out.packVarint(p_code) }
        if (!p_msg.isEmpty()) { out.append(18); out.packBin(p_msg.data) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (p_code != 0) { i_tmp.append("code", p_code) }
        if (!p_msg.isEmpty()) { i_tmp.append("msg", p_msg.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

}

