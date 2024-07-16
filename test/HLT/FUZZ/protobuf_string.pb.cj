package base

from std import collection.*
from protobuf import protobuf.*

public class StringData <: MessageLite & TypedMessage<StringData> {
    private var p_stringData01 = Pb3String()
    public let stringData02 = RepeatedString()

    public init() {
        m_init(stringData02)
        m_innerInit()
    }

    public mut prop stringData01: String { get() { p_stringData01.get() } set(i_vtmp) { p_stringData01.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!p_stringData01.isEmpty()) { i_tmp += 1 + binSize(p_stringData01.data) }
        if (!stringData02.isEmpty()) { i_tmp += m_size(stringData02, 1) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_stringData01.isEmpty() && stringData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_stringData01.clear()
        stringData02.clear()
    }

    public func copyFrom(src: StringData): StringData {
        p_stringData01 = src.p_stringData01
        stringData02.copyFrom(src.stringData02)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): StringData {
        return StringData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_stringData01.unpack(src)
                case 2 => s_add(stringData02, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_stringData01.isEmpty()) { out.append(10); out.packBin(p_stringData01.data) }
        if (!stringData02.isEmpty()) { s_pack(2, stringData02, out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!p_stringData01.isEmpty()) { i_tmp.append("stringData01", p_stringData01.get()) }
        if (!stringData02.isEmpty()) { i_tmp.append("stringData02", stringData02) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { StringData() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = StringData(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = StringData(); i_tmp.unpack(src); i_tmp }
}
