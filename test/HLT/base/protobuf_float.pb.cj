package base

from std import collection.*
from protobuf import protobuf.*

public class FloatData <: MessageLite & TypedMessage<FloatData> {
    private var p_floatData01: Float32
    public let floatData02: RepeatedField<Float32>

    public init(
        floatData01!: Float32 = Float32(.0),
        floatData02!: Array<Float32> = []
    ) {
        this.p_floatData01 = floatData01
        this.floatData02 = RepeatedField<Float32>(floatData02)
        m_init()
    }

    public init(src: FloatData__Builder) {
        this.p_floatData01 = src.floatData01
        this.floatData02 = RepeatedField<Float32>(src.floatData02)
        m_init()
    }

    private func m_init() {
        m_init(floatData02)
        m_innerInit()
    }

    public mut prop floatData01: Float32 { get() { p_floatData01 } set(_v) { p_floatData01 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (p_floatData01 != .0) { _x += 1 + 4 }
        if (!floatData02.isEmpty()) { let _s = 4 * floatData02.size; _x += 1 + varintSize(_s) + _s }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (p_floatData01 != .0) { _x.write(p_floatData01) }
        if (!floatData02.isEmpty()) { _x.write(floatData02.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_floatData01 == .0 && floatData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_floatData01 = .0
        floatData02.clear()
    }

    public operator func !=(src: FloatData): Bool { !(this == src) }
    public operator func ==(src: FloatData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_floatData01 == src.p_floatData01 && floatData02 == src.floatData02
    }

    public func mergeFrom(src: FloatData): Unit {
        if (src.p_floatData01 != .0) { p_floatData01 = src.p_floatData01 }
        if (!src.floatData02.isEmpty()) { floatData02.appendAll(src.floatData02) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
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
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_floatData01 = src.parseFloat32()
                case 2 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(floatData02, _s.parseFloat32()) } } else { s_add(floatData02, src.parseFloat32()) }
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_floatData01 != .0) { out.append(13); out.packFixed(p_floatData01) }
        if (!floatData02.isEmpty()) { out.append(18); out.packVarint(4 * floatData02.size); for (_i in floatData02) { out.packFixed(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (p_floatData01 != .0) { _x.append("floatData01", p_floatData01) }
        if (!floatData02.isEmpty()) { _x.append("floatData02", floatData02) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { FloatData() }
    public static func newBuilder() { FloatData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = FloatData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = FloatData(); _x.unpack(src); _x }
}

public class FloatData__Builder {
    public var floatData01: Float32 = Float32(.0)
    public func setFloatData01(floatData01: Float32) { this.floatData01 = floatData01; return this }

    public var floatData02: Array<Float32> = []
    public func setFloatData02(floatData02: Array<Float32>) { this.floatData02 = floatData02; return this }

    public func build() { FloatData(this) }
}
