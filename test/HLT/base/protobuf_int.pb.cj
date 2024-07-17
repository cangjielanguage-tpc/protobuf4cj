package base

from std import collection.*
from protobuf import protobuf.*

public class IntData <: MessageLite & TypedMessage<IntData> {
    private var p_intData01: Int32
    public let intData02: RepeatedField<Int32>
    private var p_intData03: Int64
    public let intData04: RepeatedField<Int64>
    private var p_uIntData01: UInt32
    public let uIntData02: RepeatedField<UInt32>
    private var p_uIntData03: UInt64
    public let uIntData04: RepeatedField<UInt64>
    private var p_sIntData01: Int32
    public let sIntData02: RepeatedField<Int32>
    private var p_sIntData03: Int64
    public let sIntData04: RepeatedField<Int64>
    private var p_fixedData01: UInt32
    public let fixedData02: RepeatedField<UInt32>
    private var p_fixedData03: UInt64
    public let fixedData04: RepeatedField<UInt64>
    private var p_sFixedData01: Int32
    public let sFixedData02: RepeatedField<Int32>
    private var p_sFixedData03: Int64
    public let sFixedData04: RepeatedField<Int64>

    public init(
        intData01!: Int32 = Int32(0),
        intData02!: Array<Int32> = [],
        intData03!: Int64 = 0,
        intData04!: Array<Int64> = [],
        uIntData01!: UInt32 = UInt32(0),
        uIntData02!: Array<UInt32> = [],
        uIntData03!: UInt64 = UInt64(0),
        uIntData04!: Array<UInt64> = [],
        sIntData01!: Int32 = Int32(0),
        sIntData02!: Array<Int32> = [],
        sIntData03!: Int64 = 0,
        sIntData04!: Array<Int64> = [],
        fixedData01!: UInt32 = UInt32(0),
        fixedData02!: Array<UInt32> = [],
        fixedData03!: UInt64 = UInt64(0),
        fixedData04!: Array<UInt64> = [],
        sFixedData01!: Int32 = Int32(0),
        sFixedData02!: Array<Int32> = [],
        sFixedData03!: Int64 = 0,
        sFixedData04!: Array<Int64> = []
    ) {
        this.p_intData01 = intData01
        this.intData02 = RepeatedField<Int32>(intData02)
        this.p_intData03 = intData03
        this.intData04 = RepeatedField<Int64>(intData04)
        this.p_uIntData01 = uIntData01
        this.uIntData02 = RepeatedField<UInt32>(uIntData02)
        this.p_uIntData03 = uIntData03
        this.uIntData04 = RepeatedField<UInt64>(uIntData04)
        this.p_sIntData01 = sIntData01
        this.sIntData02 = RepeatedField<Int32>(sIntData02)
        this.p_sIntData03 = sIntData03
        this.sIntData04 = RepeatedField<Int64>(sIntData04)
        this.p_fixedData01 = fixedData01
        this.fixedData02 = RepeatedField<UInt32>(fixedData02)
        this.p_fixedData03 = fixedData03
        this.fixedData04 = RepeatedField<UInt64>(fixedData04)
        this.p_sFixedData01 = sFixedData01
        this.sFixedData02 = RepeatedField<Int32>(sFixedData02)
        this.p_sFixedData03 = sFixedData03
        this.sFixedData04 = RepeatedField<Int64>(sFixedData04)
        m_init()
    }

    public init(src: IntData__Builder) {
        this.p_intData01 = src.intData01
        this.intData02 = RepeatedField<Int32>(src.intData02)
        this.p_intData03 = src.intData03
        this.intData04 = RepeatedField<Int64>(src.intData04)
        this.p_uIntData01 = src.uIntData01
        this.uIntData02 = RepeatedField<UInt32>(src.uIntData02)
        this.p_uIntData03 = src.uIntData03
        this.uIntData04 = RepeatedField<UInt64>(src.uIntData04)
        this.p_sIntData01 = src.sIntData01
        this.sIntData02 = RepeatedField<Int32>(src.sIntData02)
        this.p_sIntData03 = src.sIntData03
        this.sIntData04 = RepeatedField<Int64>(src.sIntData04)
        this.p_fixedData01 = src.fixedData01
        this.fixedData02 = RepeatedField<UInt32>(src.fixedData02)
        this.p_fixedData03 = src.fixedData03
        this.fixedData04 = RepeatedField<UInt64>(src.fixedData04)
        this.p_sFixedData01 = src.sFixedData01
        this.sFixedData02 = RepeatedField<Int32>(src.sFixedData02)
        this.p_sFixedData03 = src.sFixedData03
        this.sFixedData04 = RepeatedField<Int64>(src.sFixedData04)
        m_init()
    }

    private func m_init() {
        m_init(intData02)
        m_init(intData04)
        m_init(uIntData02)
        m_init(uIntData04)
        m_init(sIntData02)
        m_init(sIntData04)
        m_init(fixedData02)
        m_init(fixedData04)
        m_init(sFixedData02)
        m_init(sFixedData04)
        m_innerInit()
    }

    public mut prop intData01: Int32 { get() { p_intData01 } set(_v) { p_intData01 = _v; markDirty() } }

    public mut prop intData03: Int64 { get() { p_intData03 } set(_v) { p_intData03 = _v; markDirty() } }

    public mut prop uIntData01: UInt32 { get() { p_uIntData01 } set(_v) { p_uIntData01 = _v; markDirty() } }

    public mut prop uIntData03: UInt64 { get() { p_uIntData03 } set(_v) { p_uIntData03 = _v; markDirty() } }

    public mut prop sIntData01: Int32 { get() { p_sIntData01 } set(_v) { p_sIntData01 = _v; markDirty() } }

    public mut prop sIntData03: Int64 { get() { p_sIntData03 } set(_v) { p_sIntData03 = _v; markDirty() } }

    public mut prop fixedData01: UInt32 { get() { p_fixedData01 } set(_v) { p_fixedData01 = _v; markDirty() } }

    public mut prop fixedData03: UInt64 { get() { p_fixedData03 } set(_v) { p_fixedData03 = _v; markDirty() } }

    public mut prop sFixedData01: Int32 { get() { p_sFixedData01 } set(_v) { p_sFixedData01 = _v; markDirty() } }

    public mut prop sFixedData03: Int64 { get() { p_sFixedData03 } set(_v) { p_sFixedData03 = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (p_intData01 != 0) { _x += 1 + varintSize(p_intData01) }
        if (!intData02.isEmpty()) { var _s = 0; for (_i in intData02) { _s += varintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_intData03 != 0) { _x += 1 + varintSize(p_intData03) }
        if (!intData04.isEmpty()) { var _s = 0; for (_i in intData04) { _s += varintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_uIntData01 != 0) { _x += 1 + varintSize(p_uIntData01) }
        if (!uIntData02.isEmpty()) { var _s = 0; for (_i in uIntData02) { _s += varintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_uIntData03 != 0) { _x += 1 + varintSize(p_uIntData03) }
        if (!uIntData04.isEmpty()) { var _s = 0; for (_i in uIntData04) { _s += varintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_sIntData01 != 0) { _x += 1 + sintSize(p_sIntData01) }
        if (!sIntData02.isEmpty()) { var _s = 0; for (_i in sIntData02) { _s += sintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_sIntData03 != 0) { _x += 1 + sintSize(p_sIntData03) }
        if (!sIntData04.isEmpty()) { var _s = 0; for (_i in sIntData04) { _s += sintSize(_i) }; _x += 1 + varintSize(_s) + _s }
        if (p_fixedData01 != 0) { _x += 1 + 4 }
        if (!fixedData02.isEmpty()) { let _s = 4 * fixedData02.size; _x += 1 + varintSize(_s) + _s }
        if (p_fixedData03 != 0) { _x += 2 + 8 }
        if (!fixedData04.isEmpty()) { let _s = 8 * fixedData04.size; _x += 2 + varintSize(_s) + _s }
        if (p_sFixedData01 != 0) { _x += 2 + 4 }
        if (!sFixedData02.isEmpty()) { let _s = 4 * sFixedData02.size; _x += 2 + varintSize(_s) + _s }
        if (p_sFixedData03 != 0) { _x += 2 + 8 }
        if (!sFixedData04.isEmpty()) { let _s = 8 * sFixedData04.size; _x += 2 + varintSize(_s) + _s }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (p_intData01 != 0) { _x.write(p_intData01) }
        if (!intData02.isEmpty()) { _x.write(intData02.hashCode()) }
        if (p_intData03 != 0) { _x.write(p_intData03) }
        if (!intData04.isEmpty()) { _x.write(intData04.hashCode()) }
        if (p_uIntData01 != 0) { _x.write(p_uIntData01) }
        if (!uIntData02.isEmpty()) { _x.write(uIntData02.hashCode()) }
        if (p_uIntData03 != 0) { _x.write(p_uIntData03) }
        if (!uIntData04.isEmpty()) { _x.write(uIntData04.hashCode()) }
        if (p_sIntData01 != 0) { _x.write(p_sIntData01) }
        if (!sIntData02.isEmpty()) { _x.write(sIntData02.hashCode()) }
        if (p_sIntData03 != 0) { _x.write(p_sIntData03) }
        if (!sIntData04.isEmpty()) { _x.write(sIntData04.hashCode()) }
        if (p_fixedData01 != 0) { _x.write(p_fixedData01) }
        if (!fixedData02.isEmpty()) { _x.write(fixedData02.hashCode()) }
        if (p_fixedData03 != 0) { _x.write(p_fixedData03) }
        if (!fixedData04.isEmpty()) { _x.write(fixedData04.hashCode()) }
        if (p_sFixedData01 != 0) { _x.write(p_sFixedData01) }
        if (!sFixedData02.isEmpty()) { _x.write(sFixedData02.hashCode()) }
        if (p_sFixedData03 != 0) { _x.write(p_sFixedData03) }
        if (!sFixedData04.isEmpty()) { _x.write(sFixedData04.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_intData01 == 0 && intData02.isEmpty() && p_intData03 == 0 && intData04.isEmpty() && p_uIntData01 == 0 &&
        uIntData02.isEmpty() && p_uIntData03 == 0 && uIntData04.isEmpty() && p_sIntData01 == 0 &&
        sIntData02.isEmpty() && p_sIntData03 == 0 && sIntData04.isEmpty() && p_fixedData01 == 0 &&
        fixedData02.isEmpty() && p_fixedData03 == 0 && fixedData04.isEmpty() && p_sFixedData01 == 0 &&
        sFixedData02.isEmpty() && p_sFixedData03 == 0 && sFixedData04.isEmpty()
    }

    protected func m_clear(): Unit {
        p_intData01 = 0
        intData02.clear()
        p_intData03 = 0
        intData04.clear()
        p_uIntData01 = 0
        uIntData02.clear()
        p_uIntData03 = 0
        uIntData04.clear()
        p_sIntData01 = 0
        sIntData02.clear()
        p_sIntData03 = 0
        sIntData04.clear()
        p_fixedData01 = 0
        fixedData02.clear()
        p_fixedData03 = 0
        fixedData04.clear()
        p_sFixedData01 = 0
        sFixedData02.clear()
        p_sFixedData03 = 0
        sFixedData04.clear()
    }

    public operator func !=(src: IntData): Bool { !(this == src) }
    public operator func ==(src: IntData): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_intData01 == src.p_intData01 && intData02 == src.intData02 && p_intData03 == src.p_intData03 &&
        intData04 == src.intData04 && p_uIntData01 == src.p_uIntData01 && uIntData02 == src.uIntData02 &&
        p_uIntData03 == src.p_uIntData03 && uIntData04 == src.uIntData04 && p_sIntData01 == src.p_sIntData01 &&
        sIntData02 == src.sIntData02 && p_sIntData03 == src.p_sIntData03 && sIntData04 == src.sIntData04 &&
        p_fixedData01 == src.p_fixedData01 && fixedData02 == src.fixedData02 && p_fixedData03 == src.p_fixedData03 &&
        fixedData04 == src.fixedData04 && p_sFixedData01 == src.p_sFixedData01 && sFixedData02 == src.sFixedData02 &&
        p_sFixedData03 == src.p_sFixedData03 && sFixedData04 == src.sFixedData04
    }

    public func mergeFrom(src: IntData): Unit {
        if (src.p_intData01 != 0) { p_intData01 = src.p_intData01 }
        if (!src.intData02.isEmpty()) { intData02.appendAll(src.intData02) }
        if (src.p_intData03 != 0) { p_intData03 = src.p_intData03 }
        if (!src.intData04.isEmpty()) { intData04.appendAll(src.intData04) }
        if (src.p_uIntData01 != 0) { p_uIntData01 = src.p_uIntData01 }
        if (!src.uIntData02.isEmpty()) { uIntData02.appendAll(src.uIntData02) }
        if (src.p_uIntData03 != 0) { p_uIntData03 = src.p_uIntData03 }
        if (!src.uIntData04.isEmpty()) { uIntData04.appendAll(src.uIntData04) }
        if (src.p_sIntData01 != 0) { p_sIntData01 = src.p_sIntData01 }
        if (!src.sIntData02.isEmpty()) { sIntData02.appendAll(src.sIntData02) }
        if (src.p_sIntData03 != 0) { p_sIntData03 = src.p_sIntData03 }
        if (!src.sIntData04.isEmpty()) { sIntData04.appendAll(src.sIntData04) }
        if (src.p_fixedData01 != 0) { p_fixedData01 = src.p_fixedData01 }
        if (!src.fixedData02.isEmpty()) { fixedData02.appendAll(src.fixedData02) }
        if (src.p_fixedData03 != 0) { p_fixedData03 = src.p_fixedData03 }
        if (!src.fixedData04.isEmpty()) { fixedData04.appendAll(src.fixedData04) }
        if (src.p_sFixedData01 != 0) { p_sFixedData01 = src.p_sFixedData01 }
        if (!src.sFixedData02.isEmpty()) { sFixedData02.appendAll(src.sFixedData02) }
        if (src.p_sFixedData03 != 0) { p_sFixedData03 = src.p_sFixedData03 }
        if (!src.sFixedData04.isEmpty()) { sFixedData04.appendAll(src.sFixedData04) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: IntData): IntData {
        p_intData01 = src.p_intData01
        intData02.copyFrom(src.intData02)
        p_intData03 = src.p_intData03
        intData04.copyFrom(src.intData04)
        p_uIntData01 = src.p_uIntData01
        uIntData02.copyFrom(src.uIntData02)
        p_uIntData03 = src.p_uIntData03
        uIntData04.copyFrom(src.uIntData04)
        p_sIntData01 = src.p_sIntData01
        sIntData02.copyFrom(src.sIntData02)
        p_sIntData03 = src.p_sIntData03
        sIntData04.copyFrom(src.sIntData04)
        p_fixedData01 = src.p_fixedData01
        fixedData02.copyFrom(src.fixedData02)
        p_fixedData03 = src.p_fixedData03
        fixedData04.copyFrom(src.fixedData04)
        p_sFixedData01 = src.p_sFixedData01
        sFixedData02.copyFrom(src.sFixedData02)
        p_sFixedData03 = src.p_sFixedData03
        sFixedData04.copyFrom(src.sFixedData04)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): IntData {
        return IntData().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_intData01 = src.parseInt32()
                case 2 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(intData02, _s.parseInt32()) } } else { s_add(intData02, src.parseInt32()) }
                case 3 => p_intData03 = src.parseInt64()
                case 4 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(intData04, _s.parseInt64()) } } else { s_add(intData04, src.parseInt64()) }
                case 5 => p_uIntData01 = src.parseUInt32()
                case 6 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(uIntData02, _s.parseUInt32()) } } else { s_add(uIntData02, src.parseUInt32()) }
                case 7 => p_uIntData03 = src.parseUInt64()
                case 8 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(uIntData04, _s.parseUInt64()) } } else { s_add(uIntData04, src.parseUInt64()) }
                case 10 => p_sIntData01 = src.parseSInt32()
                case 11 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(sIntData02, _s.parseSInt32()) } } else { s_add(sIntData02, src.parseSInt32()) }
                case 12 => p_sIntData03 = src.parseSInt64()
                case 13 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(sIntData04, _s.parseSInt64()) } } else { s_add(sIntData04, src.parseSInt64()) }
                case 14 => p_fixedData01 = src.parseFixed32()
                case 15 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(fixedData02, _s.parseFixed32()) } } else { s_add(fixedData02, src.parseFixed32()) }
                case 16 => p_fixedData03 = src.parseFixed64()
                case 17 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(fixedData04, _s.parseFixed64()) } } else { s_add(fixedData04, src.parseFixed64()) }
                case 18 => p_sFixedData01 = src.parseSFixed32()
                case 19 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(sFixedData02, _s.parseSFixed32()) } } else { s_add(sFixedData02, src.parseSFixed32()) }
                case 20 => p_sFixedData03 = src.parseSFixed64()
                case 21 => if (_x[1] == PREFIXED) { let _s = subReader(src); while (!_s.isEmpty()) { s_add(sFixedData04, _s.parseSFixed64()) } } else { s_add(sFixedData04, src.parseSFixed64()) }
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (p_intData01 != 0) { out.append(8); out.packVarint(p_intData01) }
        if (!intData02.isEmpty()) { out.append(18); var _s = 0; for (_i in intData02) { _s += varintSize(_i) }; out.packVarint(_s); for (_i in intData02) { out.packVarint(_i) } }
        if (p_intData03 != 0) { out.append(24); out.packVarint(p_intData03) }
        if (!intData04.isEmpty()) { out.append(34); var _s = 0; for (_i in intData04) { _s += varintSize(_i) }; out.packVarint(_s); for (_i in intData04) { out.packVarint(_i) } }
        if (p_uIntData01 != 0) { out.append(40); out.packVarint(p_uIntData01) }
        if (!uIntData02.isEmpty()) { out.append(50); var _s = 0; for (_i in uIntData02) { _s += varintSize(_i) }; out.packVarint(_s); for (_i in uIntData02) { out.packVarint(_i) } }
        if (p_uIntData03 != 0) { out.append(56); out.packVarint(p_uIntData03) }
        if (!uIntData04.isEmpty()) { out.append(66); var _s = 0; for (_i in uIntData04) { _s += varintSize(_i) }; out.packVarint(_s); for (_i in uIntData04) { out.packVarint(_i) } }
        if (p_sIntData01 != 0) { out.append(80); out.packSInt(p_sIntData01) }
        if (!sIntData02.isEmpty()) { out.append(90); var _s = 0; for (_i in sIntData02) { _s += sintSize(_i) }; out.packVarint(_s); for (_i in sIntData02) { out.packSInt(_i) } }
        if (p_sIntData03 != 0) { out.append(96); out.packSInt(p_sIntData03) }
        if (!sIntData04.isEmpty()) { out.append(106); var _s = 0; for (_i in sIntData04) { _s += sintSize(_i) }; out.packVarint(_s); for (_i in sIntData04) { out.packSInt(_i) } }
        if (p_fixedData01 != 0) { out.append(117); out.packFixed(p_fixedData01) }
        if (!fixedData02.isEmpty()) { out.append(122); out.packVarint(4 * fixedData02.size); for (_i in fixedData02) { out.packFixed(_i) } }
        if (p_fixedData03 != 0) { out.packTag(16, BIT64); out.packFixed(p_fixedData03) }
        if (!fixedData04.isEmpty()) { out.packTag(17, PREFIXED); out.packVarint(8 * fixedData04.size); for (_i in fixedData04) { out.packFixed(_i) } }
        if (p_sFixedData01 != 0) { out.packTag(18, BIT32); out.packFixed(p_sFixedData01) }
        if (!sFixedData02.isEmpty()) { out.packTag(19, PREFIXED); out.packVarint(4 * sFixedData02.size); for (_i in sFixedData02) { out.packFixed(_i) } }
        if (p_sFixedData03 != 0) { out.packTag(20, BIT64); out.packFixed(p_sFixedData03) }
        if (!sFixedData04.isEmpty()) { out.packTag(21, PREFIXED); out.packVarint(8 * sFixedData04.size); for (_i in sFixedData04) { out.packFixed(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (p_intData01 != 0) { _x.append("intData01", p_intData01) }
        if (!intData02.isEmpty()) { _x.append("intData02", intData02) }
        if (p_intData03 != 0) { _x.append("intData03", p_intData03) }
        if (!intData04.isEmpty()) { _x.append("intData04", intData04) }
        if (p_uIntData01 != 0) { _x.append("uIntData01", p_uIntData01) }
        if (!uIntData02.isEmpty()) { _x.append("uIntData02", uIntData02) }
        if (p_uIntData03 != 0) { _x.append("uIntData03", p_uIntData03) }
        if (!uIntData04.isEmpty()) { _x.append("uIntData04", uIntData04) }
        if (p_sIntData01 != 0) { _x.append("sIntData01", p_sIntData01) }
        if (!sIntData02.isEmpty()) { _x.append("sIntData02", sIntData02) }
        if (p_sIntData03 != 0) { _x.append("sIntData03", p_sIntData03) }
        if (!sIntData04.isEmpty()) { _x.append("sIntData04", sIntData04) }
        if (p_fixedData01 != 0) { _x.append("fixedData01", p_fixedData01) }
        if (!fixedData02.isEmpty()) { _x.append("fixedData02", fixedData02) }
        if (p_fixedData03 != 0) { _x.append("fixedData03", p_fixedData03) }
        if (!fixedData04.isEmpty()) { _x.append("fixedData04", fixedData04) }
        if (p_sFixedData01 != 0) { _x.append("sFixedData01", p_sFixedData01) }
        if (!sFixedData02.isEmpty()) { _x.append("sFixedData02", sFixedData02) }
        if (p_sFixedData03 != 0) { _x.append("sFixedData03", p_sFixedData03) }
        if (!sFixedData04.isEmpty()) { _x.append("sFixedData04", sFixedData04) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { IntData() }
    public static func newBuilder() { IntData__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = IntData(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = IntData(); _x.unpack(src); _x }
}

public class IntData__Builder {
    public var intData01: Int32 = Int32(0)
    public func setIntData01(intData01: Int32) { this.intData01 = intData01; return this }

    public var intData02: Array<Int32> = []
    public func setIntData02(intData02: Array<Int32>) { this.intData02 = intData02; return this }

    public var intData03: Int64 = 0
    public func setIntData03(intData03: Int64) { this.intData03 = intData03; return this }

    public var intData04: Array<Int64> = []
    public func setIntData04(intData04: Array<Int64>) { this.intData04 = intData04; return this }

    public var uIntData01: UInt32 = UInt32(0)
    public func setUIntData01(uIntData01: UInt32) { this.uIntData01 = uIntData01; return this }

    public var uIntData02: Array<UInt32> = []
    public func setUIntData02(uIntData02: Array<UInt32>) { this.uIntData02 = uIntData02; return this }

    public var uIntData03: UInt64 = UInt64(0)
    public func setUIntData03(uIntData03: UInt64) { this.uIntData03 = uIntData03; return this }

    public var uIntData04: Array<UInt64> = []
    public func setUIntData04(uIntData04: Array<UInt64>) { this.uIntData04 = uIntData04; return this }

    public var sIntData01: Int32 = Int32(0)
    public func setSIntData01(sIntData01: Int32) { this.sIntData01 = sIntData01; return this }

    public var sIntData02: Array<Int32> = []
    public func setSIntData02(sIntData02: Array<Int32>) { this.sIntData02 = sIntData02; return this }

    public var sIntData03: Int64 = 0
    public func setSIntData03(sIntData03: Int64) { this.sIntData03 = sIntData03; return this }

    public var sIntData04: Array<Int64> = []
    public func setSIntData04(sIntData04: Array<Int64>) { this.sIntData04 = sIntData04; return this }

    public var fixedData01: UInt32 = UInt32(0)
    public func setFixedData01(fixedData01: UInt32) { this.fixedData01 = fixedData01; return this }

    public var fixedData02: Array<UInt32> = []
    public func setFixedData02(fixedData02: Array<UInt32>) { this.fixedData02 = fixedData02; return this }

    public var fixedData03: UInt64 = UInt64(0)
    public func setFixedData03(fixedData03: UInt64) { this.fixedData03 = fixedData03; return this }

    public var fixedData04: Array<UInt64> = []
    public func setFixedData04(fixedData04: Array<UInt64>) { this.fixedData04 = fixedData04; return this }

    public var sFixedData01: Int32 = Int32(0)
    public func setSFixedData01(sFixedData01: Int32) { this.sFixedData01 = sFixedData01; return this }

    public var sFixedData02: Array<Int32> = []
    public func setSFixedData02(sFixedData02: Array<Int32>) { this.sFixedData02 = sFixedData02; return this }

    public var sFixedData03: Int64 = 0
    public func setSFixedData03(sFixedData03: Int64) { this.sFixedData03 = sFixedData03; return this }

    public var sFixedData04: Array<Int64> = []
    public func setSFixedData04(sFixedData04: Array<Int64>) { this.sFixedData04 = sFixedData04; return this }

    public func build() { IntData(this) }
}
