package base

from std import collection.*
from protobuf import protobuf.*

public class ByteData <: MessageLite & TypedMessage<ByteData> {
    private var p_byteData01: BytesSlice
    public let byteData02: RepeatedField<BytesSlice>

    public init(
        byteData01!: BytesSlice = BytesSlice(),
        byteData02!: Array<Bytes> = []
    ) {
        this.p_byteData01 = byteData01
        this.byteData02 = RepeatedField<BytesSlice>(byteData02.size) { _i => BytesSlice(byteData02[_i]) }
        m_init()
    }

    public init(src: ByteData__Builder) {
        this.p_byteData01 = src.byteData01
        this.byteData02 = RepeatedField<BytesSlice>(src.byteData02.size) { _i => BytesSlice(src.byteData02[_i]) }
        m_init()
    }

    private func m_init() {
        m_init(byteData02)
        m_innerInit()
    }

    public mut prop byteData01: BytesSlice { get() { p_byteData01 } set(_v) { p_byteData01 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_byteData01.isEmpty()) { _x += 1 + binSize(p_byteData01) }
        if (!byteData02.isEmpty()) { for (_i in byteData02) { _x += 1 + binSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_byteData01.isEmpty()) { _x.write(p_byteData01.hashCode()) }
        if (!byteData02.isEmpty()) { _x.write(byteData02.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_byteData01.isEmpty() && byteData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_byteData01 = BytesSlice()
        byteData02.clear()
    }

    public operator func !=(src: ByteData): Bool { !(this == src) }
    public operator func ==(src: ByteData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_byteData01 == src.p_byteData01 && byteData02 == src.byteData02
    }

    public func mergeFrom(src: ByteData): Unit {
        if (!src.p_byteData01.isEmpty()) { p_byteData01 = src.p_byteData01 }
        if (!src.byteData02.isEmpty()) { byteData02.appendAll(src.byteData02) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: ByteData): ByteData {
        p_byteData01 = src.p_byteData01
        byteData02.copyFrom(src.byteData02)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): ByteData {
        return ByteData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_byteData01 = src.parseBytesSlice()
                case 2 => s_add(byteData02, src.parseBytesSlice())
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_byteData01.isEmpty()) { out.append(10); out.packBin(p_byteData01) }
        if (!byteData02.isEmpty()) { for (_i in byteData02) { out.append(18); out.packBin(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_byteData01.isEmpty()) { _x.append("byteData01", p_byteData01) }
        if (!byteData02.isEmpty()) { _x.append("byteData02", byteData02) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { ByteData() }
    public static func newBuilder() { ByteData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = ByteData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = ByteData(); _x.unpack(src); _x }
}

public class ByteData__Builder {
    public var byteData01: BytesSlice = BytesSlice()
    public func setByteData01(byteData01: BytesSlice) { this.byteData01 = byteData01; return this }

    public var byteData02: Array<Bytes> = []
    public func setByteData02(byteData02: Array<Bytes>) { this.byteData02 = byteData02; return this }

    public func build() { ByteData(this) }
}
