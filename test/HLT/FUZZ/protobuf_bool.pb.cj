package base

from std import collection.*
from protobuf import protobuf.*

public class BoolData <: MessageLite & TypedMessage<BoolData> {
    private var p_boolData01 = false
    public let boolData02 = RepeatedField<Bool>()

    public init() {
        m_init(boolData02)
        m_innerInit()
    }

    public mut prop boolData01: Bool { get() { p_boolData01 } set(i_vtmp) { p_boolData01 = i_vtmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (p_boolData01) { i_tmp += 1 + 1 }
        if (!boolData02.isEmpty()) { i_tmp += (1 + 1) * boolData02.size }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_boolData01 == false && boolData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_boolData01 = false
        boolData02.clear()
    }

    public func copyFrom(src: BoolData): BoolData {
        p_boolData01 = src.p_boolData01
        boolData02.copyFrom(src.boolData02)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): BoolData {
        return BoolData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_boolData01 = src.parseBool()
                case 2 => s_add(boolData02, src.parseBool())
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_boolData01) { out.append(8); out.packBool(p_boolData01) }
        if (!boolData02.isEmpty()) { for (i_itmp in boolData02) { out.append(16); out.packBool(i_itmp) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (p_boolData01) { i_tmp.append("boolData01", p_boolData01) }
        if (!boolData02.isEmpty()) { i_tmp.append("boolData02", boolData02) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { BoolData() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = BoolData(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = BoolData(); i_tmp.unpack(src); i_tmp }
}
