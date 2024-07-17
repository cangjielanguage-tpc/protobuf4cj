package base

from std import collection.*
from protobuf import protobuf.*

public class DoubleData <: MessageLite & TypedMessage<DoubleData> {
    private var p_doubleData01: Float64
    public let doubleData02: RepeatedField<Float64>

    public init(
        doubleData01!: Float64 = .0,
        doubleData02!: Array<Float64> = []
    ) {
        this.p_doubleData01 = doubleData01
        this.doubleData02 = RepeatedField<Float64>(doubleData02)
        m_init()
    }

    public init(src: DoubleData__Builder) {
        this.p_doubleData01 = src.doubleData01
        this.doubleData02 = RepeatedField<Float64>(src.doubleData02)
        m_init()
    }

    private func m_init() {
        m_init(doubleData02)
        m_innerInit()
    }

    public mut prop doubleData01: Float64 { get() { p_doubleData01 } set(_v) { p_doubleData01 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (p_doubleData01 != .0) { _x += 1 + 8 }
        if (!doubleData02.isEmpty()) { let _s = 8 * doubleData02.size; _x += 1 + varintSize(_s) + _s }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (p_doubleData01 != .0) { _x.write(p_doubleData01) }
        if (!doubleData02.isEmpty()) { _x.write(doubleData02.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_doubleData01 == .0 && doubleData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_doubleData01 = .0
        doubleData02.clear()
    }

    public operator func !=(src: DoubleData): Bool { !(this == src) }
    public operator func ==(src: DoubleData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_doubleData01 == src.p_doubleData01 && doubleData02 == src.doubleData02
    }

    public func mergeFrom(src: DoubleData): Unit {
        if (src.p_doubleData01 != .0) { p_doubleData01 = src.p_doubleData01 }
        if (!src.doubleData02.isEmpty()) { doubleData02.appendAll(src.doubleData02) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
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
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_doubleData01 = src.parseFloat64()
                case 2 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(doubleData02, _s.parseFloat64()) } } else { s_add(doubleData02, src.parseFloat64()) }
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_doubleData01 != .0) { out.append(9); out.packFixed(p_doubleData01) }
        if (!doubleData02.isEmpty()) { out.append(18); out.packVarint(8 * doubleData02.size); for (_i in doubleData02) { out.packFixed(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (p_doubleData01 != .0) { _x.append("doubleData01", p_doubleData01) }
        if (!doubleData02.isEmpty()) { _x.append("doubleData02", doubleData02) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { DoubleData() }
    public static func newBuilder() { DoubleData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = DoubleData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = DoubleData(); _x.unpack(src); _x }
}

public class DoubleData__Builder {
    public var doubleData01: Float64 = .0
    public func setDoubleData01(doubleData01: Float64) { this.doubleData01 = doubleData01; return this }

    public var doubleData02: Array<Float64> = []
    public func setDoubleData02(doubleData02: Array<Float64>) { this.doubleData02 = doubleData02; return this }

    public func build() { DoubleData(this) }
}
