package base

from std import collection.*
from protobuf import protobuf.*

public class FloatData <: MessageLite & TypedMessage<FloatData> {
    private var p_floatData01 = Float32(.0)
    public let floatData02 = RepeatedField<Float32>()

    public init() {
        m_init(floatData02)
        m_innerInit()
    }

    public mut prop floatData01: Float32 { get() { p_floatData01 } set(i_vtmp) { p_floatData01 = i_vtmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (p_floatData01 != .0) { i_tmp += 1 + 4 }
        if (!floatData02.isEmpty()) { i_tmp += (1 + 4) * floatData02.size }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_floatData01 == .0 && floatData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_floatData01 = .0
        floatData02.clear()
    }

    public func copyFrom(src: FloatData): FloatData {
        p_floatData01 = src.p_floatData01
        floatData02.copyFrom(src.floatData02)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FloatData {
        return FloatData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_floatData01 = src.parseFloat32()
                case 2 => s_add(floatData02, src.parseFloat32())
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_floatData01 != .0) { out.append(13); out.packFixed(p_floatData01) }
        if (!floatData02.isEmpty()) { for (i_itmp in floatData02) { out.append(21); out.packFixed(i_itmp) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (p_floatData01 != .0) { i_tmp.append("floatData01", p_floatData01) }
        if (!floatData02.isEmpty()) { i_tmp.append("floatData02", floatData02) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FloatData() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FloatData(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FloatData(); i_tmp.unpack(src); i_tmp }
}
