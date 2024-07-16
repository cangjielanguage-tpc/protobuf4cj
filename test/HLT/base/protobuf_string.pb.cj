package base

from std import collection.*
from protobuf import protobuf.*

public class StringData <: MessageLite & TypedMessage<StringData> {
    private var p_stringData01: String
    public let stringData02: RepeatedField<String>

    public init(
        stringData01!: String = "",
        stringData02!: Array<String> = []
    ) {
        this.p_stringData01 = stringData01
        this.stringData02 = RepeatedField<String>(stringData02)
        m_init()
    }

    public init(src: StringData__Builder) {
        this.p_stringData01 = src.stringData01
        this.stringData02 = RepeatedField<String>(src.stringData02)
        m_init()
    }

    private func m_init() {
        m_init(stringData02)
        m_innerInit()
    }

    public mut prop stringData01: String { get() { p_stringData01 } set(_v) { p_stringData01 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_stringData01.isEmpty()) { _x += 1 + binSize(p_stringData01) }
        if (!stringData02.isEmpty()) { for (_i in stringData02) { _x += 1 + binSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_stringData01.isEmpty()) { _x.write(p_stringData01.hashCode()) }
        if (!stringData02.isEmpty()) { _x.write(stringData02.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_stringData01.isEmpty() && stringData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_stringData01 = ""
        stringData02.clear()
    }

    public operator func !=(src: StringData): Bool { !(this == src) }
    public operator func ==(src: StringData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_stringData01 == src.p_stringData01 && stringData02 == src.stringData02
    }

    public func mergeFrom(src: StringData): Unit {
        if (!src.p_stringData01.isEmpty()) { p_stringData01 = src.p_stringData01 }
        if (!src.stringData02.isEmpty()) { stringData02.appendAll(src.stringData02) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
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
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_stringData01 = src.parseString()
                case 2 => s_add(stringData02, src.parseString())
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_stringData01.isEmpty()) { out.append(10); out.packBin(p_stringData01) }
        if (!stringData02.isEmpty()) { for (_i in stringData02) { out.append(18); out.packBin(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_stringData01.isEmpty()) { _x.append("stringData01", p_stringData01) }
        if (!stringData02.isEmpty()) { _x.append("stringData02", stringData02) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { StringData() }
    public static func newBuilder() { StringData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = StringData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = StringData(); _x.unpack(src); _x }
}

public class StringData__Builder {
    public var stringData01: String = ""
    public func setStringData01(stringData01: String) { this.stringData01 = stringData01; return this }

    public var stringData02: Array<String> = []
    public func setStringData02(stringData02: Array<String>) { this.stringData02 = stringData02; return this }

    public func build() { StringData(this) }
}
