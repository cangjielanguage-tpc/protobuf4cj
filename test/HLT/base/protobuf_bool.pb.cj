package base

from std import collection.*
from protobuf import protobuf.*

public class BoolData <: MessageLite & TypedMessage<BoolData> {
    private var p_boolData01: Bool
    public let boolData02: RepeatedField<Bool>

    public init(
        boolData01!: Bool = false,
        boolData02!: Array<Bool> = []
    ) {
        this.p_boolData01 = boolData01
        this.boolData02 = RepeatedField<Bool>(boolData02)
        m_init()
    }

    public init(src: BoolData__Builder) {
        this.p_boolData01 = src.boolData01
        this.boolData02 = RepeatedField<Bool>(src.boolData02)
        m_init()
    }

    private func m_init() {
        m_init(boolData02)
        m_innerInit()
    }

    public mut prop boolData01: Bool { get() { p_boolData01 } set(_v) { p_boolData01 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (p_boolData01) { _x += 1 + 1 }
        if (!boolData02.isEmpty()) { let _s = boolData02.size; _x += 1 + varintSize(_s) + _s }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (p_boolData01) { _x.write(p_boolData01) }
        if (!boolData02.isEmpty()) { _x.write(boolData02.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_boolData01 == false && boolData02.isEmpty()
    }

    protected func m_clear(): Unit {
        p_boolData01 = false
        boolData02.clear()
    }

    public operator func !=(src: BoolData): Bool { !(this == src) }
    public operator func ==(src: BoolData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_boolData01 == src.p_boolData01 && boolData02 == src.boolData02
    }

    public func mergeFrom(src: BoolData): Unit {
        if (src.p_boolData01) { p_boolData01 = src.p_boolData01 }
        if (!src.boolData02.isEmpty()) { boolData02.appendAll(src.boolData02) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
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
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_boolData01 = src.parseBool()
                case 2 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(boolData02, _s.parseBool()) } } else { s_add(boolData02, src.parseBool()) }
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_boolData01) { out.append(8); out.packBool(p_boolData01) }
        if (!boolData02.isEmpty()) { out.append(18); out.packVarint(boolData02.size); for (_i in boolData02) { out.packBool(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (p_boolData01) { _x.append("boolData01", p_boolData01) }
        if (!boolData02.isEmpty()) { _x.append("boolData02", boolData02) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { BoolData() }
    public static func newBuilder() { BoolData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = BoolData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = BoolData(); _x.unpack(src); _x }
}

public class BoolData__Builder {
    public var boolData01: Bool = false
    public func setBoolData01(boolData01: Bool) { this.boolData01 = boolData01; return this }

    public var boolData02: Array<Bool> = []
    public func setBoolData02(boolData02: Array<Bool>) { this.boolData02 = boolData02; return this }

    public func build() { BoolData(this) }
}
