package base

from std import collection.*
from protobuf import protobuf.*

public class DoubleData <: MessageLite & TypedMessage<DoubleData> {
    private var p_doubleData01 = .0
    public let doubleData02 = RepeatedField<Float64>()

    public init() {
        m_init(doubleData02)
        m_innerInit()
    }

    public mut prop doubleData01: Float64 { get() { p_doubleData01 } set(i_vtmp) { p_doubleData01 = i_vtmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (p_doubleData01 != .0) { i_tmp += 1 + 8 }
        if (!doubleData02.isEmpty()) { i_tmp += (1 + 8) * doubleData02.size }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_doubleData01 == .0 && doubleData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_doubleData01 = .0
        doubleData02.clear()
    }

    public func copyFrom(src: DoubleData): DoubleData {
        p_doubleData01 = src.p_doubleData01
        doubleData02.copyFrom(src.doubleData02)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): DoubleData {
        return DoubleData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_doubleData01 = src.parseFloat64()
                case 2 => s_add(doubleData02, src.parseFloat64())
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_doubleData01 != .0) { out.append(9); out.packFixed(p_doubleData01) }
        if (!doubleData02.isEmpty()) { for (i_itmp in doubleData02) { out.append(17); out.packFixed(i_itmp) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (p_doubleData01 != .0) { i_tmp.append("doubleData01", p_doubleData01) }
        if (!doubleData02.isEmpty()) { i_tmp.append("doubleData02", doubleData02) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DoubleData() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DoubleData(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DoubleData(); i_tmp.unpack(src); i_tmp }
}
